Code.require_file "../test_helper.exs", __FILE__

defmodule NestTest do
  use ExUnit.Case

  setup do
    {:ok, "OK"} = :eredis.q(:redis, ["SELECT", 13])
    {:ok, "OK"} = :eredis.q(:redis, ["FLUSHDB"])
    :ok
  end

  test "return the namespace" do
    n1 = Nest.new key: "foo"
    assert "foo" == n1.key
  end

  test "prepend the namespace" do
    n1 = Nest.new key: "foo"
    assert "foo:bar" == n1["bar"].key
  end

  test "work in more than one level" do
    n1 = Nest.new key: "foo"
    n2 = Nest.new n1["bar"]
    assert "foo:bar:baz" == n2["baz"].key
  end

  test "be chainable" do
    n1 = Nest.new key: "foo"
    assert "foo:bar:baz" == n1["bar"]["baz"].key
  end

  test "accept atoms" do
    n1 = Nest.new(key: "foo")
    assert "foo:bar" == n1[:bar].key
  end

  test "accept numbers" do
    n1 = Nest.new(key: "foo")
    assert "foo:3" == n1[3].key
  end

  test "accept bitstrings" do
    n1 = Nest.new(key: "foo")
    assert "foo:bar" == n1['bar'].key
  end

  test "work if :redis is registered to eredis process" do
    n1 = Nest.new key: "foo"
    assert "OK" == n1.set! "s1"
    assert "s1" == n1.get!
  end

  test "work if an eredis pid is supplied" do
    {:ok, redis} = :eredis.start_link
    n1 = Nest.new key: "foo", redis: redis
    assert "OK" == n1.set! "s1"
    assert "s1" == n1.get!
    :eredis.stop(redis)
  end

  test "work if an eredis registered atom is supplied" do
    {:ok, redis} = :eredis.start_link
    true = Process.register(redis, :other_redis)
    n1 = Nest.new key: "foo", redis: :other_redis
    assert "OK" == n1.set! "s1"
    assert "s1" == n1.get!
    :eredis.stop(redis)
  end

  test "pass the redis process to new keys" do
    {:ok, redis} = :eredis.start_link
    n1 = Nest.new key: "foo", redis: redis
    assert redis == n1["bar"].redis
    :eredis.stop(redis)
  end

  test "work with plain calls that return errors" do
    n1 = Nest.new key: "foo"
    assert {:ok, "1"} == n1.sadd "s1"
    assert {:error, "ERR Operation against a key holding the wrong kind of value"}
      == n1.lpush "s2"
    assert {:ok, "1"} == n1.scard
  end

  test "throw error when bang! called with error" do
    n1 = Nest.new key: "foo"
    assert "1" == n1.sadd! "s1"
    assert "ERR Operation against a key holding the wrong kind of value"
      == catch_throw(n1.lpush! "s2")
    assert "1" == n1.scard!
  end

end
