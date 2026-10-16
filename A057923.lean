import Std
import Init.Data.Nat.Bitwise.Lemmas

/-!
# OEIS A057923: strict increase along each parity subsequence

This formalizes the proof in RESULTS.txt directly from the least-admissible-integer
definition. All numbers are unbounded naturals. No explicit update formula is assumed.
Only Lean's standard library is used; Mathlib is not required.
-/

namespace A057923

/-- The new term is admissible and no admissible natural number is smaller. -/
def IsNext (x y m : Nat) : Prop :=
  (x ||| y) < (y ||| m) ∧ ∀ k, (x ||| y) < (y ||| k) → m ≤ k

/-- A nonempty set of natural numbers has a least member. -/
private theorem exists_least (p : Nat → Prop) (hp : ∃ n, p n) :
    ∃ m, p m ∧ ∀ k, p k → m ≤ k := by
  classical
  obtain ⟨n, hn⟩ := hp
  suffices ∀ n, p n → ∃ m, p m ∧ ∀ k, p k → m ≤ k from this n hn
  intro n
  induction n using Nat.strongRecOn with
  | ind n ih =>
    intro hn
    by_cases h : ∃ k, k < n ∧ p k
    · obtain ⟨k, hkn, hk⟩ := h
      exact ih k hkn hk
    · refine ⟨n, hn, ?_⟩
      intro k hk
      by_cases hkn : k < n
      · exact False.elim (h ⟨k, hkn, hk⟩)
      · omega

/-- Admissibility is always possible: the old OR value plus one suffices. -/
theorem exists_next (x y : Nat) : ∃ m, IsNext x y m := by
  apply exists_least (fun m => (x ||| y) < (y ||| m))
  exact ⟨(x ||| y) + 1,
    Nat.lt_of_lt_of_le (Nat.lt_succ_self _) Nat.right_le_or⟩

/-- The literal greedy choice, with existence proved above. -/
noncomputable def next (x y : Nat) : Nat :=
  Classical.choose (exists_next x y)

theorem next_spec (x y : Nat) : IsNext x y (next x y) :=
  Classical.choose_spec (exists_next x y)

/-- Remove from `m` every bit already supplied by `y`. -/
private def clear (m y : Nat) : Nat :=
  Nat.bitwise (fun b c => b && !c) m y

private theorem clear_le (m y : Nat) : clear m y ≤ m := by
  apply Nat.le_of_testBit
  intro i h
  have hh : m.testBit i = true ∧ y.testBit i = false := by
    simpa [clear, Nat.testBit_bitwise] using h
  exact hh.1

private theorem or_clear (y m : Nat) : y ||| clear m y = y ||| m := by
  apply Nat.eq_of_testBit_eq
  intro i
  simp only [Nat.testBit_or, clear,
    Nat.testBit_bitwise (f := fun b c => b && !c) (by rfl)]
  cases y.testBit i <;> cases m.testBit i <;> rfl

private theorem and_clear (y m : Nat) : y &&& clear m y = 0 := by
  apply Nat.eq_of_testBit_eq
  intro i
  simp only [Nat.testBit_and, clear,
    Nat.testBit_bitwise (f := fun b c => b && !c) (by rfl), Nat.zero_testBit]
  cases y.testBit i <;> cases m.testBit i <;> rfl

/-- Minimality forces the new term to have no set bit in common with its predecessor. -/
theorem next_disjoint (x y : Nat) : y &&& next x y = 0 := by
  have hs := next_spec x y
  have hle : next x y ≤ clear (next x y) y :=
    hs.2 _ (by rw [or_clear]; exact hs.1)
  have heq : next x y = clear (next x y) y :=
    Nat.le_antisymm hle (clear_le _ _)
  calc
    y &&& next x y = y &&& clear (next x y) y := congrArg (fun m => y &&& m) heq
    _ = 0 := and_clear _ _

/-- The usual binary identity, proved here so no extra library is needed. -/
private theorem or_add_and (x y : Nat) : (x ||| y) + (x &&& y) = x + y := by
  induction x using Nat.div2Induction generalizing y with
  | ind x ih =>
    by_cases hx : x = 0
    · simp [hx]
    have h := ih (Nat.pos_of_ne_zero hx) (y / 2)
    have hor := Nat.mod_add_div (x ||| y) 2
    have hand := Nat.mod_add_div (x &&& y) 2
    rw [show (x ||| y) % 2 = (x % 2 ||| y % 2) from
      Nat.or_mod_two_pow (n := 1), Nat.or_div_two] at hor
    rw [show (x &&& y) % 2 = (x % 2 &&& y % 2) from
      Nat.and_mod_two_pow (n := 1), Nat.and_div_two] at hand
    rcases Nat.mod_two_eq_zero_or_one x with hx | hx <;>
      rcases Nat.mod_two_eq_zero_or_one y with hy | hy <;>
      simp [hx, hy] at hor hand <;> omega

theorem or_eq_add_of_disjoint {x y : Nat} (h : x &&& y = 0) : x ||| y = x + y := by
  have hsum := or_add_and x y
  simpa [h] using hsum

/-- The exact sequence: seeds 0, 2, followed by the least admissible choice. -/
noncomputable def a : Nat → Nat
  | 0 => 0
  | 1 => 2
  | n + 2 => next (a n) (a (n + 1))

@[simp] theorem a_zero : a 0 = 0 := rfl
@[simp] theorem a_one : a 1 = 2 := rfl

theorem a_greedy (n : Nat) : IsNext (a n) (a (n + 1)) (a (n + 2)) :=
  next_spec _ _

theorem adjacent_disjoint : ∀ n, a n &&& a (n + 1) = 0
  | 0 => rfl
  | n + 1 => next_disjoint (a n) (a (n + 1))

/-- Robert Israel's exact conjecture, including n = 0. -/
theorem two_step_strict (n : Nat) : a n < a (n + 2) := by
  have h := (a_greedy n).1
  rw [or_eq_add_of_disjoint (adjacent_disjoint n),
    or_eq_add_of_disjoint (adjacent_disjoint (n + 1))] at h
  change a n + a (n + 1) < a (n + 1) + a (n + 2) at h
  omega

end A057923

#print axioms A057923.two_step_strict
