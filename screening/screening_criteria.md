# Screening Criteria & Process

## Stage 1 — Title/Abstract screening

Include if title/abstract suggests:
- Population: students in formal PK-16 education
- Intervention: an AI-based system (adaptive/automated decision-making), not just any digital tool
- A comparison/control condition is implied
- Some learning-related outcome (cognitive or non-cognitive) is measured

Exclude if:
- Not an education context (e.g., medical/corporate training only)
- AI is only used by teachers/administrators, not experienced by students (e.g., AI for grading logistics only, no student-facing intervention)
- Purely descriptive/opinion/theoretical papers with no empirical outcome data
- No comparison group evident (single-group pre-post with no control, unless it's the *only* evidence and flagged for sensitivity analysis)
- Not in English
- Outside 2012–2026 window

Borderline/unclear → advance to full-text stage rather than exclude (err toward inclusion at this stage).

## Stage 2 — Full-text screening

Apply full PICOS eligibility criteria (see `protocol/protocol.md` §3). Exclude with a specific reason code:

| Code | Reason |
|---|---|
| E1 | Wrong population (not PK-16 students) |
| E2 | Wrong intervention (not an AI-based system / no adaptive-automated component) |
| E3 | No eligible comparator/control group |
| E4 | No eligible outcome measured (neither cognitive nor non-cognitive) |
| E5 | Wrong study design (no quantifiable effect size derivable) |
| E6 | Insufficient statistics to compute/derive effect size, and authors unreachable/non-responsive |
| E7 | Duplicate / same sample reported elsewhere (keep most complete report) |
| E8 | Not English |
| E9 | Outside date range |
| E10 | Full text not retrievable |

## Reliability check

AI screens 100% of records. PI independently re-screens a random ~20% sample (stratified across include/exclude decisions) at both stages. Report percent agreement and Cohen's κ in the methods chapter. Disagreements resolved by discussion; unresolved cases default to inclusion pending full-text review.

## PRISMA flow numbers to track

1. Records identified through database searching (by database)
2. Records identified through other sources (citation chasing, hand-search, open-web)
3. Records after duplicates removed
4. Records screened (title/abstract)
5. Records excluded (title/abstract), with reasons
6. Full-text articles assessed for eligibility
7. Full-text articles excluded, with reasons (E1–E10 above, counted)
8. Studies included in qualitative synthesis
9. Studies included in quantitative synthesis (meta-analysis) — split by Objective 1 / Objective 2 / both
