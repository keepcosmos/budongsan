# Budongsan
국토교통부(molit.go.kr)과 한국 감정원에서 제공하는 아파트, 단독/다가구, 연립/다세대 주택 실거래 정보 분석을 위한 dataset과 functions를 제공합니다.

현재 http://rtdown.molit.go.kr 에서 제공되는 월간 실거래 정보를 R dataset을 제공하고 있습니다.

### 패키지 설치하기
* `budongsan` 페키지를 설치하기 위해선 `devtools` 패키지가 필요합니다.

```{r}
install.packages("devtools")
devtools::install_github("keepcosmos/budongsan")

library(budongsan)
```

### Datasets
```
# 아파트 전월세 및 매매 실거래 데이터
molit.rt.apt

# 단독/다가구 전월세 및 매매 실거래 데이터
molit.rt.sh

# 연립/다세대 전월세 및 매매 실거래 데이터
molit.rt.rh
```
* `help(molit.rt.apt)` 혹은 `?molit.rt.apt` 명령어를 통해 데이터에 대한 상세 정보를 확인 할 수 있습니다.

* 데이터 양이 큽니다. `data.table` 패키지를 먼저 추가해주면 더 빠르게 데이터를 활용할 수 있습니다.

### Issue
* Windows 환경에서 RStudio 사용 시, autocomplete이 활성화 되어 있을 경우 datasets에 대한 help메시지를 생성하며 워닝메시지가 발생합니다. Non-Ascii 문자에 대한 RStudio의 이슈이며, 해당 워닝 메시지는 무시하셔도 좋습니다. 신경쓰이신다면 autocomplete 기능을 꺼두시면 됩니다.


### TODO
* 부동산 거래 정보 정보에 필요한 유용한 함수들 추가
* 실거래 정보에 대한 국토 교통부 Open API 클라이언트 구현 (https://www.data.go.kr)
  * 아파트, 단독/다가구, 연립/다세대, 오피스텔, 토지
* 한국감정원 아파트 실거래가격지수에 대한 Open API 클라이언트 구현
  * 실거래가격지수 통계 조회 서비스
  * 아파트 실거래 가격 지수 조회 서비스
