# ordered-union

Provides a generic `Union::OrderConverter` module for specifying arbitrary type
orders when deserializing JSON into union types.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     ordered-union:
       github: aca-labs/ordered-union
   ```

2. Run `shards install`

## Usage

```crystal
require "ordered-union"

struct Example
  include JSON::Serializable

  @[JSON::Field(converter: Union::OrderedConverter(UInt64, Int64, Float64))]
  property value : UInt64 | Int64 | Float64
end

x = Example.from_json %({"value":1})
x.value.class #=> UInt64
```

Values are parsed based on the order specified for the converter instance. The
specified types do not need to be exhaustive, but must be a subset of the types
that form the union to be parsed in to.

## Contributing

1. Fork it (<https://github.com/aca-labs/ordered-union/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Kim Burgess](https://github.com/kimburgess) - creator and maintainer
