defmodule Stash do
  use Application

  def start(_a, _b) do
    MainSupervisor.start_link()
  end

end
