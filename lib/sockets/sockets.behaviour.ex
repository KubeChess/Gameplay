defmodule ClusterChess.Sockets.Behaviour do
    @callback recieve(datapack_t :: struct()) :: struct(),
    @callback forward(datapack_t :: struct()) :: struct()
end
