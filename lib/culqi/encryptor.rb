module Culqi
  class Encryptor
    def initialize(key = ENV['CULQI_KEY'])
      @key = Base64.urlsafe_decode64(key)
    end

    def encrypt(plaintext)
      cipher  = build_cipher(:encrypt)
      decoded = iv + cipher.update(plaintext) + cipher.final

      Base64.urlsafe_encode64(decoded)
    end

    def desencrypt(encrypted)
      decoded   = Base64.urlsafe_decode64(encrypted)
      iv        = decoded.slice!(0, 16)
      decipher  = build_cipher(:decrypt, iv)
      plaintext = decipher.update(decoded) + decipher.final

      plaintext
    end

    private

    def build_cipher(type, iv = nil)
      OpenSSL::Cipher::AES.new(256, :CBC).tap do |cipher|
        cipher.send(type)
        cipher.key = @key
        cipher.iv  = iv || cipher.random_iv
      end
    end
  end
end
