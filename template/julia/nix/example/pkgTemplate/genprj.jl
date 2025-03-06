# genGithubRepo2(userName, repoName)
#
# Generate GitHub repository with GitHubActions.
#
# To generate package,
# in the julia REPL
# julia> genGithubRepo("evoagile", "repoName.jl", "~/localgit")

# using PkgTemplates: Template, ProjectFile, License, Git, GitHubActions
# using PkgTemplates: CompatHelper, TagBot, Codecov, Documenter, Logo
# using PkgTemplates: Dependabot, Secret, generate
using PkgTemplates
using LibGit2

function genGithubRepo2(userName::String, repoName::String, dir::String)
  templateGithub = Template(;
    user = userName,
    dir = dir,
    julia = v"1.8",  # for [compat] section in Project.toml
    plugins = [
      # Use semantic version, See Julia Pattern book page 43.
      ProjectFile(; version = v"1.0.0-DEV"),
      License(; name = "MIT", path = nothing, destination = "LICENSE"),
      Formatter(;
        file = joinpath(@__DIR__, ".JuliaFormatter.toml"), style = "sciml"),
      Git(;
        branch = LibGit2.getconfig("init.defaultBranch", "master"),
        ssh = true,
        jl = true,
        manifest = false,
        ignore = [".data"]
      ),
      GitHubActions(;
        destination = "CI.yml",
        linux = true,
        osx = false,
        windows = false,
        x64 = true,
        x86 = false,
        coverage = true,
        extra_versions = ["1.8", "1.9", "1.10", "1.11", "nightly"]),
      CompatHelper(; destination = "CompatHelper.yml", cron = "0 0 * * *"),
      TagBot(;
        destination = "TagBot.yml",
        trigger = "JuliaTagBot",
        token = Secret("GITHUB_TOKEN"),
        ssh = Secret("DOCUMENTER_KEY"),
        ssh_password = nothing,
        changelog = nothing,
        changelog_ignore = nothing,
        gpg = nothing,
        gpg_password = nothing,
        registry = nothing,
        branches = nothing,
        dispatch = nothing,
        dispatch_delay = nothing),
      Codecov(),
      Documenter{GitHubActions}(logo = Logo(;
        light = joinpath(@__DIR__, "logo", "logo.png"),
        dark = joinpath(@__DIR__, "logo", "logo-dark.png"))),
      # light="./logo/logo.png",
      # dark="./logo/logo-dark.png")),
      Dependabot()
    ])
  generate(templateGithub, repoName)
end

# genGithubRepo2("erdosxx", "TestJulia.jl", ".")
# Check if command-line arguments are provided
if length(ARGS) >= 2
  userName = ARGS[1]
  repoName = ARGS[2]
  dir = length(ARGS) >= 3 ? ARGS[3] : "~/localgit"
  genGithubRepo2(userName, repoName, dir)
else
  println("Usage: julia genprj.jl userName repoName [dir]")
end
