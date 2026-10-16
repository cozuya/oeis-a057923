# Provenance

**Chris Ozols** directs and maintains this work. Proof development and Lean
formalization were AI-assisted. Individual model names are not recorded.

## Working record

The status audit, solving prompt, returned proof, and first successful Lean check
were recorded during the October 15, 2026 work session in the America/Chicago
time zone. This is a description of private development, not a public publication
date. Repository preparation continued on October 16, 2026 UTC (still October 15
in Chicago).

The original working files are retained byte-for-byte. Their SHA-256 hashes are:

| File | SHA-256 |
| --- | --- |
| `PROMPT.md` | `a170aaeb2ef54db78b76b827917e1efed5a984b7f6cc20a839f0160da0f857ca` |
| `RESULTS.txt` | `0c2d9ab6d9de2fba2fb0ace83530176b527a09e9d1eff06c706d5bf218528ad6` |
| `A057923.lean` | `efb5c55660f08706c028d91ade203a42c57e32e0d3fb91fbb59deec5a509e5df` |

The README gives an edited presentation of the same proof. Its existence argument
uses the old OR value plus one as a witness, as does the Lean formalization.
The original returned proof uses a sufficiently large power of two. These are
two valid existence witnesses for the same greedy definition.

## Verification record

- Compiler: Lean **4.35.0**, Git revision
  `eb6cafb7290e8bd5f2937522d8d804f58f02bafc`.
- Dependencies: Lean's standard library only.
- Exact target: `A057923.two_step_strict`, asserting
  `a n < a (n + 2)` for every natural number `n`.
- Definitions: seeds `0, 2`; `next` is the least admissible natural number,
  with existence and minimality proved in the file.
- Axiom dependencies of the original theorem: `propext`, `Classical.choice`,
  `Quot.sound`. No `sorryAx` or custom axiom is used.
- Automated verification additionally checks the literal seeds and the full
  greedy inequality/minimality statement in `Verification.lean`.

Each successful workflow produces `verification.json` and `verification.log`.
The report identifies its commit, source hashes, compiler, theorem checks,
GitHub run, triggering event, and repository visibility at that run. The run URL
provides GitHub's server-side execution record. A report's own timestamp is not
an independent timestamp authority.

## Private preparation and public availability

This repository was initially created **private**. At initial preparation,
**no public-availability date is recorded**. Citation metadata deliberately omits
`date-released` while a public release is pending.

These records establish different facts:

| Record | What it establishes |
| --- | --- |
| Git author/committer date | A date stored in the commit; not independent evidence of public availability. |
| Repository creation or private Actions run | A server-side event during private development; not public publication. |
| GitHub `PublicEvent` and the workflow it triggers | A visibility change from private to public and a new verification run associated with that event. |
| Published immutable release | A fixed tag and assets, with an attestation tying the release to its commit and files. |

Making the repository public preserves its existing history. It does not turn
the earlier private dates into earlier public-publication dates. No record here
certifies worldwide first discovery.

## First public release

The initial `v1.0.0` release is prepared as a **draft** so its contents remain
reviewable. To publish later:

1. Make any revisions as new commits and obtain a successful verification run.
2. Change repository visibility to public when ready. The `public` workflow
   trigger will run verification again without needing a new code commit.
3. Record the visibility-change event/run URL and date, and update citation
   metadata with the actual public date. Do not substitute the private creation date.
4. Refresh the draft's target commit, source archive, verification report and
   SHA-256 manifest if the content changed. Publish the draft with release
   immutability enabled.

Keep a copy of the public event/run metadata with the release assets; event feeds
and Actions artifacts are not permanent archives. The draft's current assets are
a snapshot of the commit identified in its release notes, not an automatic mirror
of future commits.

GitHub documents [visibility changes](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/managing-repository-settings/setting-repository-visibility),
the [`public` workflow trigger](https://docs.github.com/en/actions/reference/workflows-and-actions/events-that-trigger-workflows#public),
and [immutable releases](https://docs.github.com/en/code-security/concepts/supply-chain-security/immutable-releases).
