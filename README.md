# AI-Powered Meta-Analysis in Education

**Dissertation title:** AI-Powered Meta-Analysis in Education: Synthesizing the Effects of AI Interventions on Students' Learning Outcomes

This repository is the working project space for a PhD dissertation conducted as an **AI-led systematic review and meta-analysis** (PRISMA 2020-aligned). AI (Claude, via this repository) performs the primary work of search execution support, screening, data extraction/coding, statistical analysis, and drafting of results/interpretation across all three substudies. The human researcher (PI) retains authorship, ownership of judgment calls, ethical responsibility, and verifies a sample of AI outputs at each stage for reliability (documented in `screening/` and `data_extraction/` logs).

## Objectives / Substudies

| # | Objective | Status |
|---|-----------|--------|
| 1 | Synthesize effects of AI interventions on students' **cognitive** learning outcomes | Not started |
| 2 | Synthesize effects of AI interventions on students' **non-cognitive** learning outcomes | Not started |
| 3 | Identify/analyze **mechanisms and moderating factors** influencing AI intervention effectiveness | Not started |

All three objectives share one systematic search and one screened corpus of studies; they diverge at data extraction (different outcome coding) and analysis (three separate but related statistical models).

## Repository structure

```
protocol/            PRISMA-P protocol: PICOS, eligibility criteria, RoB approach, synthesis plan
search/               Boolean search strings per database/objective, search log
screening/            Inclusion/exclusion criteria, screening log (PRISMA flow counts)
data_extraction/      Codebook + blank extraction spreadsheet (one row per effect size)
analysis/scripts/     R scripts (metafor + clubSandwich) — data prep, models for Obj 1/2/3,
                      publication bias, forest/funnel plots
results/              Generated tables, plots, model output (populated once data exists)
manuscript/           Chapter/write-up outlines mapped to PRISMA reporting items
```

## Pipeline (where AI leads at each stage)

1. **Protocol** (`protocol/protocol.md`) — PICOS, eligibility, RoB tool, synthesis plan. Draft complete; needs your sign-off (and optionally PROSPERO registration) before search execution.
2. **Search** (`search/`) — Boolean strings are drafted per database. Important limitation: this environment has no institutional login to Scopus/Web of Science/PsycINFO/ERIC(EBSCO)/IEEE Xplore. AI can run open-web searches (Google Scholar-style, ERIC public interface, DOAJ, arXiv/EdArXiv preprints) directly; for subscription databases, you run the string in your university portal and export the results (RIS/CSV/BibTeX) into `search/exports/` for AI to process.
3. **Screening** (`screening/`) — AI screens title/abstract, then full text, against the eligibility criteria, logging every decision + reason in `screening_log.csv` (feeds the PRISMA flow diagram numbers). A ~20% random sample is flagged for your independent check to report inter-rater agreement (Cohen's κ).
4. **Data extraction & coding** (`data_extraction/`) — AI extracts one row per effect size into `extraction_template.csv` per the `codebook.md` field definitions, covering cognitive outcomes (Obj 1), non-cognitive outcomes (Obj 2), and moderator/mechanism variables (Obj 3).
5. **Analysis** (`analysis/scripts/`) — Three-level random-effects models (`metafor::rma.mv`) with robust variance estimation (`clubSandwich`) to handle dependent effect sizes, run separately for Objective 1 and Objective 2, plus meta-regression/subgroup analysis for Objective 3. Heterogeneity (I², τ², prediction intervals) and publication bias diagnostics (funnel plot, Egger's regression test, PET-PEESE, trim-and-fill) throughout.
6. **Interpretation & write-up** (`manuscript/`) — AI drafts forest plots, summary tables, and results/discussion prose per objective; you retain authorship and final edits.

## Status tracker

- [x] Repository scaffolded
- [ ] Protocol reviewed/approved by you
- [x] Search strings finalized; **open-web search pass #1 run** (2026-07-08) — see caveat below on subscription databases
- [ ] Title/abstract screening complete (in progress — see PRISMA counts below)
- [ ] Full-text screening complete; PRISMA flow diagram numbers finalized
- [ ] Data extraction complete for Objective 1 (cognitive)
- [ ] Data extraction complete for Objective 2 (non-cognitive)
- [ ] Moderator/mechanism coding complete for Objective 3
- [ ] Objective 1 meta-analytic model run
- [ ] Objective 2 meta-analytic model run
- [ ] Objective 3 moderator/meta-regression analysis run
- [ ] Publication bias diagnostics run for all models
- [ ] Results chapters drafted

## PRISMA running totals (after open-web search pass #1, 2026-07-08)

| Stage | n |
|---|---|
| Records identified via open-web search (10 queries, both outcome families) | 88 |
| Of which: identified as meta-analyses/systematic reviews (routed to `search/umbrella_review_candidates.csv`, not screened as candidates) | 17 |
| Remaining candidate records (primary-study pool) | 71 |
| Duplicates removed | 3 |
| Unique records screened (title/abstract) | 68 |
| **Excluded at title/abstract**, with reason codes (see `screening/screening_log_template.csv`) | 28 |
| **Included** at title/abstract (primary-study candidates, pending full-text) | **23** |
| **Unsure** — flagged for full-text to confirm design/control group | 17 |

Of the 23 confirmed includes: ~7 report both cognitive and non-cognitive outcomes (dual-coded for Objective 1 + 2), ~7 are cognitive-outcome-only, and the remainder are non-cognitive-outcome-only or anxiety/attitude-focused. All 23 have at least one Objective 3 moderator flagged in the `notes` column (AI type, duration, subject, grade level, or theoretical mechanism) for later coding. Exact per-objective counts will firm up at full-text screening.

**Known limitation from this pass:** no institutional access to Scopus/Web of Science/PsycINFO/ERIC(EBSCO)/IEEE Xplore/ACM Digital Library from this environment — all 88 records came from open-web search only. This is a first pass, not a comprehensive systematic search; treat the corpus above as provisional until subscription-database exports are added. `WebFetch` to external sites (ScienceDirect, Nature, Springer, PMC, arXiv, ERIC) returned HTTP 403 in this environment, so reference-list/backward-citation extraction for the 17 umbrella reviews could not be completed automatically — logged as a to-do per row in `search/umbrella_review_candidates.csv`.

## Next step

1. You run the subscription-database searches (Scopus/WoS/ERIC/PsycINFO/IEEE/ACM) using the strings in `search/search_strategy.md` and drop the exports in a new `search/exports/` folder — this is the biggest lever for corpus completeness.
2. Review the 17 "unsure" records in `screening/screening_log_template.csv` and the 23 "include" records — full-text retrieval and screening is the next AI-led step once you confirm scope.
3. Optionally: download PDFs for the highest-priority umbrella reviews (Ma & Adesope 2014; the 2025 K-12 ITS heterogeneity meta-analysis; the GenAI motivation/engagement meta-analysis) so AI can extract their reference lists for backward citation searching, since direct fetch is blocked from this environment.
