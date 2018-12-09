defmodule Day8Test do
  use ExUnit.Case

  describe "part 1" do
    test "decode" do
      assert "2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2\n"
             |> String.split(~r/ |\n/, trim: true)
             |> Enum.map(&String.to_integer/1)
             |> decode() == 138
    end

    test "decode with input" do
      assert File.read!("test/fixtures/day8.txt")
             |> String.split(~r/ |\n/, trim: true)
             |> Enum.map(&String.to_integer/1)
             |> decode() == 41521
    end
  end

  describe "part 2" do
    test "indexed_decode leaf" do
      assert "0 1 99\n"
             |> String.split(~r/ |\n/, trim: true)
             |> Enum.map(&String.to_integer/1)
             |> indexed_decode() == 99
    end

    test "indexed_decode node" do
      assert "1 1 0 1 99 2\n"
             |> String.split(~r/ |\n/, trim: true)
             |> Enum.map(&String.to_integer/1)
             |> indexed_decode() == 0
    end

    test "indexed decode tree" do
      assert "2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2\n"
             |> String.split(~r/ |\n/, trim: true)
             |> Enum.map(&String.to_integer/1)
             |> indexed_decode() == 66
    end

    test "indexed decode with input" do
      assert File.read!("test/fixtures/day8.txt")
             |> String.split(~r/ |\n/, trim: true)
             |> Enum.map(&String.to_integer/1)
             |> indexed_decode() == 19990
    end
  end

  defp indexed_decode(list) do
    {sum, _} = indexed_decode(list, 0)
    sum
  end

  defp indexed_decode([0 | [metadata_count | rest]], sum) do
    {metadata, remainder} = Enum.split(rest, metadata_count)
    {Enum.sum(metadata) + sum, remainder}
  end

  defp indexed_decode([child_count | [metadata_count | rest]], sum) do
    {decoded_children, remainder} = indexed_decode_children(child_count, rest, [])
    {metadata, remainder} = Enum.split(remainder, metadata_count)

    sum =
      Enum.reduce(metadata, sum, fn index, sum ->
        sum + Enum.at(decoded_children, index - 1, 0)
      end)

    {sum, remainder}
  end

  defp indexed_decode_children(0, remainder, decoded_children),
    do: {Enum.reverse(decoded_children), remainder}

  defp indexed_decode_children(child_count, remainder, decoded_children) do
    {sum, remainder} = indexed_decode(remainder, 0)
    indexed_decode_children(child_count - 1, remainder, [sum | decoded_children])
  end

  defp decode(list) do
    {sum, _} = decode(list, 0)
    sum
  end

  defp decode([child_count | [metadata_count | rest]], sum) do
    {child_sum, remainder} = decode_children(child_count, rest, sum)
    {metadata, remainder} = Enum.split(remainder, metadata_count)
    {Enum.sum(metadata) + child_sum, remainder}
  end

  defp decode_children(0, remainder, sum), do: {sum, remainder}

  defp decode_children(child_count, remainder, sum) do
    {sum, remainder} = decode(remainder, sum)
    decode_children(child_count - 1, remainder, sum)
  end
end
