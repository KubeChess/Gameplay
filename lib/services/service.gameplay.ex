defmodule ClusterChess.Services.Gameplay do

    use ClusterChess.Services.Default

    @impl GenServer
    def handle_call(request, from, state) do
        IO.puts("------------------------------------------")
        IO.puts("Received call: #{inspect(request)}")
        IO.puts("From: #{inspect(from)}")
        IO.puts("Current state: #{inspect(state)}")
        IO.puts("Current process: #{inspect(self())}")
        IO.puts("------------------------------------------")
        {:reply, {:ok, request}, state}
    end
end
