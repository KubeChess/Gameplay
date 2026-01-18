defmodule Dero.Games.WebSockets do
    @behaviour :cowboy_websocket

    @impl true
    def init(request, _state) do
        {:cowboy_websocket, request, %{}}
    end

    @impl true
    def websocket_init(state) do
        IO.puts("WebSocket connection established.")
        Process.send_after(self(), {:forward, "Hello in 3 seconds!"}, 3_000)
        {:ok, state}
    end

    @impl true
    def websocket_handle({:text, message}, state) do
        IO.puts("Received message: #{message}")
        {:reply, {:text, "Echo: #{message}"}, state}
    end

    @impl true
    def websocket_handle(_data, state) do
        {:ok, state}
    end

    @impl true
    def websocket_info({:forward, message}, state) do
        {:reply, {:text, message}, state}
    end

    @impl true
    def websocket_info(_info, state) do
        {:ok, state}
    end

    @impl true
    def terminate(_reason, _req, _state) do
        IO.puts("WebSocket connection terminated.")
        :ok
    end
end
