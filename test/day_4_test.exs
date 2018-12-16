defmodule Day4Test do
  use ExUnit.Case

  @input """
  [1518-11-01 00:30] falls asleep
  [1518-11-01 00:55] wakes up
  [1518-11-01 23:58] Guard #99 begins shift
  [1518-11-02 00:40] falls asleep
  [1518-11-02 00:50] wakes up
  [1518-11-03 00:05] Guard #10 begins shift
  [1518-11-03 00:24] falls asleep
  [1518-11-03 00:29] wakes up
  [1518-11-04 00:02] Guard #99 begins shift
  [1518-11-04 00:36] falls asleep
  [1518-11-04 00:46] wakes up
  [1518-11-05 00:03] Guard #99 begins shift
  [1518-11-05 00:45] falls asleep
  [1518-11-05 00:55] wakes up
  [1518-11-01 00:00] Guard #10 begins shift
  [1518-11-01 00:05] falls asleep
  [1518-11-01 00:25] wakes up
  """

  describe "part 1" do
    test "parse" do
      assert parse(@input) == [
               "[1518-11-01 00:00] Guard #10 begins shift",
               "[1518-11-01 00:05] falls asleep",
               "[1518-11-01 00:25] wakes up",
               "[1518-11-01 00:30] falls asleep",
               "[1518-11-01 00:55] wakes up",
               "[1518-11-01 23:58] Guard #99 begins shift",
               "[1518-11-02 00:40] falls asleep",
               "[1518-11-02 00:50] wakes up",
               "[1518-11-03 00:05] Guard #10 begins shift",
               "[1518-11-03 00:24] falls asleep",
               "[1518-11-03 00:29] wakes up",
               "[1518-11-04 00:02] Guard #99 begins shift",
               "[1518-11-04 00:36] falls asleep",
               "[1518-11-04 00:46] wakes up",
               "[1518-11-05 00:03] Guard #99 begins shift",
               "[1518-11-05 00:45] falls asleep",
               "[1518-11-05 00:55] wakes up"
             ]
    end

    test "partition" do
      assert [
               "[1518-11-01 00:00] Guard #10 begins shift",
               "[1518-11-01 00:05] falls asleep",
               "[1518-11-01 00:25] wakes up",
               "[1518-11-01 00:30] falls asleep",
               "[1518-11-01 00:55] wakes up",
               "[1518-11-01 23:58] Guard #99 begins shift",
               "[1518-11-02 00:40] falls asleep",
               "[1518-11-02 00:50] wakes up",
               "[1518-11-03 00:05] Guard #10 begins shift",
               "[1518-11-03 00:24] falls asleep",
               "[1518-11-03 00:29] wakes up",
               "[1518-11-04 00:02] Guard #99 begins shift",
               "[1518-11-04 00:36] falls asleep",
               "[1518-11-04 00:46] wakes up",
               "[1518-11-05 00:03] Guard #99 begins shift",
               "[1518-11-05 00:45] falls asleep",
               "[1518-11-05 00:55] wakes up"
             ]
             |> partition == %{
               "10" => [24..28, 30..54, 5..24],
               "99" => [45..54, 36..45, 40..49]
             }
    end

    test "most_minutes" do
      assert %{
               "10" => [24..28, 30..54, 5..24],
               "99" => [45..54, 36..45, 40..49]
             }
             |> most_minutes == {"10", [24..28, 30..54, 5..24]}
    end

    test "sleepy_minute" do
      assert [24..28, 30..54, 5..24]
             |> sleepy_minute() == {24, [24, 24]}
    end

    test "strategy1" do
      assert strategy1(@input) == 240
    end

    test "with input" do
      assert File.read!("test/fixtures/day4.txt")
             |> strategy1() == 35184
    end
  end

  describe "part 2" do
    test "sleepiest minute" do
      assert %{
               "10" => [24..28, 30..54, 5..24],
               "99" => [45..54, 36..45, 40..49]
             }
             |> sleepiest_minute == {"99", 45, 3}
    end

    test "strategy2" do
      assert strategy2(@input) == 4455
    end

    test "with input" do
      assert File.read!("test/fixtures/day4.txt")
             |> strategy2() == 37886
    end
  end

  defp strategy2(input) do
    {guard, sleepiest_minute, _} =
      input
      |> parse()
      |> partition
      |> sleepiest_minute

    String.to_integer(guard) * sleepiest_minute
  end

  defp strategy1(input) do
    {guard, intervals} =
      input
      |> parse()
      |> partition
      |> most_minutes

    {sleepy_minute, _} = sleepy_minute(intervals)
    String.to_integer(guard) * sleepy_minute
  end

  # defp sleepiest_minute(input) do
  #   Enum.reduce(input, %{}, fn {guard, intervals}, acc ->
  #     Enum.flat_map(intervals, &Enum.to_list/1)
  #     |> Enum.each(fn minute ->
  #       Map.update(acc, minute, guard)
  #     end)
  #   end)
  # end
  defp sleepiest_minute(input) do
    Enum.reduce(input, {nil, nil, 0}, fn {guard, intervals},
                                         {max_guard, max_minute, max_minutes} ->
      {minute, minutes} = sleepy_minute(intervals)

      cond do
        Enum.count(minutes) > max_minutes -> {guard, minute, Enum.count(minutes)}
        true -> {max_guard, max_minute, max_minutes}
      end
    end)
  end

  defp sleepy_minute(intervals) do
    Enum.flat_map(intervals, &Enum.to_list/1)
    |> Enum.sort()
    |> Enum.group_by(& &1)
    |> Enum.max_by(fn {_minute, minutes} -> Enum.count(minutes) end)
  end

  defp most_minutes(input) do
    Enum.max_by(input, fn {_guard, minutes} ->
      Enum.map(minutes, &Enum.count/1)
      |> Enum.sum()
    end)
  end

  defp partition(input) do
    Enum.reduce(input, {%{}, nil, nil}, fn
      <<_::binary-size(19), "Guard #", rest::bitstring>>, {acc, _guard, _sleep} ->
        %{"guard" => guard} = Regex.named_captures(~r/(?<guard>\d+)/, rest)
        {acc, guard, nil}

      <<_::binary-size(15), sleep::binary-size(2), "] falls asleep">>, {acc, guard, _sleep} ->
        {acc, guard, String.to_integer(sleep)}

      <<_::binary-size(15), wake::binary-size(2), "] wakes up">>, {acc, guard, sleep} ->
        {Map.update(acc, guard, [sleep..(String.to_integer(wake) - 1)], fn list ->
           [sleep..(String.to_integer(wake) - 1) | list]
         end), guard, nil}
    end)
    |> elem(0)
  end

  defp parse(input) do
    String.split(input, "\n", trim: true)
    |> Enum.sort()
  end
end
