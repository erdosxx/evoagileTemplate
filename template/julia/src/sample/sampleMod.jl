module sampleMod

function addone(a::Int)
  return a + 1
end

function uncovered_add(a::Int)
  return a + 2
end

end
