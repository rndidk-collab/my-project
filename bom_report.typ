// ─────────────────────────────────────────────
// KA5 BSA BOM 분석 보고서 — Typst best practice
// ─────────────────────────────────────────────

#let TYPST_VERSION = "0.14.2"

// ── 문서 메타데이터 ──
#set document(
  title: "KA5 BSA BOM 분석 보고서",
  author: "김성구 (R&D)",
  date: datetime(year: 2026, month: 4, day: 9),
)

// ── 페이지 설정 ──
#set page(
  paper: "a4",
  margin: (top: 25mm, bottom: 25mm, left: 22mm, right: 22mm),
  header: context {
    if counter(page).get().first() > 1 [
      #set text(size: 8pt, fill: luma(150))
      #grid(
        columns: (1fr, 1fr),
        align(left)[KA5 BSA BOM 분석 보고서],
        align(right)[성우하이텍 R&D],
      )
      #line(length: 100%, stroke: 0.4pt + luma(200))
    ]
  },
  footer: context {
    set text(size: 8pt, fill: luma(150))
    line(length: 100%, stroke: 0.4pt + luma(200))
    v(2pt)
    grid(
      columns: (1fr, 1fr),
      align(left)[기밀 — 내부 배포용],
      align(right)[#counter(page).display("1 / 1", both: true)],
    )
  },
)

// ── 타이포그래피 ──
#set text(font: ("Malgun Gothic", "Noto Sans KR", "Arial"), size: 10pt, lang: "ko")
#set par(justify: true, leading: 0.75em)
#set heading(numbering: "1.1.")

// ── 색상 팔레트 ──
#let primary   = rgb("#1a1a2e")
#let accent    = rgb("#e94560")
#let light-bg  = rgb("#f8f9fa")
#let border    = rgb("#dee2e6")
#let sa-color  = rgb("#3b82f6")
#let buy-color = rgb("#8b5cf6")
#let ext-color = rgb("#ef4444")
#let hw-color  = rgb("#22c55e")

// ── 재사용 컴포넌트 ──
#let badge(text-content, color) = box(
  fill: color.lighten(75%),
  stroke: 0.5pt + color,
  radius: 3pt,
  inset: (x: 5pt, y: 2pt),
  text(size: 8pt, fill: color, weight: "bold", text-content)
)

#let info-card(label, value, sub: "") = rect(
  fill: light-bg,
  stroke: 0.5pt + border,
  radius: 6pt,
  inset: 14pt,
  width: 100%,
)[
  #text(size: 8pt, fill: luma(120))[#label]
  #v(3pt)
  #text(size: 18pt, weight: "bold", fill: accent)[#value]
  #if sub != "" [ #v(2pt); #text(size: 8pt, fill: luma(150))[#sub] ]
]

#let section-rule() = {
  v(6pt)
  line(length: 100%, stroke: 1.5pt + accent)
  v(4pt)
}

// ════════════════════════════════════
//  표지
// ════════════════════════════════════
#align(center)[
  #v(30mm)

  // 로고 대체 — 컬러 블록
  #rect(
    fill: primary,
    radius: 8pt,
    inset: (x: 24pt, y: 12pt),
  )[
    #text(size: 13pt, weight: "bold", fill: white)[성우하이텍 R&D]
  ]

  #v(16mm)

  #text(size: 26pt, weight: "bold", fill: primary)[
    KA5 BSA BOM 분석 보고서
  ]

  #v(6mm)
  #line(length: 60%, stroke: 2pt + accent)
  #v(6mm)

  #text(size: 13pt, fill: luma(80))[
    KA5\_BSA\_300V\_BOM\_37500-KA000\_260205 (원가팀 송부본)
  ]

  #v(20mm)

  #grid(
    columns: (1fr, 1fr),
    gutter: 12pt,
    info-card("작성자", "김성구", sub: "R&D팀"),
    info-card("작성일", "2026-04-09"),
    info-card("차종", "KA5 HEV", sub: "300V BSA"),
    info-card("문서 상태", "내부 검토용"),
  )

  #v(1fr)
  #text(size: 8pt, fill: luma(180))[
    본 문서는 Claude Code + Typst #TYPST_VERSION 으로 자동 생성되었습니다.
  ]
]

#pagebreak()

// ════════════════════════════════════
//  1. 개요
// ════════════════════════════════════
= 분석 개요

#section-rule()

본 보고서는 KA5 HEV 배터리 시스템 어셈블리(BSA) 원가팀 송부 BOM을 분석하여 \
주요 부품 구성, 중량 분포, 조달 유형별 현황을 정리합니다.

#v(8pt)
#grid(
  columns: (1fr, 1fr, 1fr, 1fr),
  gutter: 10pt,
  info-card("총 어셈블리 중량", "40,737 g", sub: "약 40.7 kg"),
  info-card("최대 단품", "15,233 g", sub: "Battery Pack ASSY"),
  info-card("시트 수", "7개", sub: "BSA·BPC·COOLING 등"),
  info-card("주요 조달 유형", "4종", sub: "S/A·사급·구매품·H/W"),
)

// ════════════════════════════════════
//  2. 주요 부품 중량 순위
// ════════════════════════════════════
#v(10pt)
= 주요 부품 중량 순위

#section-rule()

#text(size: 8.5pt, fill: luma(100))[
  ※ 원가팀 송부본에 단가 컬럼 없음. 중량(g)을 원가 비중 지표로 활용. \
  (배터리 부품 특성상 중량 ∝ 재료비 경향)
]

#v(8pt)

// 수평 막대 차트 (Typst native)
#let bars = (
  ("Battery Pack ASSY",           15233, sa-color),
  ("Battery Pack Assy LWR Case",  12507, sa-color),
  ("Battery Module ASSY-Low Volt",  4546, sa-color),
  ("Relay ASSY-Power",             1500, ext-color),
  ("Battery Pack Cooling Block",   1185, sa-color),
  ("PNL-ASSY Battery Pack UPR Case", 1165, sa-color),
  ("BRKT-ASSY 12V Module MTG",      512, sa-color),
  ("Battery Management System",     500, ext-color),
  ("GAP FILLER (442×160×3T)",       436, buy-color),
  ("HIGH VOLTAGE CONNECTOR",        400, buy-color),
)

#let max-w = 15233

#for (name, val, color) in bars {
  let pct = val / max-w * 100%
  grid(
    columns: (8pt, 180pt, 1fr, 60pt),
    gutter: 6pt,
    align(horizon + right, text(size: 8pt, fill: luma(120))[]),
    align(horizon, text(size: 8.5pt)[#name]),
    align(horizon)[
      #box(
        width: 100%,
        height: 14pt,
        radius: 3pt,
        fill: luma(240),
      )[
        #box(width: pct, height: 14pt, radius: 3pt, fill: color)[]
      ]
    ],
    align(horizon + right, text(size: 8.5pt, weight: "bold")[#val g]),
  )
  v(4pt)
}

// ════════════════════════════════════
//  3. 전체 부품 목록 테이블
// ════════════════════════════════════
#pagebreak()
= 전체 주요 부품 목록 (중량 내림차순)

#section-rule()

#set text(size: 8.5pt)

#table(
  columns: (20pt, 90pt, 1fr, 35pt, 55pt, 45pt),
  fill: (col, row) => if row == 0 { primary } else if calc.odd(row) { light-bg } else { white },
  stroke: 0.5pt + border,
  inset: (x: 6pt, y: 5pt),
  align: (col, row) => if col == 0 or col == 3 or col == 4 { center + horizon } else { left + horizon },

  // 헤더
  text(fill: white, weight: "bold")[순위],
  text(fill: white, weight: "bold")[P/NO],
  text(fill: white, weight: "bold")[부품명],
  text(fill: white, weight: "bold")[수량],
  text(fill: white, weight: "bold")[중량(g)],
  text(fill: white, weight: "bold")[공법],

  // 데이터 행
  [1],  [37510-KA000],   [BATTERY PACK ASSY],                       [1], [15,233], badge("S/A", sa-color),
  [2],  [KA375-P1000],   [BATTERY PACK ASSY LWR CASE],              [1], [12,507], badge("S/A", sa-color),
  [3],  [37507-SW000],   [BATTERY MODULE ASSY-LOW VOLTAGE],         [2],  [4,546], badge("S/A", sa-color),
  [4],  [37514-5S000],   [RELAY ASSY-POWER],                        [1],  [1,500], badge("사급", ext-color),
  [5],  [37575-KA000],   [BATTERY PACK ASSY COOLING BLOCK],         [1],  [1,185], badge("S/A", sa-color),
  [6],  [XX375-P2000],   [PNL-ASSY BATTERY PACK UPR CASE],          [1],  [1,165], badge("S/A", sa-color),
  [7],  [BS533-KA000],   [BRKT-ASSY 12V MODULE MTG],                [1],    [512], badge("S/A", sa-color),
  [8],  [375A0-5S000],   [BATTERY MANAGEMENT SYSTEM (BMS)],         [1],    [500], badge("사급", ext-color),
  [9],  [375SA-KA000],   [GAP FILLER (442×160×3T)],                 [1],    [436], badge("구매품", buy-color),
  [10], [HV001-JX000],   [HIGH VOLTAGE CONNECTOR 300A],             [1],    [400], badge("구매품", buy-color),
  [11], [WH102-KA500],   [SNSG\_WIRING],                            [1],    [270], badge("구매품", buy-color),
  [12], [BP172-KA000],   [BRKT-WATERTIGHT REINF FRT],               [2],    [266], badge("프레스", hw-color),
  [13], [WH203-KA500],   [12V\_HV CABLE],                           [1],    [257], badge("구매품", buy-color),
  [14], [WH204-KA500],   [12V\_P4 CABLE],                           [1],    [237], badge("구매품", buy-color),
  [15], [11408-06186K],  [M6 FLANGE BOLT (M6×18) ×24],             [24],   [206], badge("H/W", hw-color),
  [16], [WH101-KA500],   [BMS EXTN\_WIRING],                        [1],    [198], badge("구매품", buy-color),
  [17], [WH201-KA500],   [HV\_NEGATIVE\_CABLE],                     [1],    [143], badge("구매품", buy-color),
  [18], [BP174-KA000],   [BRKT-WATERTIGHT REINF LH],                [1],    [130], badge("프레스", hw-color),
  [19], [BP176-KA000],   [BRKT-WATERTIGHT REINF RH],                [1],    [117], badge("프레스", hw-color),
  [20], [11403-06506K],  [M6 BOLT (L55) ×8],                        [8],    [118], badge("H/W", hw-color),
)

// ════════════════════════════════════
//  4. 조달 유형별 분석
// ════════════════════════════════════
#pagebreak()
= 조달 유형별 분석

#section-rule()

#grid(
  columns: (1fr, 1fr),
  gutter: 14pt,

  // 왼쪽: 유형 설명
  stack(
    spacing: 10pt,
    rect(fill: sa-color.lighten(80%), stroke: 0.5pt + sa-color, radius: 6pt, inset: 12pt, width: 100%)[
      #badge("S/A", sa-color) *서브어셈블리*
      #v(4pt)
      자체 생산 또는 협력사 조립품. 중량 기준 전체의 약 *73%* 차지.\
      주요 품목: Battery Pack ASSY, LWR Case, Cooling Block
    ],
    rect(fill: ext-color.lighten(80%), stroke: 0.5pt + ext-color, radius: 6pt, inset: 12pt, width: 100%)[
      #badge("사급", ext-color) *사급품 (외부 공급)*
      #v(4pt)
      OEM 지정 공급사 납품. 일정·품질 리스크 관리 필요.\
      주요 품목: Relay ASSY (1,500g), BMS (500g)\
      ⚠️ *공급사 납기 지연 시 전체 라인 영향*
    ],
  ),

  stack(
    spacing: 10pt,
    rect(fill: buy-color.lighten(80%), stroke: 0.5pt + buy-color, radius: 6pt, inset: 12pt, width: 100%)[
      #badge("구매품", buy-color) *구매품 (VCM)*
      #v(4pt)
      VCM 경로 외부 조달. 단가 협상 여지 있음.\
      주요 품목: GAP FILLER, HV CONNECTOR, 각종 WIRING
    ],
    rect(fill: hw-color.lighten(85%), stroke: 0.5pt + hw-color, radius: 6pt, inset: 12pt, width: 100%)[
      #badge("H/W", hw-color) *하드웨어*
      #v(4pt)
      볼트·너트류. 단가 낮으나 수량 많음.\
      ⚠️ M6 FLANGE BOLT: *록타이트 적용 필수*
    ],
  ),
)

// ════════════════════════════════════
//  5. 특이사항 및 조치 권고
// ════════════════════════════════════
#v(10pt)
= 특이사항 및 조치 권고

#section-rule()

#table(
  columns: (50pt, 1fr, 80pt, 60pt),
  fill: (col, row) => if row == 0 { primary } else if calc.odd(row) { light-bg } else { white },
  stroke: 0.5pt + border,
  inset: (x: 7pt, y: 6pt),
  align: horizon,

  text(fill: white, weight: "bold")[우선순위],
  text(fill: white, weight: "bold")[내용],
  text(fill: white, weight: "bold")[담당],
  text(fill: white, weight: "bold")[기한],

  badge("긴급", ext-color),
  [RELAY ASSY / BMS 사급 공급사 납기 확인 — 전체 라인 영향 품목],
  [R&D + 구매],
  [즉시],

  badge("긴급", ext-color),
  [M6 FLANGE BOLT (NO.19) 록타이트 적용 공정 재확인],
  [제조 + 품질],
  [1주],

  badge("단기", sa-color),
  [GAP FILLER 도포 균일성 검사 — 비중 2.05, 도포타입 3mm],
  [품질],
  [2주],

  badge("단기", sa-color),
  [HV CONNECTOR 300A 다이캐스팅 일체형 공차 점검],
  [R&D],
  [2주],

  badge("중기", buy-color),
  [KA5 vs JX2/RG4 BOM REV 변경 이력 비교 분석],
  [R&D],
  [1개월],
)

#v(1fr)

// 하단 서명란
#line(length: 100%, stroke: 0.5pt + border)
#v(4pt)
#grid(
  columns: (1fr, 1fr, 1fr),
  gutter: 10pt,
  align(center)[
    #rect(width: 100%, height: 30pt, stroke: 0.5pt + border, radius: 4pt)[]
    #v(3pt)
    #text(size: 8pt, fill: luma(120))[작성자: 김성구 (R&D)]
  ],
  align(center)[
    #rect(width: 100%, height: 30pt, stroke: 0.5pt + border, radius: 4pt)[]
    #v(3pt)
    #text(size: 8pt, fill: luma(120))[검토자:]
  ],
  align(center)[
    #rect(width: 100%, height: 30pt, stroke: 0.5pt + border, radius: 4pt)[]
    #v(3pt)
    #text(size: 8pt, fill: luma(120))[승인자:]
  ],
)
