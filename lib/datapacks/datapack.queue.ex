defmodule ClusterChess.Datapacks.Queue do

    use ClusterChess.Datapack.Default
    alias ClusterChess.Datapack.Behaviour

    @derive Jason.Encoder
    defstruct [
        :token,
        :rating,
        :preferred_color,
        :required_color,
        :timeformat,
        :increment
    ]

    @impl Behaviour
    def enforce(data) do
        values = struct(__MODULE__, data) |> Map.values()
        if Enum.all?(values, fn v -> !is_nil(v) end) do
            {:ok, struct(__MODULE__, data)}
        else
            {:error, "Invalid datapack"}
        end
    end

    @impl Behaviour
    def getkey(self) do
        with {:ok, timeformat} <- Map.fetch(self, :timeformat),
             {:ok, increment}  <- Map.fetch(self, :increment)
        do
            {:ok, "#{timeformat}+#{increment}"}
        else
            _ -> {:error, "Missing key fields"}
        end
    end
end
