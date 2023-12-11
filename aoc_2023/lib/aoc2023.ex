defmodule Aoc2023 do
  @moduledoc """
  Documentation for `Aoc2023`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Aoc2023.hello()
      :world
  """
  def readFileLineByLine do
    file = File.open!("./inputs/q1_sample.txt", [:read, :utf8])

    IO.puts solve(:ok, file)

    File.close(file)
  end


  defp solve(:eof, _) do
    0
  end

  defp solve(current, file) do
    aLine = IO.read(file, :line)

    trebutchet(aLine) + solve(aLine, file)

  end

  defp trebutchet(:eof) do
    0
  end

  defp trebutchet(aLine) do
    digits = aLine |> String.replace(~r/[^\d]/, "")
    <<first::binary-size(1), _::binary>> = digits
    <<_::binary-size(byte_size(digits) - 1), last::binary-size(1)>> = digits
    Integer.parse(first) |>
    (fn {num, _} -> num * 10 end).() |>
    (fn n -> {num, _} = Integer.parse(last); n + num end).()
  end

end
