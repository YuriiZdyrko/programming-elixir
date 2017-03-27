defmodule StashWorker do

  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, [])
  end

  def init do
    {:ok, 0}
  end

  def handle_call(:unstash, _from, state) do
    {:reply, state, state}
  end

  def handle_cast({:stash, new_state}, _state) do
    {:noreply, new_state}
  end

  def stash(pid, n) do
    GenServer.cast(pid, {:stash, n})
  end

  def unstash(pid) do
    GenServer.call(pid, :unstash)
  end
end
