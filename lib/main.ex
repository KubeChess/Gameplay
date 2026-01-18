defmodule Dero.Main do
    use Application

    defp cluster do
        [
            dero_cluster: [
                strategy: Cluster.Strategy.Epmd,
                config: [
                    hosts: [
                        :"a@127.0.0.1",
                        :"b@127.0.0.1",
                        :"c@127.0.0.1"
                    ]
                ]
            ]
        ]
    end

    defp children do
        [
            {Cluster.Supervisor, [cluster(), [name: :cluster_nodes_supervisor]]},
            {Horde.Registry, [name: :cluster_registry, keys: :unique, members: :auto]},
            {Horde.DynamicSupervisor, [
                name: :cluster_processes_supervisor,
                strategy: :one_for_one,
                members: :auto,
                max_restarts: 100,
                max_seconds: 5
            ]},
        ]
    end

    @impl true
    def start(_type, _args) do
        Supervisor.start_link(children(), strategy: :one_for_one)
    end

    def start(name) do
        Horde.DynamicSupervisor.start_child(
            :cluster_processes_supervisor,
            %{
                id: name,
                start: {Dero.Worker, :start_link, [name]},
                restart: :transient
            }
        )
    end

    def mailbox(name) do
        case Horde.Registry.lookup(:cluster_registry, name) do
            [{pid, _}] -> :erlang.process_info(pid, :message_queue_len)
            [] -> {:error, :not_found}
        end
    end

    def monitor() do
        Horde.DynamicSupervisor.which_children(:cluster_processes_supervisor)
    end

    def notify(name, message) do
        GenServer.cast(
            {:via, Horde.Registry, {:cluster_registry, name}},
            message
        )
    end

    def call(name, message) do
        GenServer.call(
            {:via, Horde.Registry, {:cluster_registry, name}},
            message
        )
    end
end
