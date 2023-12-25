defmodule Aoc2023 do
  @moduledoc """
  Documentation for `Aoc2023`.
    Main module dealing with the file parsing
  """

  def execute() do
    readFileLineByLine("./inputs/q1_p1.txt", &Trebutchet.trebutchetPart2/1)
    readFileLineByLine("./inputs/q1_p1.txt", &Trebutchet.trebutchet/1)
    readFileLineByLine("./inputs/q2.txt", &CubeConundrum.checkGame/1)
    readFileLineByLine("./inputs/q2.txt", &CubeConundrum.checkGamePart2/1)
  end

  @doc """
     reading the file and parsing it line by line
  """
  def readFileLineByLine(fileName, problemSolved) do
    file = File.open!(fileName, [:read, :utf8])

    IO.puts solve(:ok, file, problemSolved)

    File.close(file)
  end

  defp solve(:eof, _, _) do
    0
  end

  defp solve(current, file, problemSolved) do
    aLine = IO.read(file, :line)

    problemSolved.(aLine) + solve(aLine, file, problemSolved)
  end




end
