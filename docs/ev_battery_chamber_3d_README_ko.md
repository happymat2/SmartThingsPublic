# EV 배터리 챔버 3D 도면 (OpenSCAD)

요청하신 스케치를 기준으로 **4단 × 3열(총 12개) 배터리 팩**이 들어가는 챔버를,
단순 배치도가 아니라 **3D 기술 도면 형태(아이소 + 정면/평면/우측면 + 치수선)**로 구성했습니다.

- 3D 모델 파일: `docs/ev_battery_chamber_3d.scad`
- 단위: mm
- 포함 요소:
  - 챔버 외곽(반투명)
  - 구조 프레임 / 선반
  - 배터리 팩(단자, 커버, 냉각 포트 표현)
  - 치수 표기(폭/깊이/높이)

## 기본 치수(현재값)
- 챔버: 2600(W) × 1100(D) × 2600(H)
- 배터리 팩(개별): 700(W) × 500(D) × 140(H)
- 선반: 4단
- 각 단: 3팩

## OpenSCAD에서 확인하는 방법
1. OpenSCAD 실행
2. `docs/ev_battery_chamber_3d.scad` 열기
3. `F5` 미리보기 / `F6` 렌더
4. 필요하면 `STL`, `3MF`, `DXF(투영뷰)`로 Export

## 도면 보기 옵션
상단 플래그로 표시 화면을 켜고 끌 수 있습니다.
- `show_isometric`
- `show_front_view`
- `show_top_view`
- `show_right_view`
- `show_dimensions`

## 실제 자동차 배터리 팩 규격 반영
실제 팩 데이터시트 값으로 아래 파라미터를 교체하면 됩니다.
- 배터리 팩: `pack_w`, `pack_d`, `pack_h`, `terminal_r`, `cooling_port_r`
- 챔버: `chamber_w`, `chamber_d`, `chamber_h`, `levels`, `pack_gap`, `row_side_margin`

## 정확도 높이기(권장 입력값)
아래 값이 있으면 제조 검토 수준으로 더 정확히 맞출 수 있습니다.
- 팩 무게(kg) / 선반 허용하중
- 단자 위치(X,Y) 및 서비스 공간
- 냉각 포트 위치/직경 및 호스 굽힘 반경
- 절연거리/안전거리 기준
