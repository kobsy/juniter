require "test_helper"

class TestSuiteTest < Minitest::Test

  %i{name duration test_count failure_count disabled_count error_count skipped_count timestamp hostname id package}.each do |attribute|
    context "##{attribute} assignment" do
      setup do
        @subject = Juniter::TestSuite.new
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
      @subject = Juniter::File.from_file(::File.join(__dir__, "support", "valid.xml")).test_suites.test_suites.first
    end

    should "parse attributes as target types" do
      { name: String,
        duration: Float,
        test_count: Integer,
        failure_count: Integer,
        disabled_count: Integer,
        error_count: Integer,
        skipped_count: Integer,
        timestamp: Time,
        hostname: String,
        id: String,
        package: String }.each do |attribute, type|
          assert @subject.public_send(attribute).is_a?(type), "Expected #{attribute} to be a #{type}, but it was a #{@subject.public_send(attribute).class}"
        end
    end

    should "parse child <testcase> elements" do
      assert_equal 2, @subject.test_cases.count
    end

    should "parse child <properties>" do
      assert_equal 1, @subject.properties.count
    end

    should "parse child <system-out> elements" do
      refute @subject.stdout.empty?
    end

    should "parse child <system-err> elements" do
      refute @subject.stderr.empty?
    end
  end

  context "#to_xml" do
    should "generate the expected XML" do
      now = Time.new
      output = Juniter::TestSuite.new.tap do |test_suite|
        test_suite.name = "TestSuite"
        test_suite.duration = 5.0
        test_suite.test_count = 3
        test_suite.failure_count = 5
        test_suite.disabled_count = 0
        test_suite.error_count = 10
        test_suite.skipped_count = 0
        test_suite.timestamp = now
        test_suite.hostname = "localhost"
        test_suite.id = "3"
        test_suite.package = "TestPackage"
      end.to_xml.yield_self { |xml| Ox.dump(xml).strip }

      assert_equal output, <<~XML.strip
      <testsuite name="TestSuite" tests="3" failures="5" errors="10" disabled="0" skipped="0" time="5.0" timestamp="#{now}" hostname="localhost" id="3" package="TestPackage"/>
      XML
    end
  end

end
