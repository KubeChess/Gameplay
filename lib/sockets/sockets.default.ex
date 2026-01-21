defmodule ClusterChess.Sockets.Default do
    defmacro __using__(_opts) do
        quote do
            @behaviour WebSock
            @behaviour ClusterChess.Sockets.Behaviour

            @impl WebSock
            def handle_info({:forward, message}, state) do
                {:reply, :ok, {:text, message}, state}
            end

            @impl WebSock
            def init(options) do
                IO.puts("------------------------------------------")
                IO.puts("Connection enstabilished")
                IO.puts("Current options: #{inspect(options)}")
                IO.puts("Current process: #{inspect(self())}")
                IO.puts("------------------------------------------")
                {:ok, options}
            end

            @impl WebSock
            def handle_info(message, state) do
                IO.puts("------------------------------------------")
                IO.puts("Received info message: #{inspect(message)}")
                IO.puts("Current state: #{inspect(state)}")
                IO.puts("Current process: #{inspect(self())}")
                IO.puts("------------------------------------------")
                {:ok, state}
            end

            @impl WebSock
            def handle_in({message, [opcode: :text]}, state) do
                decoded = Jason.decode!(message)
                msgtype = Map.get(decoded, "type")
                jsonout = process(msgtype, decoded, state)
            end

            @impl WebSock
            def handle_in({_msg, [opcode: opcode]}, state)
                when (opcode != :text), do: {:ok, state}
        end
    end
end
