#' molit.rt.apt
#'
#' Apartments Real Trading & Rent Datasets from 2006\cr
#' source from molit.go.kr\cr
#' \cr
#' Call 'molit.rt.apt.(year)'
#'
#' @name molit.rt.apt
#' @docType data
#' @author Jaehyun Shin \email{keepcosmos@gmail.com}
#' @references \url{http://rtdown.molit.go.kr}
#' @keywords datasets
#' @format Classes 'data.table' and 'data.frame'
'molit.rt.apt.2016'

#' molit.rt.rh
#'
#' Row houses(tenement house) Real Trading & Rent Datasets from 2006\cr
#' source from molit.go.kr\cr
#'
#' #' Call 'molit.rt.rh.(year)'
#'
#' @name molit.rt.rh
#' @docType data
#' @author Jaehyun Shin \email{keepcosmos@gmail.com}
#' @references \url{http://rtdown.molit.go.kr}
#' @keywords datasets
#' @format Classes 'data.table' and 'data.frame'
'molit.rt.rh.2016'


#' molit.rt.sh
#'
#' Single-Family houses Real Trading & Rent Datasets from 2006
#' source from molit.go.kr\cr
#'
#' Call 'molit.rt.sh.(year)'
#'
#' @name molit.rt.sh
#' @docType data
#' @author Jaehyun Shin \email{keepcosmos@gmail.com}
#' @references \url{http://rtdown.molit.go.kr}
#' @keywords datasets
#' @format Classes 'data.table' and 'data.frame'
'molit.rt.sh.2016'

molit.rt.years <- c(2006:2016)
molit.rt.types <- c("sh", "rh", "apt")
#' @encoding UTF-8
molit.rt.colnameKorToEng <- list(
  "전월세구분" = "deal.type",
  "주택유형" = "house.type",
  "시군구" = "region",
  "단지명" = "housing.estate",
  "도로명" = "street",
  "번지" = "zipcode",
  "층" = "floor",
  "전용면적" = "net.area",
  "연면적" = "total.floor.area",
  "대지면적" = "site.area",
  "대지권면적" = "site.right.area",
  "계약면적" = "contract.area",
  "거래금액" = "trading.price",
  "보증금" = "deposit.price",
  "월세" = "monthly.price",
  "계약년" = "year",
  "계약월" = "month",
  "계약일" = "day",
  "건축년도" = "build.year"
)

#' molit.rt.get
#'
#' Get data by type and region name
#'
#' @name molit.rt.get
#' @encoding UTF-8
#' @export
#' @import data.table
#' @param type House Type (sh, rh, apt)
#' @param region Location name
#' @param engColNames Convert to English column names, default TRUE
#' @examples
#'     molit.rt.get("sh", address)
#'     molit.rt.get("apt", address)
molit.rt.get <- function(type = NA, region = NA, colnames.locale = "en"){
  molit.rt.checkType(type)

  dataNames <- paste0("molit.rt.", type, ".", molit.rt.years)

  result <- data.table()
  for(dataName in dataNames){

    cat("Fetching data from", dataName, "...\n")

    rtData <- eval(parse(text = dataName))
    if(!is.na(region)){
      rtData <- rtData[grepl(region, rtData[["시군구"]])]
    }
    result <- rbind(result, rtData, fill=TRUE)
  }

  result[result[["계약년"]] < 2011, "전월세구분" := "매매"]
  result[["전월세구분"]] <- as.factor(as.character(result[["전월세구분"]]))

  if(colnames.locale == "en"){
    result <- molit.rt.convertToEngColNames(result)
  }
  result
}

molit.rt.convertToEngColNames <- function(dt){
  names <- colnames(dt)
  colnames(dt) <- mapply(function(x){ molit.rt.colnameKorToEng[[x]] }, colnames(dt))
  dt
}

molit.rt.checkType <- function(type){
  if(!(type %in% molit.rt.types)) stop("Type must be one of ", paste(molit.rt.types, collapse = ", "))
}
