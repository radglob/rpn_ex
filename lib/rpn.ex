defmodule Rpn do
  @moduledoc """
  Documentation for a reverse Polish notation calculator.
  """

  @doc """
  Calculation function. Takes a string of characters and runs the calculation.

  Raises an `InvalidSequenceError` if the sequence cannot be collapsed.

  ## Examples

      iex> Rpn.calculate("1 2 +")
      3

      iex> Rpn.calculate("+ 1 2")
      ** (RuntimeError) Invalid sequence

      iex> Rpn.calculate("1 2 -")
      -1

      iex> Rpn.calculate("1 2 + 3 *")
      9

      iex> Rpn.calculate("1 2 + 3 * 5 - 2 /")
      2

  """
  def calculate(seq \\ "") do
    seq
    |> parse()
    |> Enum.reduce([], &handle_token/2)
    |> List.first
  end

  @doc """
  Parser function. Splits a sequence string into a list of numbers and operators.

  ## Examples

      iex> Rpn.parse("1 2 +")
      [1, 2, "+"]

  """
  def parse(seq) do
    tokens = String.split(seq, " ")
    Enum.map(tokens, fn t ->
      if t =~ ~r/[0-9]+/ do
        String.to_integer(t)
      else
        t
      end
    end)
  end

  @doc """
  Takes a stack and a new token, and returns new stack.

  ## Examples
  
      iex> Rpn.handle_token(1, [])
      [1]
      
      iex> Rpn.handle_token("+", [])
      ** (RuntimeError) Invalid sequence

      iex> Rpn.handle_token("+", [1])
      ** (RuntimeError) Invalid sequence

      iex> Rpn.handle_token(2, [1])
      [1, 2]

      iex> Rpn.handle_token("+", [1, 2])
      [3]

  """
  def handle_token("+", stack) when length(stack) < 2, do: raise "Invalid sequence"
  def handle_token("+", stack) when length(stack) >= 2 do
    [right, left] = Enum.take(stack, -2)
    result = right + left
    Enum.drop(stack, -2) ++ [result]
  end
  def handle_token("-", stack) when length(stack) < 2, do: raise "Invalid sequence"
  def handle_token("-", stack) when length(stack) >= 2 do
    [right, left] = Enum.take(stack, -2)
    result = right - left
    Enum.drop(stack, -2) ++ [result]
  end
  def handle_token("*", stack) when length(stack) < 2, do: raise "Invalid sequence"
  def handle_token("*", stack) when length(stack) >= 2 do
    [right, left] = Enum.take(stack, -2)
    result = right * left
    Enum.drop(stack, -2) ++ [result]
  end
  def handle_token("/", stack) when length(stack) < 2, do: raise "Invalid sequence"
  def handle_token("/", stack) when length(stack) >= 2 do
    [right, left] = Enum.take(stack, -2)
    result = div(right, left)
    Enum.drop(stack, -2) ++ [result]
  end
  def handle_token(token, []), do: [token]
  def handle_token(token, stack), do: stack ++ [token]
end
