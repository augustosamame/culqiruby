# Culqiruby

This gem allows your Rails or Ruby app to quickly integrate with Culqi Payment processor. It handles Culqi's flavor of encryption, decryption and Culqi ticket creation.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'culqi'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install culqi

## Versiones

La versión 1.x de este gem podrá ser usada en producción con la versión 1.x del API de Culqi

Compatible con Ruby versiones 1.9.2 y superior

Compatible con Rails versiones 3.2 y superior


## Requerimientos

Este gem requiere de la existencia de las siguientes environment variables en el ambiente de Desarrollo / Pruebas / Producción:

CULQI_KEY="llave de encriptación entregada por Culqi"

CULQI_ENDPOINT="dominio del API de Culqi"

CULQI_CODIGO_COMERCIO="código de comercio asignado por Culqi"



Para definir los environments variables en su ambiente recomendamos:


Ruby:
dotenv gem
https://github.com/bkeepers/dotenv


Rails:
figaro gem
https://github.com/laserlemon/figaro


## Forma de Uso

Instanciamos el cliente Culqi para exponer sus métodos:

```ruby
culqi = Culqi.default_client
```

## Métodos

## crear_venta

Este método permitirá crear una venta en Culqi, para luego invocar el formulario según lo indicado por la documentación de Culqi.
Para que la creación de la venta sea exitosa, los siguientes atributos le deberán ser pasados al método como un hash:

numero_pedido, moneda, monto, descripcion, correo_electronico, cod_pais, ciudad, direccion, num_tel, id_usuario_comercio, nombres, apellidos

Ejemplo:

```ruby
#instanciamos el cliente Culqi
culqi = Culqi.default_client

#creamos la venta

datos_venta = {
              codigo_comercio: ENV['CULQI_CODIGO_COMERCIO'],
              numero_pedido: '12367',
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
              }

venta = culqi.crear_venta(datos_venta)

```

El método crear_venta devolverá un arreglo con 2 valores: el primer valor es un string con el resultado de la creación de la venta y el segundo valor un hash con la respuesta del API de Culqi

Ej de respuesta exitosa:

{"mensaje_respuesta_usuario"=>"", "monto"=>"5000", "mensaje_respuesta"=>"Venta creada exitosamente.", "ticket"=>"6F6tIyUlOmrMKo3EI5rxcsvamwHRrKAEgsb", "codigo_respuesta"=>"venta_registrada", "numero_pedido"=>"1234", "codigo_comercio"=>"3zMquUkbF5s8", "informacion_venta"=>"EtEfsG1iD1Ur8YYHO98hRX1kXE2KOVlq4vbmmLVkKKX5eCBUFAHeuAhRrefRIwuUAHTWH6tiNWIthJ67Fi11LGkBEF861R2iQNjG5vsHSy8RsFuXfUU_zKTYYwGhaYkR4tAewbDRnBX3YKJOxPcMqA=="}


Ej de respuesta con error

{"mensaje_respuesta_usuario"=>"", "mensaje_respuesta"=>"La transacción ya existe. ", "codigo_respuesta"=>"parametro_invalido", "codigo_comercio"=>"3zMquUkbF5s8"}


## Encryptor Class

Para poder utilizar los métodos de encriptación y desencriptación de Culqi, debemos instanciar la clase Culqi::Encryptor.
Recuerde que de acuerdo a los requerimientos del gem indicados arriba, el environment variable CULQI_KEY debe haber sido seteado para que esta clase funcione:


```ruby
encryptor = Culqi::Encryptor.new
```

Esto expondrá los métodos: encrypt y decrypt

```ruby
texto_encriptado = encryptor.encrypt('Texto Prueba')

=> "yozxCEGWPDw_uiHdsOXW-4EAuKDfCxCcd0GO2bESegE="

texto_plano = encryptor.decrypt("yozxCEGWPDw_uiHdsOXW-4EAuKDfCxCcd0GO2bESegE=")

=> "Texto Prueba"

(su cadena encriptada será distinta ya que Culqi asigna una llave de encriptación distinta a cada cliente)
```


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/augustosamame/culqiruby.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
