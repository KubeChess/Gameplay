defmodule ClusterChess.Rules.Board do

    alias ClusterChess.Rules.Utilities
    alias ClusterChess.Rules.KingMoves
    alias ClusterChess.Rules.QueenMoves
    alias ClusterChess.Rules.RookMoves
    alias ClusterChess.Rules.BishopMoves
    alias ClusterChess.Rules.PawnMoves
    alias ClusterChess.Rules.KnightMoves

    defstruct [
        squares: %{},
        castling_rights: %{
            white_lx: true,
            white_sx: true,
            black_lx: true,
            black_sx: true
        },
        en_passant_target: nil,
        turn: :white
    ]

    def valid_move?(state, from, to) do
        case Map.get(state.squares, from) do
            {:king, _color}   -> KingMoves.valid_move?(state, from, to)
            {:queen, _color}  -> QueenMoves.valid_move?(state, from, to)
            {:rook, _color}   -> RookMoves.valid_move?(state, from, to)
            {:bishop, _color} -> BishopMoves.valid_move?(state, from, to)
            {:pawn, _color}   -> PawnMoves.valid_move?(state, from, to)
            {:knight, _color} -> KnightMoves.valid_move?(state, from, to)
            _empty_nil_square -> false
        end
    end

    def apply_move(state, from, to) do
        cond do
            Utilities.color(state.squares, from) != state.turn -> :invalid_move
            KingMoves.valid_castling?(state, from, to) -> apply_castling(state, from, to)
            PawnMoves.valid_en_passant?(state, from, to) -> apply_en_passant(state, from, to)
            valid_move?(state, from, to) -> apply_normal_move(state, from, to)
            true -> :invalid_move
        end
    end

    def apply_castling(state, from, to) do
        {rook_from, rook_to} = case to do
            {:c, 1} -> {{:a, 1}, {:d, 1}}
            {:g, 1} -> {{:h, 1}, {:f, 1}}
            {:c, 8} -> {{:a, 8}, {:d, 8}}
            {:g, 8} -> {{:h, 8}, {:f, 8}}
        end
        %{state | turn: Utilities.opponent(state.turn)}
        |> apply_normal_move(from, to)
        |> apply_normal_move(rook_from, rook_to)
    end

    def apply_en_passant(state, from, to) do
        new_board = Map.delete(state.squares, state.en_passant_target)
        tmp = %{state | board: new_board}
        apply_normal_move(tmp, from, to)
    end

    def apply_normal_move(state, from, to) do
        piece = Map.get(state.squares, from)
        new_board = state.squares
        |> Map.delete(from)
        |> Map.put(to, piece)
        opponent = Utilities.opponent(state.turn)
        %{state | board: new_board, turn: opponent}
    end
end
