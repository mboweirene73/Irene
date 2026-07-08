"""
Ad hoc meta-analysis of the primary studies the PI uploaded to raw_papers/.

R's metafor/clubSandwich could not be installed in this sandbox (CRAN is not
reachable through the environment's outbound proxy), so this follows the
task's Python fallback. Effect-size and heterogeneity formulas replicate
metafor::escalc(measure="SMD") and a standard DerSimonian-Laird random-effects
model; the pooled SE additionally gets a cluster-robust (sandwich) correction
clustering by study, since three of the four studies contribute more than one
dependent effect size (shared treatment/control samples).
"""
import csv
import math
from pathlib import Path

import numpy as np
from scipy import stats
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

ROOT = Path(__file__).resolve().parents[2]
IN_CSV = ROOT / "data_extraction" / "extraction_template.csv"
OUT_DIR = ROOT / "results" / "uploaded_papers"
OUT_DIR.mkdir(parents=True, exist_ok=True)


def hedges_g(n1, n2, m1, sd1, m2, sd2):
    df = n1 + n2 - 2
    sd_pooled = math.sqrt(((n1 - 1) * sd1**2 + (n2 - 1) * sd2**2) / df)
    d = (m1 - m2) / sd_pooled
    J = 1 - 3 / (4 * df - 1)
    g = J * d
    var_d = (n1 + n2) / (n1 * n2) + d**2 / (2 * (n1 + n2))
    var_g = J**2 * var_d
    return g, var_g


rows = []
with open(IN_CSV, newline="", encoding="utf-8") as f:
    for row in csv.DictReader(f):
        n1, n2 = int(row["n_treatment"]), int(row["n_control"])
        m1, sd1 = float(row["mean_treatment"]), float(row["sd_treatment"])
        m2, sd2 = float(row["mean_control"]), float(row["sd_control"])
        g, vg = hedges_g(n1, n2, m1, sd1, m2, sd2)
        rows.append({
            "effect_id": row["effect_id"],
            "study_id": row["study_id"],
            "outcome_subtype": row["outcome_subtype"],
            "n1": n1, "n2": n2,
            "g": g, "v": vg, "se": math.sqrt(vg),
        })

k = len(rows)
clusters = sorted(set(r["study_id"] for r in rows))
m = len(clusters)

yi = np.array([r["g"] for r in rows])
vi = np.array([r["v"] for r in rows])

# --- Fixed-effect pass to get Q and DerSimonian-Laird tau^2 ---
wi_fe = 1 / vi
y_fe = np.sum(wi_fe * yi) / np.sum(wi_fe)
Q = np.sum(wi_fe * (yi - y_fe) ** 2)
df_Q = k - 1
c = np.sum(wi_fe) - np.sum(wi_fe**2) / np.sum(wi_fe)
tau2 = max(0.0, (Q - df_Q) / c)
I2 = max(0.0, (Q - df_Q) / Q) * 100 if Q > 0 else 0.0

# --- Random-effects pooling ---
wi_re = 1 / (vi + tau2)
y_re = np.sum(wi_re * yi) / np.sum(wi_re)
se_naive = math.sqrt(1 / np.sum(wi_re))

# --- Cluster-robust (sandwich) SE for the pooled mean, clustering by study ---
# Standard CR1-type sandwich variance for a weighted-least-squares intercept.
resid_contrib = wi_re * (yi - y_re)
cluster_sums = {c_: 0.0 for c_ in clusters}
for r, rc in zip(rows, resid_contrib):
    cluster_sums[r["study_id"]] += rc
robust_var = sum(v**2 for v in cluster_sums.values()) / (np.sum(wi_re) ** 2)
se_robust = math.sqrt(robust_var)

df_robust = m - 1  # standard RVE small-sample df (# clusters - 1, intercept-only model)
tcrit = stats.t.ppf(0.975, df_robust)
ci_lo, ci_hi = y_re - tcrit * se_robust, y_re + tcrit * se_robust
t_stat = y_re / se_robust
p_robust = 2 * (1 - stats.t.cdf(abs(t_stat), df_robust))

print("=== Effect sizes (Hedges' g) ===")
for r in rows:
    print(f"{r['effect_id']:<20s} outcome={r['outcome_subtype']:<15s} "
          f"n1={r['n1']:<3d} n2={r['n2']:<3d} g={r['g']:.3f}  SE={r['se']:.3f}")

print(f"\nk = {k} effect sizes from m = {m} independent studies")
print(f"Q({df_Q}) = {Q:.3f}, tau^2 (DL) = {tau2:.4f}, I^2 = {I2:.1f}%")
print(f"\nPooled Hedges' g (random-effects) = {y_re:.3f}")
print(f"  naive SE (ignoring dependency)     = {se_naive:.3f}")
print(f"  cluster-robust SE (clustered by study, df={df_robust}) = {se_robust:.3f}")
print(f"  95% CI (robust, t-dist df={df_robust}) = [{ci_lo:.3f}, {ci_hi:.3f}]")
print(f"  t = {t_stat:.3f}, p = {p_robust:.4f}")

# --- Prediction interval (naive, using tau^2 + naive between-study variance) ---
pi_se = math.sqrt(se_naive**2 + tau2)
tcrit_pi = stats.t.ppf(0.975, max(k - 2, 1))
pi_lo, pi_hi = y_re - tcrit_pi * pi_se, y_re + tcrit_pi * pi_se
print(f"  approx. 95% prediction interval = [{pi_lo:.3f}, {pi_hi:.3f}]")

with open(OUT_DIR / "meta_analysis_summary.txt", "w") as f:
    f.write("Ad hoc meta-analysis of uploaded primary studies\n")
    f.write("=" * 50 + "\n\n")
    f.write("Effect sizes (Hedges' g):\n")
    for r in rows:
        f.write(f"{r['effect_id']:<20s} outcome={r['outcome_subtype']:<15s} "
                f"n1={r['n1']:<3d} n2={r['n2']:<3d} g={r['g']:.3f}  SE={r['se']:.3f}\n")
    f.write(f"\nk = {k} effect sizes from m = {m} independent studies "
            f"({', '.join(clusters)})\n")
    f.write(f"Q({df_Q}) = {Q:.3f}, tau^2 (DerSimonian-Laird) = {tau2:.4f}, I^2 = {I2:.1f}%\n\n")
    f.write(f"Pooled Hedges' g (random-effects) = {y_re:.3f}\n")
    f.write(f"Naive SE (ignoring within-study dependency) = {se_naive:.3f}\n")
    f.write(f"Cluster-robust SE (clustered by study, df={df_robust}) = {se_robust:.3f}\n")
    f.write(f"95% CI (robust) = [{ci_lo:.3f}, {ci_hi:.3f}]\n")
    f.write(f"t({df_robust}) = {t_stat:.3f}, p = {p_robust:.4f}\n")
    f.write(f"Approx. 95% prediction interval = [{pi_lo:.3f}, {pi_hi:.3f}]\n")

# ---------------- Forest plot ----------------
fig, ax = plt.subplots(figsize=(9, 0.55 * (k + 3) + 1))
labels = [f"{r['effect_id']} ({r['outcome_subtype']})" for r in rows][::-1]
g_vals = yi[::-1]
se_vals = np.sqrt(vi)[::-1]
ypos = np.arange(1, k + 1)

for i, (g, se) in enumerate(zip(g_vals, se_vals)):
    ax.plot([g - 1.96 * se, g + 1.96 * se], [ypos[i], ypos[i]], color="black", lw=1.2)
    ax.plot(g, ypos[i], "s", color="steelblue", markersize=7)

ax.set_yticks(ypos)
ax.set_yticklabels(labels, fontsize=9)
ax.axvline(0, color="grey", linestyle=":", lw=1)

# pooled diamond at the top
diamond_y = k + 1.5
half_width = 1.96 * se_robust
diamond = plt.Polygon(
    [(y_re - half_width, diamond_y), (y_re, diamond_y + 0.35),
     (y_re + half_width, diamond_y), (y_re, diamond_y - 0.35)],
    closed=True, color="firebrick",
)
ax.add_patch(diamond)
ax.axhline(k + 0.7, color="grey", lw=0.8)
ax.set_yticks(list(ypos) + [diamond_y])
ax.set_yticklabels(labels + [f"Pooled RE (robust 95% CI), g={y_re:.2f}"], fontsize=9)
ax.set_ylim(0, k + 2.3)
ax.set_xlabel("Hedges' g (favors AI intervention →)")
ax.set_title("Forest plot: AI interventions vs. control on student learning outcomes")
fig.tight_layout()
fig.savefig(OUT_DIR / "forest_plot.png", dpi=150)
plt.close(fig)

# ---------------- Funnel plot ----------------
fig2, ax2 = plt.subplots(figsize=(6.5, 6))
se_all = np.sqrt(vi)
ax2.scatter(yi, se_all, color="steelblue", edgecolor="black", zorder=3)
max_se = se_all.max() * 1.15
se_range = np.linspace(0, max_se, 100)
ax2.plot(y_re - 1.96 * se_range, se_range, color="grey", lw=1, linestyle="--")
ax2.plot(y_re + 1.96 * se_range, se_range, color="grey", lw=1, linestyle="--")
ax2.axvline(y_re, color="firebrick", lw=1)
ax2.invert_yaxis()
ax2.set_xlabel("Hedges' g")
ax2.set_ylabel("Standard error")
ax2.set_title(f"Funnel plot (k={k} effect sizes, m={m} studies — too few for a\nformal publication-bias test)")
fig2.tight_layout()
fig2.savefig(OUT_DIR / "funnel_plot.png", dpi=150)
plt.close(fig2)

print(f"\nSaved: {OUT_DIR / 'forest_plot.png'}")
print(f"Saved: {OUT_DIR / 'funnel_plot.png'}")
print(f"Saved: {OUT_DIR / 'meta_analysis_summary.txt'}")
