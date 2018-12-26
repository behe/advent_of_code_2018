defmodule Day12Test do
  use ExUnit.Case

  @input """
  initial state: #..#.#..##......###...###

  ...## => #
  ..#.. => #
  .#... => #
  .#.#. => #
  .#.## => #
  .##.. => #
  .#### => #
  #.#.# => #
  #.### => #
  ##.#. => #
  ##.## => #
  ###.. => #
  ###.# => #
  ####. => #
  """

  @test_initial_state MapSet.new([0, 3, 5, 8, 9, 16, 17, 18, 22, 23, 24])
  @test_win_states MapSet.new([
                     [0, 0, 0, 1, 1],
                     [0, 0, 1, 0, 0],
                     [0, 1, 0, 0, 0],
                     [0, 1, 0, 1, 0],
                     [0, 1, 0, 1, 1],
                     [0, 1, 1, 0, 0],
                     [0, 1, 1, 1, 1],
                     [1, 0, 1, 0, 1],
                     [1, 0, 1, 1, 1],
                     [1, 1, 0, 1, 0],
                     [1, 1, 0, 1, 1],
                     [1, 1, 1, 0, 0],
                     [1, 1, 1, 0, 1],
                     [1, 1, 1, 1, 0]
                   ])

  describe "part 1" do
    test "parse" do
      assert parse(@input) == {@test_initial_state, @test_win_states}
    end

    test "generate" do
      assert generate(@test_initial_state, @test_win_states) ==
               MapSet.new([0, 4, 9, 15, 18, 21, 24])
    end

    test "gen_20" do
      assert generation(@input, 20) == 325
    end

    test "with input" do
      assert generation(File.read!("test/fixtures/day12.txt"), 20) == 2767
    end
  end

  describe "part 2" do
    test "with input" do
      assert generation(File.read!("test/fixtures/day12.txt"), 50_000_000_000) ==
               2_650_000_001_362
    end
  end

  defp generation(input, generations) do
    {initial_state, win_states} = parse(input)

    Enum.reduce_while(1..generations, {initial_state, sum(initial_state), [nil, nil, 0]}, fn
      i, {state, sum, previous_diffs} ->
        new_state = generate(state, win_states)
        new_sum = sum(new_state)
        new_diff = new_sum - sum

        if stable_diff?(previous_diffs, new_diff) do
          {:halt, {nil, (generations - i) * new_diff + new_sum, nil}}
        else
          {:cont, {new_state, new_sum, [new_diff | Enum.take(previous_diffs, 2)]}}
        end
    end)
    |> elem(1)
  end

  def stable_diff?(previous_diffs, new_diff) do
    case [new_diff, new_diff, new_diff] do
      ^previous_diffs -> true
      _ -> false
    end
  end

  defp sum(state) do
    state
    |> MapSet.to_list()
    |> Enum.sum()
  end

  defp generate(state, win_states) do
    {min, max} = Enum.min_max(state)
    range = (min - 4)..(max + 4)

    Enum.map(range, fn index -> if(MapSet.member?(state, index), do: 1, else: 0) end)
    |> Enum.chunk_every(5, 1, :discard)
    |> Enum.with_index(min - 2)
    |> Enum.reduce(MapSet.new(), fn {value, index}, acc ->
      if MapSet.member?(win_states, value) do
        MapSet.put(acc, index)
      else
        acc
      end
    end)
  end

  defp parse(input) when is_binary(input) do
    [initial_state | states] = String.split(input, ["initial state: ", "\n"], trim: true)

    initial =
      to_charlist(initial_state)
      |> Enum.with_index()
      |> Enum.reduce(MapSet.new(), fn
        {?#, index}, acc -> MapSet.put(acc, index)
        _, acc -> acc
      end)

    win_states =
      Enum.map(states, fn <<input::binary-size(5), " => ", result>> ->
        case result do
          ?# -> to_plant_list(input)
          _ -> nil
        end
      end)
      |> Enum.reject(&is_nil/1)
      |> MapSet.new()

    {initial, win_states}
  end

  defp to_plant_list(input) when is_binary(input) do
    to_charlist(input)
    |> Enum.map(fn
      ?# -> 1
      _ -> 0
    end)
  end
end
