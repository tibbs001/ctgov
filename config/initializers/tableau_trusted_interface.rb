require 'net/http'
require 'uri'

class TableauTrustedInterface

  attr_accessor :config

  def initialize
    @config = TableauTrustedInterface.config ## bring the config into our scope
  end

  ## class method because we will need to access this elsewhere in singleton mode
  def self.config
    @@config ||= YAML::load(ERB.new((IO.read("#{::Rails.root.to_s}/config/tableau.yml"))).result)[Rails.env].symbolize_keys
  end

  def server
    @server ||= config[:server]
  end

  def client_ip_required?
    @require_client_ip ||= config[:require_client_ip]
  end

  def get_trusted_ticket(tabuser, client_ip)
    post_data = {
      "username" => tabuser
    }
    post_data.merge!({"client_ip" => client_ip}) if client_ip_required?

    handle_response Net::HTTP.post_form(URI.parse("#{server}/trusted"), post_data)
  end

  private
  def handle_response(response)
    case response
    when Net::HTTPSuccess
      return response.body.to_i
    else
      return -1
    end
  end
end