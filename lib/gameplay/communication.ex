defmodule ClusterChess.Gameplay.Communication do

    use ClusterChess.Commons.Datapack

    @derive Jason.Encoder
    defstruct [
        :type,
        :token,
        :game,
        :count,
    ]

    @impl ClusterChess.Commons.Datapack
    def id(self),
        do: self.count |>
          Integer.to_string()
end
