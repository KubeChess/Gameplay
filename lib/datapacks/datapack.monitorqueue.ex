defmodule ClusterChess.Datapacks.MonitorQueue do

    use ClusterChess.Datapack.Default

    @derive Jason.Encoder
    defstruct [
        :uid,
        :queue_id
    ]
end
