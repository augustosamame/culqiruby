require 'test_helper'
require 'culqi/encryptor'

class EncryptorTest < Minitest::Test
  TEST_KEY = '89d641e07b069fba48f9c1b00a565825d3b89a6f5b393ec39ba7bc38b156b803836137a40e12e89878db21eb53442c10d179bc9f2fc8520dfd1ff19ab55a3700'

  def test_encrypt_decrypt
    encryptor = Culqi::Encryptor.new(TEST_KEY)
    plaintext = 'test string'
    encrypted = encryptor.encrypt(plaintext)

    assert_equal plaintext, encryptor.decrypt(encrypted)
  end
end
