# TimeoutReproducer

Reproducer for https://github.com/elixir-ecto/db_connection/issues/127

Start with `iex -S mix` and execute `TimeoutReproducer.App.test`, the following error should start to appear.
```
08:51:09.028 [error] Task #PID<0.276.0> started from #PID<0.184.0> terminating
** (stop) exited in: :gen_server.call(#PID<0.180.0>, {:checkout, #Reference<0.250900131.883949572.240280>, true, 5000}, 5000)
    ** (EXIT) time out
    (db_connection) lib/db_connection/poolboy.ex:112: DBConnection.Poolboy.checkout/3
    (db_connection) lib/db_connection.ex:928: DBConnection.checkout/2
    (db_connection) lib/db_connection.ex:750: DBConnection.run/3
    (db_connection) lib/db_connection.ex:1141: DBConnection.run_meter/3
    (db_connection) lib/db_connection.ex:592: DBConnection.prepare_execute/4
    (postgrex) lib/postgrex.ex:146: Postgrex.query/4
    (timeout_reproducer) lib/app.ex:28: anonymous fn/1 in TimeoutReproducer.App.test/0
    (elixir) lib/task/supervised.ex:88: Task.Supervised.do_apply/2
Function: #Function<1.76782678/0 in TimeoutReproducer.App.test/0>
    Args: []
```

```
docker run --name db -e POSTGRES_USER=assetmap -e POSTGRES_PASSWORD=assetmap -e POSTGRES_DATABASE=assetmap -d --net=host postgres:10
docker run --net=host -it jtrantin/timeout_reproducer
iex> TimeoutReproducer.App.test
```
