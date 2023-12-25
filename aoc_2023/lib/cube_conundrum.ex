defmodule CubeConundrum do
  @colours %{"red" => 12, "green" => 13, "blue" => 14}

  def checkGame(:eof) do
    0
  end

  def checkGame(aLine) do
    tuples = String.replace(aLine, ~r/[,.;:\n]/, "") |> String.split(" ") |> Enum.chunk_every(2)
    {game, _} = hd(tuples) |> tl |> hd |> Integer.parse
    if Enum.map(tl(tuples), fn aList -> then(Integer.parse(hd(aList)),
    fn {num, _} -> @colours[List.last(aList)] >= num end) end) |>
    Enum.reduce(true, &and/2),
    do: game,
    else: 0
  end

  def checkGamePart2(:eof) do
    0
  end

  def checkGamePart2(aLine) do
    currentColours = %{"red" => 0, "green" => 2, "blue" => 0}
    tuples = String.replace(aLine, ~r/[,.;:\n]/, "") |> String.split(" ") |> Enum.chunk_every(2)
    {game, _} = hd(tuples) |> tl |> hd |> Integer.parse
    Enum.group_by(tl(tuples), &List.last/1, &List.first/1) |>
    Map.values |>
    Enum.map(fn aList -> Enum.map(aList, &String.to_integer/1) |>
    Enum.max  end) |>
    Enum.reduce(1, &*/2)
  end
end
