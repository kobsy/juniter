require "test_helper"

class TestSuitePropertyTest < Minitest::Test

  %i{name value}.each do |attribute|
    context "##{attribute} assignment" do
      setup do
        @subject = Juniter::TestSuiteProperty.new
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
      @subject = Juniter::File.from_file(::File.join(__dir__, "support", "valid.xml"))
        .test_suites
        .test_suites
        .first
        .properties
        .first
    end

    should "parse attributes as target types" do
      { name: String,
        value: String }.each do |attribute, type|
          assert @subject.public_send(attribute).is_a?(type), "Expected #{attribute} to be a #{type}, but it was a #{@subject.public_send(attribute).class}"
        end
    end
  end

  context "#to_xml" do
    should "generate the expected XML" do
      output = Juniter::TestSuiteProperty.new.tap do |property|
        property.name = "Prop"
        property.value = "Value"
      end.to_xml.yield_self { |xml| Ox.dump(xml).strip }

      assert_equal output, <<~XML.strip
      <property name="Prop" value="Value"/>
      XML
    end
  end

end
