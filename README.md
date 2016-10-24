# Budongsan
국토교통부(molit.go.kr)와 한국 감정원에서 제공하는 아파트, 단독/다가구, 연립/다세대 주택 실거래 정보 분석을 위한 dataset과 함수를 제공합니다.

현재는, http://rtdown.molit.go.kr 에서 제공되는 2011~2016년까지의 모든 실거래 정보에 대한 R dataset을 제공하고 있습니다.

### 패키지 설치하기
* `budongsan` 패키지를 설치하기 위해선 `devtools` 패키지가 필요합니다.

```{r}
install.packages("devtools")
devtools::install_github("keepcosmos/budongsan")
# 100MB 이상의 데이터로 다소 시간이 소요될 수 있습니다.

library(budongsan)
```

### Datasets
`molit.rt.{type}.{year}` 형식으로 데이터를 불러옵니다.
* type:
  - `apt`: 아파트
  - `sh`: 단독 / 다가구
  - `rh`: 연립 / 다세대
* year: 2011 ~ 2016

```{r}
# 2016년 아파트 전월세 및 매매 실거래 데이터
molit.rt.apt.2016

# 2016년 단독/다가구 전월세 및 매매 실거래 데이터
molit.rt.sh.2016

# 2015년 연립/다세대 전월세 및 매매 실거래 데이터
molit.rt.rh.2015
```
* `help(molit.rt.apt)` 혹은 `?molit.rt.apt` 명령어를 통해 데이터에 대한 상세 정보를 확인할 수 있습니다.
* 데이터 양이 큽니다. `data.table` 패키지를 먼저 추가해주면 더 빠르게 데이터를 활용할 수 있습니다.
* 면적은 평방미터, 가격은 만원단위로 표시됩니다.

## Contribution
* 해당 데이터를 활용한 어떤 분석이든 공유해주세요. PR뿐 아니라 Issue를 통한 제안이나 Gist를 통해 본인이 분석한 Script를 공유해주셔도 됩니다.
* molit.go.kr에서 다운받은 raw 파일은 package size 문제로 `data-raw` 브랜치에서 관리합니다. 데이터를 정리한 후 rda파일만 master에 머지하고 있으니 참고해주세요.

### TODO
* 부동산 거래 정보 정보에 필요한 유용한 함수들 추가
* 실거래 정보에 대한 국토 교통부 Open API 클라이언트 구현 (https://www.data.go.kr)
  * 아파트, 단독/다가구, 연립/다세대, 오피스텔, 토지
* 한국감정원 아파트 실거래가격지수에 대한 Open API 클라이언트 구현
  * 실거래가격지수 통계 조회 서비스
  * 아파트 실거래 가격 지수 조회 서비스
