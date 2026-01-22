defmodule ClusterChess.Sockets.Matchmaking do

    use ClusterChess.Sockets.Default

    alias ClusterChess.Main.Validation
    alias ClusterChess.Sockets.Behaviour
    alias ClusterChess.Sockets.Commons
    alias ClusterChess.Services.Matchmaking
    alias ClusterChess.Datapacks.Queue

    @opcodes ["queue.join", "queue.monitor", "queue.leave"]

    @impl WebSock
    def terminate(_reason, _state) do
        :ok
    end

    @impl Behaviour
    def process(opcode, msg, state) when opcode in @opcodes do
        with {:ok, _auth} <- Validation.validate_token(msg["token"]),
             {:ok, queue} <- Queue.enforce(msg),
             {:ok, mmkey} <- Queue.getkey(queue)
        do
            Commons.delegate(Matchmaking, mmkey, queue)
            {:ok, state, %{"msg" => "#{opcode}.ack"}}
        else
            {:error, reason} -> {:error, state, reason}
        end
    end

    @impl Behaviour
    def process(opcode, _, state),
        do: {:error, state, "Unsupported operation: #{opcode}"}
end
