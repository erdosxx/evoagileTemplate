module PkgUtil

import PkgTemplates as PT
using LibGit2
import Coverage as CV
using Pkg

# Generate GitHub repository with GitHubActions.
#
# To generate package,
# in the julia REPL
# julia> PkgUtil.genGithubRepo("evoagile", "repoName.jl", "~/localgit")
function genGithubRepo(userName::String, repoName::String, dir::String)
  templateGithub = PT.Template(;
    user = userName,
    dir = dir,
    julia = v"1.8",  # for [compat] section in Project.toml
    plugins = [
      # Use semantic version, See Julia Pattern book page 43.
      PT.ProjectFile(; version = v"1.0.0-DEV"),
      PT.License(; name = "MIT", path = nothing, destination = "LICENSE"),
      PT.Formatter(;
        file = joinpath(@__DIR__, ".JuliaFormatter.toml"), style = "sciml"),
      PT.Readme(;
        file = joinpath(@__DIR__, "README.md"),
        destination = "README.md",
        inline_badges = false
      ),
      PT.Git(;
        branch = LibGit2.getconfig("init.defaultBranch", "master"),
        ssh = true,
        jl = true,
        manifest = false,
        ignore = [".data"]
      ),
      PT.GitHubActions(;
        file = joinpath(@__DIR__, "CI.yml"),
        destination = "CI.yml",
        linux = true,
        osx = false,
        windows = false,
        x64 = true,
        x86 = false,
        coverage = true,
        extra_versions = ["1.8", "1.9", "1.10", "1.11", "nightly"]),
      PT.CompatHelper(; destination = "CompatHelper.yml", cron = "0 0 * * *"),
      PT.TagBot(;
        destination = "TagBot.yml",
        trigger = "JuliaTagBot",
        token = PT.Secret("GITHUB_TOKEN"),
        ssh = PT.Secret("DOCUMENTER_KEY"),
        ssh_password = nothing,
        changelog = nothing,
        changelog_ignore = nothing,
        gpg = nothing,
        gpg_password = nothing,
        registry = nothing,
        branches = nothing,
        dispatch = nothing,
        dispatch_delay = nothing),
      PT.Codecov(),
      PT.Documenter{PT.GitHubActions}(
        logo = PT.Logo(;
          light = joinpath(@__DIR__, "logo", "logo.png"),
          dark = joinpath(@__DIR__, "logo", "logo-dark.png")
        ),
        make_jl = joinpath(@__DIR__, "make.jlt"),
        index_md = joinpath(@__DIR__, "index.md")
      ),
      PT.Dependabot()
    ])
  PT.generate(templateGithub, repoName)
end

function covtest(target::String; coverage = true, test_args = String[])
  Pkg.test(target; coverage, julia_args = ["--inline=no"], test_args)
  if coverage
    CV.LCOV.writefile("lcov.info", CV.process_folder())
  end
end

function cleanup()
  CV.clean_folder(".")
end

end
