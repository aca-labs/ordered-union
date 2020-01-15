# Converter to be used with `JSON.mapping` to read JSON values into a `Union`
# type with a non-standard type order.
#
# ```
# require "json"
#
# class Example
#   JSON.mapping({
#     value:           {type: Int64 | Float64},
#     converted_value: {type: Int64 | Float64, converter: Union::OrderedConverter(Int64, Float64)},
#   })
# end
#
# example = Example.from_json(%({"value": 1, "converted_value": 1}))
# example.value           # => "1.0"
# example.converted_value # => "1"
# example.to_json         # => %({"value": 1.0, "converted_value": 1})
# ```
module Union::OrderedConverter(*T)
  def self.from_json(pull : JSON::PullParser) : Union(*T)
    location = pull.location
    string = nil

    {% begin %}
      {% primitives = [Bool, String] + Number::Primitive.union_types %}
      {% read = false %}

      {% for type in T %}
        {% if read %}
          begin
            return {{type}}.from_json(string)
          rescue JSON::ParseException
            # Ignore
          end
        {% else %}
          {% if type == Nil %}
            return pull.read_null if pull.kind.null?
          {% elsif primitives.includes? type %}
            value = pull.read?({{type}})
            return value unless value.nil?
          {% else %}
            {% read = true %}
            string = pull.read_raw
            begin
              return {{type}}.from_json(string)
            rescue JSON::ParseException
              # Ignore
            end
          {% end %}
        {% end %}
      {% end %}
    {% end %}

    string ||= pull.read_raw
    raise JSON::ParseException.new("Couldn't parse #{Union(*T)} from #{string}", *location)
  end

  def self.to_json(value, json : JSON::Builder)
    value.to_json(json)
  end
end
