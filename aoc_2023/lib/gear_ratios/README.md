# Aoc2023

## Solutions Gear Ratios Part 1

The input file for the 3rd problem in AoC 2023 Gear Ratios can be found in inputs/q3.txt

## Description

Here we have to find the sum of all numbers which border at least one sign, given a 2D plan as a text file. For the purpose of simplicity we consider a sign everything other than a dot (.) or a digit (0 to 9), in the input these are only signs like '*','$','+','%','#', '@', '=', '&'.

By 'borders' it is meant:

1. Vertically - on the next and the previous line
2. Horizontaly - just before or after the number
3. Diagonally - on the diagonal - just before or after the number on the next or the previous line

Consider the following sample:

```
..224.....487..
....*..........
.235...........
.........705%..
.....82........
```

Looking the numbers individually:

1. 224 boarders the '*' on line 2 vertically - 224 spans from index 2 to index 5 on line 1 and the '*' is on index 5 on line 2
2. 487 does not boarder any sign - only dots
3. 235 on line 3 boarders the same '*' on line 2 **diagonally** as the '*' is on index 4 and 235 spawns from index 1 to index 3 (first char on the line being at  index 0)
4. 705 boarders '%' horizontally - being appended to the number
5. 82 does not boarder any sign so we do not include it to the sum.


If our input is the above sample, the sum would have been:

```
224 + 235 + 705 = 1164
```

## Solution : Divide and Conquer

Consider a Divide and Conquer approach where we are to split the file and select the numbers to be included from each line **(Divide)**, prior to adding these to the sum **(Conquer)**

### Division Factor

How should we split the file?

It won't be enough to split it line by line as we need to consider the signs above and below each number to make the decision whether to include it or not - we would need to consider the previous and the next line as well.

1. Division Unit - the part of the input for which will derive each of the sub-solutions of the whole result
2. Division Fringe - the context of the input that is needed to determine the value of the solution for the division unit

For us the Division Unit is a single line and the Division Fringe is the line plus the line above and below. The **First** and the **Last** line would need only one additional line in the Fringe - only the next and only the previous respectively.


### Division in Elixir

The division bit is made by utilising the key advantage of Elixir - [distributed tasks in form of processes](https://engineering.intility.com/article/a-brief-introduction-to-elixir) view the brief introduction by Rolf Blindheim, where he talks about the background and scheduling in elixir.

For our task the code for the split is as follows:

```elixir
  def splitFilesonFunction(fileContents, solutionFunc) do
    fileContents |> String.split("\n", trim: true)
      |> (fn (xs,x) -> [x|xs] end).(:start) # prepend a start atom infront to form a triple
      |> Kernel.++([:end]) # append an end atom in the end to form the final triple
      |> Enum.chunk_every(3, 1, :discard) # rolling window of each three consequitive lines in the input
      |> Enum.map(fn n -> Task.async(fn -> solutionFunc.(n) end) end) # apply the sub solution function on each 3 lines
      |> Enum.map(&Task.await/1) # await for the tasks above to finish
      |> Enum.sum() # sum all of the sub solutions into the overall solution
  end
```

I could not find a more idiomatic way to put an item infront of the list, please do post if you know anything better than:

```elixir
  (fn (xs,x) -> [x|xs] end).(:start)
```

As you probably already spotted, the above function may be used to solve many problems that follow the same division strategy, I will use it on the further advent of code problems that follow the same division pattern. (We can further generalise with parametrising the chunking window size - here is 3 with the step of 1)

### Sub Solution

Then the remaining solution becomes easier - finding the locations of the signs **on the Division Fringe - all of the lines** and the number locations **on the Division Unit (middle line)** and then matching with the formula

```
number -> signIndex >= (locationStart - 1) && signIndex <= (locationStart + numberLength)
```

In the function itself, we first need to sanitize the input - removing the atmos and get the [graphemes](https://hexdocs.pm/elixir/1.12/String.html#graphemes/1) to derive the indexes:

```elixir
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
```

## Disclamer

This my solution of the AoC 2023 problem, using the power of the recent programing gem called Elexir. I combined my intorduction to Elixir with solving these problems. :rocket:
