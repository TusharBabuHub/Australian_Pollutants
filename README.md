# Australian_Pollutants

 A revealjs presentation on Pollutant inventory of Australia created using **R MarkDown**
 
 Objective of this attempt is to create a dynamic slide presentation with no effort being put into updating metrics or the visualisation in case of data updates.
 
 The slides are technology agnostic and can be accessed via a browser. This is due to the presentation being an HTML file.


## Data Source

Australian Government's Pollution Inventory data : [National Pollutant Inventory](https://data.gov.au/dataset/ds-dga-043f58e0-a188-4458-b61c-04e5b540aea4/details)

Furthermore details can be found at:  [NPI](https://www.dcceew.gov.au/environment/protection/npi)

The data used in this draft is csv. Please download the csv files and place it in a folder named dataset. There is a provision of using API for data integration. My objective was to create a minimum viable product to showcase a dynamic and easy to update presentation. This can be updated in the future.


## Folder Structure

Finally, the folder structure should look something like this,

![1670883410046](image/README/1670883410046.png)

* code has source R files to run some computations to display visualisations
* images have files created for visuals
* dataset should have the source csv files
* libs contain revealjs and other libraries for the presentation
