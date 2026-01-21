defmodule ClusterChess.Main.Router do
    use Plug.Router
    alias Plug.Conn
    alias ClusterChess.Main.Sockets
    alias ClusterChess.Auth.Validation

    plug :match
    plug :dispatch

    get "/games" do
        handler = {Sockets, %{}, []}
        Conn.upgrade_adapter(conn, :websocket, handler)
    end

    match _ do
        send_resp(conn, 404, "Not found")
    end
end
