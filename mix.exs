defmodule Dero.Build do
    use Mix.Project

    def project do
        [
            app: :dero,
            version: "0.1.0",
            elixir: "~> 1.19",
            start_permanent: Mix.env() == :prod,
            deps: []
        ]
    end

    def application do
        [
            extra_applications: [:logger],
            mod: {Dero.Main, []}
        ]
    end
end
