defmodule ClusterChess.Sockets.Matchmaking do

    use ClusterChess.Sockets.Default

    alias ClusterChess.Sockets.Behaviour
    alias ClusterChess.Datapacks.MonitorQueue
    alias ClusterChess.Datapacks.JoinQueue
    alias ClusterChess.Datapacks.LeaveQueue
    alias ClusterChess.Main.Commons

    @impl WebSock
    def terminate(_reason, _state) do
        :ok
    end

    @impl Behaviour
    def process("queue.monitor", decoded, state) do
        json_message = Commons.validate_and_parse(decoded, MonitorQueue)
        with {:ok, _datapack} <- json_message do
            IO.puts "User monitoring the queue"
            {:reply, :ok, {:text, "queue.monitor.ack"}, state}
        else
            {:error, reason} -> {:reply, :ok, {:text, "error: #{reason}"}, state}
        end
    end

    @impl Behaviour
    def process("queue.join", decoded, state) do
        json_message = Commons.validate_and_parse(decoded, JoinQueue)
        with {:ok, _datapack} <- json_message do
            IO.puts "User joined queue"
            {:reply, :ok, {:text, "queue.join.ack"}, state}
        else
            {:error, reason} -> {:reply, :ok, {:text, "error: #{reason}"}, state}
        end
    end

    @impl Behaviour
    def process("queue.leave", decoded, state) do
        json_message = Commons.validate_and_parse(decoded, LeaveQueue)
        with {:ok, _datapack} <- json_message do
            IO.puts "User left queue"
            {:reply, :ok, {:text, "queue.leave.ack"}, state}
        else
            {:error, reason} -> {:reply, :ok, {:text, "error: #{reason}"}, state}
        end
    end
end
