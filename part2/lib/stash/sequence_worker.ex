defmodule SequenceWorker do

  use GenServer

  def start_link(stashWorkerPid) do

    args = GenServer.call(stashWorkerPid, :unstash)
    run(stashWorkerPid, args)
  end

  def run(stashWorkerPid, stack) do
    GenServer.start_link(__MODULE__, {stack, stashWorkerPid}, [name: __MODULE__, debug: [:trace]])
  end

  def init(args) do
    {:ok, args}
  end

  def handle_call(:pop, _from, {s, p}) do
    {i, l} = List.pop_at(s, -1)
    StashWorker.stash(p, l)
    {:reply, i, {l, p}}
  end

  def handle_cast({:push, val}, {s, p}) do
    l = [val|s]
    StashWorker.stash(p, l)
    {:noreply, {l, p}}
  end

  def terminate(reason, {s, p}) do
    StashWorker.stash(p, s)
  end

  def pop do
    GenServer.call(__MODULE__, :pop)
  end

  def push(val) do
    GenServer.cast(__MODULE__, {:push, val})
  end
end
