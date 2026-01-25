defmodule ClusterChess.Datapacks.Queue do

    use ClusterChess.Datapacks.Default
    alias ClusterChess.Datapacks.Behaviour

    @derive Jason.Encoder
    defstruct [
        :type,
        :token,
        :pool,
        :minutes,
        :increment
    ]

    @impl Behaviour
    def id(self) do
        with {:ok, minutes}   <- Map.fetch(self, :minutes),
             {:ok, increment} <- Map.fetch(self, :increment),
             {:ok, pool}      <- Map.fetch(self, :pool)
        do
            {:ok, "#{pool}-#{minutes}+#{increment}"}
        else
            _ -> {:error, "Missing key fields"}
        end
    end
end
