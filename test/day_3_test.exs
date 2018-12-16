defmodule Day3Test do
  use ExUnit.Case

  describe "part 1" do
    test "with test input" do
      assert ["#1 @ 1,3: 4x4", "#2 @ 3,1: 4x4", "#3 @ 5,5: 2x2"]
             |> plot
             |> Enum.filter(&(Enum.count(&1) > 1))
             |> Enum.count() == 4
    end

    test "with input" do
      assert File.read!("test/fixtures/day3.txt")
             |> String.split("\n", trim: true)
             |> plot
             |> Enum.filter(&(Enum.count(&1) > 1))
             |> Enum.count() == 111_266
    end
  end

  describe "part 2" do
    test "with test input" do
      out =
        ["#1 @ 1,3: 4x4", "#2 @ 3,1: 4x4", "#3 @ 5,5: 2x2"]
        |> plot

      unique = Enum.filter(out, &(Enum.count(&1) == 1)) |> List.flatten() |> Enum.uniq()
      duplicates = Enum.filter(out, &(Enum.count(&1) > 1)) |> List.flatten() |> Enum.uniq()
      assert unique_id(unique, duplicates) == [3]
    end

    test "with input" do
      out =
        File.read!("test/fixtures/day3.txt")
        |> String.split("\n", trim: true)
        |> plot

      unique = Enum.filter(out, &(Enum.count(&1) == 1)) |> List.flatten() |> Enum.uniq()
      duplicates = Enum.filter(out, &(Enum.count(&1) > 1)) |> List.flatten() |> Enum.uniq()
      assert unique_id(unique, duplicates) == [266]
    end
  end

  def unique_id(unique, duplicates) do
    Enum.reduce(unique, unique, fn n, acc ->
      if n in duplicates do
        List.delete(acc, n)
      else
        acc
      end
    end)
  end

  def plot(input) do
    Enum.reduce(input, %{}, fn input, acc ->
      parsed = parse(input)

      for x <- parsed.x..(parsed.x + parsed.w - 1),
          y <- parsed.y..(parsed.y + parsed.h - 1) do
        {x, y}
      end
      |> Enum.reduce(acc, fn {x, y}, acc ->
        Map.update(acc, {x, y}, [parsed.id], fn list ->
          [parsed.id | list]
        end)
      end)
    end)
    |> Map.values()
  end

  def parse(input) do
    Regex.named_captures(
      ~r/#(?<id>\d+) @ (?<x>\d+),(?<y>\d+): (?<w>\d+)x(?<h>\d+)/,
      input
    )
    |> Enum.map(fn {k, v} -> {String.to_atom(k), String.to_integer(v)} end)
    |> Map.new()
  end
end
