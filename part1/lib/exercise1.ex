defmodule UniqueProcesses do

  # Stupid approach
  def start_process(sender) do
    receive do
      curse ->
        send sender, curse
    end
  end

  def run_one do
    procOne = spawn(UniqueProcesses, :start_process, [self()])
    procTwo = spawn(UniqueProcesses, :start_process, [self()])

    send procOne, "Hello"
    send procTwo, "World"

    receive do
      word ->
        IO.puts "It says #{word}..."
        receive do
          word_two ->
            IO.puts "And also #{word_two}!!!"
        end
    end
  end


  # better approach
  def run_two do
    spawn_and_send("Hello")
    spawn_and_send("World")
  end

  def spawn_and_send(word) do
    process = spawn(UniqueProcesses, :echo, [self()])
    send process, word
    receive do
      response ->
        IO.puts "It says #{response}"
    end
  end

  def echo(caller) do
    receive do
      any ->
        send caller, any
    end
  end
end
