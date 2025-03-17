"""
  sampleMod

Show some exmple function to test.

"""
module sampleMod

"""
    addone(x, y=1)

Compute plus `x` and `y`.

If `y` is unspecified, compute add by 1 using default `y` value as 1.

# Examples
```jldoctest
julia> addone(1)
2
```

# Arguments
- `x::Integer`: first number to add.
- `y::Integer=1`: second number to add.
"""
function addone(x::Int, y::Int = 1)
  return x + y
end

function uncovered_add(a::Int)
  return a + 2
end

end
