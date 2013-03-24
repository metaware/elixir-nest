Nest
====

Record Oriented Keys for Redis

Description
-----------

Nest for Elixir is a clone of [Nest for
Ruby](https://github.com/soveran/nest).

Nest helps you generate keys for key value stores by providing chainable
namespaces. Nest uses [eredis
](https://github.com/wooga/eredis) for connecting to redis.

    >> {:ok, redis} = :eredis.start_link
    >> event = Nest.new(key: "event", redis: redis)
    >> event[3][:attendies].sadd!("albert")
    >> event[3][:attendies].smembers!
    => ["Albert"]

Usage
-----

To create a new namespace: 

    >> ns = Nest.new(key: "foo")
    => Nest[key: "foo", redis: :redis]
   
    >> ns["bar"].key
    => "foo:bar"

    >> ns["bar"]["baz"]["qux"].key
    => "foo:bar:baz:qux"

You can use any Integer, Atom, or BitString as a key, not only binary:

    >> ns[:bar][42]['bee']
    => "foo:bar:42:bee"

Here is an example dealing with events:

    >> events = Nest.new(key: "events")
    => "events"

    >> id = events[:id].incr
    => {:ok, "1"}

    >> events[id][:attendees].sadd("Albert")
    => {:ok, "OK"}

    >> meetup = events[id]
    => Nest[key: "events:1", redis: :redis]

    >> meetup[:attendees].smembers
    => {:ok, ["Albert"]}

Calling redis commands with a bang (!) will 
return only the value, throwing any errors.

    >> events = Nest.new(key: "events")
    => "events"

    >> id = events[:id].incr!
    => "1"

    >> events[id][:attendees].sadd!("Albert")
    => "OK"

    >> meetup = events[id]
    => Nest[key: "events:1", redis: :redis]

    >> meetup[:attendees].smembers!
    => ["Albert"]

Multiple arguements can be suppled as a List:

    >> events[id][:orders].lpush(["beer", beer", "wine"])
    => "3"
    >> events[id][:orders].lrange([0, -1])
    => ["beer", beer", "wine"]

Overriding call/2


License
-------


Copyright (c) 2013 Tyler Butchart
Copyright (c) 2010 Michel Martens & Damian Janowski (for Ruby Nest)

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE. 
