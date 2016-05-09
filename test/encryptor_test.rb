require 'test_helper'
require 'culqi/encryptor'

class EncryptorTest < Minitest::Test
  TEST_KEY = '0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef'

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
    @encryptor ||= Culqui::Encryptor.new(TEST_KEY)
  end
end
