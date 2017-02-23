defmodule Timmer do
  def run do
    Process.flag(:trap_exit, true)
    res = spawn_monitor(Timmer, :spawn, [])
    IO.puts inspect res
    receive do
      message -> IO.puts inspect message
    after 3000 ->
      IO.puts "TIME PASSED"
    end
  end

  def spawn do
    :timer.sleep(2000)
    exit("BOOM")
  end
end
