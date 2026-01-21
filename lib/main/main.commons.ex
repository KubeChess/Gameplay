defmodule ClusterChess.Main.Commons do

    alias ClusterChess.Main.Validation

    def validate_and_parse(decoded, _module) do
        with {:ok, authdata} <- Validation.validate_token(decoded["token"]),
             true            <- authdata.uid == decoded["datapack"]["uid"]
        do
                {:ok, decoded["datapack"]}
        else
                {:error, reason} -> {:error, reason}
                _uid_dont_match  -> {:error, "Unauthorized"}
        end
    end
end
