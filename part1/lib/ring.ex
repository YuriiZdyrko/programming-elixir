defmodule Ringee do

  @me __MODULE__
  @leader_name :leader_proc

  def run do
    {pid, _} = spawn_monitor(@me, :loop, [])
    Process.register(pid, @leader_name)
  end

  def join do
    {pid, ref} = spawn_monitor(@me, :loop, [])
    send @leader_name, {:join, pid}
  end

  def loop(own_pid, next, leader_pid) do
    receive do
      {:DOWN, _, :process, _, reason} ->
        IO.puts("Leader is dead. Reason: #{reason}")

      {:join, new_pid} ->
        send(self(), {:set_next, new_pid})
        send(new_pid, {:set_next, next})

      {:join, _} ->
        IO.puts("I should not be called")

      {:set_next, new_next} ->
        loop(own_pid, new_next, leader_pid)

      {:tick} ->
        IO.puts("pid: #{own_pid} received tick")
        :timer.sleep(2 * 1000)
        IO.puts("tick sent to pid: #{next}")
        send(next, {:tick})
        loop(own_pid, next, leader_pid)
    end
  end
end
