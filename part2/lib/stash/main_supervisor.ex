defmodule MainSupervisor do
  use Supervisor

  def start_link do
    {:ok, sup } = Supervisor.start_link(__MODULE__, [])
    {:ok, stashWorkerPid} = Supervisor.start_child(sup, worker(StashWorker, []))
    {:ok, _} = Supervisor.start_child(sup, supervisor(Sequence, [stashWorkerPid]))
  end

  def init(_) do
    supervise [], strategy: :one_for_one
  end

end
