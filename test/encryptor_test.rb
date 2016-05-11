require 'test_helper'
require 'culqi/encryptor'

class EncryptorTest < Minitest::Test
  ENV['CULQI_KEY'] = 'JlhLlpOB5s1aS6upiioJkmdQ0OYZ6HLS2+/o4iYO2MQ='
  def test_encrypt_decrypt
    encryptor = Culqi::Encryptor.new
    plaintext = 'test string'
    encrypted = encryptor.encrypt(plaintext)

    assert_equal plaintext, encryptor.decrypt(encrypted)
  end
end
