defmodule ClusterChess.Matchmaking.Socket do

    use ClusterChess.Commons.Socket

    alias ClusterChess.Commons.Validation
    alias ClusterChess.Main.Messaging
    alias ClusterChess.Commons.Formatting
    alias ClusterChess.Matchmaking.Listener
    alias ClusterChess.Matchmaking.Queue

    @message_types ["queue.join", "queue.ping", "queue.leave"]

    @impl WebSock
    def handle_in({message, [opcode: protocol]}, state) do
        with {:ok, plain} <- Formatting.decode(message, protocol),
             {:ok, token} <- Map.fetch(plain, "token"),
             {:ok, _rank} <- Map.fetch(plain, "elo"),
             {:ok, mtype} <- Map.fetch(plain, "type"),
             {:ok, _type} <- Formatting.contains(@message_types, mtype),
             {:ok, _mode} <- Map.fetch(plain, "gamemode"),
             {:ok, creds} <- Validation.validate_token(token),
             {:ok, queue} <- Queue.enforce(plain),
             {:ok, _resp} <- delegate_matchmaking(queue, creds)
        do
            Formatting.encode!(%{ "msg" => "#{mtype}.ack" }, protocol)
                |> Formatting.resp(protocol, state)
        else
            {:error, reason} -> Formatting.error(reason, protocol, state)
            generic_err -> "Invalid message format #{inspect(generic_err)}" |>
                Formatting.error(protocol, state)
        end
    end

    defp delegate_matchmaking(request, creds) do
        Messaging.summon_and_delegate(
            Listener, request, [
                gamemode: request.gamemode,
                player: creds.uid,
                elo: request.elo
            ]
        )
    end
end
