require 'minitest/autorun'
require 'Cws3chk'
require 'mocha/mini_test'
require 'aws'

class Cws3chkTest < Minitest::Test

  class Subject
    def image?
      true
    end

    def image
    end
  end

  class FakeRedis
    attr_reader :sets
    def initialize
      @sets = {}
    end

    def sadd key, value
      (@sets[key] ||= []) << value
    end
  end

  def setup
    Cws3chk::Store.any_instance.stubs(:redis).returns(fake_redis)
  end

  def test_check_one_present_asset
    set_s3_headers_to headers_of_present_asset
    Cws3chk::Checker.new(request, :image, 2).check
    keys = fake_redis.sets["Cws3chk::metadata"]
    assert_equal keys.size, 2
    assert_equal keys.sort, [
      "[\"Cws3chkTest::Subject\",1,\"image\",\"pdf\",1999]",
      "[\"Cws3chkTest::Subject\",1,\"image\",null,1999]"
    ]
  end

  def test_check_one_missing_asset
    set_s3_headers_to headers_of_missing_asset
    Cws3chk::Checker.new(request, :image, 2).check
    keys = fake_redis.sets["Cws3chk::missing"]
    assert_equal keys.size, 2
    assert_equal keys.sort, [
      "[\"Cws3chkTest::Subject\",1,\"image\",\"pdf\"]",
      "[\"Cws3chkTest::Subject\",1,\"image\",null]"
    ]
  end

  private

  def set_s3_headers_to headers
    @headers = headers
    Aws::S3::Key.stubs(:create).returns(s3_key)
  end

  def headers_of_present_asset
    {'content-length' => 1999}
  end

  def headers_of_missing_asset
    nil
  end

  def s3_key
    mock('s3_key').tap do |_mock|
      _mock.stubs(:head).returns(true)
      _mock.stubs(:headers).returns(@headers)
    end
  end

  def request
    mock().tap do |_mock|
      _mock.stubs(:find_each).yields(subject)
    end
  end

  def subject
    mock().tap do |_mock|
      _mock.stubs(:image).returns(uploader)
      _mock.stubs(:image?).returns(true)
      _mock.stubs(:class).returns(Subject)
      _mock.stubs(:id).returns(1)
    end
  end

  def uploader
    mock().tap do |_mock|
      _mock.stubs(:versions).returns(mock keys: [:pdf])
      _mock.stubs(:pdf).returns(pdf_version)
      _mock.stubs(:path).returns(path)
    end
  end

  def path
    'path_to_original'
  end

  def pdf_version
    mock().tap do |_mock|
      _mock.stubs(:path).returns(pdf_path)
    end
  end

  def pdf_path
    'path_to_pdf_version'
  end

  def fake_redis
    @fake_redis ||= FakeRedis.new
  end
end
