defmodule Day14Test do
  use ExUnit.Case

  describe "part 1" do
    test "mix" do
      assert mix(%{0 => 3, 1 => 7}, 0, 1) == {%{0 => 3, 1 => 7, 2 => 1, 3 => 0}, 0, 1}

      assert mix(%{0 => 3, 1 => 7, 2 => 1, 3 => 0}, 0, 1) ==
               {%{0 => 3, 1 => 7, 2 => 1, 3 => 0, 4 => 1, 5 => 0}, 4, 3}

      assert mix(%{0 => 3, 1 => 7, 2 => 1, 3 => 0, 4 => 1, 5 => 0}, 4, 3) ==
               {%{0 => 3, 1 => 7, 2 => 1, 3 => 0, 4 => 1, 5 => 0, 6 => 1}, 6, 4}

      assert mix(%{0 => 3, 1 => 7, 2 => 1, 3 => 0, 4 => 1, 5 => 0, 6 => 1}, 6, 4) ==
               {%{0 => 3, 1 => 7, 2 => 1, 3 => 0, 4 => 1, 5 => 0, 6 => 1, 7 => 2}, 0, 6}
    end

    test "scores_after" do
      assert scores_after(5) == [0, 1, 2, 4, 5, 1, 5, 8, 9, 1]
      assert scores_after(9) == [5, 1, 5, 8, 9, 1, 6, 7, 7, 9]
      assert scores_after(18) == [9, 2, 5, 1, 0, 7, 1, 0, 8, 5]
      assert scores_after(2018) == [5, 9, 4, 1, 4, 2, 9, 8, 8, 2]
    end

    test "with input" do
      assert scores_after(503_761) == [1, 0, 4, 4, 2, 5, 7, 3, 9, 7]
    end
  end

  defp mix(map, first_position, second_position) do
    first = Map.get(map, first_position)
    second = Map.get(map, second_position)
    sum = first + second
    map_size = map_size(map)

    scores =
      case div(sum, 10) do
        1 -> %{map_size => 1, (map_size + 1) => rem(sum, 10)}
        0 -> %{map_size => rem(sum, 10)}
      end

    map = Map.merge(map, scores)
    first_position = next_position(first_position, first, map)
    second_position = next_position(second_position, second, map)
    {map, first_position, second_position}
  end

  defp scores_after(iterations) do
    Enum.reduce_while(1..(iterations + 10), {%{0 => 3, 1 => 7}, 0, 1}, fn
      _, {map, _, _} when map_size(map) >= iterations + 10 ->
        {:halt, Map.take(map, iterations..(iterations + 9)) |> Map.values()}

      _, {map, first_position, second_position} ->
        {:cont, mix(map, first_position, second_position)}
    end)
  end

  defp next_position(position, score, map) when is_map(map) do
    rem(position + score + 1, map_size(map))
  end
end
