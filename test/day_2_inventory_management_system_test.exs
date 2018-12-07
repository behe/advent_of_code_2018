defmodule Day2InventoryManagementSystemTest do
  use ExUnit.Case

  setup do
    input = """
    abcdef
    bababc
    abbcde
    abcccd
    aabcdd
    abcdee
    ababab
    """

    {:ok, pid} = StringIO.open(input)
    file_stream = IO.stream(pid, :line)

    {:ok, stream: file_stream}
  end

  describe "part 1" do
    test "to list", %{stream: file_stream} do
      assert file_stream
             |> Stream.flat_map(&String.splitter(&1, "\n", trim: true))
             |> Enum.to_list() == [
               "abcdef",
               "bababc",
               "abbcde",
               "abcccd",
               "aabcdd",
               "abcdee",
               "ababab"
             ]
    end

    test "to repeats", %{stream: file_stream} do
      assert file_stream
             |> Enum.flat_map(&String.splitter(&1, "\n", trim: true))
             |> Enum.flat_map(&repeats/1) == [2, 3, 2, 3, 2, 2, 3]
    end

    test "to checksum", %{stream: file_stream} do
      assert file_stream
             |> Enum.flat_map(&String.splitter(&1, "\n", trim: true))
             |> Enum.flat_map(&repeats/1)
             |> repeat_count
             |> Enum.reduce(fn x, acc -> x * acc end) == 12
    end

    test "to checksum with input" do
      assert File.stream!("test/fixtures/day2.txt")
             |> Stream.flat_map(&String.splitter(&1, "\n", trim: true))
             |> Stream.flat_map(&repeats/1)
             |> repeat_count
             |> Enum.reduce(fn x, acc -> x * acc end) == 8398
    end
  end

  describe "part 2" do
    test "common" do
      assert ["abcde", "fghij", "klmno", "pqrst", "fguij", "axcye", "wvxyz"]
             |> Enum.map(&String.split(&1, "", trim: true))
             |> common == "fgij"
    end

    test "common with input" do
      assert File.stream!("test/fixtures/day2.txt")
             |> Stream.flat_map(&String.splitter(&1, "\n", trim: true))
             |> Enum.map(&String.split(&1, "", trim: true))
             |> common == "hhvsdkatysmiqjxunezgwcdpr"
    end
  end

  defp common([head | tail]) do
    Enum.find_value(tail, &common_string(head, &1, [], 0)) || common(tail)
  end

  defp common_string([], [], common, 1) do
    Enum.reverse(common) |> Enum.join()
  end

  defp common_string([], [], _, _) do
    nil
  end

  defp common_string([x | rest1], [x | rest2], common, i) do
    common_string(rest1, rest2, [x | common], i)
  end

  defp common_string([_ | _], [_ | _], _, 1) do
    nil
  end

  defp common_string([_ | rest1], [_ | rest2], common, 0) do
    common_string(rest1, rest2, common, 1)
  end

  defp repeats(x) do
    String.splitter(x, "", trim: true)
    |> repeat_count
    |> Enum.uniq()
    |> Enum.filter(&(&1 in [2, 3]))
  end

  defp repeat_count(x) do
    Enum.sort(x)
    |> Enum.chunk_by(& &1)
    |> Enum.map(&Enum.count/1)
  end
end
