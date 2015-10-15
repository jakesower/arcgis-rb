require 'rspec'
require 'rspec/expectations'
require 'yaml'
require 'arcgis-ruby'

module TestHelper
  def create_testing_group(options={})
    connection = Arcgis::Connection.new(ArcConfig.config["online"])
    connection.group.create(
      :title => "Ruby Testing Group",
      :description => "Group for Testing",
      :access => "org",
      :tags => "test,ruby")
  end

  def delete_testing_group
    unless @group.nil? || @group["group"].nil?
      @connection.group(@group["group"]["id"]).delete
    end
  end
end


RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
  config.include TestHelper
end


module ArcConfig
  class << self
    def config
      @config ||= YAML.load_file(File.dirname(__FILE__) + '/agol_config.yml')
    end
  end
end
