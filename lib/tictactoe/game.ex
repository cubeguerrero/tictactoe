defmodule Tictactoe.Game do
  alias Tictactoe.Game

  @winning_combinations [
    [0, 1, 2],
    [0, 3, 7],
    [0, 5, 8],
    [1, 5, 7],
    [2, 6, 8],
    [2, 5, 6]
  ]

  defstruct [
    board: {nil, nil, nil, nil, nil, nil, nil, nil, nil},
    players: %{},
    current_turn: :x,
    status: :new
  ]

  def new(player1, player2) do
    %Game{
      players: %{player1 => :x, player2 => :o}
    }
  end

  def make_move(%Game{} = game, 0, column) do
    game
    |> check_move(column)
    |> update_board(column)
    |> check_winner()
    |> update_turn()
  end
  def make_move(%Game{} = game, 1, column) do
    make_move(game, 0, column + 3)
  end
  def make_move(%Game{} = game, 2, column) do
    make_move(game, 0, column + 6)
  end

  defp check_move(%Game{board: board} = game, column) do
    value = elem(board, column)

    if value == nil do
      %Game{game | status: :good_move}
    else
      %Game{game | status: :bad_move}
    end
  end

  defp update_board(%Game{status: :bad_move} = game, _column) do
    game
  end
  defp update_board(%Game{board: board, current_turn: current_turn} = game, column) do
    new_board = put_elem(board, column, current_turn)
    %Game{game | board: new_board}
  end

  def check_winner(%Game{status: :bad_move} = game), do: game
  def check_winner(%Game{board: board} = game) do
    if Enum.any?(@winning_combinations, fn ([a, b, c]) ->
          elem(board, a) == elem(board, b) &&
            elem(board, a) == elem(board, c)
        end) do
      %Game{game | status: :winner}
    else
      game
    end
  end

  def update_turn(%Game{status: :bad_move} = game), do: game
  def update_turn(%Game{current_turn: :x} = game) do
    %Game{game | current_turn: :o}
  end
  def update_turn(game) do
    %Game{game | current_turn: :x}
  end
end
