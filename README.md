Pure ruby independent ID generator like the SnowFlake, ChiliFlake
=================================================================

This is ID generator like the SnowFlake and ChiliFlake that implemented by pure ruby.


Installation
------------

Add this line to your application's Gemfile:

    gem "anyflake"

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install anyflake


QuickStart
----------

**Genenate ID:**

```
service_epoch = Time.new(2016, 7, 1, 0, 0, 0).strftime('%s%L').to_i
node_id = 1
af = AnyFlake.new(service_epoch, node_id)
af.next_id
=> 8697308774404097
```

**Parse for the Flaked ID:**

```
af.parse(8697308774404097)

or

AnyFlake.parse(8697308774404097, service_epoch)
=> {:epoch_time=>2073600000, :time=>2016-07-25 00:00:00 +0900, :node_id=>1, :sequence=>1}
```


Overview
--------

ID structure

```
 upper bit(always 0)   1 bit
 epoch timestamp      41 bits
 node id              10 bits
 sequence per node    12 bits
```


Notice:

1. Duplicate when generate the ID of 4096 or more per node within 1ms.  
   => Workaround: Unique check in the user side. (e.g. DB Pkey, unique index...)

   see https://github.com/twitter/snowflake  
   see https://github.com/ma2shita/chiliflake

Contributing
------------

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/anyflake.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

