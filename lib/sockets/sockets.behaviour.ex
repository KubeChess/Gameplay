defmodule ClusterChess.Sockets.Behaviour do

    @callback process(String.t(), map(), module())
        :: struct() | map()

end
