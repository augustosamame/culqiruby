require 'culqi/encryptor'
require 'culqi/sale'
require 'culqi/client'

module Culqi
  def self.default_client
    Client.new(ENV['CULQI_KEY'], ENV['CULQI_ENDPOINT'], ENV['CULQI_CODIGO_COMERCIO'])
  end
end
