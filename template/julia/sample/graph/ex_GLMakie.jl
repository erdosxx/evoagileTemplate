using GLMakie

function basic_line_plot()
  x = range(0, 10, length=100)
  y = sin.(x)
  lines(x, y, label="sin(x)")
end

function scatter_plot()
  x = 1:10
  y = rand(10)
  scatter(x, y, label="Random Points")
end

function multiple_series_plot()
  x = 0:0.1:2π
  lines!(x, sin.(x), label="sin")
  lines!(x, cos.(x), label="cos")
end

function heatmap_plot()
  A = rand(10, 10)
  heatmap(A, colormap=:viridis)
end

function bar_plot()
  tbl = (cat=[1, 1, 1, 2, 2, 2, 3, 3, 3],
    height=0.1:0.1:0.9,
    grp=[1, 2, 3, 1, 2, 3, 1, 2, 3],
    grp1=[1, 2, 2, 1, 1, 2, 1, 1, 2],
    grp2=[1, 1, 2, 1, 2, 1, 1, 2, 1]
  )

  barplot(tbl.cat, tbl.height,
    stack=tbl.grp,
    color=tbl.grp,
    axis=(xticks=(1:3, ["left", "middle", "right"]),
      title="Stacked bars"),
  )
end

function histogram_plot()
  data = randn(1000)
  hist(data, bins=30, normalization=:pdf)
end

function subplots_plot()
  fig = Figure(size=(800, 600))
  ax1 = Axis(fig[1, 1])
  ax2 = Axis(fig[1, 2])
  ax3 = Axis(fig[2, 1])
  ax4 = Axis(fig[2, 2])
  lines!(ax1, rand(10))
  scatter!(ax2, rand(10))
  barplot!(ax3, 1:10, rand(10))
  hist!(ax4, randn(1000))
  fig
end

basic_line_plot()
scatter_plot()
multiple_series_plot()
heatmap_plot()
bar_plot()
histogram_plot()
subplots_plot()
