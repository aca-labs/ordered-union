require "spec"
require "json"
require "../src/ordered_union"

struct JSONAttrWithOrderedUnion
  include JSON::Serializable

  @[JSON::Field(converter: Union::OrderedConverter(Int64, Float64))]
  property value : Int64 | Float64
end

class JSONAttrWithComplexOrderedUnion
  include JSON::Serializable

  @[JSON::Field(converter: Union::OrderedConverter(Int64, Float64, Array(Int32)))]
  property value : Int64 | Float64 | Array(Int32)
end
