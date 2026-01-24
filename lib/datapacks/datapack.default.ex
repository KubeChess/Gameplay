defmodule ClusterChess.Datapacks.Default do
    defmacro __using__(_opts) do
        quote do
            @behaviour ClusterChess.Datapacks.Behaviour

            @impl ClusterChess.Datapacks.Behaviour
            def enforce(data) do
                not_nil? = fn k -> !is_nil(data[k]) end
                res = struct(__MODULE__, %{})
                    |> Map.keys()
                    |> Enum.map(&to_string/1)
                    |> Enum.filter(&(&1 != "__struct__"))
                    |> Enum.all?(not_nil?)
                if res, do: {:ok, data},
                    else: {:error, "Invalid Datapack"}
            end

            defoverridable enforce: 1
        end
    end
end
