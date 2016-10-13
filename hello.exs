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
    assert [0 | ls] == [0, 0, 1, 1]
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

  test "comparison operators (==, ===, <, ...)" do
    # === is more strict about types when comparing numbers

    assert 1 == 1.0
    refute 1 != 1.0

    refute 1 === 1.0
    assert 1 !== 1.0

    # all types are comparable (excerpt)

    assert 1 < "1"

    assert 0 < :nil < (fn -> nil end) < {nil} < [nil]
  end

  test "more term ordering" do
    assert :ni < :nil
    assert :nil < :nim

    assert "a" < "aa"
    assert "aa" < "ab"

    assert {0} < {nil}
    assert {0} < {0, 0}
    assert {0, 0} < {0, 1}

    assert [0] < [nil]
    assert [0] < [0, 0]
    assert [0, 0] < [0, 1]
  end

  test "match operator" do
    x = 1
    assert (1 = x) == 1
    assert_raise MatchError, fn -> 2 = x end
  end

  test "pattern matching" do
    {a, b, c} = {0, :one, "two"}

    assert a == 0
    assert b == :one
    assert c == "two"

    assert_raise MatchError, fn -> {x, y} = {0} end
    assert_raise MatchError, fn -> {x} = {0, 1} end
    assert_raise MatchError, fn -> {x} = [0, 1] end

    {:ok, d} = {:ok, 201}

    assert d == 201

    assert_raise MatchError, fn -> {:ok, x} = {:no, 500} end

    [e, f, g] = [3, :four, "five"]

    assert e == 3
    assert f == :four
    assert g == "five"

    assert_raise MatchError, fn -> [x, y] = [0] end
    assert_raise MatchError, fn -> [x] = [0, 1] end

    [h | t] = [1, 2, 3]

    assert h == 1
    assert t == [2, 3]

    [h | _] = [1, 2, 3] # ignore tail (_ cannot be read from)

    assert_raise MatchError, fn -> [x | y] = [] end

    {z, z} = {1, 1}
    assert z == 1

    assert_raise MatchError, fn -> {q, q} = {1, 2} end

    {r, _, _} = {0, 1, 2} # _ can match different values
    assert r == 0
  end

  test "nested pattern matching" do
    [[a, b], [c, d]] = [[1, 2], [3, 4]]

    assert a == 1
    assert b == 2
    assert c == 3
    assert d == 4
  end

  test "pin operator" do
    x = 1 # bind (variable on lhs)
    x = 2 # rebind

    assert_raise MatchError, fn -> 1 = x end # std. match (variable on rhs)
    assert_raise MatchError, fn -> ^x = 1 end # do not rebind, but match

    {^x, y} = {2, 3} # prevent rebinding of x, instead match {2, y} = {2, 3}
    assert y == 3

    assert_raise MatchError, fn -> {^x, z} = {0, 3} end
  end
end
