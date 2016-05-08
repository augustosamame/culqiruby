require 'openssl'
require 'base64'
require 'net/http'
require 'json'
require 'culqi/encryptor'
require 'culqi/sale'

class Culqi
  ERROR_MESSAGES = {
    failed_request: 'Error al crear venta, HTTP code:'
  }

  def self.client
    new(ENV['CULQI_KEY'], ENV['CULQI_ENDPOINT'], ENV['CULQI_CODIGO_COMERCIO'])
  end

  def initialize(key, endpoint, code)
    @key  = key
    @url  = URI(endpoint + '/api/v1/web/crear')
    @code = code
  end

  def crear_venta(attrs)
    sale    = Sale.new(attrs)
    request = http_request(sale.payload)

    http_response(request)
  end

  private

  def http_client
    http             = Net::HTTP.new(url.host, url.port)
    http.use_ssl     = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    http
  end

  def http_request(payload)
    request                 = Net::HTTP::Post.new(url)
    request['content-type'] = 'application/json'
    request.body            = { codigo_comercio: @code, informacion_venta: encryptor.encrypt(payload) }.to_json
    request
  end

  def http_response(request)
    response = http_client.request(request)

    raise "#{ MESSAGES[:failed_request] } #{ response.code }" unless response.code == '200'

    JSON.parse(encryptor.decrypt(response))
  end

  def encryptor
    @encryptor ||= Encryptor.new(@key)
  end
end
