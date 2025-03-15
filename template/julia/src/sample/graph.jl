module sampleGraph

import GLMakie as gm
import Plots as pl

"""
    gm_basic_line_plot()

GLMakie basic line plot example.

![GLMakie basic line plot](assets/gm_basic_line_plot.png)
"""
function gm_basic_line_plot()
  x = range(0, 10, length = 100)
  y = sin.(x)
  gm.lines(x, y, label = "sin(x)")
end

"""
    gm_scatter_plot()

GLMakie scatter plot example.

![GLMakie scatter plot](assets/gm_scatter_plot.png)
"""
function gm_scatter_plot()
  x = 1:10
  y = rand(10)
  gm.scatter(x, y, label = "Random Points")
end

"""
    gm_multiple_series_plot()

GLMakie multiple series plot example.

![GLMakie multiple series plot](assets/gm_multiple_series_plot.png)
"""
function gm_multiple_series_plot()
  fig = gm.Figure()
  ax = gm.Axis(fig[1, 1])
  x = 0:0.1:(2π)
  gm.lines!(ax, x, sin.(x), label = "sin")
  gm.lines!(ax, x, cos.(x), label = "cos")
  gm.axislegend()
  return fig
end

"""
    gm_heatmap_plot()

GLMakie heatmap plot example.

![GLMakie heatmap plot](assets/gm_heatmap_plot.png)
"""
function gm_heatmap_plot()
  A = rand(10, 10)
  gm.heatmap(A, colormap = :viridis)
end

"""
    gm_bar_plot()

GLMakie bar plot example.

![GLMakie bar plot](assets/gm_bar_plot.png)
"""
function gm_bar_plot()
  tbl = (cat = [1, 1, 1, 2, 2, 2, 3, 3, 3],
    height = 0.1:0.1:0.9,
    grp = [1, 2, 3, 1, 2, 3, 1, 2, 3],
    grp1 = [1, 2, 2, 1, 1, 2, 1, 1, 2],
    grp2 = [1, 1, 2, 1, 2, 1, 1, 2, 1]
  )

  gm.barplot(tbl.cat, tbl.height,
    stack = tbl.grp,
    color = tbl.grp,
    axis = (xticks = (1:3, ["left", "middle", "right"]),
      title = "Stacked bars")
  )
end

"""
    gm_histogram_plot()

GLMakie historgram plot example.

![GLMakie histogram plot](assets/gm_histogram_plot.png)
"""
function gm_histogram_plot()
  data = randn(1000)
  gm.hist(data, bins = 30, normalization = :pdf)
end

"""
    gm_subplots_plot()

GLMakie subplots plot example.

![GLMakie subplots plot](assets/gm_subplots_plot.png)
"""
function gm_subplots_plot()
  fig = gm.Figure(size = (800, 600))
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

"""
    pl_basic_line_plot()

Plots basic line plot example.

![Plots basic line plot](assets/pl_basic_line_plot.png)
"""
function pl_basic_line_plot()
  x = range(0, 10, length = 100)
  y = sin.(x)
  pl.plot(x, y, label = "sin(x)")
end

"""
    pl_scatter_plot()

Plots scatter plot example.

![Plots scatter plot](assets/pl_scatter_plot.png)
"""
function pl_scatter_plot()
  x = 1:10
  y = rand(10)
  pl.scatter(x, y, label = "Random Points")
end

"""
    pl_multiple_series_plot()

Plots multiple series plot example.

![Plots multiple series plot](assets/pl_multiple_series_plot.png)
"""
function pl_multiple_series_plot()
  x = 0:0.1:(2π)
  pl.plot(x, [sin.(x), cos.(x)], label = ["sin" "cos"])
end

"""
    pl_customized_plot()

Plots customized plot example.

![Plots customized plot](assets/pl_customized_plot.png)
"""
function pl_customized_plot()
  x = range(0, 2π, length = 100)
  y = sin.(x)
  pl.plot(x, y,
    title = "Sine Wave",
    xlabel = "x",
    ylabel = "sin(x)",
    lw = 2,
    color = :blue,
    legend = false)
end

"""
    pl_heatmap_plot()

Plots heatmap plot example.

![Plots heatmap plot](assets/pl_heatmap_plot.png)
"""
function pl_heatmap_plot()
  A = rand(10, 10)
  pl.heatmap(A, c = :viridis)
end

"""
    pl_bar_plot()

Plots bar plot example.

![Plots bar plot](assets/pl_bar_plot.png)
"""
function pl_bar_plot()
  categories = ["A", "B", "C", "D"]
  values = [15, 25, 10, 30]
  pl.bar(categories, values, legend = false)
end

"""
    pl_historgram_plot()

Plots histogram plot example.

![Plots histogram plot](assets/pl_histogram_plot.png)
"""
function pl_histogram_plot()
  data = randn(1000)
  pl.histogram(data, bins = 30, normalize = :pdf)
end

"""
    pl_subplots_plot()

Plots subplots plot example.

![Plots subplots plot](assets/pl_subplots_plot.png)
"""
function pl_subplots_plot()
  p1 = pl.plot(rand(10))
  p2 = pl.scatter(rand(10))
  p3 = pl.bar(rand(10))
  p4 = pl.histogram(randn(1000))
  pl.plot(p1, p2, p3, p4, layout = (2, 2), size = (800, 600))
end

end
