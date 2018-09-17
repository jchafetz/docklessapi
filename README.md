[![Build Status](https://travis-ci.org/achafetz/docklessapi.svg?branch=master)](https://travis-ci.org/achafetz/docklessapi)

# Dockless API
Aggregating dockless bike share data in Washington, DC from varying private dockless company's APIs (links can be found here: https://ddot.dc.gov/page/dockless-api). Data provides current location of available bikes in fleet. 

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

### Data Viz created off the data

![910911map2](https://user-images.githubusercontent.com/8933069/45558890-fc7e7900-b80e-11e8-902a-b15c07fbc557.gif)

![910911graph2](https://user-images.githubusercontent.com/8933069/45558895-ff796980-b80e-11e8-9667-370f3a097b68.gif)


If you experience any issues or have any suggestions, please [add a new issue](https://github.com/jchafetz/docklessapi/issues).
