require 'test_helper'

class ClientTest < Minitest::Test

  CODIGO_RESPUESTA_EXITO = 'venta_registrada'

  def setup
    ENV['CULQI_KEY'] = 'JlhLlpOB5s1aS6upiioJkmdQ0OYZ6HLS2+/o4iYO2MQ=';
    ENV['CULQI_CODIGO_COMERCIO'] = 'demo'
    ENV['CULQI_ENDPOINT'] = 'https://integ-pago.culqi.com'

    @culqi = Culqi.default_client
  end

  def test_crear_venta_exito
    venta = @culqi.crear_venta(datos_venta)
    assert_equal CODIGO_RESPUESTA_EXITO, venta['codigo_respuesta']
  end

  def test_crear_venta_error
    venta = @culqi.crear_venta(datos_venta({cod_pais: 'PAIS_INVALIDO'}))
    refute CODIGO_RESPUESTA_EXITO == venta['codigo_respuesta']
  end

  private

  def datos_venta(params = {})
    {
      numero_pedido: "PEDIDO.#{Time.now.to_f}",
      moneda: 'PEN',
      monto: '5000',
      descripcion: 'Venta de prueba',
      correo_electronico: 'augustosamame@gmail.com',
      cod_pais: 'PE',
      ciudad: 'Lima',
      direccion: 'Av Javier Prado 2320, San Borja',
      num_tel: '986976309',
      id_usuario_comercio: '2',
      nombres: 'Augusto',
      apellidos: 'Samame'
    }.merge(params)
  end

end
