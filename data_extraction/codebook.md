# Data Extraction Codebook

One row in `extraction_template.csv` per **independent effect size** (a study contributing multiple outcomes, timepoints, or subsamples yields multiple rows sharing the same `study_id`, which is what makes the dependency structure explicit for the three-level model).

## Bibliographic / study identifiers

| Field | Description |
|---|---|
| `study_id` | Unique ID, e.g. `Author2023a` (letter suffix distinguishes multiple reports of one study) |
| `effect_id` | Unique row ID: `study_id` + sequence, e.g. `Author2023a_1` |
| `citation` | Full APA citation |
| `country` | Country/region of sample |
| `publication_type` | journal / conference / dissertation / preprint |
| `publication_year` | Year |

## PICOS / sample fields

| Field | Description |
|---|---|
| `education_level` | primary / secondary / higher_ed / mixed |
| `subject_domain` | e.g. math, language, science, general |
| `n_treatment` | Sample size, AI-intervention arm |
| `n_control` | Sample size, comparison arm |
| `age_mean` | Mean age if reported |
| `ai_intervention_type` | ITS / adaptive_learning / chatbot_conversational_agent / generative_AI_tool / automated_feedback_system / AI_assessment_personalization / other |
| `ai_intervention_description` | Free text, brief |
| `comparator_type` | business_as_usual / no_intervention / alternative_nonAI_edtech |
| `duration_weeks` | Intervention duration in weeks (convert from reported units) |
| `dosage_sessions` | Number/frequency of sessions if reported |
| `study_design` | RCT / quasi_experimental_pretest_posttest / quasi_experimental_posttest_only |
| `wwc_rating` | meets_standards / meets_with_reservations / does_not_meet |

## Outcome & effect size fields

| Field | Description |
|---|---|
| `outcome_family` | `cognitive` (Objective 1) or `noncognitive` (Objective 2) |
| `outcome_subtype` | cognitive: achievement / knowledge_gain / skill_acquisition / problem_solving / critical_thinking / retention. non-cognitive: motivation / engagement / self_efficacy / attitude / anxiety / self_regulation / satisfaction |
| `outcome_measure_name` | Name of instrument/test used |
| `outcome_timing` | posttest / follow_up |
| `stat_type_reported` | means_sd / t_value / f_value / correlation / p_exact |
| `mean_treatment`, `sd_treatment`, `mean_control`, `sd_control` | Raw stats if reported |
| `t_or_f_value` | If means/SDs unavailable |
| `es_metric` | Always `hedges_g` after conversion |
| `es_value` | Computed Hedges' g |
| `es_variance` | Computed sampling variance |

*(Effect size conversion performed in `analysis/scripts/01_data_prep.R` via `metafor::escalc()`, using whichever raw statistic is available per row.)*

## Objective 3 — moderator / mechanism fields

| Field | Description |
|---|---|
| `ai_adaptivity_level` | none_static / rule_based / ML_adaptive / generative_dynamic |
| `feedback_immediacy` | immediate / delayed / none |
| `personalization_level` | low / medium / high |
| `teacher_role` | replaced / supplemented / unchanged |
| `theoretical_mechanism` | scaffolding / personalization / immediate_feedback / motivational_design / adaptive_sequencing / cognitive_load_reduction / other — the mechanism the primary study proposes/tests as the explanation for effects |
| `mechanism_tested_or_assumed` | tested_empirically / assumed_theoretically |
| `implementation_fidelity` | high / medium / low / not_reported |

## Extraction QA

| Field | Description |
|---|---|
| `extracted_by` | `AI` (default) or PI initials if manually corrected |
| `pi_verified` | Y/N — whether PI independently re-extracted this row for the reliability check (~20% random sample) |
| `notes` | Any ambiguity, assumption made during extraction, or conversion detail |
