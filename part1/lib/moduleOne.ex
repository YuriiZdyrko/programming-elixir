defmodule ModuleOne do
  def greet do
    receive do
      {sender, msg} ->
        send sender, msg
    end
  end
end
