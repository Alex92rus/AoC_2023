defmodule ScratchCards do

  def solvePart1(:eof) do
    0
  end

  def solvePart1(aLine) do
    aLine |> String.split()
           |> Enum.slice(1..-1//1)
           |> Enum.frequencies
           |> Map.values
           |> Enum.filter(fn n -> n == 2 end)
           |> length
           |> (fn n -> if n > 0 do Integer.pow(2, n - 1) else 0 end end).()
   end


  def cardScore(aLine) do
    aLine |> String.split()
          |> Enum.slice(1..-1//1)
          |> Enum.frequencies
          |> Map.values
          |> Enum.filter(fn n -> n == 2 end)
          |> length
  end

  def solvePart2(:eof) do
    0
  end

  def solvePart2(scratchCards) do
    linesList = scratchCards |> String.split("\n")
       |> Enum.reverse
    lineValues = linesList |> Enum.map(&cardScore/1)
    Enum.reduce(lineValues, [0], fn x, acc -> if (x > 0) do [1 + (Enum.slice(acc,0..(x-1))|>Enum.sum)|acc] else [1 | acc] end end)
    |> Enum.sum
    # aLine |> String.split()
    #        |> Enum.slice(1..-1//1)
    #        |> Enum.frequencies
    #        |> Map.values
    #        |> Enum.filter(fn n -> n == 2 end)
    #        |> length
    #        |> (fn m -> if m + lineNo > 202 do (202 - lineNo) + 1 else m + 1 end end).()
   end
end
