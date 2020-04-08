defmodule RpnTest do
  use ExUnit.Case
  doctest Rpn

  test "runs a simple calculation" do
    assert Rpn.calculate("1 2 +") == 3
  end
end
