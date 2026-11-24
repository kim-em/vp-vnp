/-
`lake exe cache get`: runs scripts/cache-get.sh, which fetches Mathlib's cache and then this
project's build outputs.
-/
def main (args : List String) : IO UInt32 := do
  let child ← IO.Process.spawn { cmd := "bash", args := #["scripts/cache-get.sh"] ++ args.toArray }
  child.wait
