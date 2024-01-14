defmodule GearRatios do

  def gearRatiosPart1(fileContents) do
    splitFilesonFunction(fileContents, &signedParts/1)
  end

  def gearRatiosPart2(fileContents) do
    splitFilesonFunction(fileContents, &gears/1)
  end

  def splitFilesonFunction(fileContents, solutionFunc) do
    fileContents |> String.split("\n", trim: true)
      |> (fn (xs,x) -> [x|xs] end).(:start)
      |> Kernel.++([:end])
      |> Enum.chunk_every(3, 1, :discard)
      |> Enum.map(fn n -> Task.async(fn -> solutionFunc.(n) end) end)
      |> Enum.map(&Task.await/1)
      |> Enum.sum()
  end

  def signedParts(threeLines) do
    locationSigns = threeLines
        |> Enum.filter(&is_bitstring/1)
        |> Enum.map(&String.graphemes/1)
        |> Enum.map(&Enum.with_index/1)
        |> Enum.map(fn k -> Enum.filter(k, fn({x, _y}) -> String.match?(x, ~r/[^\r\n.\d]/) end) end)
        |> Enum.flat_map(fn k -> Enum.map(k, fn ({_x, y}) -> y end) end)
    numberLocations = Enum.zip(Regex.scan(~r/\d+/, Enum.at(threeLines, 1), capture: :all) |> List.flatten(),
      Regex.scan(~r/\d+/, Enum.at(threeLines, 1), return: :index) |> List.flatten())
    numberLocations |> Enum.filter(fn ({_k, m}) -> m |> (fn ({x, z}) -> Enum.any?(locationSigns, fn number  -> number >= (x - 1) && number <= (x + z) end) end).() end)
        |> Enum.map(fn ({x, _y}) -> String.to_integer(x) end)
        |> Enum.sum()
  end

  def gears(threeLines) do
    numberLocations = threeLines |> Enum.filter(&is_bitstring/1)
      |> Enum.map(fn planLine -> Enum.zip(Regex.scan(~r/\d+/, planLine, capture: :all) |> List.flatten(),
      Regex.scan(~r/\d+/, planLine, return: :index) |> List.flatten()) end)
      |> List.flatten()
    locationSigns = Enum.zip(Regex.scan(~r/\*/, Enum.at(threeLines, 1), capture: :all) |> List.flatten(),
      Regex.scan(~r/\*/, Enum.at(threeLines, 1), return: :index) |> List.flatten())
      |> Enum.map(fn ({_x, y}) -> y |> (fn ({m, _n}) -> m end).() end)
    locationSigns |> Enum.map(fn location -> numberLocations
        |> Enum.filter(fn ({_k, m}) -> m |> (fn ({x, z}) -> location >= (x - 1) && location <= (x + z) end).() end)
        |> Enum.map(fn ({x, _y}) -> String.to_integer(x) end) end)
      |> Enum.filter(fn numbers -> length(numbers) == 2 end)
      |> Enum.map(&Enum.product/1)
      |> Enum.sum()
  end

end
