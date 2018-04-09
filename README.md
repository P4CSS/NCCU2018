# https://github.com/R4CSS/NCCU2018

* You can download course materials from two ways
  * Fork the NCCU2018 repository
  * Download whole R Project from the [link](https://www.dropbox.com/sh/ia3p7yg0wpibw4l/AADIOkHe53WzuCHTQzulPhzva?dl=0)
* [Course slides](https://drive.google.com/open?id=1t54qpJ1GmeY_NAoMAXqIYQ9xmjPxZr1u)
* [Review Videos](https://www.youtube.com/playlist?list=PLK0n8HKZQ_VfJcqBGlcAc0IKoY00mdF1B)

# Before class
* Be sure to open RStudio by clicking **RWorkshop.Rproj** inside the project folder.
* After opening the R project, click 0_install_pkg.R to install essential packages.

# Q&A
* Cannot see regular Chinese word in View panel
```{r}
Sys.setlocale(category = "LC_ALL", locale = "UTF-8")
Sys.setlocale(category = "LC_ALL", locale = "C") 
Sys.setlocale(category = "LC_ALL", locale = "cht") # for win
```
