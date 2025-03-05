import GLMakie as gm

function gm_basic_line_plot()
  x = range(0, 10, length=100)
  y = sin.(x)
  gm.lines(x, y, label="sin(x)")
end

function gm_scatter_plot()
  x = 1:10
  y = rand(10)
  gm.scatter(x, y, label="Random Points")
end

function gm_multiple_series_plot()
  x = 0:0.1:2π
  gm.lines!(x, sin.(x), label="sin")
  gm.lines!(x, cos.(x), label="cos")
end

function gm_heatmap_plot()
  A = rand(10, 10)
  gm.heatmap(A, colormap=:viridis)
end

function gm_bar_plot()
  tbl = (cat=[1, 1, 1, 2, 2, 2, 3, 3, 3],
    height=0.1:0.1:0.9,
    grp=[1, 2, 3, 1, 2, 3, 1, 2, 3],
    grp1=[1, 2, 2, 1, 1, 2, 1, 1, 2],
    grp2=[1, 1, 2, 1, 2, 1, 1, 2, 1]
  )

  gm.barplot(tbl.cat, tbl.height,
    stack=tbl.grp,
    color=tbl.grp,
    axis=(xticks=(1:3, ["left", "middle", "right"]),
      title="Stacked bars"),
  )
end

function gm_histogram_plot()
  data = randn(1000)
  gm.hist(data, bins=30, normalization=:pdf)
end

function gm_subplots_plot()
  fig = gm.Figure(size=(800, 600))
  ax1 = gm.Axis(fig[1, 1])
  ax2 = gm.Axis(fig[1, 2])
  ax3 = gm.Axis(fig[2, 1])
  ax4 = gm.Axis(fig[2, 2])
  gm.lines!(ax1, rand(10))
  gm.scatter!(ax2, rand(10))
  gm.barplot!(ax3, 1:10, rand(10))
  gm.hist!(ax4, randn(1000))
  fig
end

gm_basic_line_plot()
gm_scatter_plot()
gm_multiple_series_plot()
gm_heatmap_plot()
gm_bar_plot()
gm_histogram_plot()
gm_subplots_plot()
