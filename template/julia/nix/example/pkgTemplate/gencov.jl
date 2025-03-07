include("PkgUtil.jl")

if length(ARGS) >= 1
  pkgname = ARGS[1]
  PkgUtil.covtest(pkgname; coverage = true)
else
  println("Usage: julia gencov.jl <pkgname>")
end
