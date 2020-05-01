require "test_helper"

class JuniterTest < Minitest::Test
  attr_reader :file_mock

  should "forward .read to Juniter::File" do
    assert_calls_on_file :read do
      Juniter.read StringIO.new
    end
  end

  should "forward .from_file to Juniter::File" do
    assert_calls_on_file :from_file do
      Juniter.from_file "/some/file/name.xml"
    end
  end

  should "forward .parse to Juniter::File" do
    assert_calls_on_file :parse do
      Juniter.parse "<?xml><TestSuite/>"
    end
  end

private

  def assert_calls_on_file(method_name)
    mock = Minitest::Mock.new
    mock.expect(method_name, nil, [ Object ])
    Juniter.stub_const(:File, mock) do
      yield
    end

    assert mock.verify
  end

end
