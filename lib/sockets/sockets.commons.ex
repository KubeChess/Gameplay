defmodule ClusterChess.Sockets.Commons do

    def delegate(module, name, msg) do
        case get_worker(module, name) |> GenServer.call(msg) do
            :ok -> {:ok, :ack}
            {:ok, something} -> {:ok, something}
            _ -> delegate(module, name, msg)
        end
    end

    defp get_worker(module, name) do
        settings = {module, :start_link, [name]}
        outcome = Horde.DynamicSupervisor.start_child(
            :cluster_processes_supervisor,
            %{ id: name, restart: :transient, start: settings}
        )
        case outcome do
            {:ok, pid} -> pid
            {:error, {:already_started, pid}} -> pid
        end
    end

    def decode!(frame, :text),   do: Jason.decode!(frame)
    def decode!(frame, :binary), do: Msgpax.unpack!(frame)
    def decode(frame, :text),    do: Jason.decode(frame)
    def decode(frame, :binary),  do: Msgpax.unpack(frame)
    def encode!(data, :text),    do: Jason.encode!(data)
    def encode!(data, :binary),  do: Msgpax.pack!(data)

    def error(reason, opcode, state \\ %{}),
        do: {:reply, :ok, {opcode, error_helper(reason, opcode)}, state}

    defp error_helper(reason, :text),   do: Jason.encode!(%{"error" => reason})
    defp error_helper(reason, :binary), do: Msgpax.pack!(%{"error" => reason})
end
