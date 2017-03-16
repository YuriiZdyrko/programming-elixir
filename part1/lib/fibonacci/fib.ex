defmodule Fiba do
  def run(scheduler) do
    send scheduler, {:ready, self()}
    receive do
      {:fib, next, client} ->
        send client, {:answer, fib(next), self()}
        run(scheduler)
      {:shutdown} ->
        exit(:normal)
    end
  end

  def fib(0), do: 0
  def fib(1), do: 1
  def fib(n) do
    fib(n - 1) + fib(n - 2)
  end
end

defmodule Scheduler do
  def run(n_slaves, m, f, a) do
    1..n_slaves
    |> Enum.map(fn(_) -> spawn(m, f, [self()]) end)
    |> use_slaves(a, [])
  end

  def use_slaves(slaves, queue, result) do
    receive do
      {:ready, slave_pid} when length(queue) > 0 ->
        [h | t] = queue;
        send slave_pid, {:fib, h, self()}
        use_slaves(slaves, t, result)

      {:ready, slave_pid} ->
        send slave_pid, {:shutdown}
        slaves = List.delete(slaves, slave_pid)
        if length(slaves) > 0 do
          use_slaves(slaves, queue, result)
        else
          result
        end

      {:answer, answer, slave_pid} ->
        use_slaves(slaves, queue, [answer | result])
    end
  end
end

defmodule FibRunner do
  def run do
    list = List.duplicate(30, 20);
    number_of_slaves = 20
    1..number_of_slaves
    |> Enum.each(fn(n) ->
      {time, result} = :timer.tc(Scheduler, :run, [n, Fiba, :run, list])
      IO.puts(time / 1000)
    end)
  end
end
