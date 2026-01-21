defmodule ClusterChess.Datapacks.LeaveQueue do

    use ClusterChess.Datapack.Default

    @derive Jason.Encoder
    defstruct [
        :uid,
        :queue_id
    ]
end
