defmodule DebugApp do
  use Application
  def start(_, _) do
    #YourModule.your_function()
    {:ok, self()}
  end
end
