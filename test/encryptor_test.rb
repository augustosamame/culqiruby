require 'test_helper'
require 'culqi/encryptor'

class EncryptorTest < Minitest::Test
  TEST_KEY = '89d641e07b069fba48f9c1b00a565825d3b89a6f5b393ec39ba7bc38b156b803836137a40e12e89878db21eb53442c10d179bc9f2fc8520dfd1ff19ab55a3700'

  def setup
    @plaintext = 'test string'
    @encrypted = '' #TODO: Calculate
  end

  def test_encrypt
    assert_equal @encrypted, encryptor.encrypt(@plaintext)
  end

  def test_decrypt
    assert_equal @plaintext, encryptor.encrypt(@encrypted)
  end

  private

  def encryptor
    @encryptor ||= Culqi::Encryptor.new(TEST_KEY)
  end
end
