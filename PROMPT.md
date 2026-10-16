# Solve the exact greedy bitwise-OR monotonicity problem

Find a complete, rigorous proof or a counterexample to the conjecture below. This is a solving task. Work independently and aim to finish in one response. Seek the shortest sound argument; the historical word “conjecture” is not evidence that the problem is difficult or currently open.

## Exact definition

For nonnegative integers, let `OR` denote bitwise OR using ordinary finite binary expansions, with arbitrary precision and no fixed word-size truncation.

Define

\[
a_0=0,\qquad a_1=2,
\]

and, for every integer \(n\ge 0\),

\[
a_{n+2}=\min\left\{m\in\mathbb Z_{\ge0}:
(a_{n+1}\operatorname{OR}m)>
(a_n\operatorname{OR}a_{n+1})\right\}.
\]

The minimum is in the usual numerical order. The comparison `>` is also the usual numerical comparison, not containment of sets of bits. Terms may repeat: there is **no** requirement to choose a value that has not appeared before.

Prove or disprove:

\[
\boxed{a_{n+2}>a_n\quad\text{for every integer }n\ge0.}
\]

Equivalently, the even-indexed and odd-indexed subsequences are each strictly increasing. The claim does **not** say that consecutive terms increase.

For checking the interpretation, the first terms are

```text
0, 2, 1, 4, 2, 5, 8, 6, 9, 16, 10, 17, 12, 18, 13, 32,
14, 33, 16, 34, 17, 36, 18, 37
```

## What constitutes a solution

- Establish that the greedy choice is well defined, and cover the initial cases as well as all later indices.
- Give a self-contained argument from the definition. State any essential lemma precisely and prove it. If you introduce an invariant, establish its base case and preservation without assuming the desired conclusion.
- Justify every replacement of a bitwise expression by an ordinary arithmetic expression. In particular, do not assume that OR with a fixed integer preserves numerical order.
- If you use a faster update rule, establish that it selects the actual least admissible integer. Matching a finite prefix does not establish this equivalence.
- A disproof must identify an index and justify the relevant greedy choices, including minimality. Report the earliest failing index if you can establish it.
- Computation may help explore or check an argument, but finite verification cannot prove the universal assertion. Formalization is optional; a clear elementary proof is sufficient.

Prefer a direct structural argument over a large computational search. Avoid introducing a stronger theorem unless it simplifies the proof of this exact target. Once the proof is complete, stop rather than adding speculative extensions.

## Historical context and an optional published lead

This sequence is OEIS A057923, credited to Larry Reeves on October 3, 2000. Its two-step monotonicity conjecture is credited to Robert Israel on August 13, 2017. A separate status audit on October 15, 2026 located no prior explicit resolution or directly covering theorem in the searched sources. That is a bounded search result, **not** a claim that the conjecture is unsolved or that a solution would be new.

For the related sequence A051145, whose seeds are \(0,1\), Charlie Neder published the update formula

\[
u_{k+2}=\bigl((u_k\operatorname{OR}u_{k+1})+1\bigr)
\operatorname{AND}\operatorname{NOT}u_{k+1}.
\]

Here `C AND NOT y` means clearing from the nonnegative integer `C` every bit that is set in `y`; it does not require choosing a finite word width. The jOEIS implementation also uses this expression with seeds \(0,2\). The inspected sources supplied no accompanying proof of the update rule or of the target monotonicity.

You may use this as a lead, but do not assume its correctness, its applicability to other seeds, or that it already constitutes a historical proof of the conjecture. A direct proof that does not need the formula is equally welcome.

References, if useful:

- Exact sequence and conjecture: https://oeis.org/A057923
- Related sequence and Neder's formula: https://oeis.org/A051145
- Published term table: https://oeis.org/A057923/b057923.txt
- Version-pinned implementation of the update: https://github.com/archmageirvine/joeis/blob/8a82c68a786fc49c380cab5f31daca3af7d6d704/src/irvine/oeis/a051/A051145.java

The mathematical problem above is self-contained; browsing is unnecessary for solving it. Do not contact anyone, post a solution, submit an OEIS revision, or modify external resources.

## Final response

Start with **PROVED**, **DISPROVED**, or **INCOMPLETE**, according to what you actually establish. Then present the complete proof or counterexample in an auditable order. Identify any reliance on the published lead separately from deductions made in your response, and make no unsupported novelty claim. If incomplete, state the precise remaining gap rather than treating evidence or a plausible invariant as a proof.
