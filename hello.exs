ExUnit.start

defmodule GettingToKnowElixir do
  use ExUnit.Case, async: true

  import ExUnit.CaptureIO

  test "io" do
    sentence = "Bam! It's Elixir!"
    expected = "#{sentence}\n" # string interpolation

    assert capture_io(fn -> IO.puts sentence end) == expected
  end

  test "types" do
    assert is_nil(nil)
    assert nil == :nil # nil is actually an atom
    assert is_atom(nil)

    assert is_boolean(true)
    assert is_boolean(false)

    assert is_atom(:atom)
    assert true == :true # booleans are actually atoms
    assert false == :false
    assert is_atom(true)
    assert is_atom(false)

    assert is_integer(1)
    assert is_number(1)
    refute is_float(1)

    assert is_integer(0x1f)
    assert 0x1f == 31
    assert is_integer(0x1F)
    assert 0x1F == 31

    assert is_integer(0b11111)
    assert 0b11111 == 31

    assert is_integer(0o37)
    assert 0o37 == 31

    assert is_float(6.28)
    assert is_number(6.28)
    refute is_integer(6.28)

    assert is_list([0, 1, 2, :mixed, "types"])

    assert is_tuple({:tuple, "values", 3})
  end

  test "boolean operators (strict and non-strict)" do
    # not, and, or are strict (only accept booleans)

    assert not false
    assert true and true
    assert false or true

    assert_raise ArgumentError, fn -> not 0 end
    assert_raise ArgumentError, fn -> 0 and true end
    assert_raise ArgumentError, fn -> nil or true end

    # !, && and || accept non-boolean values

    refute !0
    assert 0 && true
    assert nil || true

    # all values but nil and false are truthy

    refute nil
    refute false

    assert 0
    assert 0.0
    assert ""
    assert []
    assert {}
    assert fn -> false end
  end

  test "comparison operators (==, ===, <, ...)" do
    # === is more strict about types when comparing numbers

    assert 1 == 1.0
    refute 1 != 1.0

    refute 1 === 1.0
    assert 1 !== 1.0

    # all types are comparable (excerpt)

    assert 1 < "1"

    assert 999 < :a < (fn -> nil end) < {:a} < [:a]
  end

  test "anonymous functions & closures" do
    add = fn a -> (fn b -> a + b end) end
    inc = add.(1)

    assert inc.(0) == 1
    assert inc.(1) == 2
    assert inc.(2) == 3
  end

  test "function shorthand & capturing functions" do
    square = &(&1 * &1) # shorthand

    assert square.(12) == 144

    puts = &IO.puts/1 # capture

    assert capture_io(fn -> puts.(square.(13)) end) == "169\n"
    
    assert (fn a -> a > 0 end).(1) # immediately invoked function expression
  end

  test "lists" do
    ls = [0, 1, 1]

    assert length(ls) == 3
    assert hd(ls) == 0
    assert tl(ls) == [1, 1]
    assert (ls -- [1]) == [0, 1]
    assert (ls ++ [2]) == [0, 1, 1, 2]
    assert ((ls -- [1]) ++ [2]) == [0, 1, 2]
  end

  test "tuples" do
    tp = {:zero, 1, "two"}

    assert tuple_size(tp) == 3

    assert elem(tp, 0) == :zero
    assert elem(tp, 1) == 1
    assert elem(tp, 2) == "two"

    assert_raise ArgumentError, fn -> elem(tp, 3) end
    assert_raise ArgumentError, fn -> elem(tp, -1) end

    tp2 = put_elem(tp, 1, :one)

    assert tp2 != tp
    assert tp == {:zero, 1, "two"}
    assert tp2 == {:zero, :one, "two"}
  end
end
