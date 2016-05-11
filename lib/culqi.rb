require 'culqi/encryptor'
require 'culqi/sale'
require 'culqi/client'

module Culqi
  def self.default_client
    variables = %w{CULQI_KEY CULQI_ENDPOINT CULQI_CODIGO_COMERCIO}
    missing = variables - ENV.keys
    raise "The following env vars are missing and are needed to use this gem: #{missing.join(', ')}." unless missing.empty?
    Client.new(ENV['CULQI_KEY'], ENV['CULQI_ENDPOINT'], ENV['CULQI_CODIGO_COMERCIO'])
  end
end
