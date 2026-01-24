defmodule ClusterChess.Sockets.Matchmaking.Test do
    use ExUnit.Case

    alias ClusterChess.Sockets.Matchmaking
    alias ClusterChess.Datapacks.Queue

    test "Join Matchmaking Queue" do
        msg = %{
            "token" => "Guest",
            "rating" => "1500",
            "preferred_color" => "white",
            "required_color" => "none",
            "ranked" => true,
            "minutes" => "5",
            "increment" => "0"
        }
        result = Matchmaking.process("queue.join", msg, %{})
        assert result == {:ok, %{}, %{"msg" => "queue.join.ack"}}
    end
end
