defmodule Trebutchet do
  def findFirstDigit(<<first::binary-size(1), rest::binary>>, destination) do
    cond do
      String.ends_with?(destination, ["1","one"]) -> 1
      String.ends_with?(destination, ["2", "two"]) -> 2
      String.ends_with?(destination, ["3", "three"]) -> 3
      String.ends_with?(destination, ["4", "four"]) -> 4
      String.ends_with?(destination, ["5", "five"]) -> 5
      String.ends_with?(destination, ["6", "six"]) -> 6
      String.ends_with?(destination, ["7", "seven"]) -> 7
      String.ends_with?(destination, ["8", "eight"]) -> 8
      String.ends_with?(destination, ["9", "nine"]) -> 9
      true -> findFirstDigit(rest, "#{destination}#{first}")
    end
  end

  def findFirstDigit("", _fullString), do: nil

  @spec findLastDigit(nonempty_binary(), binary()) :: nil | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9
  def findLastDigit(strLine, destination) do
    cond do
      String.starts_with?(destination, ["1","one"]) -> 1
      String.starts_with?(destination, ["2", "two"]) -> 2
      String.starts_with?(destination, ["3", "three"]) -> 3
      String.starts_with?(destination, ["4", "four"]) -> 4
      String.starts_with?(destination, ["5", "five"]) -> 5
      String.starts_with?(destination, ["6", "six"]) -> 6
      String.starts_with?(destination, ["7", "seven"]) -> 7
      String.starts_with?(destination, ["8", "eight"]) -> 8
      String.starts_with?(destination, ["9", "nine"]) -> 9
      true -> <<head::binary-size(byte_size(strLine) - 1), last::binary>> = strLine
              findLastDigit(head, "#{last}#{destination}")
    end
  end

  def trebutchetPart2(:eof) do
    0
  end

  def trebutchetPart2(aLine) do
    findFirstDigit(aLine, "") * 10 + findLastDigit(aLine, "")
  end

  def trebutchet(:eof) do
    0
  end

  def trebutchet(aLine) do
    digits = aLine |> String.replace(~r/[^\d]/, "")
    <<first::binary-size(1), _::binary>> = digits
    <<_::binary-size(byte_size(digits) - 1), last::binary-size(1)>> = digits
    Integer.parse(first) |>
    (fn {num, _} -> num * 10 end).() |>
    (fn n -> {num, _} = Integer.parse(last); n + num end).()
  end
end
