# Protocol: AI-Powered Meta-Analysis in Education

Status: **DRAFT — awaiting PI review/sign-off before search execution.** Written in PRISMA-P (Preferred Reporting Items for Systematic Review and Meta-Analysis Protocols) style so it can support PROSPERO registration if desired.

## 1. Title
AI-Powered Meta-Analysis in Education: Synthesizing the Effects of AI Interventions on Students' Learning Outcomes

## 2. Objectives / Research Questions

- **RQ1 (Objective 1):** What is the pooled effect of AI interventions on students' cognitive learning outcomes (e.g., academic achievement, knowledge acquisition, skill performance) compared to non-AI conditions?
- **RQ2 (Objective 2):** What is the pooled effect of AI interventions on students' non-cognitive learning outcomes (e.g., motivation, self-efficacy, engagement, attitudes, anxiety, self-regulation) compared to non-AI conditions?
- **RQ3 (Objective 3):** Which intervention-, sample-, and study-level factors moderate the effectiveness of AI interventions, and what mechanisms are proposed/tested to explain these effects?

## 3. Eligibility Criteria (PICOS)

| Element | Criteria (default — adjust to your scope) |
|---|---|
| **Population** | Students in formal education settings, PK–16 (primary, secondary, higher education). *Adjust if you want to restrict to e.g. only K-12, or only higher ed.* |
| **Intervention** | Any AI-based educational intervention: intelligent tutoring systems (ITS), adaptive learning platforms, AI-driven feedback/writing tools, conversational agents/chatbots (incl. generative AI such as ChatGPT used pedagogically), AI-powered assessment/personalization systems, learning-analytics-driven adaptive systems. Must involve a system with adaptive/automated decision-making (excludes plain digital tools with no AI component, e.g. static e-textbooks). |
| **Comparator** | Business-as-usual/traditional instruction, no-intervention control, or non-AI ed-tech alternative. |
| **Outcomes** | **Obj 1 (cognitive):** academic achievement, test/exam scores, knowledge gain, skill acquisition, problem-solving, critical thinking, retention/transfer. **Obj 2 (non-cognitive):** motivation, engagement, self-efficacy, attitudes toward subject/learning, anxiety, self-regulated learning, satisfaction, collaboration. **Obj 3:** moderator/mechanism variables coded across both outcome families (see `data_extraction/codebook.md`). |
| **Study design** | Experimental or quasi-experimental designs with a comparison/control group (RCT, quasi-RCT, pre-post with control), reporting sufficient statistics to compute or derive a standardized effect size (means+SDs+n, t/F values, correlations, or exact p-values with n). |
| **Timeframe** | Default 2012–2026 (captures the adaptive-learning and generative-AI era). *Adjust if a longer historical window is wanted.* |
| **Language** | English (documented limitation — non-English studies excluded, noted in limitations). |
| **Publication status** | Peer-reviewed journal articles, conference proceedings, and grey literature (dissertations/theses, preprints) to reduce publication bias, per PRISMA/Cochrane guidance. |

## 4. Information Sources

- Subscription databases (require your institutional access — see `search/search_strategy.md` for exact strings to run): Scopus, Web of Science, ERIC (EBSCO), PsycINFO (EBSCO/APA PsycNet), IEEE Xplore, ACM Digital Library.
- Open-access sources AI can search directly: Google Scholar (via web search), ERIC public interface, DOAJ, arXiv/EdArXiv/PsyArXiv preprint servers, OpenAlex/Semantic Scholar APIs.
- Supplementary: backward/forward citation chasing on included studies, hand-search of key journals (e.g., *Computers & Education*, *Journal of Educational Psychology*, *British Journal of Educational Technology*).

## 5. Search Strategy

See `search/search_strategy.md` for full Boolean strings. Concept blocks: (AI intervention terms) AND (education/student terms) AND (outcome terms) AND (study design filter, applied only as a sensitivity check, not as a hard limit at search stage).

## 6. Study Records

- **Data management:** all records logged in `screening/screening_log.csv` with a unique `study_id`; deduplication by DOI/title+year before screening.
- **Selection process:** AI performs title/abstract screening, then full-text screening, against Section 3 criteria, recording include/exclude + reason for every record. A ~20% random sample is independently checked by the PI; inter-rater agreement (Cohen's κ) reported.
- **Data collection process:** AI extracts data into `data_extraction/extraction_template.csv` per `data_extraction/codebook.md`. One row per independent effect size (studies contributing multiple outcomes/timepoints/samples get multiple rows, linked by `study_id` for dependency modeling).
- **Data items:** defined in the codebook — bibliographic info, PICOS fields, effect-size raw statistics, computed effect size (Hedges' g), and moderator/mechanism codes.

## 7. Risk of Bias / Study Quality

Assess each included study using criteria adapted from the **What Works Clearinghouse (WWC) Group Design Standards** (appropriate for the mixed RCT/quasi-experimental education literature expected here): random assignment, baseline equivalence, attrition, confounding, outcome measure reliability. Rating: Meets standards / Meets with reservations / Does not meet. Recorded per study in the extraction sheet; used as a candidate moderator and for sensitivity analysis (excluding low-quality studies).

## 8. Data Synthesis

- **Effect size metric:** Hedges' g (bias-corrected standardized mean difference), computed via `metafor::escalc()`.
- **Model:** Three-level random-effects meta-analysis (`metafor::rma.mv`) to account for effect sizes nested within studies (multiple outcomes/samples per study), with **robust variance estimation** (`clubSandwich::coef_test`) as a robustness check for the dependency structure. Separate models fit for Objective 1 (cognitive) and Objective 2 (non-cognitive) outcome subsets.
- **Heterogeneity:** I², τ² at each level, Q-test, 95% prediction interval.
- **Moderator analysis (Objective 3):** meta-regression (`mods = ~ moderator`) on intervention type, AI adaptivity level, feedback immediacy, duration/dosage, subject domain, grade band, study quality rating, and publication year; subgroup analyses for categorical moderators with sufficient k per subgroup (≥4 studies).
- **Publication bias:** funnel plot asymmetry, Egger's regression test, trim-and-fill, PET-PEESE sensitivity check.
- **Sensitivity analyses:** leave-one-out, restriction to "meets WWC standards" studies only, restriction to peer-reviewed only (vs. + grey literature).

## 9. Role of AI vs. Human (transparency statement)

AI (Claude) conducts search execution support, screening, data extraction, statistical modeling, and first-draft interpretation. The human researcher: sets/approves eligibility criteria and scope, independently verifies a random sample at screening and extraction stages, makes final judgment calls on ambiguous cases, and takes authorship responsibility for interpretation and conclusions. This division of labor should be reported explicitly in the dissertation's methods chapter for transparency (journals/committees increasingly require an AI-use disclosure statement).

## 10. Known Limitations to Disclose

- No institutional access to subscription databases from within this environment — search comprehensiveness depends on database exports you supply.
- English-language restriction.
- AI-based screening/extraction, while logged and spot-checked, is not equivalent to fully independent dual human review; report the verification sampling rate and agreement statistics as a reliability check.
