defmodule Sequence do
  use Supervisor

  def start_link(stashWorkerPid) do
    {:ok, _pid} = Supervisor.start_link(__MODULE__, stashWorkerPid)
  end

  def init(stashWorkerPid) do
    children = [
      worker(SequenceWorker, [stashWorkerPid])
    ]
    supervise children, strategy: :one_for_one
  end
end
