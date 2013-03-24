{:ok, redis} = :eredis.start_link
true = Process.register(redis, :redis)
ExUnit.start
