# Prior-art status audit — October 15, 2026

This records the bounded historical-status investigation performed before the
solving attempt. Its verdict was **STILL LISTED CONJECTURAL; NO PRIOR RESOLUTION
LOCATED**. The proof subsequently obtained in this project is separate from that
historical finding. The search did not establish that nobody had proved it before.
The mathematical comparisons below were added during review after the solving
attempt; they are deductions from the cited sources, not earlier proof records.

## Statement and dates

The normalized greedy definition in the README matches [A057923](https://oeis.org/A057923),
its [internal record](https://oeis.org/A057923/internal), and Israel's Maple program.
Repeated values are allowed and the inequality is strict. The conjecture concerns
two-step, not consecutive, increase.

[A057923's history](https://oeis.org/history?seq=A057923) credits Larry Reeves with
the sequence on October 3, 2000. The earliest accessible snapshot inspected was
May 16, 2003 and already carried that attribution. Revision #5, dated August 13,
2017 at 15:52:14 EDT, adds Robert Israel's monotonicity conjecture. The sequence
date and conjecture date are distinct. All nine displayed revisions were inspected.

## Substantial related sources

- **Robert Israel, A057923 Maple program, August 13, 2017.** The search starts
  at `B[n-1] - A[n-1]`, which is `(x OR y) - y` for preceding terms `x, y`.
  Every admissible `m` satisfies `(x OR y) < (y OR m) <= y + m`, and therefore
  `m > (x OR y) - y`. The program starts at the lower bound and then tests the
  strict OR inequality. This bound is a closely related ingredient of the short
  proof, although the program supplies no adjacent-disjointness argument or
  explicit proof of two-step monotonicity.
  [Entry and program](https://oeis.org/A057923).
- **Charlie Neder, A051145, October 12, 2018.** The formula
  `u(k+2) = ((u(k) OR u(k+1)) + 1) AND NOT u(k+1)` appears in revision #17,
  approved October 19. All 28 displayed revisions were inspected. The formula is
  stated for the related sequence with seeds `0, 1`; no accompanying proof,
  linked proof, or explicit two-step monotonicity argument was located.
  [Entry](https://oeis.org/A051145),
  [formula history](https://oeis.org/history?seq=A051145&start=10).
- **jOEIS, Sean A. Irvine.** The formula occurs in a commit dated August 26, 2021.
  A commit dated July 12, 2022 parameterizes the seeds and adds the A057923 wrapper
  with seeds `0, 2`. The actual implementation, relevant file revisions, commit
  messages and available comments were inspected. No proof was found.
  These are Git dates; early public availability was not independently dated.
  [Pinned implementation](https://github.com/archmageirvine/joeis/blob/8a82c68a786fc49c380cab5f31daca3af7d6d704/src/irvine/oeis/a051/A051145.java),
  [wrapper](https://github.com/archmageirvine/joeis/blob/8a82c68a786fc49c380cab5f31daca3af7d6d704/src/irvine/oeis/a057/A057923.java).
- **Rémy Sigrist, C++ attachment under A244747.** OEIS linked the program on
  October 9, 2022. Its update uses `(pp + p + 1) & ~p` for the `0, 1` sequence
  while recording power-of-two occurrences. No explanatory proof is present.
  [Program](https://oeis.org/A244747/a244747_1.txt),
  [dated history](https://oeis.org/history?seq=A244747).
- **LODA, credited submitter Science United.** The earliest located file-history
  commit is dated August 18, 2024. Later formula-comment updates do not change the
  executable loop. All three file-history versions and the available discussion
  of PR #414 were inspected. GitHub records the PR's creation and merge on
  September 30, 2026. These server timestamps date the PR events; they do not
  independently establish when the initial 2024 file first became public.
  No proof was found.
  [Initial file](https://github.com/loda-lang/loda-programs/blob/349b415a24778d7b0103e2121a6ad057f9dae3f2/oeis/057/A057923.asm),
  [PR #414](https://github.com/loda-lang/loda-programs/pull/414).

The related [OR-value sequence A057924](https://oeis.org/A057924) and
[first power-of-two occurrence sequence A057925](https://oeis.org/A057925) were
also inspected. They supplied no resolution.

## Relationship to this proof

The `AND NOT y` in Neder's formula clears every bit supplied by the preceding
term `y`. If that formula generates the greedy sequence, successive terms have
disjoint set bits. With the initially disjoint seeds `0, 2`, this gives
`x OR y = x + y` for every adjacent pair. Israel's search bound then becomes
`m > (x OR y) - y = x`, exactly the target inequality.

Thus the older sources contain closely related ingredients from which a short
deduction is available. Neder's published formula is stated for seeds `0, 1`;
jOEIS applies it to `0, 2`, but the inspected sources provide no proof of that
application or explicit monotonicity argument. Combining those observations
now does not establish that the conjecture was explicitly resolved earlier.
The README and Lean proof establish disjointness directly from greedy minimality,
so they do not depend on assuming the update formula is correct.

The OEIS entry's `easy` keyword describes the ease of generating sequence terms;
it does not determine the status or difficulty of the conjecture.
[OEIS keyword definitions](https://oeis.org/wiki/Keywords#easy).

## Formalization and wider searches

The investigation searched identifiers, author names and descriptions of the
greedy bitwise OR construction. It included open, closed and merged PR searches,
and inspected actual definitions for promising matches.

- [trureturing at c5d73a7](https://github.com/the-omega-institute/trureturing/tree/c5d73a7ca13f94229870aeae5bbdc1f4b7f54f6d):
  tracked-path inventory; source/documentation searches under `D5`, `Problems`,
  `Library`, `Blueprint`, and `docs`; GitHub code and PR searches.
- [formal-conjectures at e750f77](https://github.com/google-deepmind/formal-conjectures/tree/e750f777b32aeae464c01809e0d223dd62e99fab):
  source and PR searches, including inspection of candidate OEIS bitwise statements.
- [openai/math at 1581d4c](https://github.com/openai/math/tree/1581d4cbdd69a0faf34b2089614fe2a814316a6a):
  tracked-path inventory, indexed default-branch code and PR searches, and
  inspection of candidate OR-related definitions. Not every file body was read.

No matching theorem was located. Broader searches included Lean, Isabelle,
Coq/Rocq, mathematical code and AI-discovery repositories, mathematical forums,
author references, papers and indexed SeqFan material. Apparent matches involving
XOR/Gray-code recurrences or other OR optimization problems had different definitions.

## Limits and computational checks

Direct SeqFan archive access failed. Individual OEIS revision-snapshot URLs also
failed intermittently, although aggregate histories and all seven requested
primary OEIS sources were eventually inspected. Search-engine and GitHub indexing
and result limits prevent an exhaustive negative conclusion. No contemporaneous
2000 capture was recovered.

A literal greedy implementation, Neder's update, and the LODA loop agreed with
published terms `a(0)` through `a(100)`; all 99 two-step inequalities in that prefix
held. The [published table](https://oeis.org/A057923/b057923.txt) extends through
index 10000; that entire range was not independently verified. This finite check
was for definition fidelity and is not the proof in this repository.
