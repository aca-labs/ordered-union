require "./spec_helper"

describe Union::OrderedConverter do
  it "parses custom ordering with primitive types" do
    string = %({"value":1})
    json = JSONAttrWithOrderedUnion.from_json(string)
    json.value.should be_a(Int64)
    json.to_json.should eq(string)
  end

  it "parses with complex types" do
    string = %({"value":[1,2,3]})
    json = JSONAttrWithComplexOrderedUnion.from_json(string)
    json.value.should be_a(Array(Int32))
    json.to_json.should eq(string)
  end
end
