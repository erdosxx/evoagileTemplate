import {{PRJ_NAME}}.sampleGraph as sg

import Plots as pl
import GLMakie as gm
import Distributions as dt

pl.gr() # Headless-friendly backend
dest_dir = "docs/src/assets/"

gm.save(dest_dir * "gm_basic_line_plot.png", sg.gm_basic_line_plot())
gm.save(dest_dir * "gm_scatter_plot.png", sg.gm_scatter_plot())
gm.save(dest_dir * "gm_multiple_series_plot.png", sg.gm_multiple_series_plot())
gm.save(dest_dir * "gm_heatmap_plot.png", sg.gm_heatmap_plot())
gm.save(dest_dir * "gm_bar_plot.png", sg.gm_bar_plot())
gm.save(dest_dir * "gm_histogram_plot.png", sg.gm_histogram_plot())
gm.save(dest_dir * "gm_subplots_plot.png", sg.gm_subplots_plot())

pl.savefig(sg.pl_basic_line_plot(), dest_dir * "pl_basic_line_plot.png")
pl.savefig(sg.pl_scatter_plot(), dest_dir * "pl_scatter_plot.png")
pl.savefig(sg.pl_multiple_series_plot(), dest_dir * "pl_multiple_series_plot.png")
pl.savefig(sg.pl_customized_plot(), dest_dir * "pl_customized_plot.png")
pl.savefig(sg.pl_heatmap_plot(), dest_dir * "pl_heatmap_plot.png")
pl.savefig(sg.pl_bar_plot(), dest_dir * "pl_bar_plot.png")
pl.savefig(sg.pl_histogram_plot(), dest_dir * "pl_histogram_plot.png")
pl.savefig(sg.pl_subplots_plot(), dest_dir * "pl_subplots_plot.png")
