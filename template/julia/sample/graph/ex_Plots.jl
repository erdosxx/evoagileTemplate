import Plots as pl

function pl_basic_line_plot()
  x = range(0, 10, length=100)
  y = sin.(x)
  pl.plot(x, y, label="sin(x)")
end

function pl_scatter_plot()
  x = 1:10
  y = rand(10)
  pl.scatter(x, y, label="Random Points")
end

function pl_multiple_series_plot()
  x = 0:0.1:2π
  pl.plot(x, [sin.(x), cos.(x)], label=["sin" "cos"])
end

function pl_customized_plot()
  x = range(0, 2π, length=100)
  y = sin.(x)
  pl.plot(x, y,
    title="Sine Wave",
    xlabel="x",
    ylabel="sin(x)",
    lw=2,
    color=:blue,
    legend=false)
end

function pl_heatmap_plot()
  A = rand(10, 10)
  pl.heatmap(A, c=:viridis)
end

function pl_bar_plot()
  categories = ["A", "B", "C", "D"]
  values = [15, 25, 10, 30]
  pl.bar(categories, values, legend=false)
end

function pl_histogram_plot()
  data = randn(1000)
  pl.histogram(data, bins=30, normalize=:pdf)
end

function pl_subplots_plot()
  p1 = pl.plot(rand(10))
  p2 = pl.scatter(rand(10))
  p3 = pl.bar(rand(10))
  p4 = pl.histogram(randn(1000))
  pl.plot(p1, p2, p3, p4, layout=(2, 2), size=(800, 600))
end

pl_basic_line_plot()
pl_scatter_plot()
pl_multiple_series_plot()
pl_customized_plot()
pl_heatmap_plot()
pl_bar_plot()
pl_histogram_plot()
pl_subplots_plot()
