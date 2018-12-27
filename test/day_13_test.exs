defmodule Day13Test do
  use ExUnit.Case

  @input """
  /->-\\
  |   |  /----\\
  | /-+--+-\\  |
  | | |  | v  |
  \\-+-/  \\-+--/
    \\------/
  """

  @tracks %{
    {0, 0} => "/",
    {1, 0} => "-",
    {2, 0} => "-",
    {3, 0} => "-",
    {4, 0} => "\\",
    {0, 1} => "|",
    {4, 1} => "|",
    {7, 1} => "/",
    {8, 1} => "-",
    {9, 1} => "-",
    {10, 1} => "-",
    {11, 1} => "-",
    {12, 1} => "\\",
    {0, 2} => "|",
    {2, 2} => "/",
    {3, 2} => "-",
    {4, 2} => "+",
    {5, 2} => "-",
    {6, 2} => "-",
    {7, 2} => "+",
    {8, 2} => "-",
    {9, 2} => "\\",
    {12, 2} => "|",
    {0, 3} => "|",
    {2, 3} => "|",
    {4, 3} => "|",
    {7, 3} => "|",
    {9, 3} => "|",
    {12, 3} => "|",
    {0, 4} => "\\",
    {1, 4} => "-",
    {2, 4} => "+",
    {3, 4} => "-",
    {4, 4} => "/",
    {7, 4} => "\\",
    {8, 4} => "-",
    {9, 4} => "+",
    {10, 4} => "-",
    {11, 4} => "-",
    {12, 4} => "/",
    {2, 5} => "\\",
    {3, 5} => "-",
    {4, 5} => "-",
    {5, 5} => "-",
    {6, 5} => "-",
    {7, 5} => "-",
    {8, 5} => "-",
    {9, 5} => "/"
  }

  describe "part 1" do
    test "parse" do
      assert parse(@input) ==
               {@tracks, %{{2, 0} => {">", :left}, {9, 3} => {"v", :left}}}
    end

    test "tick 1" do
      assert tick(@tracks, %{{2, 0} => {">", :left}, {9, 3} => {"v", :left}}) ==
               %{{3, 0} => {">", :left}, {9, 4} => {">", :straight}}
    end

    test "tick 2" do
      assert tick(@tracks, %{{3, 0} => {">", :left}, {9, 4} => {">", :straight}}) ==
               %{{4, 0} => {"v", :left}, {10, 4} => {">", :straight}}
    end

    test "tick 3" do
      assert tick(@tracks, %{{4, 0} => {"v", :left}, {10, 4} => {">", :straight}}) ==
               %{{4, 1} => {"v", :left}, {11, 4} => {">", :straight}}
    end

    test "tick 4" do
      assert tick(@tracks, %{{4, 1} => {"v", :left}, {11, 4} => {">", :straight}}) ==
               %{{4, 2} => {">", :straight}, {12, 4} => {"^", :straight}}
    end

    test "tick 5" do
      assert tick(@tracks, %{{4, 2} => {">", :straight}, {12, 4} => {"^", :straight}}) ==
               %{{5, 2} => {">", :straight}, {12, 3} => {"^", :straight}}
    end

    test "tick 6" do
      assert tick(@tracks, %{{5, 2} => {">", :straight}, {12, 3} => {"^", :straight}}) ==
               %{{6, 2} => {">", :straight}, {12, 2} => {"^", :straight}}
    end

    test "tick 7" do
      assert tick(@tracks, %{{6, 2} => {">", :straight}, {12, 2} => {"^", :straight}}) ==
               %{{7, 2} => {">", :right}, {12, 1} => {"<", :straight}}
    end

    test "tick 8" do
      assert tick(@tracks, %{{7, 2} => {">", :right}, {12, 1} => {"<", :straight}}) ==
               %{{8, 2} => {">", :right}, {11, 1} => {"<", :straight}}
    end

    test "tick 9" do
      assert tick(@tracks, %{{8, 2} => {">", :right}, {11, 1} => {"<", :straight}}) ==
               %{{9, 2} => {"v", :right}, {10, 1} => {"<", :straight}}
    end

    test "tick 10" do
      assert tick(@tracks, %{{9, 2} => {"v", :right}, {10, 1} => {"<", :straight}}) ==
               %{{9, 3} => {"v", :right}, {9, 1} => {"<", :straight}}
    end

    test "tick 11" do
      assert tick(@tracks, %{{9, 3} => {"v", :right}, {9, 1} => {"<", :straight}}) ==
               %{{9, 4} => {"<", :left}, {8, 1} => {"<", :straight}}
    end

    test "tick 12" do
      assert tick(@tracks, %{{9, 4} => {"<", :left}, {8, 1} => {"<", :straight}}) ==
               %{{8, 4} => {"<", :left}, {7, 1} => {"v", :straight}}
    end

    test "tick 13" do
      assert tick(@tracks, %{{8, 4} => {"<", :left}, {7, 1} => {"v", :straight}}) ==
               %{{7, 4} => {"^", :left}, {7, 2} => {"v", :right}}
    end

    test "crash when second moves into first cart" do
      assert tick(@tracks, %{{7, 4} => {"^", :left}, {7, 2} => {"v", :right}}) ==
               {7, 3}
    end

    test "crash when first moves into second cart" do
      assert tick(@tracks, %{{7, 3} => {"^", :left}, {7, 2} => {"v", :right}}) ==
               {7, 3}
    end

    test "first crash" do
      assert first_crash(@input) == {7, 3}
    end

    test "first crash with input" do
      assert first_crash(File.read!("test/fixtures/day13.txt")) == {33, 69}
    end
  end

  @part2_input """
  />-<\\
  |   |
  | /<+-\\
  | | | v
  \\>+</ |
    |   ^
    \\<->/
  """
  @part2_tracks %{
    {0, 0} => "/",
    {0, 1} => "|",
    {0, 2} => "|",
    {0, 3} => "|",
    {0, 4} => "\\",
    {1, 0} => "-",
    {1, 4} => "-",
    {2, 0} => "-",
    {2, 2} => "/",
    {2, 3} => "|",
    {2, 4} => "+",
    {2, 5} => "|",
    {2, 6} => "\\",
    {3, 0} => "-",
    {3, 2} => "-",
    {3, 4} => "-",
    {3, 6} => "-",
    {4, 0} => "\\",
    {4, 1} => "|",
    {4, 2} => "+",
    {4, 3} => "|",
    {4, 4} => "/",
    {4, 6} => "-",
    {5, 2} => "-",
    {5, 6} => "-",
    {6, 2} => "\\",
    {6, 3} => "|",
    {6, 4} => "|",
    {6, 5} => "|",
    {6, 6} => "/"
  }
  describe "part 2" do
    test "parse" do
      assert parse(@part2_input) ==
               {@part2_tracks,
                %{
                  {1, 0} => {">", :left},
                  {3, 0} => {"<", :left},
                  {3, 2} => {"<", :left},
                  {6, 3} => {"v", :left},
                  {1, 4} => {">", :left},
                  {3, 4} => {"<", :left},
                  {6, 5} => {"^", :left},
                  {3, 6} => {"<", :left},
                  {5, 6} => {">", :left}
                }}
    end

    test "tock 1" do
      assert tock(@part2_tracks, %{
               {1, 0} => {">", :left},
               {3, 0} => {"<", :left},
               {3, 2} => {"<", :left},
               {6, 3} => {"v", :left},
               {1, 4} => {">", :left},
               {3, 4} => {"<", :left},
               {6, 5} => {"^", :left},
               {3, 6} => {"<", :left},
               {5, 6} => {">", :left}
             }) == %{
               {2, 2} => {"v", :left},
               {2, 6} => {"^", :left},
               {6, 6} => {"^", :left}
             }
    end

    test "tock 2" do
      assert tock(@part2_tracks, %{
               {2, 2} => {"v", :left},
               {2, 6} => {"^", :left},
               {6, 6} => {"^", :left}
             }) ==
               %{{2, 3} => {"v", :left}, {2, 5} => {"^", :left}, {6, 5} => {"^", :left}}
    end

    test "crash when second moves into first cart" do
      assert tock(@part2_tracks, %{
               {2, 3} => {"v", :left},
               {2, 5} => {"^", :left},
               {6, 5} => {"^", :left}
             }) ==
               %{{6, 4} => {"^", :left}}
    end

    test "crash when first moves into second cart" do
      assert tock(@part2_tracks, %{
               {2, 4} => {"v", :left},
               {2, 5} => {"^", :left},
               {6, 5} => {"^", :left}
             }) ==
               %{{6, 4} => {"^", :left}}
    end

    test "last cart" do
      assert last_cart(@part2_input) == {6, 4}
    end

    test "last cart with input" do
      assert last_cart(File.read!("test/fixtures/day13.txt")) == {135, 9}
    end
  end

  defp last_cart(input) do
    {tracks, carts} = parse(input)
    last_cart(tracks, carts)
  end

  defp last_cart(_tracks, carts) when map_size(carts) == 1 do
    Map.keys(carts) |> hd
  end

  defp last_cart(tracks, carts) do
    last_cart(tracks, tock(tracks, carts))
  end

  defp tock(tracks, carts) do
    carts
    |> Enum.sort_by(fn {{x, y}, _} -> {y, x} end)
    |> Enum.reduce_while({carts, []}, fn
      {{x, y} = coord, {heading, next_direction}}, {carts, crashed_coords} ->
        # IO.inspect({coord, crashed_coords})
        # IO.inspect({{x, y}, {heading, next_direction}})
        if coord in crashed_coords do
          {:cont, {carts, crashed_coords}}
        else
          next_coord =
            case heading do
              "<" -> {x - 1, y}
              ">" -> {x + 1, y}
              "v" -> {x, y + 1}
              "^" -> {x, y - 1}
            end

          if Map.has_key?(carts, next_coord) do
            {:cont, {Map.drop(carts, [coord, next_coord]), [next_coord | crashed_coords]}}
          else
            {:cont,
             {move(tracks, carts, {x, y}, next_coord, heading, next_direction), crashed_coords}}
          end
        end
    end)
    |> elem(0)
  end

  defp first_crash(input) do
    {tracks, carts} = parse(input)
    first_crash(tracks, carts)
  end

  defp first_crash(_tracks, coord) when is_tuple(coord), do: coord

  defp first_crash(tracks, carts) do
    first_crash(tracks, tick(tracks, carts))
  end

  defp tick(tracks, carts) do
    carts
    |> Enum.sort_by(fn {{x, y}, _} -> {y, x} end)
    |> Enum.reduce_while(carts, fn {{x, y}, {heading, next_direction}}, carts ->
      # IO.inspect({{x, y}, {heading, next_direction}})

      next_coord =
        case heading do
          "<" -> {x - 1, y}
          ">" -> {x + 1, y}
          "v" -> {x, y + 1}
          "^" -> {x, y - 1}
        end

      if Map.has_key?(carts, next_coord) do
        {:halt, next_coord}
      else
        {:cont, move(tracks, carts, {x, y}, next_coord, heading, next_direction)}
      end
    end)
  end

  defp move(tracks, carts, coord, next_coord, heading, next_direction) do
    next_track = Map.get(tracks, next_coord)
    carts = Map.delete(carts, coord)

    cond do
      next_track in ["-", "|"] ->
        Map.put(carts, next_coord, {heading, next_direction})

      "+" == next_track ->
        Map.put(
          carts,
          next_coord,
          {rotate(heading, next_direction), next_direction(next_direction)}
        )

      next_track in ["/", "\\"] ->
        Map.put(carts, next_coord, {turn(heading, next_track), next_direction})
    end
  end

  defp turn(heading, "\\") when heading in ["<", ">"], do: rotate(heading, :right)
  defp turn(heading, "/") when heading in ["^", "v"], do: rotate(heading, :right)
  defp turn(heading, "\\") when heading in ["^", "v"], do: rotate(heading, :left)
  defp turn(heading, "/") when heading in ["<", ">"], do: rotate(heading, :left)

  @clockwise_headings ["^", ">", "v", "<"]
  defp rotate(current_heading, :left) do
    Enum.at(
      @clockwise_headings,
      rem(
        Enum.find_index(@clockwise_headings, fn heading ->
          heading == current_heading
        end) - 1,
        Enum.count(@clockwise_headings)
      )
    )
  end

  defp rotate(heading, :straight) do
    heading
  end

  defp rotate(current_heading, :right) do
    Enum.at(
      @clockwise_headings,
      rem(
        Enum.find_index(@clockwise_headings, fn heading ->
          heading == current_heading
        end) + 1,
        Enum.count(@clockwise_headings)
      )
    )
  end

  @directions [:left, :straight, :right]
  defp next_direction(current_direction) do
    Enum.at(
      @directions,
      rem(
        Enum.find_index(@directions, fn direction ->
          direction == current_direction
        end) + 1,
        Enum.count(@directions)
      )
    )
  end

  # {x_coordinate, y_coordinate, heading, next_direction}
  defp parse(input) do
    tracks =
      String.split(input, "\n", trim: true)
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {row, y}, acc ->
        String.graphemes(row)
        |> Enum.with_index()
        |> Enum.reduce(acc, fn
          {" ", _x}, acc -> acc
          {track, x}, acc -> Map.put(acc, {x, y}, track)
        end)
      end)

    Enum.reduce(tracks, {tracks, %{}}, fn
      {coord, track}, {tracks, carts} when track in ["^", "v"] ->
        {Map.put(tracks, coord, "|"), Map.put(carts, coord, {track, :left})}

      {coord, track}, {tracks, carts} when track in ["<", ">"] ->
        {Map.put(tracks, coord, "-"), Map.put(carts, coord, {track, :left})}

      _, {tracks, carts} ->
        {tracks, carts}
    end)
  end
end
