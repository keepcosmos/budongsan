stats.apt.gap <- function(region = NA, minArea = NA, maxArea = NA){
  data <- molit.rt.get("apt", region)
  if(!is.na(areaMin)){
    data <- data[net.area >= minArea]
  }
  if(!is.na(areaMax)){
    data <- data[net.area <=  maxArea]
  }
  data$date <- stats.apt.parseDate(data)
  data[deal.type == "매매", price.per.area := (trading.price / net.area)]
  data[deal.type == "전세", price.per.area := (deposit.price / net.area)]
  data <- data[!is.na(price.per.area)]
  data <- select(data, deal.type, region, housing.estate, date, price.per.area) %>%
    group_by(deal.type, housing.estate, date) %>%
    summarise(price.per.area = mean(price.per.area)) %>% data.table
  data

}

stats.apt.parseDate <- function(dt){
  day <- sapply(dt$day, function(x){
    ifelse(x == "1~10", "01", ifelse(x == "11~20", "11", "21"))
  })
  as.Date(paste(dt$year, dt$month, day, sep = "-"))
}


setMacOS <- function(){
  ggplot2::theme_set(ggplot2::theme_grey() + ggplot2::theme(text = ggplot2::element_text(family="AppleGothic")))

  grDevices::quartzFonts(
    sans =grDevices::quartzFont(rep("AppleGothic",4)),
    serif=grDevices::quartzFont(rep("AppleMyungjo",4))
  )
  grDevices::pdf.options(family="Korea1")
  grDevices::ps.options(family="Korea1")

  attach(NULL, name = "KoreaEnv")
  assign("familyset_hook",
         function(){
           macfontdevs=c("quartz","quartz_off_screen", "RStudioGD")
           devname=strsplit(names(dev.cur()),":")[[1L]][1]
           if (capabilities("aqua") &&
               devname %in% macfontdevs)
             par(family="sans")
         },
         pos="KoreaEnv")
  setHook("plot.new", get("familyset_hook", pos="KoreaEnv"))
  setHook("persp", get("familyset_hook", pos="KoreaEnv"))

  options(java.parameters=c("-Xmx8g", "-Dfile.encoding=UTF-8"))
}
