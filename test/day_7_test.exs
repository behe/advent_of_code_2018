defmodule Day7Test do
  use ExUnit.Case

  describe "part 1" do
    test "decode" do
      assert [
               "Step C must be finished before step A can begin.\n",
               "Step C must be finished before step F can begin.\n",
               "Step A must be finished before step B can begin.\n",
               "Step A must be finished before step D can begin.\n",
               "Step B must be finished before step E can begin.\n",
               "Step D must be finished before step E can begin.\n",
               "Step F must be finished before step E can begin.\n"
             ]
             |> Enum.flat_map(&String.split(&1, "\n", trim: true))
             |> Enum.map(fn <<"Step ", a::binary-size(1), " must be finished before step ",
                              b::binary-size(1), " can begin.">> ->
               [a, b]
             end)
             |> Enum.reduce(%{}, fn [a, b], acc ->
               acc
               |> Map.update(a, {[b], []}, fn {x, y} -> {[b | x], y} end)
               |> Map.update(b, {[], [a]}, fn {x, y} -> {x, [a | y]} end)
             end)
             |> decode("") == "CABDFE"
    end

    test "decode with input" do
      assert File.stream!("test/fixtures/day7.txt")
             |> Enum.flat_map(&String.split(&1, "\n", trim: true))
             |> Enum.map(fn <<"Step ", a::binary-size(1), " must be finished before step ",
                              b::binary-size(1), " can begin.">> ->
               [a, b]
             end)
             |> Enum.reduce(%{}, fn [a, b], acc ->
               acc
               |> Map.update(a, {[b], []}, fn {x, y} -> {[b | x], y} end)
               |> Map.update(b, {[], [a]}, fn {x, y} -> {x, [a | y]} end)
             end)
             |> decode("") == "OKBNLPHCSVWAIRDGUZEFMXYTJQ"
    end
  end

  defp decode(map, string) when map_size(map) == 0, do: string

  defp decode(map, string) do
    next = fn map ->
      Enum.filter(map, fn
        {_, {_, []}} -> true
        _ -> false
      end)
      |> Enum.sort(fn {a, _}, {b, _} -> a <= b end)
      |> hd
    end

    {key, {to, _}} = next.(map)

    Enum.reduce(to, map, fn x, map ->
      Map.update(map, x, nil, fn {to, from} -> {to, List.delete(from, key)} end)
    end)
    |> Map.delete(key)
    |> decode(string <> key)
  end
end
