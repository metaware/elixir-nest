defrecord Nest, key: nil, redis: :redis do

  methods = [ :append, :bitcount, :blpop, :brpop, :brpoplpush, :decr,
    :decrby, :del, :dump, :exists, :expire, :expireat, :get, :getbit,
    :getrange, :getset, :hdel, :hexists, :hget, :hgetall, :hincrby,
    :hincrbyfloat, :hkeys, :hlen, :hmget, :hmset, :hset, :hsetnx, :hvals,
    :incr, :incrby, :incrbyfloat, :lindex, :linsert, :llen, :lpop,
    :lpush, :lpushx, :lrange, :lrem, :lset, :ltrim, :move, :persist,
    :pexpire, :pexpireat, :psetex, :pttl, :publish, :rename, :renamenx,
    :restore, :rpop, :rpoplpush, :rpush, :rpushx, :sadd, :scard,
    :sdiff, :sdiffstore, :set, :setbit, :setex, :setnx, :setrange,
    :sinter, :sinterstore, :sismember, :smembers, :smove, :sort, :spop,
    :srandmember, :srem, :strlen, :sunion, :sunionstore,
    :ttl, :type, :watch, :zadd, :zcard, :zcount,
    :zincrby, :zinterstore, :zrange, :zrangebyscore, :zrank, :zrem,
    :zremrangebyrank, :zremrangebyscore, :zrevrange, :zrevrangebyscore,
    :zrevrank, :zscore, :zunionstore ]

  lc method inlist methods do
    args = [
      quote(do: argv // []),
      quote(do: Nest[key: key, redis: redis] = state) ]

    guards = [
      quote(do: is_binary(key)),
      quote(do: is_pid(redis) or is_atom(redis)) ]

    def method, args, guards do
      quote do
        call(redis, make_command(unquote(method), key, argv))
      end
    end

    def :'#{method}!', args, guards do
      quote do
        call!(redis, make_command(unquote(method), key, argv))
      end
    end
  end

  defp call(redis, command) do
    :eredis.q(redis, command)
  end

  defp call!(redis, command) do
    case :eredis.q(redis, command) do
      {:ok, reply} -> reply
      {:error, error} -> throw error
    end
  end
  
  defoverridable [call: 2, call!: 2]
  
  defp make_command(method, key, argv) when is_list(argv) do
    List.concat([method, key], argv)
  end
  defp make_command(method, key, arg) do
    make_command(method, key, [arg])
  end
  
end

defimpl Access, for: Nest do
  def access(Nest[key: key, redis: redis], part) when is_binary(key) do
    Nest.new(key: "#{key}:#{part}", redis: redis)
  end
end
