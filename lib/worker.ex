defmodule Dero.Worker do
    use GenServer

    def start_link(name) do
        GenServer.start_link(__MODULE__, [], name:
            {:via, Horde.Registry, {:cluster_registry, name}})
    end

    @impl true
    def init(state) do
        IO.puts("Dero.Worker started with state: #{inspect(state)} on node #{Node.self()}")
        {:ok, state}
    end

    @impl true
    def handle_cast(:crash, state) do
        IO.puts("Crashing now on node #{Node.self()}...")
        raise "boom"
        {:noreply, state}
    end

    @impl true
    def handle_cast(message, state) do
        IO.puts("Received message: #{inspect(message)} on node #{Node.self()}")
        {:noreply, state}
    end
end
