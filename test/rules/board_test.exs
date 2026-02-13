defmodule ClusterChess.Rules.Board.Test do
    use ExUnit.Case

    alias ClusterChess.Rules.Board

    @full_castling_rights %{
        white_kingside:  true,
        white_queenside: true,
        black_kingside:  true,
        black_queenside: true
    }

    test "board move ok [valid move, white turn, no special case]" do
        squares = %{ {:a, 2} => {:pawn, :white} }
        state = %{
            squares: squares,
            turn: :white,
            en_passant_target: nil,
            castling_rights: @full_castling_rights
        }
        assert Board.apply_move(state, {:a, 2}, {:a, 3}) != :invalid_move
        assert Board.apply_move(state, {:a, 2}, {:a, 3}).en_passant_target == nil
    end

    test "board move ok [valid move, white turn, erase existing en-passant]" do
        squares = %{ {:a, 2} => {:pawn, :white}, {:b, 4} => {:pawn, :white} }
        state = %{
            squares: squares,
            turn: :white,
            en_passant_target: {:b, 4},
            castling_rights: @full_castling_rights
        }
        assert Board.apply_move(state, {:a, 2}, {:a, 3}) != :invalid_move
        assert Board.apply_move(state, {:a, 2}, {:a, 3}).en_passant_target == nil
    end

    test "board move ok [valid move, white turn, make en-passant target]" do
        squares = %{ {:a, 2} => {:pawn, :white} }
        state = %{
            squares: squares,
            turn: :white,
            en_passant_target: nil,
            castling_rights: @full_castling_rights
        }
        assert Board.apply_move(state, {:a, 2}, {:a, 3}) != :invalid_move
        assert Board.apply_move(state, {:a, 2}, {:a, 4}).en_passant_target == {:a, 4}
    end

    test "board move ok [illegal move, too far away]" do
        squares = %{ {:a, 2} => {:pawn, :white} }
        state = %{
            squares: squares,
            turn: :white,
            en_passant_target: nil,
            castling_rights: @full_castling_rights
        }
        assert Board.apply_move(state, {:a, 2}, {:a, 8}) == :invalid_move
    end

    test "board move ok [valid move, white turn, castling]" do
        squares = %{ {:e, 1} => {:king, :white}, {:h, 1} => {:rook, :white} }
        state = %{
            squares: squares,
            turn: :white,
            en_passant_target: nil,
            castling_rights: @full_castling_rights
        }
        out = Board.apply_move(state, {:e, 1}, {:g, 1})
        assert out != :invalid_move
        assert out.castling_rights.white_kingside == false
        assert out.castling_rights.white_queenside == false
        assert out.castling_rights.black_kingside == true
        assert out.castling_rights.black_queenside == true
    end

    test "board move ok [valid move, white turn, invalidating castling rights]" do
        squares = %{ {:e, 1} => {:king, :white}, {:h, 1} => {:rook, :white} }
        state = %{
            squares: squares,
            turn: :white,
            en_passant_target: nil,
            castling_rights: @full_castling_rights
        }
        out = Board.apply_move(state, {:h, 1}, {:h, 3})
        assert out != :invalid_move
        assert out.castling_rights.white_kingside == false
        assert out.castling_rights.white_queenside == true
        assert out.castling_rights.black_kingside == true
        assert out.castling_rights.black_queenside == true
    end

end
