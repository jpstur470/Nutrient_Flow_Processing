# For the N P flows project
#
# Load libraries and query GCAM output
# Jillian Sturtevant, August 2026

# Change
#  INSTALL_PACKAGES to TRUE to install required packages
#  QUERY_GCAM to TRUE to re-query GCAM output
#  PATH_TO_GCAM to change the path to GCAM output
#  FIGS_DIR to change figures sub-directory e.g., figures/v1, v2, etc.

# set bools
INSTALL_PACKAGES <- FALSE # set to TRUE to install required packages
QUERY_GCAM <- FALSE # set to TRUE to re-query GCAM output
FIGS_SAVE <- TRUE  # set to TRUE to save figures to FIGS_DIR

# install packages ----

if(INSTALL_PACKAGES){
  install.packages('ggplot2')
  install.packages('dplyr')
  install.packages('tidyr')
  install.packages('readr')
  install.packages('grid')
  install.packages('maps')
  install.packages("patchwork")
  install.packages("purrr")
  install.packages("ggtext")
  install.packages("egg")
  install.packages("scales")
  install.packages("ggrepel")
  install.packages('hrbrthemes')
  install.packages('ggspatial')
  install.packages('sf')

  install.packages("devtools")

  # install JGCRI packages from GitHub
  devtools::install_github("JGCRI/rgcam", build_vignettes = TRUE)
  devtools::install_github("JGCRI/rmap", build_vignettes = TRUE)
}

# load libraries ----
library(rgcam)
library(ggplot2)
library(dplyr)
library(tidyr)
library(readr)
library(grid)
library(maps)
library(patchwork)
library(rmap)
library(purrr)
library(ggtext)
library(egg)
library(scales)
library(ggrepel)
library(hrbrthemes)
library(rmap)
library(ggspatial)
library(sf)

# paths ----
OUTPUT_DATA_DIR <- "output_data/"
FIGS_DIR <- "figures/v1/" # change the subfolder here if desired
INPUT_DIR <- "input_data"

# create figs dir if it doesn't exist
if (!dir.exists(FIGS_DIR)) {
  dir.create(FIGS_DIR)
  paste0("Created directory: ", FIGS_DIR)
  }

# create output data dir if it doesn't exist
if (!dir.exists(OUTPUT_DATA_DIR)) {
  dir.create(OUTPUT_DATA_DIR)
  paste0("Created directory: ", OUTPUT_DATA_DIR)
}

# constants ----
CONV_USD_1975_2020 <- 3.8
CONV_KG_T <- 1000
H2_GJ_kg <- 0.1202
DAYS_PER_YEAR <- 365.25
CONV_PCAL_MCAL <- 1e9
CONV_NH3_N <- 14/17    # convert mass of NH3 to mass of N
ROUNDING_DIGITS <- 7    # number of decimals for data being written out. R's default is absurd (17 digits) but some values are quite small

HIST_YEARS <- c(1975, 1990, 2005, 2010, 2015, 2021, 2025)

# query GCAM ----
OUTPUTFILE <- "NPKflows.proj"

if (QUERY_GCAM) {
  # query variables
  PATH_TO_GCAM <- "output"

  SCENARIOS <- c("NPK_manure")

  QUERYFILE <- "BatchQueries_OTAQ_nutrients.xml"

  # query
  conn <- localDBConn(PATH_TO_GCAM, "database_basexdb")
  NPKflows_proj <- addScenario(conn, OUTPUTFILE, SCENARIOS, QUERYFILE, clobber = TRUE)
}

# load project ----
NPKflows_proj <- loadProject(OUTPUTFILE)


cat(paste("Queries:\n", paste(listQueries(NPKflows_proj), collapse = ", ")))
cat(paste("\nScenarios:\n", paste(listScenarios(NPKflows_proj), collapse = ", ")))
