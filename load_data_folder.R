# Load everything in Data 

list.files("data")

for(i in list.files("data")){
  
  if(grepl(".csv", i, fixed = TRUE)){
    assign(x = gsub(".csv","", i, fixed = TRUE),
           value = read.csv(paste0("data/",i), row.names = NULL)  
    )
  } else if(grepl(".json", i, fixed = TRUE)){ 
    assign(x = gsub(".json", "", i, fixed = TRUE),
           value = jsonlite::fromJSON(paste0("data/", i))
    )
  }
}

rm(i)
