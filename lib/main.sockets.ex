defmodule ClusterChess.Main.Sockets do
    @behaviour WebSock

    @impl WebSock
    def init(_options) do
        IO.puts("Connected")
        #Registry.register(:socket_registry, options.user_id, %{})
        #{:ok, options}
        {:ok, %{}}
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
    def handle_info(_message, state) do
        {:ok, state}
    end

    @impl WebSock
    def terminate(_reason, _state) do
        :ok
    end
end
