# list all files to be read
files <- list.files(pattern = ".*csv",
                    recursive = TRUE)

# read and create dataframe for each source
for (fl in files)
  assign(str_match(fl,
                   'dataset/(.*?).csv')[, 2],
         read_csv(fl))

# remove all except the dataframes loaded
rm(list = setdiff(ls(),
                  Filter(function(x)
                    is.data.frame(get(
                      x
                    )),
                    ls())))
