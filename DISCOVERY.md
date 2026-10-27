# A057923 — proof available for Robert Israel's two-step monotonicity conjecture

**Result:** A Lean-verified proof is available that the greedy bitwise-OR sequence
[OEIS A057923](https://oeis.org/A057923) satisfies **a(n+2) > a(n)** for every
nonnegative integer n. In particular, the even-indexed and odd-indexed
subsequences are strictly increasing.

**Historical status:** A bounded, AI-assisted search of the sources described
in [PRIOR_ART.md](PRIOR_ART.md) found no previous explicit proof. **No claim
of novelty, first discovery, historical priority, or an official update to
the OEIS entry is made.** This page exists so that people independently
investigating the problem can find and check a proof.

**Original problem:** Robert Israel's conjecture added to Larry Reeves'
sequence A057923 in 2017 (not a conjecture that consecutive terms increase).
The underlying sequence starts 0, 2 and repeatedly chooses the smallest
nonnegative integer m such that (previous term OR m) exceeds (previous two
terms OR one another). See [README.md](README.md#exact-statement) for the
fully specified recurrence and precise theorem.

**Proof in brief:** Greedy minimality forces successive terms to have
disjoint set bits. For a disjoint adjacent pair, bitwise OR equals addition,
and the recurrence's strict inequality reduces to a(n+2) > a(n).

**How to check:** [Lean proof](A057923.lean) ·
[Exact-statement verification](Verification.lean) ·
[GitHub Actions verification runs](https://github.com/cozuya/oeis-a057923/actions/workflows/verify.yml) ·
[Reproduction instructions](README.md#reproduce-the-verification) ·
[Prior-art audit](PRIOR_ART.md) · [Provenance](PROVENANCE.md).

The proof is checked with Lean 4.35.0 using Lean's standard library.
The audited declarations use only Lean's standard foundational axioms,
as documented in the README.

**Search names:** OEIS A057923; Robert Israel's two-step monotonicity conjecture;
A057923 a(n+2) > a(n); Larry Reeves greedy bitwise OR sequence;
A051145 related bitwise-OR formula; Lean formalization of A057923.

Repository: https://github.com/cozuya/oeis-a057923

Overview page: https://cozuya.github.io/proofs/oeis-a057923/
