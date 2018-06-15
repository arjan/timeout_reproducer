defmodule TimeoutReproducer.App do
  use Application

  @timeout 5000

  def start(_, _) do
    children = [
      {Postgrex, [
        hostname: "localhost",
        username: "assetmap",
        password: "assetmap",
        database: "assetmap",
        timeout: @timeout,
        pool: DBConnection.Poolboy,
        pool_size: 100,
        name: TestPool
      ]}
    ]

    Supervisor.start_link(children, name: TimeoutReproducer.Supervisor, strategy: :one_for_one)
  end

  def query(query, params \\ []) do
    Postgrex.query(TestPool, query, params, timeout: @timeout, pool_timeout: @timeout, pool: DBConnection.Poolboy)
  end

  def test() do
    Enum.each(1..40, fn i -> Task.async(fn -> 
      {:ok, _} = query("SELECT pg_sleep(1)") 
      IO.puts "Query #{i} OK"
    end) end)
  end
end
