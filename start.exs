# Simple IO
IO.puts "Bam! Elixir is in da house!"
IO.puts ""

# Types
IO.puts true
IO.puts :atom
IO.puts true == :true # booleans are actually atoms
IO.puts 1
IO.puts 0x1f # or 0x1F
IO.puts 0b11111
IO.puts 0o37
IO.puts 6.28
IO.inspect [0, 1, 2, :mixed, "types"] # lists
IO.inspect {:tuple, "values", 0} # tuples

# Anonymous functions & closures
add = fn a -> (fn b -> a + b end) end
inc = add.(1)

IO.puts inc.(0)
IO.puts inc.(1)
IO.puts inc.(2)

# Function shorthand & capturing functions
square = &(&1 * &1)
puts = &IO.puts/1

puts.(square.(12))

# Lists (linked lists)

ls = [0, 1, 2]

IO.puts length(ls)
IO.inspect hd(ls) # head
IO.inspect tl(ls) # tail

# Tuples

tp = {:zero, 1, "two"}

IO.puts elem(tp, 0)

tp2 = put_elem(tp, 1, :one)

IO.puts elem(tp, 1)
IO.puts tuple_size(tp)
