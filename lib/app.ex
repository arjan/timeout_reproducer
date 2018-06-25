defmodule TimeoutReproducer.App do
  use Application

  @timeout 5000

  def start(_, _) do
    children = [
      {Postgrex, [
          hostname: "localhost",
          username: "postgres",
          password: "postgres",
          database: "arjan",
          timeout: @timeout,
          pool: DBConnection.Poolboy,
          pool_size: 10,
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
    Process.sleep 500
    for _ <- 1..100 do
      test()
      Process.sleep 6000
    end
  end

  def test() do
    IO.puts "testing.."
    Enum.each(1..40, fn i -> Task.async(fn ->
{:ok, _} = query("SELECT pg_sleep(1)")
IO.puts "Query #{i} OK"
end) end)
  end
end
