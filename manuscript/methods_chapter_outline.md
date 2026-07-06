# Methods Chapter Outline (maps to PRISMA 2020 reporting checklist)

Use this as the skeleton for the dissertation's methods chapter; each heading maps to a PRISMA item and to a repo artifact so the write-up stays traceable to the actual pipeline.

1. **Study design / protocol** — reference `protocol/protocol.md`; state whether pre-registered (PROSPERO).
2. **Eligibility criteria** — PICOS table from protocol §3.
3. **Information sources & search strategy** — `search/search_strategy.md` + `search/search_log.csv`; disclose which databases were searched by AI directly (open web) vs. via PI-run exports (subscription databases).
4. **Selection process** — `screening/screening_criteria.md`; report inter-rater reliability (κ) from the PI verification sample.
5. **Data collection process / data items** — `data_extraction/codebook.md`; disclose AI's role in extraction and the PI verification sampling rate.
6. **Study risk of bias assessment** — WWC-adapted criteria, per-study ratings from the extraction sheet.
7. **Effect size measures & synthesis methods** — Hedges' g; three-level `rma.mv` model with `clubSandwich` robust variance estimation; rationale for treating Objective 1 and Objective 2 as separate models.
8. **Reporting bias assessment** — funnel plots, Egger's test, trim-and-fill, PET-PEESE (`results/publication_bias_summary.txt`).
9. **Certainty/confidence in evidence** — optional GRADE-style summary per objective.
10. **AI-use transparency statement** — explicit paragraph (see protocol §9) describing what AI did at each stage and what the human researcher verified/decided.

## Results chapter skeleton (one per objective)

- PRISMA flow diagram (numbers from `screening/screening_log.csv`)
- Study characteristics table (from extraction sheet)
- Forest plot + pooled effect (`results/forest_objective*.png`)
- Heterogeneity statistics (I², τ², prediction interval)
- Moderator/meta-regression results (Objective 3 only, or as a subsection under 1/2)
- Publication bias diagnostics
- Sensitivity analyses (leave-one-out, WWC-meets-standards-only subset)

## Discussion chapter prompts (per objective)

- How do pooled effects compare to prior (non-AI-led) meta-analyses in this space?
- What do the Objective 3 moderator results imply about *which* AI intervention designs work best, and *why* (mechanism)?
- Limitations specific to an AI-led synthesis process (see protocol §10) and how they were mitigated.
