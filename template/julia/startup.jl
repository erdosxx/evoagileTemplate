import Pkg

function install_package(pkg::String)
  if pkg == "REPLVim"
    @info "Installing $pkg..."
    @eval Pkg.add(url = "https://github.com/andreypopp/julia-repl-vim")
  else
    @eval Pkg.add($pkg)
  end
end

function load_package(pkg::String)
  pkg_s = Symbol(pkg)

  @eval using $pkg_s
  if pkg == "REPLVim"
    @eval @async $pkg_s.serve()
  end
end

function load_install_package(pkg::String)
  try
    load_package(pkg)
  catch e
    @info "Not installed $pkg"
    if isa(e, ArgumentError)
      install_package(pkg)
      load_package(pkg)
    else
      @warn "Error while checking $pkg" exception=(e, catch_backtrace())
    end
  end
end

# packages = ["REPLVim", "PkgTemplates", "LibGit2"]
packages = []

for pkg in packages
  load_install_package(pkg)
end

# To work with toggleterm
@eval OhMyREPL.enable_autocomplete_brackets(false)
