class Arcgis::Connection
  @@object_registry = {}

  attr_reader :username

  #
  # Take in username/password upon initialization
  #
  def initialize(host:, username: nil, password: nil, token: nil)
    @host = host.sub(/\/$/,'')
    @token, @token_expires = token, nil
    @username, @password = username, password

    if username && password
      login(username, password)
    end
  end


  def login(username, password)
    response = run(
      path: "/generateToken",
      method: "POST",
      body: {username: username, password: password, referer: "http://arcgis.com"}
    )

    @token = response["token"]
    @token_expires = Time.at(response["expires"]/1000)
  end


  def search(params={})
    run(
      path: "/search",
      params: params
    )
  end


  def run(path:, method: "GET", params: {}, headers: {}, body: {})
    full_params = default_params.merge(params)

    # JSON encode array and hash fields
    params, body = sanitize_params(params), sanitize_params(body)

    request = Typhoeus::Request.new(
      @host + path,
      {method: method, params: full_params, headers: headers, body: body}
    )

    handle_response(request.run)
  end


  def default_params
    @token.nil? ? {f: :json} : {f: :json, token: @token}
  end


  # also used on body
  def sanitize_params(params)
    params.reduce({}) do |agg,(k,v)|
      agg[k] = (v.is_a?(Hash) || v.is_a?(Array)) ? v.to_json : v
      agg
    end
  end


  def handle_response(response)
    if response.success?
      r = JSON.parse(response.body)
      raise ErrorResponse.new(r["error"]) if r["error"]
      r
    else
      raise response.inspect
    end
  end


  #
  # Connection acts as something of a container for different AGOL models,
  # passing its own information along to them.
  #
  (Arcgis::Routes::ROUTES.keys - [:root]).each do |object|
    define_method object do |id = nil|
      Arcgis::Model.build(connection: self, type: object, id: id)
    end
  end

end



class ErrorResponse < RuntimeError
  attr_accessor :response
  def initialize(response={})
    message = response["message"] || response[:message] || response[:code] || response.inspect
    message += response["details"].join("\n") if response["details"]
    super(message)
    @response = response
  end
end
