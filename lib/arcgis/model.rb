#
# Acts as a builder for classes based on routes.rb. This should be considered
# private. All entry points to models should come through connection.
#
module Arcgis::Model
  class << self
    @@classes = {}


    #
    # Sole entry point into the module--looks up the appropriate class by
    # type (e.g. item, group, etc.) and initializes an instance of it
    #
    def build(connection:, type:, id: nil)
      class_for_type(type).new(connection, id)
    end


    #
    # Returns a copy of a class to handle the appropriate object type, creating
    # the class if needed
    #
    def class_for_type(type)
      @@classes[type] ||= Class.new do
        def initialize(connection, id)
          @connection, @id = connection, id
        end


        #
        # Helper method to extract HTTP method, argument names, the the path.
        # e.g. "POST /content/users/:username/items/:id/delete" becomes
        # {method: "POST", args: ["username", "id"],
        #    path: "/content/users/:username/items/:id/delete"}
        #
        def extract_config(path_config)
          method, path_pattern = path_config.split(' ')
          args = path_pattern.scan(/\/:[^\/]+/)
          arg_names = args.map{|a| a[2..-1]}
          return { method: method, args: arg_names, path: path_pattern }
        end


        #
        # Args to be merged into every path
        #
        def default_args
          {id: @id, username: @connection.username}
        end


        # Helper procs
        stringify_keys = ->(x) { x.reduce({}){|h, (k,v)| h[k.to_s] = v; h} }
        symbolize_keys = ->(x) { x.reduce({}){|h, (k,v)| h[k.to_s.to_sym] = v; h} }

        Arcgis::Routes::ROUTES[type].each_pair do |meth, path_config|
          #
          # Creates the specific path for a request, merging default_args with
          # user-provided arguments, to create a final path.
          # e.g. for item: delete: "POST /content/users/:username/items/:id/delete"
          # substitutes in :username and :id to get something like
          # {method: "POST",
          #  path: "/content/users/someuser/items/4e770315ad9049e7950b552aa1e40869/delete"}
          #
          self.send(:define_method, "#{meth}_path") do |local_args = {}|
            # stringify keys
            local_args = stringify_keys[local_args]

            config = self.extract_config(path_config)
            args = stringify_keys[self.default_args.merge(local_args)]

            path = config[:args].reduce(config[:path]) do |u,arg|
              u.sub("/:#{arg}", "/#{args[arg]}")
            end

            {method: config[:method], path: path}
          end


          #
          # Creates a method for each route in the routes file that merges in
          # variables (see #{meth}_path) and then runs the request via the
          # connection
          #
          self.send(:define_method, "#{meth}") do |local_args = {}|
            local_args = symbolize_keys[local_args]
            path_args = send("#{meth}_path")
            args = (path_args[:method] == "GET") ?
              path_args.merge(params: stringify_keys[local_args]) :
              path_args.merge(body: stringify_keys[local_args])

            @connection.run(args)
          end
        end
      end
    end
  end

end
