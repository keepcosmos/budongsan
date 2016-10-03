# data/source/molit/montly 하위에 있는 국토교통부 실거래가 공개시스템에 개시된
# 월별 아파트(apt), 연립/다세대(rh), 단독/다가구(sh) 주택의 매매(trade)/전월세(rent) 정보를
# R data 파일로 변환한다.
# 국토교통부에서 제공하는 소스 파일은
# `data/source/molit/montly/{주택 타입}/{거래종류}.{YYYYMM}.xls` 로 존재하여야하며
# 결과는
# `data/{주택 타입}.{거래종류}.{YYYYMM}` 으로 저장된다.

library(readxl)
library(stringr)
library(data.table)

molit.data.convertToData <- function(year, month, pathPrefix = "data-raw/molit/monthly/"){
  year <- as.integer(year)
  month <- as.integer(month)
  if(year < 2016) stop(paste(year, "must be greater than 2016"))
  if(month > 12) stop(paste(month, "must be less than 12"))
  month <- str_pad(month, 2, pad = "0")

  filePrefix <- paste0(year, month)
  sourceFiles <- list.files(pathPrefix)
  targetPathes <- paste0(pathPrefix, sourceFiles[grepl(paste0("^", filePrefix), sourceFiles)])

  result <- data.table()

  for(target in targetPathes){
    type <- ifelse(grepl(".apt.", target), "아파트",
              ifelse(grepl(".rh.", target), "연립/다세대",
                ifelse(grepl(".sh.", target), "단독/다가구",
                  stop(paste(target, "is not supported file name."))
                )
              )
            )
    sheetNames <- excel_sheets(target)
    for(sheet in sheetNames){
      sheetData <- data.table(read_excel(target, sheet = sheet, skip = 7))
      sheetData$type <- type
      result <- rbind(result, sheetData, fill=T)
    }
  }
  result
}

molit.data.exists <- function(fileName, pathPrefix = "data/source/molit/monthly/"){

}
