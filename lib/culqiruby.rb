require 'culqiruby/version'
require 'dotenv'
require "openssl"
require 'base64'
require 'url_safe_base64'
Dotenv.load

class Culqiruby
  
  def initialize
    # Instance variables
    # Culqiruby gem requires these 3 environment variables to be set in order to work properly
    variables = %w{CULQI_KEY CULQI_ENDPOINT CULQI_CODIGO_COMERCIO}
    missing = variables - ENV.keys
    unless missing.empty?
      raise "The following env vars are missing and are needed to use this gem: #{missing.join(', ')}."
    end
    #raise Culqiruby, '1 or more required env vars are missing' unless (defined? ENV['CULQI_KEY'] || defined? ENV['CULQI_ENDPOINT'] || defined? ENV['CULQI_CODIGO_COMERCIO'])
    @culqi_key = ENV['CULQI_KEY']
    @culqi_endpoint = ENV['CULQI_ENDPOINT']
    @culqi_codigo_comercio = ENV['CULQI_CODIGO_COMERCIO']
  end
  
  def encriptar(data_to_encrypt)
    #will take a string and encrypt it using the culqi_key, a random IV and then will urlsafebase64 encode it for transmition
    cipher = OpenSSL::Cipher::AES.new(256, :CBC)
    cipher.encrypt
    cipher.key = UrlSafeBase64.decode64 @culqi_key
    iv = cipher.random_iv
    cipher.iv = iv
    bytes_cifrado = cipher.update(data_to_encrypt) + cipher.final
    #concatenates iv + encrypted_data as specified in Culqi documentation
    cifrado_concatenado = iv + bytes_cifrado
    #encrypted data is converted to UrlSafeBase64Encoded to transmit via REST
    UrlSafeBase64.encode64 cifrado_concatenado
  end  
  
  def desencriptar(data_to_decrypt)
    #will take a Culqi encrypted string, decode it, decrypt it using the culqi_key and the included IV and return plain data
    #data to decrypt is converted to UrlSafeBase64Unencoded
    decoded_string = UrlSafeBase64.decode64 data_to_decrypt
    decipher = OpenSSL::Cipher::AES.new(256, :CBC)
    decipher.decrypt
    decipher.key = UrlSafeBase64.decode64 @culqi_key
    #remove iv from received data to use it for decryption
    iv = decoded_string.slice!(0,16)
    decipher.iv = iv
    decipher.update(decoded_string) + decipher.final
  end  
  
  def crear_venta
    # es necesario que estén seteados los atributos de la venta como variables de instancia para el correcto funcionamiento del gem
    # preparamos la data recibida y creamos la venta
    pedido=Hash.new
    pedido['codigo_comercio']=@culqi_codigo_comercio
    pedido['numero_pedido']=self.numero_pedido
    pedido['moneda']=self.moneda || 'PEN' #defaults to PEN if moneda attribute not set
    pedido['monto']=self.monto
    pedido['descripcion']=self.descripcion[0..79] #will use only first 80 characters due tu Culqi limit
    pedido['correo_electronico']=self.correo_electronico[0..49] #will use only first 50 characters due tu Culqi limit
    pedido['cod_pais']=self.cod_pais || 'PE' #defaults to PE if pais attribute not set
    pedido['ciudad']=self.ciudad
    pedido['direccion']=self.direccion
    pedido['num_tel']=self.num_tel[0..14] #will use only first 15 characters due tu Culqi limit
    pedido['id_usuario_comercio']=self.id_usuario_comercio
    pedido['nombres']=self.nombres[0..49] #will use only first 50 characters due tu Culqi limit
    pedido['apellidos']=self.apellidos[0..49] #will use only first 50 characters due tu Culqi limit
    # encriptamos la data y preparamos el body del POST
    json_cifrado=self.encriptar(pedido.to_json)
    body = { "codigo_comercio" => @culqi_codigo_comercio, "informacion_venta" => json_cifrado}.to_json
    # hacemos la llamada servidor a servidor para CREAR LA VENTA
    url = URI(@culqi_endpoint + '/api/v1/web/crear')
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Post.new(url)
    request["content-type"] = 'application/json'
    request.body = body
    response = http.request(request)
    # generamos una excepción si hay un error HTTP
    raise Culqiruby, "Error al crear venta, HTTP code: " << response.code unless response.code=='200'
    # desencriptamos y parseamos la respuesta de Culqi
    culqiresponse = JSON.parse(self.desencriptar(response.read_body))
    if culqiresponse['codigo_respuesta']=="venta_registrada"   
      return 'Venta creada exitosamente', culqiresponse
    else
      return 'Error al crear venta', culqiresponse
    end
  end

end