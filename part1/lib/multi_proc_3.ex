defmodule MultiProc do
  def run do
    spawn_link(MultiProc, :child_proc, [self()])
    :timer.sleep(500)
    listen()
  end

  def child_proc(parentPid) do
    send parentPid, "Hi from childProc"
    exit("child exited")
  end

  def listen do
    receive do
      received_data ->
        IO.puts inspect received_data
        listen()
      after 1000 ->
        IO.puts("Timeout reached")
        exit("Nothing ever happens")
    end
  end
end
