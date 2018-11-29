
<!-- README.md is generated from README.Rmd. Please edit that file and knit -->
bioRad <img src="man/figures/logo.png" align="right" alt="" width="120">
========================================================================

bioRad aims to provide standardized methods for extracting and reporting biological signals from weather radars. It includes functionality to inspect low‐level radar data, process these data into meaningful biological information on animal speeds and directions at different altitudes in the atmosphere, visualize these biological extractions, and calculate further summary statistics.

To get started, see:

-   [Dokter et al. (2018)](https://doi.org/10.1111/ecog.04028): a paper describing the package.
-   [bioRad vignette](https://adokter.github.io/bioRad/articles/bioRad.html): an introduction to bioRad's main functionalities.
-   [Function reference](https://adokter.github.io/bioRad/reference/index.html): an overview of all bioRad functions.

Installation
------------

You can install the released version of bioRad from [CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("bioRad") # Coming soon!
```

Alternatively, you can install the latest development version from [GitHub](https://github.com/adokter/bioRad) with:

``` r
devtools::install_github("adokter/bioRad")
```

Then load the package with:

``` r
library(bioRad)
#> Welcome to bioRad version 0.3.0.9166
#> Docker daemon running, Docker functionality enabled.
```

### *Attention!*

Google has [recently changed its API requirements](https://developers.google.com/maps/documentation/geocoding/usage-and-billing), and \*\*ggmap\*\_\_\*\* - the package used by bioRad to overlay radar scans on maps - now requires users to provide an API key *and* enable billing in order to use Google imagery. bioRad switched to using [stamen](http://maps.stamen.com/) maps by default, which do not require special credentials.

**ggmap** itself is outdated on CRAN; its developers hope to have the new version up on CRAN soon, but until then, see [ggmap Github page](https://github.com/dkahle/ggmap/) for how to install the latest development version.

### Docker (optional)

You only need to install Docker to:

-   Read [NEXRAD radar data](https://www.ncdc.noaa.gov/data-access/radar-data) with `read_pvolfile()`. Docker is not required for reading ODIM radar data.
-   Convert NEXRAD radar data to ODIM format with `nexrad_to_odim()`.
-   Process radar data into vertical profiles of biological targets with `calculate_vp()`.

Why? bioRad makes use of a [C implementation of the vol2bird](https://github.com/adokter/vol2bird) algorithm through [Docker](https://www.docker.com/) to do the above. All other bioRad functions will work without a Docker installation. <details> <summary><strong>Installing Docker</strong></summary>

1.  Go to [Docker Desktop](https://www.docker.com/products/docker-desktop).
2.  Download Docker for Windows or Mac (free login required) and follow the installation instructions. Note that Docker for Windows requires Microsoft Windows 10 Professional or Enterprise 64-bit. Installing Docker Toolbox for previous versions will *not* work.
3.  Open the Docker application. The Docker (whale) icon will appear in your menu bar and indicate if it is running correctly.
4.  In R do `check_docker()`.
5.  You can now use the bioRad functionality that requires Docker. </details>

Usage
-----

### Radar data example

bioRad can read weather radar data (= polar volumes) in the [`ODIM`](http://eumetnet.eu/wp-content/uploads/2017/01/OPERA_hdf_description_2014.pdf) format and formats supported by the [RSL library](http://trmm-fc.gsfc.nasa.gov/trmm_gv/software/rsl/), such as NEXRAD data. NEXRAD data (US) are [available as open data](https://www.ncdc.noaa.gov/data-access/radar-data/nexrad) and on [AWS](https://registry.opendata.aws/noaa-nexrad/).

Here we read an example polar volume data file with `read_pvolfile()`, extract the scan/sweep at elevation angle 3 with `get_scan()`, project the data to a plan position indicator with `project_as_ppi()` and plot the *radial velocity* of detected targets with `plot()`:

``` r
library(tidyverse) # To pipe %>% the steps below
system.file("extdata", "volume.h5", package = "bioRad") %>%
  read_pvolfile() %>%
  get_scan(3) %>%
  project_as_ppi() %>%
  plot(param = "VRADH") # VRADH = radial velocity in m/s
```

<img src="man/figures/README-plot_ppi-1.png" width="100%" />

*Radial velocities towards the radar are negative, while radial velocities away from the radar are positive, so in this plot there is movement from the top right to the bottom left.*

### Vertical profile data example

Weather radar data can be processed into vertical profiles of biological targets using `calculate_vp()`. This type of data is [available as open data](https://enram.github.io/data-repository) for over 100 European weather radars.

Once vertical profile data are loaded into bioRad, these can be bound into time series using `bind_into_vpts()`. Here we read an example time series, project it on a regular time grid with `regularize_vpts()` and plot it with `plot()`:

``` r
example_vpts %>%
  regularize_vpts() %>%
  plot()
#> projecting on 300 seconds interval grid...
```

<img src="man/figures/README-plot_vpts-1.png" width="100%" />

*The gray bars in the plot indicate gaps in the data.*

The altitudes in the profile can be integrated with `integrate_profile()` resulting in a dataframe with rows for datetimes and columns for quantities. Here we plot the quantity *migration traffic rate* (column `mtr`) with `plot()`:

``` r
my_vpi <- integrate_profile(example_vpts)

plot(my_vpi, quantity = "mtr") # mtr = migration traffic rate
```

<img src="man/figures/README-plot_vpi-1.png" width="100%" />

To know the total number of birds passing over the radar during the full time series, we use the last value of the *cumulative migration traffic* (column `mt`):

``` r
my_vpi %>%
  pull(mt) %>% # Extract column mt as a vector
  last()
#> [1] 173023.8
```

For more exercises, see [this tutorial](https://adokter.github.io/bioRad/articles/functionality_overview.html).

Meta
----

-   We welcome [contributions](.github/CONTRIBUTING.md) including bug reports.
-   License: MIT
-   Get citation information for `bioRad` in R doing `citation(package = "bioRad")`.
-   Please note that this project is released with a [Contributor Code of Conduct](.github/CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.
