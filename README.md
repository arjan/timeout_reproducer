# TimeoutReproducer

Reproducer for https://github.com/elixir-ecto/db_connection/issues/127

Start with `./run.sh`, which just starts the `timeout_reproducer` app.

```
iex -pa '_build/dev/lib/*/ebin' --app timeout_reproducer
```


The following error should start to appear after a while:

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

You can verify that the workers are stuck by running `diagnose`:

```
iex(6)> TimeoutReproducer.App.diagnose
----
Worker #PID<0.569.0> is stuck:
{:current_stacktrace,
 [
   {:prim_inet, :recv0, 3, []},
   {Postgrex.Protocol, :msg_recv, 4,
    [file: 'lib/postgrex/protocol.ex', line: 1985]},
   {Postgrex.Protocol, :ping_recv, 4,
    [file: 'lib/postgrex/protocol.ex', line: 1734]},
   {DBConnection.Connection, :handle_info, 2,
    [file: 'lib/db_connection/connection.ex', line: 373]},
   {Connection, :handle_async, 3, [file: 'lib/connection.ex', line: 810]},
   {:gen_server, :try_dispatch, 4, [file: 'gen_server.erl', line: 637]},
   {:gen_server, :handle_msg, 6, [file: 'gen_server.erl', line: 711]},
   {:proc_lib, :init_p_do_apply, 3, [file: 'proc_lib.erl', line: 249]}
 ]}

```
