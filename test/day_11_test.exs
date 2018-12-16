defmodule Day11Test do
  use ExUnit.Case

  describe "part 1" do
    test "power level" do
      assert power_level(3, 5, 8) == 4
      assert power_level(122, 79, 57) == -5
      assert power_level(217, 196, 39) == 0
      assert power_level(101, 153, 71) == 4
    end

    test "table" do
      assert table(3, 18) ==
               %{
                 {1, 1} => -2,
                 {2, 1} => -2,
                 {3, 1} => -1,
                 {1, 2} => -1,
                 {2, 2} => 0,
                 {3, 2} => 0,
                 {1, 3} => 0,
                 {2, 3} => 1,
                 {3, 3} => 2
               }
    end

    test "sum_table" do
      assert table(3, 18)
             |> sum_table() ==
               %{
                 {1, 1} => -2,
                 {2, 1} => -4,
                 {3, 1} => -5,
                 {1, 2} => -3,
                 {2, 2} => -5,
                 {3, 2} => -6,
                 {1, 3} => -3,
                 {2, 3} => -4,
                 {3, 3} => -3
               }
    end

    test "with test input" do
      assert table(300, 18)
             |> sum_table()
             |> max_power_area(3) == {33, 45, 29, 3}

      assert table(300, 42)
             |> sum_table()
             |> max_power_area(3) == {21, 61, 30, 3}
    end

    test "with input" do
      assert table(300, 1133)
             |> sum_table()
             |> max_power_area(3) == {235, 14, 31, 3}
    end
  end

  describe "part 2" do
    test "with test input" do
      assert table(300, 18)
             |> sum_table()
             |> max_power() == {90, 269, 113, 16}

      assert table(300, 42)
             |> sum_table()
             |> max_power() == {232, 251, 119, 12}
    end

    test "with input" do
      assert table(300, 1133)
             |> sum_table()
             |> max_power() == {237, 227, 108, 14}
    end
  end

  defp power_level(x, y, sn) do
    div(rem(((x + 10) * y + sn) * (x + 10), 1000), 100) - 5
  end

  defp table(n, sn) do
    for(x <- 1..n, y <- 1..n, do: {{x, y}, power_level(x, y, sn)})
    |> Map.new()
  end

  # 1 2 3
  # 2 4 6
  # 3 6 9
  defp sum_table(table) do
    Map.to_list(table)
    |> Enum.sort()
    |> Enum.reduce(%{}, fn {{x, y}, value}, acc ->
      sum =
        value + Map.get(acc, {x - 1, y}, 0) + Map.get(acc, {x, y - 1}, 0) -
          Map.get(acc, {x - 1, y - 1}, 0)

      Map.put(acc, {x, y}, sum)
    end)
  end

  defp max_power(sum_table) do
    1..300
    |> Flow.from_enumerable()
    |> Flow.partition()
    |> Flow.reduce(fn -> [] end, fn size, acc ->
      [max_power_area(sum_table, size) | acc]
    end)
    |> Enum.max_by(fn {_, _, sum, _} -> sum end)
  end

  defp max_power_area(sum_table, size) do
    for(x <- 1..(300 - size + 1), y <- 1..(300 - size + 1), do: {x, y})
    |> Enum.map(fn {x, y} ->
      {x, y, power_area(sum_table, x, y, size)}
    end)
    |> Enum.max_by(fn {_, _, sum} -> sum end)
    |> Tuple.append(size)
  end

  defp power_area(sum_table, x, y, size) do
    Map.get(sum_table, {x + size - 1, y + size - 1}, 0) + Map.get(sum_table, {x - 1, y - 1}, 0) -
      Map.get(sum_table, {x - 1, y + size - 1}, 0) - Map.get(sum_table, {x + size - 1, y - 1}, 0)
  end
end
