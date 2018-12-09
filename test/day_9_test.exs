defmodule Day9Test do
  use ExUnit.Case

  describe "part 1" do
    test "9 players; last marble is worth 23 points" do
      assert "9 players; last marble is worth 23 points\n"
             |> play() == 32
    end

    test "10 players; last marble is worth 1618 points" do
      assert "10 players; last marble is worth 1618 points\n"
             |> play() == 8317
    end

    test "13 players; last marble is worth 7999 points" do
      assert "13 players; last marble is worth 7999 points\n"
             |> play() == 146_373
    end

    test "17 players; last marble is worth 1104 points" do
      assert "17 players; last marble is worth 1104 points\n"
             |> play() == 2764
    end

    test "21 players; last marble is worth 6111 points" do
      assert "21 players; last marble is worth 6111 points\n"
             |> play() == 54718
    end

    test "30 players; last marble is worth 5807 points" do
      assert "30 players; last marble is worth 5807 points\n"
             |> play() == 37305
    end

    test "insert at" do
      assert insert_at([0], 0) == 1
      assert insert_at([0, 1], 1) == 1
      assert insert_at([0, 2, 1], 1) == 3
    end

    test "play with input" do
      assert File.read!("test/fixtures/day9.txt")
             |> play() == 434_674
    end
  end

  defp play(input) do
    {players, last_marble} = parse(input)

    play([0], 0, 0, 1, for(_ <- 1..players, do: 0), last_marble) |> elem(1) |> Enum.max()
  end

  defp play(state, _current_marble, _current_player, current_point, player_scores, last_marble)
       when current_point == last_marble + 1 do
    {state, player_scores}
  end

  defp play(state, current_marble, current_player, current_point, player_scores, last_marble)
       when rem(current_point, 23) == 0 do
    # IO.inspect({current_player, length(player_scores)}, label: current_point)

    current_marble = rem(length(state) + rem(current_marble - 7, length(state)), length(state))
    # |> IO.inspect(label: :current_marble)

    {score, state} = List.pop_at(state, current_marble)
    #  |> IO.inspect(label: :state)

    player_scores = List.update_at(player_scores, current_player, &(&1 + score + current_point))
    # |> IO.inspect(label: :player_scores)

    play(
      state,
      current_marble,
      rem(current_player + 1, length(player_scores)),
      current_point + 1,
      player_scores,
      last_marble
    )
  end

  defp play(state, current_marble, current_player, current_point, player_scores, last_marble) do
    current_marble = insert_at(state, current_marble)

    play(
      List.insert_at(state, current_marble, current_point),
      current_marble,
      rem(current_player + 1, length(player_scores)),
      current_point + 1,
      player_scores,
      last_marble
    )
  end

  defp insert_at(state, current_marble) do
    with 0 <- rem(current_marble + 2, length(state)) do
      length(state)
    end
  end

  defp parse(input) do
    input =
      input
      |> String.split("\n", trim: true)
      |> hd

    result =
      Regex.named_captures(
        ~r/(?<players>\d+) players; last marble is worth (?<points>\d+) points/,
        input
      )

    {
      String.to_integer(result["players"]),
      String.to_integer(result["points"])
    }
  end
end
