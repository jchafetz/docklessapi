# Dockless API
Aggregating dockless bike share data in Washington, DC

### How to install

While many packages you use daily are on CRAN, additional packages can also be hosted on and installed from GitHub. You'll need to have a package called `devtools` which will then allow you to install this package.

```
install.packages("devtools")
devtools::install_github("jchafetz/docklessapi")
```
To ensure you have the latest version, you can always rerun devtools::install_github("jchafetz/docklessapi")


### Usage

This package is extremely easy to use and requires only one input from the user - where do you want to save your file? After loading the package, you can run this one line of code to retun a csv output containing the bike share company name, the vehicle type (bike/scooter), company's assigned bike ID, the coordinates(lat/long) and the	time of the pull.

```
library(docklessapi)

#pull currently available bikes, saved in R
  bikedata <- getDocklessdata()
  
#pull currently available bikes, saved as csv
  getDocklessdata("~/Documents/BikeData")
```

If you experience any issues or have any suggestions, please [add a new issue](https://github.com/jchafetz/docklessapi/issues).
