require "test_helper"

class TestSuitePropertiesTest < Minitest::Test

  context "#to_xml" do
    should "generate the expected XML" do
      output = Juniter::TestSuiteProperties.new.tap do |properties|
        properties << Juniter::TestSuiteProperty.new.tap do |property|
          property.name = "Prop"
          property.value = "Value"
        end
      end.to_xml.yield_self { |xml| Ox.dump(xml).strip }

      assert_equal output, <<~XML.strip
      <properties>
        <property name="Prop" value="Value"/>
      </properties>
      XML
    end
  end

end
