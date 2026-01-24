defmodule ClusterChess.Datapacks.Default do
    defmacro __using__(_opts) do
        quote do
            @behaviour ClusterChess.Datapacks.Behaviour

            @impl ClusterChess.Datapacks.Behaviour
            def enforce(data) do
                keys = struct(__MODULE__, %{})
                |> Map.keys()
                |> Enum.map(&to_string/1)
                |> Enum.filter(&(&1 != "__struct__"))

                results = Enum.map(keys, fn k -> {k, data[k], is_nil(data[k])} end)
                IO.inspect(results, label: "Key checks")

                not_nil? = fn k -> !is_nil(data[k]) end

                if Enum.all?(keys, not_nil?),
                    do: {:ok, data},
                    else: {:error, "Invalid Datapacks"}
            end

            defoverridable enforce: 1
        end
    end
end
