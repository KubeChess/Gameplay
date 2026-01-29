defmodule ClusterChess.Gameplay.DoMove do

    use ClusterChess.Commons.Datapack

    @derive Jason.Encoder
    defstruct [
        :type,
        :token,
        :game,
        :count,
        :from,
        :to,
        :promotion
    ]

    @impl ClusterChess.Commons.Datapack
    def id(self),
        do: self.move_count |>
          Integer.to_string()
end
