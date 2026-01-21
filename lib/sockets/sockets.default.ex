defmodule ClusterChess.Sockets.Base do
    defmacro __using__(_opts) do
        quote do
            @behaviour WebSock

            @impl WebSock
            def init(options) do
                IO.puts("Connected")
                IO.inspect(options)
                {:ok, options}
            end

            @impl WebSock
            def handle_in({"ping", [opcode: :text]}, state) do
                {:reply, :ok, {:text, "pong"}, state}
            end

            @impl WebSock
            def handle_in({message, [opcode: :text]}, state) do
                {:reply, :ok, {:text, "You said: #{message}"}, state}
            end

            @impl WebSock
            def handle_in(_frame, state) do
                {:ok, state}
            end

            @impl WebSock
            def handle_info({:forward, message}, state) do
                {:reply, :ok, {:text, "Forwarded message: #{message}"}, state}
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
            def terminate(_reason, _state) do
                :ok
            end
        end
    end
end
