module Culqi
  class Sale
    DEFAULTS = {
      moneda:   'PEN',
      cod_pais: 'PE'
    }

    attr_accessor :codigo_comercio,
                  :numero_pedido,
                  :moneda,
                  :monto,
                  :descripcion,
                  :correo_electronico,
                  :cod_pais,
                  :ciudad,
                  :direccion,
                  :num_tel,
                  :id_usuario_comercio,
                  :nombres,
                  :apellidos

    def initialize(attrs)
      attrs.each { |key, value| public_send("#{ key }=", value) }
    end

#codigo_comercio:      ENV['CULQI_CODIGO_COMERCIO'],

    def payload
      {
        codigo_comercio:      '3zMquUkbF5s8',
        numero_pedido:        numero_pedido,
        moneda:               (moneda || DEFAULTS[:moneda]),
        monto:                monto,
        descripcion:          descripcion[0..79],
        correo_electronico:   correo_electronico[0..49],
        cod_pais:             (cod_pais || DEFAULTS[:cod_pais]),
        ciudad:               ciudad,
        direccion:            direccion,
        num_tel:              num_tel[0..14],
        id_usuario_comercio:  id_usuario_comercio,
        nombres:              nombres[0..49],
        apellidos:            apellidos[0..49]
      }.to_json
    end
  end
end
