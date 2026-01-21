defmodule ClusterChess.Datapacks.JoinQueue do

    use ClusterChess.Datapack.Default

    @derive Jason.Encoder
    defstruct [
        :uid,
        :rating,
        :preferred_color,
        :required_color,
        :timeformat,
        :increment
    ]
end
