defmodule ClusterChess.Datapacks.Queue.Test do
    use ExUnit.Case

    alias ClusterChess.Datapacks.Queue

    test "Parse Queue Datapacks" do
        msg = %{
            "token" => "guest",
            "rating" => "1500",
            "preferred_color" => "white",
            "required_color" => "none",
            "ranked" => true,
            "minutes" => "5",
            "increment" => "0"
        }
        {status, _output} = Queue.enforce(msg)
        assert :ok == status
    end
end
