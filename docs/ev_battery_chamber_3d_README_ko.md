# EV 배터리 챔버 3D 도면 (OpenSCAD)

요청하신 스케치를 기준으로 **4단 × 3열(총 12개) 배터리 팩**이 들어가는 형태의 3D 챔버 도면을 만들었습니다.

- 3D 모델 파일: `docs/ev_battery_chamber_3d.scad`
- 단위: mm
- 구성: 챔버 외곽, 구조 프레임, 선반, 배터리 팩(단자 포함)

## 기본 치수(현재 설정)
- 챔버: 2600(W) × 1100(D) × 2600(H)
- 배터리 팩(개별): 700(W) × 500(D) × 140(H)
- 선반: 4단
- 각 단: 3팩

## OpenSCAD에서 확인하는 방법
1. OpenSCAD 실행
2. `docs/ev_battery_chamber_3d.scad` 열기
3. `F5`(미리보기) 또는 `F6`(렌더)
4. 필요하면 `STL` 또는 `3MF`로 Export

## 실배터리 규격 반영 방법
실제 사용하실 자동차 배터리 팩 규격서 기준으로 아래 파라미터만 바꾸면 됩니다.
- `pack_w`, `pack_d`, `pack_h`
- `chamber_w`, `chamber_d`, `chamber_h`
- `levels`, `packs_per_row`, `pack_gap`, `row_side_margin`

규격표(가로/세로/높이, 무게, 냉각라인 간섭치수)를 주시면 해당 값으로 정확히 다시 맞춰드릴 수 있습니다.
