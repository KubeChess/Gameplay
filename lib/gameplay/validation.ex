defmodule ClusterChess.Gameplay.Validation do

    alias ClusterChess.Gameplay.Board

    @files [:a, :b, :c, :d, :e, :f, :g, :h]
    @ranks [1, 2, 3, 4, 5, 6, 7, 8]

    def validate_move(state, from, to) do
        case Map.get(state.board, from) do
            nil -> {:error, :no_piece_at_from}
            {:king, _color}    -> valid_king_move(state, from, to)
            {:queen, _color}   -> valid_queen_move(state, from, to)
            {:rook, _color}    -> valid_rook_move(state, from, to)
            {:bishop, _color}  -> valid_bishop_move(state, from, to)
            {:pawn, _color}    -> valid_pawn_move(state, from, to)
            {:knight, _color}  -> valid_knight_move(state, from, to)
        end
    end

    def valid_king_move(state, {sf, sr}, {df, dr}) do
        {sf_int, df_int} = Board.intify(sf, df)
        {fdiff, rdiff} = {abs(sf_int - df_int), abs(sr - dr)}
        short? = fdiff <= 1 and rdiff <= 1
        (valid_queen_move(state, {sf, sr}, {df, dr}) and short?)
        or valid_castling_move(state, {sf, sr}, {df, dr})
    end

    def valid_queen_move(state, from, to),
        do: valid_rook_move(state, from, to)
        or valid_bishop_move(state, from, to)

    def valid_castling_move(state, from, to) do
        color = Board.color(state.board, from)
        king_has_rights? = case {from, to} do
            {{:e, 1}, {:h, 1}} -> color == :white and state.castling_rights.white_rx
            {{:e, 1}, {:a, 1}} -> color == :white and state.castling_rights.white_lx
            {{:e, 8}, {:h, 8}} -> color == :black and state.castling_rights.black_lx
            {{:e, 8}, {:a, 8}} -> color == :black and state.castling_rights.black_rx
            _other -> false
        end
        king_can_move? = valid_castling_path(state, from, to)
        king_can_move? and king_has_rights?
    end

    def valid_castling_path(state, from, to) do
        king_color = Board.color(state.board, from)
        board_with_no_rook = Map.put(state.board, from, nil)
        valid_rook_move(%{state | board: board_with_no_rook}, from, to)
        and Enum.all?(for f <- @files, r <- @ranks, p <- path(from, to) do
            {f, r} in [from, to] or p == to
            or Board.color(state.board, {f, r}) in [nil, king_color]
            or not validate_move(state, {f, r}, p)
        end)
    end

    defp path({sf, sr}, {df, dr}) do
        {sf_int, df_int} = Board.intify(sf, df)
        for f <- (sf_int .. df_int), r <- (sr .. dr) do
            {List.to_atom([?a + f]), r}
        end
    end

    def valid_rook_move(state, {sf, sr}, {df, dr}) do
        path = path({sf, sr}, {df, dr})
        straight? = sf == df or sr == dr
        valid_move_path(state, path) and straight?
    end

    def valid_bishop_move(state, {sf, sr}, {df, dr}) do
        {sf_int, df_int} = Board.intify(sf, df)
        path = for i <- 0..abs(df_int - sf_int) do
            f = List.to_atom([?a + sf_int + i * Board.direction(sf_int, df_int)])
            {f, sr + i * Board.direction(sr, dr)}
        end
        diagonal? = abs(sf_int - df_int) == abs(sr - dr)
        valid_move_path(state, path) and diagonal?
    end

    def valid_knight_move(state, {sf, sr}, {df, dr}) do
        {sf_int, df_int} = Board.intify(sf, df)
        vertical_diff = abs(sr - dr)
        horizontal_diff = abs(sf_int - df_int)
        case {vertical_diff, horizontal_diff} do
            {2, 1} -> valid_move_ends(state, {sf, sr}, {df, dr})
            {1, 2} -> valid_move_ends(state, {sf, sr}, {df, dr})
            _other -> false
        end
    end

    def valid_pawn_move(state, {sf, sr}, {df, dr}) do
        {from, to} = {{sf, sr}, {df, dr}}
        {color, opponent_color} = Board.color(state.board, from, to)
        {sf_int, df_int} = Board.intify(sf, df)
        prerequisites = Enum.all?([
            (color == :white or sr > dr),
            (color == :black or sr < dr),
            abs(sf_int - df_int) <= 1,
            abs(sr - dr) <= 2,
            {sf, sr} != {df, dr}
        ])
        dest_clear = not Map.has_key?(state.board, to)
        dest_enemy = opponent_color not in [nil, color]
        vertical_diff = abs(sr - dr)
        horizontal_diff = abs(sf_int - df_int)
        prerequisites and case {vertical_diff, horizontal_diff} do
            {1, 0} -> dest_clear
            {1, 1} -> dest_enemy
            {2, 0} -> dest_clear and valid_rook_move(state, from, to)
            _ -> false
        end
    end

    def valid_move_ends(state, {sf, sr}, {df, dr}) do
        {color1, color2} = Board.color(state.board, {sf, sr}, {df, dr})
        color1 != color2 and color1 != nil and
        sf in @files and df in @files and
        sr in @ranks and dr in @ranks
    end

    def valid_move_path(state, path) do
        from = {sf, sr} = hd(path)
        to = {df, dr} = List.last(path)
        Enum.all?(path, fn {f, r} ->
            {f, r} in [{df, dr}, {sf, sr}]
            or not Map.has_key?(state.board, {f, r})
        end)
        and length(path) > 1
        and valid_move_ends(state, from, to)
    end
end
