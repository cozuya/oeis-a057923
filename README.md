# A057923: Proof of Robert Israel's Two-Step Monotonicity Conjecture

**By Chris Ozols, with AI-assisted proof development and formalization.**

**Sequence:** Larry Reeves, October 3, 2000. **Conjecture:** Robert Israel,
August 13, 2017. These contributions are credited in
[OEIS A057923](https://oeis.org/A057923).

This repository proves that the greedy bitwise OR sequence **OEIS A057923** satisfies
**a(n + 2) > a(n) for every n >= 0**. Both its even-indexed and odd-indexed subsequences
are strictly increasing. The proof is verified with **Lean 4.35.0**, using only Lean's
standard library; Mathlib is not required.

[Formal proof](A057923.lean) ·
[Verification runs](https://github.com/cozuya/oeis-a057923/actions/workflows/verify.yml) ·
[Provenance](PROVENANCE.md) · [Prior-art audit](PRIOR_ART.md) · [Citation](CITATION.cff)

## Exact statement

Let $\lor$ denote bitwise OR on arbitrary-precision nonnegative integers. Define

```math
a_0=0,\qquad a_1=2,
```

and, for every integer $n\ge0$,

```math
a_{n+2}=\min\left\{m\in\mathbb{Z}_{\ge0}:
(a_{n+1}\lor m)>(a_n\lor a_{n+1})\right\}.
```

The minimum and the strict comparison use the usual numerical order. Values may
repeat; there is no unused-value condition or fixed word size. The initial terms are

```text
0, 2, 1, 4, 2, 5, 8, 6, 9, 16, 10, 17, 12, 18, 13, 32
```

**Theorem.** For every $n\ge0$, $a_{n+2}\gt a_n$.

## Proof

The greedy choice always exists. For any preceding pair $x,y$, take
$m=(x\lor y)+1$. Then
$(y\lor m)\ge m\gt(x\lor y)$.
The nonempty set of admissible natural numbers has a least member.

Let $m$ be the least admissible choice after $y$. It cannot share a set bit
with $y$: clearing such a bit from $m$ would give a smaller nonnegative
integer with exactly the same OR with $y$, contradicting minimality.
Every newly formed adjacent pair therefore has disjoint set bits. The initial
pair $0,2$ also has this property.

For nonnegative integers with disjoint set bits, OR equals addition: adding their
binary expansions produces no carries. Consequently, the inequality defining
each new term becomes

```math
a_{n+1}+a_{n+2}>a_n+a_{n+1}.
```

Cancelling $a_{n+1}$ proves $a_{n+2}\gt a_n$, including $n=0$. ∎

## Reproduce the verification

With Lean 4.35.0 and Python 3 installed, run:

```sh
python3 scripts/verify.py
```

If Lean is installed outside your PATH, set `LEAN` to the executable's path.
The script checks the exact compiler version and Git revision, compiles the proof
from source, and separately checks the seeds, greedy minimality, and final theorem
in [Verification.lean](Verification.lean). It rejects compiler warnings, errors,
missing axiom reports, and dependencies outside `propext`, `Classical.choice`, and
`Quot.sound`. In particular, a proof using `sorryAx` is rejected.

The output is `.build/verification.json` and `.build/verification.log`. The JSON
records the checked commit, source SHA-256 hashes, compiler identity, axiom
dependencies, and, when run on GitHub, the workflow URL, event and visibility.

The main result is `A057923.two_step_strict`:

```lean
theorem two_step_strict (n : Nat) : a n < a (n + 2) := by
  have h := (a_greedy n).1
  rw [or_eq_add_of_disjoint (adjacent_disjoint n),
    or_eq_add_of_disjoint (adjacent_disjoint (n + 1))] at h
  change a n + a (n + 1) < a (n + 1) + a (n + 2) at h
  omega
```

GitHub Actions repeats verification on pushes, pull requests, manual runs, and a
change from private to public. It downloads a checksum-pinned Lean release and
retains the verification report as a workflow artifact. Publication dates and
private development dates are recorded separately; see [PROVENANCE.md](PROVENANCE.md).

## Attribution and historical context

[OEIS A057923](https://oeis.org/A057923) credits the sequence to Larry Reeves
(October 3, 2000) and the monotonicity conjecture to Robert Israel
(August 13, 2017). Charlie Neder's October 12, 2018 update formula for the related
[A051145](https://oeis.org/A051145) is relevant prior art. This proof proceeds
directly from greedy minimality and does not assume that formula.
Israel's Maple search bound and the disjointness visible in Neder's formula are
closely related ingredients; their connection to this proof is explained in
[PRIOR_ART.md](PRIOR_ART.md#relationship-to-this-proof).

A bounded prior-art audit on October 15, 2026 located no earlier explicit
resolution or directly covering theorem in the sources searched. This repository
makes no claim of established worldwide priority. The scope and access limits
are in [PRIOR_ART.md](PRIOR_ART.md).

For attribution, use **Chris Ozols, _A057923: Proof of Robert Israel's Two-Step
Monotonicity Conjecture_**, with the version or commit you consulted.
Machine-readable metadata is in [CITATION.cff](CITATION.cff).

## Original working records

- [PROMPT.md](PROMPT.md): the solving prompt.
- [RESULTS.txt](RESULTS.txt): the returned proof, retained unchanged.
- [A057923.lean](A057923.lean): the formalization, retained unchanged from its first successful local verification.

Search terms: A057923; A051145; Robert Israel; Larry Reeves; Charlie Neder;
greedy bitwise OR sequence; two-step monotonicity; alternating subsequences;
Lean proof; Chris Ozols.
