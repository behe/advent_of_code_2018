defmodule Day7Test do
  use ExUnit.Case

  @input [
    "Step C must be finished before step A can begin.\n",
    "Step C must be finished before step F can begin.\n",
    "Step A must be finished before step B can begin.\n",
    "Step A must be finished before step D can begin.\n",
    "Step B must be finished before step E can begin.\n",
    "Step D must be finished before step E can begin.\n",
    "Step F must be finished before step E can begin.\n"
  ]

  describe "part 1" do
    test "parse" do
      assert @input
             |> parse() == %{
               ?A => [?D, ?B],
               ?B => [?E],
               ?C => [?F, ?A],
               ?D => [?E],
               ?E => [],
               ?F => [?E]
             }
    end

    test "decode" do
      assert @input |> parse() |> decode() == "CABDFE"
    end

    test "decode with input" do
      assert File.stream!("test/fixtures/day7.txt") |> parse() |> decode() ==
               "OKBNLPHCSVWAIRDGUZEFMXYTJQ"
    end
  end

  describe "part 2" do
    test "decode with worker" do
      assert %{
               ?A => [?D, ?B],
               ?B => [?E],
               ?C => [?F, ?A],
               ?D => [?E],
               ?E => [],
               ?F => [?E]
             }
             |> decode_with_workers(2)
             |> Enum.count() == 258
    end

    test "decode input with worker" do
      assert File.stream!("test/fixtures/day7.txt")
             |> parse()
             |> decode_with_workers(5)
             #  |> IO.inspect(limit: -1)
             |> Enum.count() == 982
    end
  end

  defp decode_with_workers(map, worker_count) do
    decode_with_workers(map, Enum.map(1..worker_count, fn _ -> :idle end), [])
  end

  defp decode_with_workers(map, _workers, string) when map_size(map) == 0 do
    Enum.reverse(string)
  end

  defp decode_with_workers(map, workers, string) do
    workers = assign_work(map, workers)
    string = [{length(string), current_state(workers)} | string]
    {map, workers} = work(map, workers)
    decode_with_workers(map, workers, string)
  end

  defp current_state(workers) do
    Enum.map(workers, fn
      :idle -> '.'
      {k, _} -> [k]
    end)
  end

  defp work(map, workers) do
    Enum.reduce(workers, {map, []}, fn
      :idle, {map, acc} ->
        {map, [:idle | acc]}

      # mark finished workers as idle
      {key, 1}, {map, acc} ->
        {Map.delete(map, key), [:idle | acc]}

      # tick down work
      {key, count}, {map, acc} ->
        {map, [{key, count - 1} | acc]}
    end)
  end

  defp assign_work(map, workers) do
    Enum.reduce(workers, [], fn
      # attempt to assign work to idle workers
      :idle, acc ->
        key = next(map, workers ++ acc)

        unless is_nil(key) do
          [{key, key - 4} | acc]
        else
          [:idle | acc]
        end

      worker, acc ->
        [worker | acc]
    end)
  end

  defp decode(map) do
    decode(map, [])
  end

  defp decode(map, string) when map_size(map) == 0, do: string |> Enum.reverse() |> to_string()

  defp decode(map, string) do
    key = next(map)
    map = Map.delete(map, key)
    decode(map, [key | string])
  end

  defp next(map, workers) do
    working_keys =
      Enum.filter(workers, fn
        {_, _} -> true
        _ -> false
      end)
      |> Enum.map(&elem(&1, 0))

    ((Map.keys(map) -- (Map.values(map) |> List.flatten())) -- working_keys)
    |> Enum.sort()
    # |> IO.inspect(label: :next)
    |> List.first()
  end

  defp next(map) do
    (Map.keys(map) -- (Map.values(map) |> List.flatten()))
    |> Enum.sort()
    |> hd
  end

  defp parse(input) do
    input
    |> Enum.flat_map(&String.split(&1, "\n", trim: true))
    |> Enum.map(fn <<"Step ", a::binary-size(1), " must be finished before step ",
                     b::binary-size(1), " can begin.">> ->
      {hd(to_charlist(a)), hd(to_charlist(b))}
    end)
    |> Enum.reduce(%{}, fn {a, b}, acc ->
      acc
      |> Map.update(a, [b], fn next -> [b | next] end)
      |> Map.put_new(b, [])
    end)
  end
end
