source('3_visualize/src/save_lc_img_gif.R')
source('3_visualize/src/raster_plotting_w_ggplot.R')
source('3_visualize/src/lc_levelplot.R')
source('3_visualize/src/bar_plot.R')

p3_targets_list<- list(

  # Plotting
  tar_target(
    p3_gif_years,
    c('1900','1910','1920','1930','1940','1950','1960','1970','1980','1990','2001','2011','2019')
  ),
  # jsut forsce
  tar_target(
    p3_gif_years_FOR,
    c('1900','1910','1920','1930','1940','1950','1960','1970','1980','1990','2000','2010','2020')
  ),
    tar_target(
    # this seems sort of weird, it's to be able to set the x-axis limits for the stacked bar without getting mapped
    p3_all_years, 
    p3_gif_years
  ),
  tar_target(
    # this seems sort of weird, it's to be able to set the x-axis limits for the stacked bar without getting mapped
    p3_all_years_FOR, 
    p3_gif_years_FOR
  ),
  # Plot land cover through time   - this takes the most time ( over 30 min)
  ## Land cover maps
  tar_target(
    p3_lc_map_fp,
    plot_raster_map(
      year = p3_gif_years,
      raster_df = p2_lc_df_list,
      reach_shp = p1_streams_polylines_drb,
      extent_map = p1_drb_extent,
      legend_df = legend_df,
      out_folder = '3_visualize/out/map/'),
    pattern = map(p2_lc_df_list, p3_gif_years),
    format = 'file'
  ),
  # backcasted and future scenarios
  tar_target(
    p3_lc_map_fp_FOR,
    plot_raster_map(
      year = p3_gif_years_FOR,
      raster_df = p2_lc_df_list_FOR,
      reach_shp = p1_streams_polylines_drb,
      extent_map = p1_drb_extent,
      legend_df = legend_df,
      out_folder = '3_visualize/out/map/'),
    pattern = map(p2_lc_df_list_FOR, p3_gif_years_FOR),
    format = 'file'
  ),
  ## Land cover chart
  tar_target(
    p3_lc_chart,
    plot_lc_chart(
      counts =  p2_count_ordered,
      legend_df = legend_df,
      years = p3_all_years, 
      chart_year = p3_gif_years),
    pattern = map(p2_lc_df_list, p3_gif_years)
  ),
  tar_target(
    p3_lc_chart_FOR,
    plot_lc_chart(
      counts = p2_count_ordered_FOR,
      legend_df = legend_df,
      years = p3_all_years_FOR, 
      chart_year = p3_gif_years_FOR),
    pattern = map(p2_lc_df_list_FOR, p3_gif_years_FOR)
  ),
  # Combine chart elements
  tar_target(
    p3_compose_frames,
    compose_lc_frames(
      lc_map_fp = p3_lc_map_fp,
      lc_chart = p3_lc_chart,
      frame_year = p3_gif_years,
      font_fam = "Dongle",
      out_folder = '3_visualize/out/frames/',
      title = "Land cover change in the Delaware River Basin",
      sub_text = 'Reconstructed timeseries made using modeled historical\nlandscapes from the USGS FORE-SCE model (1900-1990) and\nthe National Land Cover Database (2001, 2011, 2019).',
      legend_df
      ),
    pattern = map(p3_lc_map_fp, p3_lc_chart, p3_gif_years),
    format = 'file'
  ),
  tar_target(
    p3_compose_frames_FOR,
    compose_lc_frames(
      lc_map_fp = p3_lc_map_fp_FOR,
      lc_chart = p3_lc_chart_FOR,
      frame_year = p3_gif_years_FOR,
      font_fam = "Dongle",
      out_folder = '3_visualize/out/frames/',
      title = "Land cover change in the Delaware River Basin",
      sub_text = 'Reconstructed timeseries made using modeled historical\nlandscapes from the USGS FORE-SCE model.\nData: doi.org/10.5066/P93J4Z2W',
      legend_df
    ),
    pattern = map(p3_lc_map_fp_FOR, p3_lc_chart_FOR, p3_gif_years_FOR),
    format = 'file'
  ),

  # Animation
  ## create gif
  tar_target(
    p3_land_cover_gif,
    animate_frames_gif(frames = p3_compose_frames,
                       out_file = paste0('3_visualize/out/gifs/drb_land_cover.gif'),
                       reduce = FALSE, frame_delay_cs = 100),
    format = 'file'
  ),
  # JUST FOR 
  tar_target(
    p3_extra_frame,
    c(p3_compose_frames_FOR[length(p3_compose_frames_FOR)], p3_compose_frames_FOR)
  ),
  tar_target(
    p3_land_cover_gif_FOR,
    animate_frames_gif(frames = p3_extra_frame,
                       out_file = paste0('3_visualize/out/gifs/drb_land_cover_FOR.gif'),
                       reduce = FALSE, frame_delay_cs = 100),
    format = 'file'
  ),
  tar_target(
    p3_sankey,
    plot_sankey(p2_long_sankey)
  )
)
