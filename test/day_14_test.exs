defmodule Day14Test do
  use ExUnit.Case

  describe "part 1" do
    test "mix" do
      assert mix(%{0 => 3, 1 => 7}, 2, 0, 1) == {%{0 => 3, 1 => 7, 2 => 1, 3 => 0}, 4, 0, 1, [1, 0]}

      assert mix(%{0 => 3, 1 => 7, 2 => 1, 3 => 0}, 4,0, 1) ==
               {%{0 => 3, 1 => 7, 2 => 1, 3 => 0, 4 => 1, 5 => 0}, 6,4, 3, [1, 0]}

      assert mix(%{0 => 3, 1 => 7, 2 => 1, 3 => 0, 4 => 1, 5 => 0}, 6,4, 3) ==
               {%{0 => 3, 1 => 7, 2 => 1, 3 => 0, 4 => 1, 5 => 0, 6 => 1}, 7,6, 4, [1]}

      assert mix(%{0 => 3, 1 => 7, 2 => 1, 3 => 0, 4 => 1, 5 => 0, 6 => 1}, 7,6, 4) ==
               {%{0 => 3, 1 => 7, 2 => 1, 3 => 0, 4 => 1, 5 => 0, 6 => 1, 7 => 2}, 8,0, 6, [2]}
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

  describe "part 2" do
    test "iterations_before" do
      assert iterations_before([0, 1, 2, 4, 5]) == 5
      assert iterations_before([5, 1, 5, 8, 9]) == 9
      assert iterations_before([9, 2, 5, 1, 0]) == 18
      assert iterations_before([5, 9, 4, 1, 4]) == 2018
    end

    test "with input" do
      assert iterations_before([5, 0, 3, 7, 6, 1]) == 20_185_425
    end
  end

  defp iterations_before(scores) do
    iterations_before({%{0 => 3, 1 => 7}, 2, 0, 1, [3, 7]}, [], scores)
  end

  defp iterations_before(
         {map, map_size, first_position, second_position, added_scores},
         current_scores,
         scores
       ) do
    current_scores = current_scores ++ added_scores

    current_scores =
      Enum.drop(current_scores, max(length(current_scores) - length(scores) - 1, 0))

    cond do
      tl(current_scores) == scores ->
        map_size - length(scores)

      List.starts_with?(current_scores, scores) ->
        map_size - length(scores) - 1

      :otherwise ->
        iterations_before(mix(map, map_size, first_position, second_position), current_scores, scores)
    end
  end

  defp scores_after(iterations) do
    Enum.reduce_while(1..(iterations + 10), {%{0 => 3, 1 => 7}, 2, 0, 1, []}, fn
      _, {map, map_size, _, _, _} when map_size >= iterations + 10 ->
        {:halt, Map.take(map, iterations..(iterations + 9)) |> Map.values()}

      _, {map, map_size, first_position, second_position, _} ->
        {:cont, mix(map, map_size, first_position, second_position)}
    end)
  end

  defp mix(map, map_size, first_position, second_position) do
    first = Map.get(map, first_position)
    second = Map.get(map, second_position)
    sum = first + second

    scores =
      case div(sum, 10) do
        1 -> [1, rem(sum, 10)]
        0 -> [rem(sum, 10)]
      end

    {map, map_size} =
      Enum.reduce(scores, {map, map_size}, fn score, {acc, i} ->
        {Map.put(acc, i, score), i + 1}
      end)

    first_position = next_position(first_position, first, map_size)
    second_position = next_position(second_position, second, map_size)
    {map, map_size, first_position, second_position, scores}
  end

  defp next_position(position, score, map_size) do
    rem(position + score + 1, map_size)
  end
end
