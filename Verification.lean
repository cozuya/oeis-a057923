import A057923

/- Independent statement checks: the seeds, literal greedy specification, and target. -/
namespace Verification

theorem seed_zero : A057923.a 0 = 0 := A057923.a_zero
theorem seed_one : A057923.a 1 = 2 := A057923.a_one

theorem greedy_minimum (n : Nat) :
    (A057923.a n ||| A057923.a (n + 1)) <
      (A057923.a (n + 1) ||| A057923.a (n + 2)) ∧
    ∀ m : Nat,
      (A057923.a n ||| A057923.a (n + 1)) < (A057923.a (n + 1) ||| m) →
      A057923.a (n + 2) ≤ m :=
  A057923.a_greedy n

theorem claimed_result (n : Nat) : A057923.a (n + 2) > A057923.a n :=
  A057923.two_step_strict n

end Verification

#print axioms Verification.seed_zero
#print axioms Verification.seed_one
#print axioms Verification.greedy_minimum
#print axioms Verification.claimed_result
