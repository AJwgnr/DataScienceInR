

# Preprocesses the person dataset
preprocessedPersonData <- function(persons){
  persons[is.na(firstVR), "firstVR"] = -1
  persons[is.na(VE_Day2), "VE_Day2"] = -1
  
  #TODO:
  #REmove column "Differences_PartialNew" because of null values
  #Handle Null values in columns "VLMT_Dg1_5", "VLMT_Dg7", "VLMT_Dg5minusDg7","NV_total_Combined_SBB_FBB", "NV_total_Raw_SBB", "VE_Day2
  #Filter elements of column "Exclusion_Position_Data"
  #implement filtering and removing of bad data here
  return(persons)
}