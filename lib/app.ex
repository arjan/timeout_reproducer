defmodule TimeoutReproducer.App do
  use Application

  @timeout 5000
  @sleep 0.1
  @pool 100
  @n 400

  def start(_, _) do
    children = [
      {Postgrex, [
          hostname: "localhost",
          username: "postgres",
          password: "postgres",
          database: "arjan",
          timeout: @timeout,
          pool: DBConnection.Poolboy,
          pool_size: @pool,
          name: TestPool
        ]}
    ]

    spawn(fn -> test_loop() end)

    Supervisor.start_link(children, name: TimeoutReproducer.Supervisor, strategy: :one_for_one)
  end

  def query(query, params \\ []) do
    Postgrex.query(TestPool, query, params, timeout: @timeout, pool_timeout: @timeout, pool: DBConnection.Poolboy)
  end

  def test_loop do
    test()
    Process.sleep @timeout
    test_loop()
  end

  def test() do
    IO.puts "Testing.."
    1..@n
    |> Enum.map(fn i -> Task.async(fn -> {:ok, _} = query("SELECT pg_sleep(#{@sleep})") end) end)
    |> Enum.map(fn t -> Task.await(t) end)
  end

  def diagnose do
    stuck =
      GenServer.call(Elixir.TestPool, :get_all_workers)
      |> Enum.map(&elem(&1, 1))
      |> Enum.filter(fn(pid) -> {_, len} = Process.info(pid, :message_queue_len); len > 0 end)

    for pid <- stuck do
      IO.puts "----"
      IO.puts "Worker #{inspect pid} is stuck:"
      IO.inspect Process.info(pid, :current_stacktrace)
      IO.puts ""
    end
  end
end
