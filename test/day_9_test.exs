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

  defp play(input) do
    {players, last_marble} = parse(input)

    state = :ets.new(:marbles, [])
    :ets.insert(state, {0, {0, 0}})

    play(state, 0, 0, 1, for(_ <- 1..players, do: 0), last_marble)
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
        [{_, {prev, _}}] = :ets.lookup(state, current_marble)
        prev
      end)

    player_scores = List.update_at(player_scores, current_player, &(&1 + score + current_point))
    current_marble = pop_at(state, score)

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
    current_marble = next(state, current_marble)
    insert_at(state, current_marble, current_point)

    play(
      state,
      current_point,
      rem(current_player + 1, length(player_scores)),
      current_point + 1,
      player_scores,
      last_marble
    )
  end

  defp next(state, current_marble) do
    [{_, {_, next}}] = :ets.lookup(state, current_marble)
    next
  end

  defp insert_at(state, current_marble, current_point) do
    [{_, {prev, next}}] = :ets.lookup(state, current_marble)
    :ets.insert(state, {current_marble, {prev, current_point}})

    [{_, {_, next_next}}] = :ets.lookup(state, next)
    :ets.insert(state, {next, {current_point, next_next}})
    :ets.insert(state, {current_point, {current_marble, next}})
  end

  defp pop_at(state, current_marble) do
    [{_, {current_prev, current_next}}] = :ets.lookup(state, current_marble)
    [{_, {_, current_next_next}}] = :ets.lookup(state, current_next)
    [{_, {current_prev_prev, _}}] = :ets.lookup(state, current_prev)

    :ets.insert(state, {current_next, {current_prev, current_next_next}})
    :ets.insert(state, {current_prev, {current_prev_prev, current_next}})
    :ets.delete(state, current_marble)

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
