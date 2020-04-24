require "test_helper"

class TestSuitesTest < Minitest::Test

  %i{name duration test_count failure_count disabled_count error_count}.each do |attribute|
    context "##{attribute} assignment" do
      setup do
        @subject = Juniter::TestSuites.new
      end

      should "allow a value to be assigned" do
        @subject.public_send :"#{attribute}=", "A value"
        assert true
      end

      should "allow reading a value" do
        @subject.public_send :"#{attribute}=", "A value"
        refute @subject.public_send(:"#{attribute}").nil?
      end
    end
  end

  context ".from_xml" do
    setup do
      @subject = Juniter::File.from_file(::File.join(__dir__, "support", "valid.xml")).test_suites
    end

    should "parse attributes as target types" do
      { name: String,
        duration: Float,
        test_count: Integer,
        failure_count: Integer,
        disabled_count: Integer,
        error_count: Integer }.each do |attribute, type|
          assert @subject.public_send(attribute).is_a?(type), "Expected #{attribute} to be a #{type}, but it was a #{@subject.public_send(attribute).class}"
        end
    end

    should "parse child <testsuite> elements" do
      assert_equal 1, @subject.test_suites.count
    end
  end

  context "#to_xml" do
    should "generate the expected XML" do
      output = Juniter::TestSuites.new.tap do |test_suites|
        test_suites.name = "TestSuites"
        test_suites.duration = 5.0
        test_suites.test_count = 3
        test_suites.failure_count = 5
        test_suites.disabled_count = 0
        test_suites.error_count = 10
      end.to_xml.yield_self { |xml| Ox.dump(xml).strip }

      assert_equal output, <<~XML.strip
        <testsuites name="TestSuites" time="5.0" tests="3" failures="5" disabled="0" errors="10"/>
      XML
    end
  end

end
