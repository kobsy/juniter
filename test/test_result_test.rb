require "test_helper"

class TestResultTest < Minitest::Test

  context ".from_xml" do
    setup do
      test_suite = Juniter::File.from_file(::File.join(__dir__, "support", "valid.xml"))
        .test_suites
        .test_suites
        .first
      @error_subject = test_suite.test_cases.last.result
    end

    should "parse attributes as target types" do
      { type: String,
        message: String }.each do |attribute, type|
          assert @error_subject.public_send(attribute).is_a?(type), "Expected #{attribute} to be a #{type}, but it was a #{@error_subject.public_send(attribute).class}"
        end
    end

    should "parse the description" do
      assert @error_subject.description.length.positive?
    end

    should "parse embedded CDATA as the description" do
      test_suite = Juniter::File.from_file(::File.join(__dir__, "support", "cdata.xml"))
        .test_suites
        .test_suites
        .first
      @error_subject = test_suite.test_cases.last.result

      assert @error_subject.description.length.positive?
    end
  end

  context ".to_xml" do
    should "output the correct tag based on status" do
      expectations = {
        pass: "",
        fail: "<failure/>",
        error: "<error/>",
        skip: "<skipped/>"
      }
      expectations.each do |status, tag|
        xml = Juniter::TestResult.new(status).to_xml
        string = xml.nil? ? "" : Ox.dump(xml).strip
        assert_equal tag, string
      end
    end

    should "output all attributes and children correctly" do
      result = Juniter::TestResult.new(:fail).tap do |failure|
        failure.type = "Epic"
        failure.message = "It was terrible"
        failure.description = "Stacktrace here"
      end
      assert_equal <<~XML.strip, Ox.dump(result.to_xml).strip
        <failure type="Epic" message="It was terrible">Stacktrace here</failure>
      XML
    end
  end

  should "reflect the proper status via ? methods" do
    STATUSES.each do |status|
      result = Juniter::TestResult.new(status)
      assert result.public_send(:"#{status}?")
      (STATUSES - [ status ]).each do |not_status|
        refute result.public_send(:"#{not_status}?")
      end
    end
  end

  STATUSES = %i{pass fail error skip}.freeze

end
