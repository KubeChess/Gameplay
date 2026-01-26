defmodule ClusterChess.Services.Matchmaking do

    use ClusterChess.Services.Default

    @registry :matchmaking_registry
    @initial_state %{ queue: [], matches: 0 }

    def start_link(gamemode, player, elo) do
        process_key = %{ gamemode: gamemode, player: player, elo: elo }
        GenServer.start_link(__MODULE__, @initial_state, name:
            {:via, Horde.Registry, {@registry, process_key}})
    end

    def search_opponents(gamemode, min_elo, max_elo) do
        Horde.Registry.select(:matchmaking_registry, [{
            {:"$1", :"$2", :"$3"}, [
                {:is_map, :"$1"},
                {:is_map_key, :elo, :"$1"},
                {:is_map_key, :gamemode, :"$1"},
                {:==, {:map_get, :gamemode, :"$1"}, gamemode},
                {:>=, {:map_get, :elo, :"$1"}, min_elo},
                {:<, {:map_get, :elo, :"$1"}, max_elo}
            ], [{{:"$1", :"$2"}}]
        }])
    end

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
