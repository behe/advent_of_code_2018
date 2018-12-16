defmodule Day5Test do
  use ExUnit.Case

  describe "part 1" do
    test "react unit" do
      assert react?(?a, ?A) == true
      assert react?(?A, ?a) == true
      assert react?(?a, ?a) == false
      assert react?(?A, ?A) == false
    end

    test "react polymer" do
      assert react("aA") == ""
      assert react("Aa") == ""
      assert react("aa") == "aa"
      assert react("AA") == "AA"
      assert react("abBA") == ""
      assert react("abAB") == "abAB"
      assert react("aabAAB") == "aabAAB"
    end

    test "with test input" do
      polymer = "dabAcCaCBAcCcaDA"
      final_polymer = react(polymer)
      assert final_polymer == "dabCBAcaDA"
      assert String.length(final_polymer) == 10
    end

    test "with input" do
      polymer =
        File.read!("test/fixtures/day5.txt")
        |> String.trim()

      final_polymer = react(polymer)
      assert String.length(final_polymer) == 10888
    end
  end

  describe "part 2" do
    test "pairs" do
      assert to_charlist("dabAcCaCBAcCcaDA")
             |> pairs() == ['aA', 'bB', 'cC', 'dD']
    end

    test "remove unit" do
      assert remove_unit("dabAcCaCBAcCcaDA", 'aA') == "dbcCCBcCcD"
      assert remove_unit("dabAcCaCBAcCcaDA", 'bB') == "daAcCaCAcCcaDA"
      assert remove_unit("dabAcCaCBAcCcaDA", 'cC') == "dabAaBAaDA"
      assert remove_unit("dabAcCaCBAcCcaDA", 'dD') == "abAcCaCBAcCcaA"
    end

    test "with test input" do
      polymer = "dabAcCaCBAcCcaDA"
      final_polymer_size = reduce_polymer(polymer)
      assert final_polymer_size == 4
    end

    test "with input" do
      polymer =
        File.read!("test/fixtures/day5.txt")
        |> String.trim()

      final_polymer_size = reduce_polymer(polymer)
      assert final_polymer_size == 6952
    end
  end

  defp reduce_polymer(polymer) do
    to_charlist(polymer)
    |> pairs
    |> Enum.reduce(String.length(polymer), fn pair, min_length ->
      remove_unit(polymer, pair)
      |> react()
      |> String.length()
      |> min(min_length)
    end)
  end

  defp remove_unit(polymer, unit) do
    to_charlist(polymer)
    |> Enum.reject(fn char -> char in unit end)
    |> to_string
  end

  defp pairs(polymer) do
    Enum.reduce(polymer, MapSet.new(), fn unit, acc ->
      lower = :string.lowercase([unit])
      upper = :string.uppercase([unit])
      MapSet.put(acc, [hd(lower) | upper])
    end)
    |> MapSet.to_list()
  end

  defp react(polymer) do
    to_charlist(polymer)
    |> Enum.reduce([], fn
      unit, [prev_unit | rest] = acc ->
        if react?(unit, prev_unit) do
          rest
        else
          [unit | acc]
        end

      unit, [] ->
        [unit]
    end)
    |> Enum.reverse()
    |> to_string
  end

  defp react?(a, b) do
    abs(a - b) == 32
  end
end
