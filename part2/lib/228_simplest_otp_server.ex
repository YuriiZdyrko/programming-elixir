defmodule SimplestOTPServer do
  defstruct [
    counter: 0
  ]

  use GenServer

  def run do
    GenServer.start_link(__MODULE__, nil, [])
  end

  def init(_) do
    {:ok, %SimplestOTPServer{counter: 0}}
  end

  def handle_call(:inc, _from, %{counter: c}) do
    c_plus = c + 1
    {:reply, c_plus, %SimplestOTPServer{counter: c_plus}, 1000}
  end

  def handle_call({:set, num}, from, state) do
    {:reply, :ok, %SimplestOTPServer{counter: num}}
  end


  def handle_info(msg, state) do
    case msg do
      :timeout ->
        IO.puts "handle_info:timeout"
        {:noreply, state}
    end
  end

end
