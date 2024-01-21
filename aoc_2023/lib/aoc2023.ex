defmodule Aoc2023 do
  @moduledoc """
  Documentation for `Aoc2023`.
    Main module dealing with the file parsing
  """

  def execute() do

    readFileLineByLine("./inputs/q1_p1.txt", &Trebutchet.trebutchetPart2/1, "Question 1 part 1: Trebuchet")
    readFileLineByLine("./inputs/q1_p1.txt", &Trebutchet.trebutchet/1, "Question 1 part 2: Trebuchet")
    readFileLineByLine("./inputs/q2.txt", &CubeConundrum.checkGame/1, "Question 2 part 1: Cube Condurum")
    readFileLineByLine("./inputs/q2.txt", &CubeConundrum.checkGamePart2/1, "Question 2 part 2: Cube Condurum")
    solveWithWholeFile("./inputs/q3.txt", &GearRatios.gearRatiosPart1/1, "Question 3 part 1: Gondola Parts")
    solveWithWholeFile("./inputs/q3.txt", &GearRatios.gearRatiosPart2/1, "Question 3 part 2: Gears")
    readFileLineByLine("./inputs/q4.txt", &ScratchCards.solvePart1/1, "Question 4 part 1: Scratch Cards")
    solveWithWholeFile("./inputs/q4.txt", &ScratchCards.solvePart2/1, "Question 4 part 2: Scratch Cards")
  end

  @doc """
     reading the file and parsing it line by line
  """
  def readFileLineByLine(fileName, problemSolved, description) do
    IO.puts description

    file = File.open!(fileName, [:read, :utf8])

    IO.puts solve(:ok, file, problemSolved)

    File.close(file)
  end

  defp solve(:eof, _, _) do
    0
  end

  defp solve(_current, file, problemSolved) do
    aLine = IO.read(file, :line)

    problemSolved.(aLine) + solve(aLine, file, problemSolved)
  end

  defp solveWithWholeFile(filename, problemSolved, description) do
    IO.puts description
    fileContents = File.read!(filename)
    IO.puts problemSolved.(fileContents)
  end




end
