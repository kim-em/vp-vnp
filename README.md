# VP ≠ VNP over every field (fork)

This repository is a fork of the `vp-vnp` folder of Anthropic's
https://github.com/anthropics/formal-math, taken at commit
[`918c8e2`](https://github.com/anthropics/formal-math/tree/918c8e2778aee18b0283dc5a33ed39ab3cd63a96/vp-vnp)
(merged in https://github.com/anthropics/formal-math/pull/51). The Lean code and the paper are
Copyright 2026 Anthropic, PBC, and are used here under the Apache License, Version 2.0; see
[LICENSE](LICENSE) and [NOTICE](NOTICE). This fork is not affiliated with or endorsed by Anthropic.

The first commit of this repository is the upstream folder exactly as published: its git tree hash
is `b076b4b081298c4e909bac3f87f0e4462d1fb2cb`, the same as `918c8e2:vp-vnp` upstream.

## Changes from upstream

Every change is in the git history after the first commit. In summary:

- This README. The upstream README follows below, unchanged.
- The toolchain is moved to Lean `v4.37.0-rc1` and Mathlib `v4.37.0-rc1`, with the proof adapted to
  the Mathlib changes (31 files, 81 lines). The only change to `Statement.lean` is notational:
  Mathlib removed the function `MvPolynomial.coeff m p`, so `coeff d q` is written `q.coeff d`.
  `Challenge.lean`, `Solution.lean` and `comparator.json` are unchanged.
- Continuous integration that builds the project and checks the proof with independent kernels;
  see [.github/workflows/ci.yml](.github/workflows/ci.yml).
- A Lake cache of the project's build, fetched with `lake exe cache get`: the `cache` executable
  and `[cache]` table in `lakefile.toml`, and `scripts/Cache.lean` and `scripts/cache-get.sh`.

### Continuous integration

On every push and pull request, CI:

- builds the project with `lake build`, and fails on any `sorry` outside `Challenge.lean`;
- runs `scripts/PrintAxioms.lean` and fails if any of the five theorems uses an axiom other than
  `propext`, `Classical.choice` and `Quot.sound`;
- exports the five theorems of `comparator.json`, with everything they depend on, from `Challenge`
  and from `Solution`, using the toolchain's `leanexport`;
- checks the two exports with `--compare` in two independent kernels,
  [con-leche](https://github.com/leanprover/con-leche) and
  [con-ron](https://github.com/leanprover/con-ron). Each must accept, with exactly the five theorems
  of `comparator.json` justified by the solution and no axioms beyond the three above;
- checks the `Solution` export with the toolchain's `nanoda_bin`.

On a push to `main`, CI also publishes the build to the cache below.

### Cache

A full build takes about 50 CPU-minutes on top of Mathlib (11 minutes on a 4-core CI runner). To
download a build instead:

```bash
lake exe cache get
lake build --no-build
```

This fetches Mathlib's cache and then this project's `.olean` files, built by CI for the current
commit (or its nearest ancestor with a published build). A full build makes Lean check every proof
on your machine. The cache downloads files that were compiled elsewhere, so Lean does not
re-check the proofs.

---

# VP ≠ VNP over every field

For every field, circuits for the Hamiltonian cycle polynomial, and for the permanent outside characteristic 2, need more than m^(c (log m)^(1/3)) gates for all large m. The same holds for approximating circuits. So VP is a proper subset of VNP, and VNP is not contained in the closure of VP. This does not settle P vs NP.

The result was discovered by an internal research Claude model. This folder holds the paper and its Lean 4 formalization. Both were written by AI models, and no human mathematician has checked the proof.

Research artifact. Not maintained and not accepting contributions.

## Paper

**[paper.pdf](paper.pdf)**: *VP ≠ VNP over every field*, by Claude (Anthropic). The full proof is its appendix.

## Lean proof

**1. Read the statement.** [Statement.lean](Statement.lean) states all of the above and imports only Mathlib. Lean checks the proofs, but no machine checks that this file says what is claimed. Appendix Q of [paper.pdf](paper.pdf) lists the Lean counterparts of the numbered statements (Table 3) and says where they differ.

**2. Check the proofs.** With [elan](https://github.com/leanprover/elan) installed, in this folder:

    lake exe cache get
    lake build
    lake env lean scripts/PrintAxioms.lean

The build prints sorry warnings from Challenge.lean only, which states the theorems without proofs for the fuller check. The last command should name no axiom other than propext, Classical.choice and Quot.sound.

The fuller check is the one this repository's CI runs, bash ../.github/scripts/comparator-check.sh (Linux): Comparator compares the statements with Challenge.lean and re-checks the proofs with a second, independently written kernel, nanoda.

## License

Apache 2.0; see [LICENSE](LICENSE) and [NOTICE](NOTICE).
