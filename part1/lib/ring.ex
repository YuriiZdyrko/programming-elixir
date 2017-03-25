defmodule Ring do
  @moduledoc """
  Every joining process becomes a leader.
  Leader is responsible for passing "next_pid" to joining process.
  """

  @me __MODULE__
  @leader_name :leader_proc
  @interval 2000

  def run do
    pid = spawn(@me, :loop, [])
    send(pid, {:tick})
    Process.register(pid, @leader_name)
  end

  def join do
    pid = spawn(@me, :loop, [])
    send @leader_name, {:join, pid}
  end

  def loop do
    loop(self(), self())
  end

  def loop(own_pid, next) do
    receive do
      {:join, new_pid} ->
        send(new_pid, {:set_next, next})
        Process.unregister(@leader_name)
        Process.register(new_pid, @leader_name)
        loop(own_pid, new_pid)

      {:set_next, next_pid} ->
        loop(own_pid, next_pid)

      {:tick} ->
        IO.puts("#{inspect own_pid} received tick")
        :erlang.send_after(@interval, next, {:tick})
        loop(own_pid, next)
    end
  end
end
