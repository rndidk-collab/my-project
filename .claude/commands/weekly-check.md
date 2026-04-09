---
description: 배터리 로그 주간 점검 보고서 자동 생성
allowedTools: Read, Write, Bash, Glob, Grep
---

practice-data/A-RnD/ 폴더에서 가장 최신 battery_log CSV 파일을 찾아 읽고, 아래 순서로 주간 점검 보고서를 생성하세요.

## 분석 순서

1. **전체 현황 요약**: 총 기록 수, 정상/이상 건수, 비율
2. **이상 이벤트 분류**:
   - LOW_VOLTAGE: 전압 3.0V 미만
   - HIGH_TEMP: 온도 45°C 초과
3. **셀별 이상 집계**: 셀 ID별 발생 횟수, 최고/최저값, 추세(악화/안정/개선)
4. **해결 방안**: 이상 유형별 즉시/단기/원인분석/조치 단계
5. **종합 판정**: 합격/불합격 (CLAUDE.md 기준 자동 적용)

## 출력 규칙

- CLAUDE.md의 Always 규칙 전체 적용
- 모든 수치에 단위 표기 (V, °C, %)
- 표(table) 형식 필수
- 판정: 합격/불합격 명시

## 저장

결과를 `weekly_report_YYYY-MM-DD.md` 파일로 저장하세요.
