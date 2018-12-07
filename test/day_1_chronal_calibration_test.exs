defmodule Day1ChronalCalibrationTest do
  use ExUnit.Case

  setup do
    input = """
    +1
    -2
    +3
    +1
    """

    {:ok, pid} = StringIO.open(input)
    file_stream = IO.stream(pid, :line)

    {:ok, stream: file_stream}
  end

  describe "part 1" do
    test "to list", %{stream: file_stream} do
      assert file_stream
             |> Stream.flat_map(&String.splitter(&1, "\n", trim: true))
             |> Enum.to_list() == ["+1", "-2", "+3", "+1"]
    end

    test "to integers", %{stream: file_stream} do
      assert file_stream
             |> Flow.from_enumerable()
             |> Flow.flat_map(&String.splitter(&1, "\n", trim: true))
             |> Flow.map(&String.to_integer/1)
             |> Enum.to_list() == [1, -2, 3, 1]
    end

    test "sum", %{stream: file_stream} do
      assert file_stream
             |> Flow.from_enumerable()
             |> Flow.flat_map(&String.splitter(&1, "\n", trim: true))
             |> Flow.map(&String.to_integer/1)
             |> Enum.sum() == 3
    end

    test "sum with input" do
      assert File.stream!("test/fixtures/day1.txt")
             |> Flow.from_enumerable()
             |> Flow.flat_map(&String.splitter(&1, "\n", trim: true))
             |> Flow.map(&String.to_integer/1)
             |> Enum.sum() == 574
    end
  end

  describe "part 2" do
    test "repetition", %{stream: file_stream} do
      assert file_stream
             |> Stream.flat_map(&String.splitter(&1, "\n", trim: true))
             |> Enum.map(&String.to_integer/1)
             |> Stream.cycle()
             |> Enum.reduce_while({0, MapSet.new([0])}, fn charge, {freq, set} ->
               current = freq + charge

               if MapSet.member?(set, current) do
                 {:halt, current}
               else
                 {:cont, {current, MapSet.put(set, current)}}
               end
             end) == 2
    end

    test "repetition with input" do
      assert File.stream!("test/fixtures/day1.txt")
             |> Stream.flat_map(&String.splitter(&1, "\n", trim: true))
             |> Enum.map(&String.to_integer/1)
             |> Stream.cycle()
             |> Enum.reduce_while({0, MapSet.new([0])}, fn charge, {freq, set} ->
               current = freq + charge

               if MapSet.member?(set, current) do
                 {:halt, current}
               else
                 {:cont, {current, MapSet.put(set, current)}}
               end
             end) == 452
    end
  end
end
