require 'openssl'
require 'base64'

module Culqi
  class Encryptor
    def initialize(key)
      @key = Base64.urlsafe_decode64(key)
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

      decipher.update(decoded) + decipher.final
    end

    private

    def build_cipher(type)
      cipher = OpenSSL::Cipher::AES.new(256, :CBC)
      cipher.send(type)
      cipher.key = @key
      cipher
    end
  end
end
