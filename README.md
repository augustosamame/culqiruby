# Culqiruby

This gem allows your rails 3/4/5 app to quickly integrate with Culqi Payment processor. It handles Culqi's flavor of encryption, decryption and Culqi ticket creation.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'culqiruby'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install culqiruby

## Forma de uso

La versión 0.x de este gem corresponde a una versión en desarollo.
La versión 1.x de este gem podrá ser usada en producción con la versión 1.0 del API de Culqi

Requerimientos: este gem requiere de la existencia de las siguientes environment variables en el ambiente de desarrollo / Pruebas / Producción:


CULQI_KEY="ingrese la llave entregada por Culqi aquí"

CULQI_ENDPOINT="ingrese el dominio del API de Culqi aquí"

CULQI_CODIGO_COMERCIO="ingrese el código de comercio asignado por Culqi aquí"


Para definir los environments variables en su ambiente recomendamos:

Ruby:
dotenv gem
https://github.com/bkeepers/dotenv

Rails:
figaro gem
https://github.com/laserlemon/figaro

## Métodos

Para utilizar los métodos, deberá crear una instancia de la clase Culqiruby así:

```ruby
culqi = Culqiruby.new
```
## encriptar

```ruby
texto_encriptado = culqi.encriptar('Texto a encriptar')
```

El método encriptar devolverá un texto_encriptado según los requerimientos de Culqi haciendo uso de la llave entregada por Culqi y especificada en los environment variables

## desencriptar

```ruby
texto_desencriptado = culqi.desencriptar('Texto a desencriptar')
```

El método desencriptar devolverá un texto_desencriptado según las especificaciones de Culqi haciendo uso de la llave entregada por Culqi y especificada en los environment variables y del IV que es parte del mismo texto a desencriptar

## crear_venta

Este método permitirá crear una venta en Culqi, para luego invocar el formulario según lo indicado por la documentación Culqi.
Para que la creación de la venta sea exitosa, los siguientes atributos deberán haber sido seteados antes de llamar al método:

culqi.numero_pedido

culqi.moneda

culqi.monto

culqi.descripcion

culqi.correo_electronico

culqi.cod_pais

culqi.ciudad

culqi.direccion

culqi.num_tel

culqi.id_usuario_comercio

culqi.nombres

culqi.apellidos


Ejemplo:

```ruby
#instanciamos la clase Culqiruby
culqi = Culqi.default_client

#creamos la venta
venta = culqi.crear_venta numero_pedido:       '1234'
                          moneda:              'PEN'
                          monto:               '5000'
                          descripcion:         'Venta de prueba'
                          correo_electronico:  'augustosamame@gmail.com'
                          cod_pais:            'PE'
                          ciudad:              'Lima'
                          direccion:           'Av. Javier Prado 1750, San Borja'
                          num_tel:             '986977321'
                          id_usuario_comercio: '1'
                          nombres:             'Augusto'
                          apellidos:           'Samamé'

```

El método crear_venta devolverá un arreglo con 2 valores: el primer valor es un string con el resultado de la creación de la venta y el segundo valor un hash con la respuesta del API de Culqi

Ej de respuesta exitosa:

{"mensaje_respuesta_usuario"=>"", "monto"=>"5000", "mensaje_respuesta"=>"Venta creada exitosamente.", "ticket"=>"6F6tIyUlOmrMKo3EI5rxcsvamwHRrKAEgsb", "codigo_respuesta"=>"venta_registrada", "numero_pedido"=>"1234", "codigo_comercio"=>"3zMquUkbF5s8", "informacion_venta"=>"EtEfsG1iD1Ur8YYHO98hRX1kXE2KOVlq4vbmmLVkKKX5eCBUFAHeuAhRrefRIwuUAHTWH6tiNWIthJ67Fi11LGkBEF861R2iQNjG5vsHSy8RsFuXfUU_zKTYYwGhaYkR4tAewbDRnBX3YKJOxPcMqA=="}


Ej de respuesta con error

{"mensaje_respuesta_usuario"=>"", "mensaje_respuesta"=>"La transacción ya existe. ", "codigo_respuesta"=>"parametro_invalido", "codigo_comercio"=>"3zMquUkbF5s8"}


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/augustosamame/culqiruby.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
