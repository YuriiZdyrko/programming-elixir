defmodule Pmap do
  def run do
    time_taken = :timer.tc(fn() -> pma([1,3,4,5,6,7]) end)
    {microsecs, result} = time_taken;
    IO.puts "Time (msec): #{inspect microsecs / 1000}"
    IO.puts "Result: #{inspect result}"
  end

  def pma(list) do
    list

    # Spawn worker process for each item
    |> Enum.map(fn(item) ->
      spawn_link(Pmap, :worker, [self(), item])
    end)

    # Collect responses from workers,
    # compare id to ensure order
    |> Enum.map(fn(pid) ->
      receive do
        {id, result, sleep_time} when id == pid -> {result, sleep_time}
      end
    end)
  end

  def worker(parent_pid, number) do
    sleep_time = :rand.uniform(2000)
    :timer.sleep(sleep_time)
    send parent_pid, {self(), number * number, sleep_time}
  end
end
