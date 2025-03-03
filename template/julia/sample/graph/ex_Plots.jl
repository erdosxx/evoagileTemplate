using Plots

function basic_line_plot()
  x = range(0, 10, length=100)
  y = sin.(x)
  plot(x, y, label="sin(x)")
end

function scatter_plot()
  x = 1:10
  y = rand(10)
  scatter(x, y, label="Random Points")
end

function multiple_series_plot()
  x = 0:0.1:2π
  plot(x, [sin.(x), cos.(x)], label=["sin" "cos"])
end

function customized_plot()
  x = range(0, 2π, length=100)
  y = sin.(x)
  plot(x, y,
    title="Sine Wave",
    xlabel="x",
    ylabel="sin(x)",
    lw=2,
    color=:blue,
    legend=false)
end

function heatmap_plot()
  A = rand(10, 10)
  heatmap(A, c=:viridis)
end

function bar_plot()
  categories = ["A", "B", "C", "D"]
  values = [15, 25, 10, 30]
  bar(categories, values, legend=false)
end

function histogram_plot()
  data = randn(1000)
  histogram(data, bins=30, normalize=:pdf)
end

function subplots_plot()
  p1 = plot(rand(10))
  p2 = scatter(rand(10))
  p3 = bar(rand(10))
  p4 = histogram(randn(1000))
  plot(p1, p2, p3, p4, layout=(2, 2), size=(800, 600))
end

basic_line_plot()
scatter_plot()
multiple_series_plot()
customized_plot()
heatmap_plot()
bar_plot()
histogram_plot()
subplots_plot()
