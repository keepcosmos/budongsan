# data/source/molit 하위에 있는 국토교통부 실거래가 공개시스템에 개시된
# 월별 아파트(apt), 연립/다세대(rh), 단독/다가구(sh) 주택의 매매(trade)/전월세(rent) 정보를
# R data 파일로 변환한다.
# 국토교통부에서 제공하는 소스 파일은
# `data-raw/molit/{year}/{YYYYMM}.{주택 타입}.{거래종류}.xls` 로 존재하여야하며
# 결과는
# `data/molit.rt.{주택 타입}.{YYYYMM}` 으로 저장된다.

library(readxl)
library(stringr)
library(data.table)

molit.data.years = c(2006:2016)

molit.data.convertAllRTData <- function(){
  for(year in molit.data.years){
    molit.data.convertToAPTData(year)
    molit.data.convertToRHData(year)
    molit.data.convertToSHData(year)
  }
}

molit.data.convertToAPTData <- function(year){ molit.data.convertToData("apt", year) }
molit.data.convertToRHData <- function(year){ molit.data.convertToData("rh", year) }
molit.data.convertToSHData <- function(year){ molit.data.convertToData("sh", year) }

molit.data.convertToData <- function(type, year, pathPrefix = "data-raw/molit/"){
  if(!type %in% c("apt", "rh", "sh")) stop(paste(type, "must be one of 'apt', 'rh', 'sh'"))
  sourcePath <- paste0(pathPrefix, year, "/")
  sourceFiles <- list.files(sourcePath)
  targetFiles <- sourceFiles[grepl(paste0(".", type, "."), sourceFiles)]

  result <- data.table()

  for(target in targetFiles){
    month <- as.integer(substr(target, 5, 6))

    if(year < 2006) stop(paste(year, "must be greater than 2011, file name:", target))
    if(month > 12) stop(paste(month, "must be less than 12, file name:", target))

    targetPath <- targetPathes <- paste0(sourcePath, target)
    cat("converting", paste0("'", targetPath, "'"), "...\n")
    sheetNames <- excel_sheets(targetPath)
    for(sheet in sheetNames){
      sheetData <- data.table(read_excel(targetPath, sheet = sheet, skip = 7))
      if(nrow(sheetData) < 1){ next }
      sheetData[["계약년"]] <- year
      sheetData[["계약월"]] <- month
      result <- rbind(result, sheetData, fill=T)
    }
  }

  result <- molit.rt.cleaningColumnType(result)

  objectName <- paste0("molit.rt.", type, ".", year)
  cat("save to", objectName, "object\n")
  assign(objectName, result)
  savePath <- paste0("data/", objectName, ".rda")
  save(list=objectName, file = savePath)
}

molit.rt.cleaningColumnType <- function(data){
  trim <- function (x){ gsub("^\\s+|\\s+$", "", x) }
  convertMoneyToInteger <- function(x){ as.integer(gsub(",", "", x)) }
  colnames(data) <- trim(gsub("\\((.*?)\\)$", "", colnames(data)))

  # ISSUE: macOS unknown encoding issue
  Encoding(colnames(data)) <- 'latin1'
  Encoding(colnames(data)) <- 'UTF-8'

  colConvertors <- list(
    "시군구" = function(x){ as.factor(trim(x)) },
    "전용면적" = as.numeric,
    "대지권면적" = as.numeric,
    "연면적" = as.numeric,
    "대지면적" = as.numeric,
    "계약면적" = as.numeric,
    "주택유형" = as.factor,
    "계약년" = as.integer,
    "계약월" = as.integer,
    "계약일" = as.factor,
    "전월세구분" = function(x){
      x <- ifelse(is.na(x), "매매", x)
      Encoding(x) <- "UTF-8"
      as.factor(x)
    },
    "거래금액" = convertMoneyToInteger,
    "보증금" = convertMoneyToInteger,
    "월세" = function(x){ replace(convertMoneyToInteger(x), 0, NA) },
    "층" = as.integer,
    "건축년도" = as.integer,
    "도로명" = as.factor
  )
  for(col in colnames(data)){
    if(!is.null(colConvertors[[col]])){
      data[, eval(col) := colConvertors[[col]](data[[col]])]
    }
  }
  data
}
