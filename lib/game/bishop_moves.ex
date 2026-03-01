defmodule Game.BishopMoves do

    alias Game.Utilities
    alias Game.MakeUpdates

    def apply_move!(board, from, to),
        do: board
        |>  MakeUpdates.update_en_passant_target(from, to)
        |>  MakeUpdates.update_fullmoves_counter(from, to)
        |>  MakeUpdates.update_halfmoves_counter(from, to)
        |>  MakeUpdates.update_current_turn()
        |>  MakeUpdates.update_squares_after_move(from, to)

    def legal_moves(board, from) do
        diag1 = for x <- -7..7, do: Utilities.shift(board, from, {x, x})
        diag2 = for x <- -7..7, do: Utilities.shift(board, from, {x, -x})
        Enum.filter(diag1 ++ diag2, fn to -> valid_move?(board, from, to) end)
    end

    def valid_move?(state, from, to),
        do: Utilities.valid_diagonal_move?(state, from, to)
        and Map.get(state.squares, from) != nil
        and Map.get(state.squares, from) |> elem(0) == :bishop
end
