defmodule Day10Test do
  use ExUnit.Case

  @input """
  position=< 9,  1> velocity=< 0,  2>
  position=< 7,  0> velocity=<-1,  0>
  position=< 3, -2> velocity=<-1,  1>
  position=< 6, 10> velocity=<-2, -1>
  position=< 2, -4> velocity=< 2,  2>
  position=<-6, 10> velocity=< 2, -2>
  position=< 1,  8> velocity=< 1, -1>
  position=< 1,  7> velocity=< 1,  0>
  position=<-3, 11> velocity=< 1, -2>
  position=< 7,  6> velocity=<-1, -1>
  position=<-2,  3> velocity=< 1,  0>
  position=<-4,  3> velocity=< 2,  0>
  position=<10, -3> velocity=<-1,  1>
  position=< 5, 11> velocity=< 1, -2>
  position=< 4,  7> velocity=< 0, -1>
  position=< 8, -2> velocity=< 0,  1>
  position=<15,  0> velocity=<-2,  0>
  position=< 1,  6> velocity=< 1,  0>
  position=< 8,  9> velocity=< 0, -1>
  position=< 3,  3> velocity=<-1,  1>
  position=< 0,  5> velocity=< 0, -1>
  position=<-2,  2> velocity=< 2,  0>
  position=< 5, -2> velocity=< 1,  2>
  position=< 1,  4> velocity=< 2,  1>
  position=<-2,  7> velocity=< 2, -2>
  position=< 3,  6> velocity=<-1, -1>
  position=< 5,  0> velocity=< 1,  0>
  position=<-6,  0> velocity=< 2,  0>
  position=< 5,  9> velocity=< 1, -2>
  position=<14,  7> velocity=<-2,  0>
  position=<-3,  6> velocity=< 2, -1>
  """

  describe "part 1" do
    test "parse" do
      assert @input
             |> parse == %{
               {-6, 0} => [{2, 0}],
               {-6, 10} => [{2, -2}],
               {-4, 3} => [{2, 0}],
               {-3, 6} => [{2, -1}],
               {-3, 11} => [{1, -2}],
               {-2, 2} => [{2, 0}],
               {-2, 3} => [{1, 0}],
               {-2, 7} => [{2, -2}],
               {0, 5} => [{0, -1}],
               {1, 4} => [{2, 1}],
               {1, 6} => [{1, 0}],
               {1, 7} => [{1, 0}],
               {1, 8} => [{1, -1}],
               {2, -4} => [{2, 2}],
               {3, -2} => [{-1, 1}],
               {3, 3} => [{-1, 1}],
               {3, 6} => [{-1, -1}],
               {4, 7} => [{0, -1}],
               {5, -2} => [{1, 2}],
               {5, 0} => [{1, 0}],
               {5, 9} => [{1, -2}],
               {5, 11} => [{1, -2}],
               {6, 10} => [{-2, -1}],
               {7, 0} => [{-1, 0}],
               {7, 6} => [{-1, -1}],
               {8, -2} => [{0, 1}],
               {8, 9} => [{0, -1}],
               {9, 1} => [{0, 2}],
               {10, -3} => [{-1, 1}],
               {14, 7} => [{-2, 0}],
               {15, 0} => [{-2, 0}]
             }
    end

    test "parse duplicates" do
      assert """
             position=<1,  2> velocity=< 1,  0>
             position=<1,  2> velocity=< 2,  0>
             """
             |> parse == %{{1, 2} => [{2, 0}, {1, 0}]}
    end

    test "print" do
      assert @input
             |> parse
             |> print == """
             ........#.............
             ................#.....
             .........#.#..#.......
             ......................
             #..........#.#.......#
             ...............#......
             ....#.................
             ..#.#....#............
             .......#..............
             ......#...............
             ...#...#.#...#........
             ....#..#..#.........#.
             .......#..............
             ...........#..#.......
             #...........#.........
             ...#.......#..........
             """
    end

    test "tick one" do
      assert tick({{-6, 0}, {2, 0}}) == {{-4, 0}, {2, 0}}
      assert tick(%{{-6, 0} => [{2, 0}]}) == %{{-4, 0} => [{2, 0}]}
    end

    test "tick" do
      assert @input
             |> parse
             |> tick
             |> print == """
             ........#....#....
             ......#.....#.....
             #.........#......#
             ..................
             ....#.............
             ..##.........#....
             ....#.#...........
             ...##.##..#.......
             ......#.#.........
             ......#...#.....#.
             #...........#.....
             ..#.....#.#.......
             """
    end

    test "tick 2" do
      assert @input
             |> parse
             |> tick
             |> tick
             |> print == """
             ..........#...
             #..#...####..#
             ..............
             ....#....#....
             ..#.#.........
             ...#...#......
             ...#..#..#.#..
             #....#.#......
             .#...#...##.#.
             ....#.........
             """
    end

    test "tick 3" do
      assert @input
             |> parse
             |> tick
             |> tick
             |> tick
             |> print == """
             #...#..###
             #...#...#.
             #...#...#.
             #####...#.
             #...#...#.
             #...#...#.
             #...#...#.
             #...#..###
             """
    end

    test "words?" do
      parsed_input = parse(@input)
      assert parsed_input |> words? == false
      assert parsed_input |> tick |> words? == false
      assert parsed_input |> tick |> tick |> words? == false
      assert parsed_input |> tick |> tick |> tick |> words? == true
    end

    test "solve with test input" do
      assert solve(@input) ==
               {3,
                """
                #...#..###
                #...#...#.
                #...#...#.
                #####...#.
                #...#...#.
                #...#...#.
                #...#...#.
                #...#..###
                """}
    end

    test "solve with input" do
      assert File.read!("test/fixtures/day10.txt")
             |> solve() ==
               {10003,
                """
                .####...######..#....#..#####...#....#....##....#####...#....#
                #....#.......#..#...#...#....#..##...#...#..#...#....#..##...#
                #............#..#..#....#....#..##...#..#....#..#....#..##...#
                #...........#...#.#.....#....#..#.#..#..#....#..#....#..#.#..#
                #..........#....##......#####...#.#..#..#....#..#####...#.#..#
                #.........#.....##......#.......#..#.#..######..#..#....#..#.#
                #........#......#.#.....#.......#..#.#..#....#..#...#...#..#.#
                #.......#.......#..#....#.......#...##..#....#..#...#...#...##
                #....#..#.......#...#...#.......#...##..#....#..#....#..#...##
                .####...######..#....#..#.......#....#..#....#..#....#..#....#
                """}
    end
  end

  defp solve(input) when is_binary(input) do
    solve(parse(input), 0, false)
  end

  defp solve(coords, s, true) when is_map(coords), do: {s, print(coords)}

  defp solve(coords, s, false) when is_map(coords) do
    coords = tick(coords)
    solve(coords, s + 1, words?(coords))
  end

  defp words?(coords) do
    coords
    |> Enum.all?(fn {{x, y}, _} ->
      neighbours =
        Map.take(coords, [
          {x - 1, y - 1},
          {x, y - 1},
          {x + 1, y - 1},
          {x - 1, y},
          {x + 1, y},
          {x - 1, y + 1},
          {x, y + 1},
          {x + 1, y + 1}
        ])

      map_size(neighbours) > 0
    end)
  end

  defp tick({{x, y}, {x_velocity, y_velocity} = velocity}) do
    {{x + x_velocity, y + y_velocity}, velocity}
  end

  defp tick(coords) when is_map(coords) do
    # IO.inspect(Map.values(coords) |> List.flatten() |> length, label: :in)

    coords
    |> Enum.reduce(%{}, fn {position, velocities}, acc ->
      Enum.reduce(velocities, acc, fn velocity, acc ->
        {position, velocity} = tick({position, velocity})
        Map.update(acc, position, [velocity], fn velocities -> [velocity | velocities] end)
      end)
    end)

    # |> (fn out ->
    #       IO.inspect(Map.values(out) |> List.flatten() |> length, label: :out)
    #       out
    #     end).()
  end

  defp print(coords) when is_map(coords) do
    all_x = Enum.map(coords, fn {{x, _}, _} -> x end)
    x_range = Enum.min_max(all_x) |> (fn {min, max} -> min..max end).()
    all_y = Enum.map(coords, fn {{_, y}, _} -> y end)
    y_range = Enum.min_max(all_y) |> (fn {min, max} -> min..max end).()

    Enum.reduce(y_range, [], fn y, acc ->
      [
        '\n'
        | Enum.reduce(x_range, acc, fn x, acc ->
            [if(Map.get(coords, {x, y}), do: '#', else: '.') | acc]
          end)
      ]
    end)
    |> Enum.reverse()
    |> to_string
  end

  defp parse(input) when is_binary(input) do
    String.split(input, ["position=", "<", " ", ",", ">", "velocity=", "\n"], trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(2)
    |> Enum.map(&List.to_tuple/1)
    |> Enum.chunk_every(2)
    |> Enum.reduce(%{}, fn [position, velocity], acc ->
      Map.update(acc, position, [velocity], fn velocities -> [velocity | velocities] end)
    end)
  end
end
