include("PkgUtil.jl")

if length(ARGS) >= 2
  userName = ARGS[1]
  repoName = ARGS[2]
  dir = length(ARGS) >= 3 ? ARGS[3] : "~/localgit"
  PkgUtil.genGithubRepo(userName, repoName, dir)
else
  println("Usage: julia genprj.jl userName repoName [dir]")
end
