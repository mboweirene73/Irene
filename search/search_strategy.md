# Search Strategy

Three concept blocks combined with AND; each block is an OR-list of terms/synonyms. A study design filter block is used only as a *sensitivity* filter, not applied at initial search (to avoid over-restricting recall).

## Concept blocks

**Block A — AI intervention:**
`"artificial intelligence" OR "machine learning" OR "intelligent tutoring system*" OR "adaptive learning" OR "adaptive learning system*" OR chatbot* OR "conversational agent*" OR "generative AI" OR ChatGPT OR "large language model*" OR "AI-based" OR "AI-powered" OR "AI-driven" OR "automated feedback" OR "learning analytics" OR "personalized learning system*"`

**Block B — Education/student population:**
`student* OR learner* OR pupil* OR education* OR classroom OR school* OR "higher education" OR university OR college OR K-12`

**Block C — Outcomes (run as two separate searches, or combined then split during screening):**
- *Cognitive (Objective 1):* `achievement OR "learning outcome*" OR performance OR "test score*" OR "academic achievement" OR knowledge OR "skill acquisition" OR comprehension OR "problem solving" OR "critical thinking"`
- *Non-cognitive (Objective 2):* `motivation OR engagement OR "self-efficacy" OR attitude* OR anxiety OR satisfaction OR "self-regulat*" OR "self-regulated learning" OR collaboration`

**Block D — Design filter (sensitivity only):**
`experiment* OR "randomized controlled trial" OR RCT OR "quasi-experiment*" OR "control group" OR intervention`

Recommendation: search with **A AND B AND (C-cognitive OR C-noncognitive)** to get one combined corpus, then split into Objective 1 / Objective 2 (and often both) during data extraction, since many primary studies report both outcome types.

## Per-database strings

### Scopus
```
TITLE-ABS-KEY(
  ("artificial intelligence" OR "machine learning" OR "intelligent tutoring system*" OR "adaptive learning" OR chatbot* OR "conversational agent*" OR "generative AI" OR ChatGPT OR "AI-based" OR "AI-powered" OR "AI-driven" OR "automated feedback" OR "learning analytics")
  AND (student* OR learner* OR education* OR classroom OR school* OR "higher education")
  AND (achievement OR "learning outcome*" OR performance OR motivation OR engagement OR "self-efficacy" OR attitude* OR anxiety OR "self-regulat*")
)
AND PUBYEAR > 2011 AND PUBYEAR < 2027
AND LANGUAGE(english)
```

### Web of Science (Topic search, TS=)
```
TS=(("artificial intelligence" OR "machine learning" OR "intelligent tutoring system*" OR "adaptive learning" OR chatbot* OR "conversational agent*" OR "generative AI" OR ChatGPT OR "AI-based" OR "AI-powered")
AND (student* OR learner* OR education* OR classroom OR school*)
AND (achievement OR "learning outcome*" OR performance OR motivation OR engagement OR "self-efficacy" OR attitude* OR anxiety))
Refined by: Years = 2012-2026, Language = English
```

### ERIC (EBSCOhost) / PsycINFO (EBSCOhost)
```
AB ( ("artificial intelligence" OR "machine learning" OR "intelligent tutoring system*" OR "adaptive learning" OR chatbot* OR "conversational agent*" OR "generative AI" OR ChatGPT OR "AI-based" OR "AI-powered")
AND (student* OR learner* OR education* OR classroom OR school*)
AND (achievement OR "learning outcome*" OR performance OR motivation OR engagement OR "self-efficacy" OR attitude* OR anxiety) )
Limiters: Publication Date 2012-2026; English
```

### IEEE Xplore
```
("Abstract":"artificial intelligence" OR "Abstract":"intelligent tutoring system" OR "Abstract":"adaptive learning" OR "Abstract":"chatbot" OR "Abstract":"generative AI")
AND ("Abstract":"student" OR "Abstract":"education" OR "Abstract":"learning outcome")
```

### ACM Digital Library
```
[Abstract: "artificial intelligence"] OR [Abstract: "intelligent tutoring system"] OR [Abstract: "adaptive learning"] OR [Abstract: "chatbot"] OR [Abstract: "generative ai"]
AND [Abstract: student] AND [Abstract: "learning outcome" OR achievement OR motivation OR engagement]
```

### Open-web search (AI-executable directly — no login required)
Use `WebSearch` with queries such as:
- `AI intervention student achievement meta-analysis education`
- `intelligent tutoring system learning outcomes randomized controlled trial`
- `generative AI ChatGPT student motivation engagement study`
- `adaptive learning system effect size academic achievement`
- site-restricted: `site:eric.ed.gov AI tutoring student achievement`
- preprints: `site:arxiv.org OR site:edarxiv.org AI education learning outcomes`

Log every query run + date + number of hits in `search/search_log.csv`.

## Search log

See `search/search_log_template.csv` — one row per database/query combination, recording: date run, database, exact string, filters applied, number of hits, exported filename.
