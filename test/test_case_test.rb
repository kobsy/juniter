require "test_helper"

class TestCaseTest < Minitest::Test

  %i{name assertion_count duration class_name status}.each do |attribute|
    context "##{attribute} assignment" do
      setup do
        @subject = Juniter::TestCase.new
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
      test_suite = Juniter::File.from_file(::File.join(__dir__, "support", "valid.xml"))
        .test_suites
        .test_suites
        .first
      @pass_subject = test_suite.test_cases.first
      @error_subject = test_suite.test_cases.last
    end

    should "parse attributes as target types" do
      { name: String,
        duration: Float,
        assertion_count: Integer,
        class_name: String,
        status: String }.each do |attribute, type|
          assert @pass_subject.public_send(attribute).is_a?(type), "Expected #{attribute} to be a #{type}, but it was a #{@pass_subject.public_send(attribute).class}"
        end
    end

    should "parse the test_result" do
      assert @pass_subject.result.pass?
      refute @error_subject.result.pass?
      refute @pass_subject.result.error?
      assert @error_subject.result.error?
    end

    should "parse child <system-out> elements" do
      refute @pass_subject.stdout.empty?
    end

    should "parse child <system-err> elements" do
      refute @error_subject.stderr.empty?
    end
  end

  context "#to_xml" do
    should "generate the expected XML" do
      now = Time.new
      output = Juniter::TestCase.new.tap do |test_case|
        test_case.name = "AwesomeTest"
        test_case.duration = 5.0
        test_case.assertion_count = 3
        test_case.class_name = "TestCase"
        test_case.status = "passing"
      end.to_xml.yield_self { |xml| Ox.dump(xml).strip }

      assert_equal output, <<~XML.strip
      <testcase name="AwesomeTest" assertions="3" time="5.0" classname="TestCase" status="passing"/>
      XML
    end
  end

end
