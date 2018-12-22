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

  @test_initial_state %{
    0 => 1,
    3 => 1,
    5 => 1,
    8 => 1,
    9 => 1,
    16 => 1,
    17 => 1,
    18 => 1,
    22 => 1,
    23 => 1,
    24 => 1
  }
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
      assert generate(@test_initial_state, @test_win_states) == %{
               0 => 1,
               4 => 1,
               9 => 1,
               15 => 1,
               18 => 1,
               21 => 1,
               24 => 1
             }
    end

    test "gen_20" do
      gen_20 = gen_20(@input)

      assert gen_20 == %{
               -2 => 1,
               3 => 1,
               4 => 1,
               9 => 1,
               10 => 1,
               11 => 1,
               12 => 1,
               13 => 1,
               17 => 1,
               18 => 1,
               19 => 1,
               20 => 1,
               21 => 1,
               22 => 1,
               23 => 1,
               28 => 1,
               30 => 1,
               33 => 1,
               34 => 1
             }

      assert Map.keys(gen_20) |> Enum.sum() == 325
    end

    test "with input" do
      assert gen_20(File.read!("test/fixtures/day12.txt"))
             |> Map.keys()
             |> Enum.sum() == 2767
    end
  end

  defp gen_20(input) do
    {initial_state, win_states} = parse(input)

    Enum.reduce(1..20, initial_state, fn _, state ->
      generate(state, win_states)
    end)
  end

  defp generate(state, win_states) do
    {{min, _}, {max, _}} = Enum.min_max(state)

    range = (min - 4)..(max + 4)

    Enum.map(range, fn index -> Map.get(state, index, 0) end)
    |> Enum.chunk_every(5, 1, :discard)
    |> Enum.with_index(min - 2)
    |> Enum.reduce(%{}, fn {value, index}, acc ->
      if MapSet.member?(win_states, value) do
        Map.put(acc, index, 1)
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
      |> Enum.reduce(%{}, fn
        {?#, index}, acc -> Map.put(acc, index, 1)
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
