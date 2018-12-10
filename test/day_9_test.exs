defmodule Day9Test do
  use ExUnit.Case

  describe "part 1" do
    # test "" do
    #   assert play(%{0 => {0, 0}}, 0, 0, 1, [0, 0, 0, 0, 0, 0, 0, 0, 0], 1) |> elem(0) == %{
    #            0 => {1, 1},
    #            1 => {0, 0}
    #          }

    #   assert play(
    #            %{0 => {1, 1}, 1 => {0, 0}},
    #            1,
    #            1,
    #            2,
    #            [0, 0, 0, 0, 0, 0, 0, 0, 0],
    #            2
    #          )
    #          |> elem(0) == %{0 => {1, 2}, 1 => {2, 0}, 2 => {0, 1}}

    #   assert play(
    #            %{0 => {1, 2}, 1 => {2, 0}, 2 => {0, 1}},
    #            2,
    #            2,
    #            3,
    #            [0, 0, 0, 0, 0, 0, 0, 0, 0],
    #            3
    #          )
    #          |> elem(0) == %{
    #            0 => {3, 2},
    #            2 => {0, 1},
    #            1 => {2, 3},
    #            3 => {1, 0}
    #          }
    # end

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

    # test "next" do
    #   assert next(%{0 => {0, 0}}, 0) == 0
    #   assert next(%{0 => {1, 1}, 1 => {0, 0}}, 0) == 1
    #   assert next(%{0 => {1, 1}, 1 => {0, 0}}, 1) == 0
    #   assert next(%{0 => {1, 2}, 1 => {2, 0}, 2 => {0, 1}}, 2) == 1
    #   assert next(%{0 => {1, 2}, 1 => {2, 0}, 2 => {0, 1}}, 0) == 2
    # end

    # test "insert_at" do
    #   assert insert_at(%{0 => {0, 0}}, 0, 1) == %{0 => {1, 1}, 1 => {0, 0}}

    #   assert insert_at(%{0 => {1, 1}, 1 => {0, 0}}, 0, 2) == %{
    #            0 => {1, 2},
    #            1 => {2, 0},
    #            2 => {0, 1}
    #          }

    #   assert insert_at(%{0 => {1, 2}, 1 => {2, 0}, 2 => {0, 1}}, 1, 3) == %{
    #            0 => {3, 2},
    #            2 => {0, 1},
    #            1 => {2, 3},
    #            3 => {1, 0}
    #          }
    # end

    test "play with input" do
      assert File.read!("test/fixtures/day9.txt")
             |> play() == 434_674
    end
  end

  describe "part 2" do
    test "play with input" do
      assert "404 players; last marble is worth 7185200 points"
             |> play() == 3_653_994_575
    end
  end

  defp insert_at(current_marble, current_point) do
    {_, next} = Process.get(current_marble)

    Process.put(current_marble, {Process.get(current_marble) |> elem(0), current_point})
    Process.put(next, {current_point, Process.get(next) |> elem(1)})
    Process.put(current_point, {current_marble, next})
  end

  defp next(current_marble) do
    {_, next} = Process.get(current_marble)
    next
  end

  defp play(input) do
    {players, last_marble} = parse(input)

    Process.put(0, {0, 0})

    play(%{0 => {0, 0}}, 0, 0, 1, for(_ <- 1..players, do: 0), last_marble)
    |> Enum.max()
  end

  defp play(_state, _current_marble, _current_player, current_point, player_scores, last_marble)
       when current_point == last_marble + 1 do
    player_scores
  end

  defp play(state, current_marble, current_player, current_point, player_scores, last_marble)
       when rem(current_point, 23) == 0 do
    score =
      Enum.reduce(1..7, current_marble, fn _, current_marble ->
        {prev, _} = Process.get(current_marble)
        prev
      end)

    player_scores = List.update_at(player_scores, current_player, &(&1 + score + current_point))
    current_marble = pop_at(score)

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
    current_marble = next(current_marble)
    insert_at(current_marble, current_point)

    play(
      state,
      current_point,
      rem(current_player + 1, length(player_scores)),
      current_point + 1,
      player_scores,
      last_marble
    )
  end

  defp pop_at(current_marble) do
    {current_prev, current_next} = Process.get(current_marble)

    Process.put(current_next, {current_prev, Process.get(current_next) |> elem(1)})
    Process.put(current_prev, {Process.get(current_prev) |> elem(0), current_next})
    Process.delete(current_marble)

    current_next
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
