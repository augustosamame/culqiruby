require 'openssl'
require 'base64'

module Culqi
  class Encryptor
    def initialize
      raise 'Invalid Culqi Key' unless resembles_base64(ENV['CULQI_KEY'])
      @key = Base64.urlsafe_decode64(ENV['CULQI_KEY'])
    end

    def encrypt(plaintext)
      cipher    = build_cipher(:encrypt)
      cipher.iv = iv = cipher.random_iv
      decoded   = iv + cipher.update(plaintext) + cipher.final

      Base64.urlsafe_encode64(decoded)
    end

    def decrypt(encrypted)
      decoded     = Base64.urlsafe_decode64(encrypted)
      decipher    = build_cipher(:decrypt)
      decipher.iv = decoded.slice!(0, 16)

      decrypt_text = decipher.update(decoded) + decipher.final
      decrypt_text.force_encoding('utf-8')
    end

    private

    def build_cipher(type)
      cipher = OpenSSL::Cipher::AES.new(256, :CBC)
      cipher.send(type)
      cipher.key = @key
      cipher
    end

    def resembles_base64(mystring)
      mystring.length % 4 == 0 && mystring =~ /^[A-Za-z0-9+\/=]+\Z/
    end

  end
end
