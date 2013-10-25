Odonata trait data
==================
This repository contains the odonata trait data that are held within the Biological Records 
Centre (BRC). The scripts in this repository can be used to produce an overview of the odonata 
trait data measurements. Additionally, we have uploaded a script that combines the trait 
measurement data to the single value per trait data set.


Overview of the trait measurements 
==================================
This script (odonata_trait_summary.R) acts a simple tutorial for gaining a quick overview of the 
odonata trait measurements held within the Biological Records Centre (BRC).


Trait summaries
---------------
First, we need to ensure R is clear, add the trait data and install and load the *lattice* 
and *reshape2* packages:

```s
rm(list=ls()) # clear R
Odo_data <- read.csv(paste0(getwd(),"/Data/Species_trait_measurements.csv"),header=T) 
# install.packages("lattice")
# install.packages("reshape2")
library("lattice")
library("reshape2")
```

Next, we want to create a series of box plots that summarises the trait measurement data. We may
want to produce species specific trait summaries or a summary across all species. We have written
a simple function where the users specifies name of the species they want a trait summary for: 
```s
trait_summary(x="Anax imperator")
```

or alternatively the user can specify all species:
```s
trait_summary()
```

A list of the 37 species that we have trait data for can be extracted from the species column:
```s
levels(Odo_data$Species)
```

We use the *bwplot* from *lattice* to produced the panelled box plots.  The first step in the 
function drops unused columns.  Next, the *melt* function is used to reshape the data to fit 
the format required by *lattice*. We specify the factors that will be used to produce the box 
plots as *trait.f* and *Sex.f*. *trait.f* is the trait factor, we use *labels* to give sensible 
names to the traits.  Similarly we give sensible labels to the sex trait, *Sex.f*:
```s
trait_summary <- function(x="all_species") {
  if(x=="all_species"){
    temp_data <- Odo_data
  } else {
    temp_data <- Odo_data[Odo_data$Species==x,]
  }
  
  # prepare data
  temp_data <- temp_data[,c(6:length(temp_data))]
  Odo <- melt(temp_data, id=c("Species", "Sex"), na.rm=TRUE)
  
  # create factors with value labels
  trait.f <- factor(Odo$variable,levels=names(temp_data)[3:13],
    labels=c("Thorax length","Thorax width","Thorax depth","L forewing length","L forewing width",
              "L hindwing length","L hindwing width","R forewing length","R forewing width",
              "R hindwing length","R hindwing width"))
  Sex.f <- factor(Odo$Sex,levels=c("f","m"),
    labels=c("Female","Male"))

  # identify y axis limits
  T_max <- ceiling(max(Odo[Odo$variable=="thorax_length"|Odo$variable=="thorax_width"|Odo$variable=="thorax_depth","value"]))
  T_min <- floor(min(Odo[Odo$variable=="thorax_length"|Odo$variable=="thorax_width"|Odo$variable=="thorax_depth","value"]))
  WL_max <- ceiling(max(Odo[Odo$variable=="left_forewing_length"|Odo$variable=="left_hindwing_length"|
                  Odo$variable=="right_forewing_length"|Odo$variable=="right_forewing_length","value"]))
  WL_min <- floor(min(Odo[Odo$variable=="left_forewing_length"|Odo$variable=="left_hindwing_length"|
                  Odo$variable=="right_forewing_length"|Odo$variable=="right_forewing_length","value"]))
  WD_max <- ceiling(max(Odo[Odo$variable=="left_forewing_width"|Odo$variable=="left_hindwing_width"|
                  Odo$variable=="right_forewing_width"|Odo$variable=="right_forewing_width","value"]))
  WD_min <- floor(min(Odo[Odo$variable=="left_forewing_width"|Odo$variable=="left_hindwing_width"|
                  Odo$variable=="right_forewing_width"|Odo$variable=="right_forewing_width","value"]))
  
  
  # produce the panelled box plots
  bwplot(Odo$value~Sex.f|trait.f,
    ylab=list("Value (mm)",cex=1.3), 
    xlab=list("Sex",cex=1.3),
    ylim=list(c(T_min,T_max),c(T_min,T_max),c(T_min,T_max),
              c(WL_min,WL_max),c(WD_min,WD_max),c(WL_min,WL_max),c(WD_min,WD_max),
              c(WL_min,WL_max),c(WD_min,WD_max),c(WL_min,WL_max),c(WD_min,WD_max)),
    main=list("Trait summary",cex=1.5),
    par.strip.text=list(cex=0.9),
    scales = list(y = list(relation = "free")),
    index.cond=list(c(4,8,6,10,5,9,7,11,1,2,3)),
    layout=(c(4,3))
    )  
}
```

### Examples
#### Trait summary across all species
```s
trait_summary()
```
![ScreenShot](https://raw.github.com/BiologicalRecordsCentre/Odonata_traits/blob/master/Images/All_species_trait_summary.jpg)

#### Trait summary for *Anax imperator*
```s
trait_summary(x="Anax imperator")
```
![ScreenShot](https://raw.github.com/BiologicalRecordsCentre/Odonata_traits/blob/master/Images/Anax_imperator_trait_summary.jpg)
