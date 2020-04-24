require "test_helper"

class JuniterFileTest < Minitest::Test

  context ".read" do
    should "read the contents of the IO stream and pass it to parse" do
      value = "A string of some sort"
      stream = StringIO.new(value)
      Juniter::File.stub :parse, ->(string) { assert string == value } do
        Juniter::File.read stream
      end
    end
  end

  context ".from_file" do
    should "open the file for reading and pass it to read" do
      begin
        value = "A string of some sort"
        tempfile = Tempfile.new("test")
        tempfile.write value
        Juniter::File.stub :read, ->(io) { assert io.read == tempfile.read } do
          Juniter::File.from_file tempfile.path
        end
      ensure
        tempfile.close
        tempfile.unlink
      end
    end
  end

  context ".parse" do
    should "return a Juniter::File when given valid JUnit XML" do
      ::File.open(::File.join(__dir__, "support", "valid.xml")) do |f|
        assert Juniter::File.parse(f.read).is_a? Juniter::File
      end
    end

    should "raise an error if the XML file is invalid" do
      ::File.open(::File.join(__dir__, "support", "invalid.xml")) do |f|
        assert_raises do
          Juniter::File.parse(f.read)
        end
      end
    end

    should "raise an error if the XML is valid, but is not JUnit format" do
      ::File.open(::File.join(__dir__, "support", "not-junit.xml")) do |f|
        assert_raises do
          Juniter::File.parse(f.read)
        end
      end
    end
  end

  context "#test_suites" do
    should "point to a TestSuites object when given a file with the <testsuites> container tag" do
      ::File.open(::File.join(__dir__, "support", "valid.xml")) do |f|
        assert Juniter::File.parse(f.read).test_suites.is_a?(Juniter::TestSuites)
      end
    end

    should "wrap a single TestSuite in a TestSuites object when there is no <testsuites> container" do
      ::File.open(::File.join(__dir__, "support", "no-testsuites.xml")) do |f|
        assert Juniter::File.parse(f.read).test_suites.is_a?(Juniter::TestSuites)
      end
    end
  end

end
