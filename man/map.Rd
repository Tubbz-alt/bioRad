% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/map.R
\name{map}
\alias{map}
\alias{map.ppi}
\title{Map a plan position indicator (\code{ppi})}
\usage{
map(x, ...)

\method{map}{ppi}(
  x,
  map,
  param,
  alpha = 0.7,
  xlim,
  ylim,
  zlim = c(-20, 20),
  ratio,
  radar_size = 3,
  radar_color = "red",
  n_color = 1000,
  radar.size = 3,
  radar.color = "red",
  n.color = 1000,
  palette = NA,
  ...
)
}
\arguments{
\item{x}{An object of class \code{ppi}.}

\item{...}{Arguments passed to low level \link[ggmap]{ggmap} function.}

\item{map}{The basemap to use, result of a call to \link{download_basemap}.}

\item{param}{The scan parameter to plot.}

\item{alpha}{Transparency of the data, value between 0 and 1.}

\item{xlim}{Range of x values to plot (degrees longitude), as atomic
vector of length 2.}

\item{ylim}{Range of y values to plot (degrees latitude), as an atomic
vector of length 2.}

\item{zlim}{The range of values to plot.}

\item{ratio}{Aspect ratio between x and y scale, by default
\eqn{1/cos(latitude radar * pi/180)}.}

\item{radar_size}{Size of the symbol indicating the radar position.}

\item{radar_color}{Color of the symbol indicating the radar position.}

\item{n_color}{The number of colors (>=1) to be in the palette.}

\item{radar.size}{Deprecated argument, use radar_size instead.}

\item{radar.color}{Deprecated argument, use radar_color instead.}

\item{n.color}{Deprecated argument, use n_color instead.}

\item{palette}{(Optional) character vector of hexadecimal color values defining
the plot color scale, e.g. output from \link[viridisLite]{viridis}}
}
\value{
A ggmap object (a classed raster object with a bounding
box attribute).
}
\description{
Plot a ppi on a Stamen Maps, OpenStreetMap, Google Maps or Naver Map base
layer map using \link[ggmap]{ggmap}.
}
\details{
Available scan parameters for mapping can by printed to screen by
\code{summary(x)}. Commonly available parameters are:
\describe{
\item{"\code{DBZH}", "\code{DBZ}"}{(Logged) reflectivity factor (dBZ)}
\item{"\code{TH}", "\code{T}"}{(Logged) uncorrected reflectivity factor (dBZ)}
\item{"\code{VRADH}", "\code{VRAD}"}{Radial velocity (m/s). Radial
velocities towards the radar are negative, while radial velocities away
from the radar are positive}
\item{"\code{RHOHV}"}{Correlation coefficient (unitless) Correlation
between vertically polarized and horizontally polarized reflectivity factor}
\item{"\code{PHIDP}"}{Differential phase (degrees)}
\item{"\code{ZDR}"}{(Logged) differential reflectivity (dB)}
}
The scan parameters are named according to the OPERA data information
model (ODIM), see Table 16 in the
\href{https://github.com/adokter/vol2bird/blob/master/doc/OPERA2014_O4_ODIM_H5-v2.2.pdf}{ODIM specification}.
}
\section{Methods (by class)}{
\itemize{
\item \code{ppi}: plot a 'ppi' object on a map
}}

\examples{
# load an example scan:
data(example_scan)
# make ppi's for all scan parameters in the scan
ppi <- project_as_ppi(example_scan)
\dontrun{
# grab a basemap that matches the extent of the ppi:
# using a gray-scale basemap:
basemap <- download_basemap(ppi, maptype = "toner-lite")

# map the radial velocity scan parameter onto the basemap:
map(ppi, map = basemap, param = "VRADH")

# extend the plotting range of velocities, from -50 to 50 m/s:
map(ppi, map = basemap, param = "VRADH", zlim = c(-50, 50))

# map the reflectivity on a terrain basemap:
basemap <- download_basemap(ppi, maptype = "terrain")
map(ppi, map = basemap, param = "DBZH")

# change the color palette, e.g. Viridis colors:
map(ppi, map = basemap, param = "DBZH", palette = viridis::viridis(100), zlim=c(-10,10))

# give the data more transparency:
map(ppi, map = basemap, param = "DBZH", alpha = 0.3)

# change the appearance of the symbol indicating the radar location:
map(ppi, map = basemap, radar_size = 5, radar_color = "blue")

# crop the map:
map(ppi, map = basemap, xlim = c(12.4, 13.2), ylim = c(56, 56.5))
}
}
