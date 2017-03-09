defmodule Ticker do
  @interval 2000
  @name :ticker

  def start do
    pid = spawn(__MODULE__, :generator, [[], 0])
    :global.register_name(@name, pid)
  end

  def register(client_pid) do
    send :global.whereis_name(@name), {:register, client_pid}
  end

  def generator(clients, current_client_index) do
    receive do
      {:register, client_pid} ->
        generator((clients ++ [client_pid]), current_client_index)
    after @interval ->
      if (length(clients) > 0) do
        to = Enum.at(clients, current_client_index)
        to
        |> send({:tick, current_client_index})
      end
      generator(clients, get_current_client_index(clients, current_client_index))
    end
  end

  def get_current_client_index(clients, index) do
    current_not_last = length(clients) > index + 1
    case current_not_last do
      true -> index + 1
      _ -> 0
    end
  end
end

defmodule Client do
  def start do
    pid = spawn(__MODULE__, :handler, [])
    Ticker.register(pid)
  end

  def handler do
    receive do
      {:tick, current_client_index} -> IO.puts("Client with index #{current_client_index} received a tick")
      handler()
    end
  end
end
