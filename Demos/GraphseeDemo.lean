import Graphsee

set_option linter.unusedVariables false

set_option graphsee.edgeColours "vibrant"

/- Place cursor after 'by' or actionable steps -/

/- Basic relation chain -/
example
  (W : Type) (w1 w2 w3 : W)
  (R : W → W → Prop)
  (h1 : R w1 w2)
  (h2 : R w2 w3)
  (h3 : R w1 w3) : True := by
  trivial

/- Reflexive relation and goal visualisation -/
example
  (W : Type) (w1 : W)
  (R : W → W → Prop)
  (reflR : ∀ x : W, R x x)
  : R w1 w1 := by
  exact reflR w1

/- Witness with multiple properties -/
example
  (W : Type)
  (w u : W)
  (R : W → W → Prop)
  (P Q : W → Prop)
  (h1 : R w u)
  (h2 : P u)
  (h3 : Q u)
  : ∃ x, R w x ∧ P x ∧ Q x := by
  exact ⟨u, h1, h2, h3⟩

/- Transitive relation -/
example
  (W : Type) (w1 w2 w3 w4 : W)
  (R : W → W → Prop)
  (P : W → Prop)
  (trans : ∀ a b c : W, R a b → R b c → R a c)
  (h1 : R w1 w2)
  (h2 : R w2 w3)
  (h3 : R w3 w4)
  (hp : P w4)
  : ∃ x, R w1 x ∧ P x := by
  have h13 : R w1 w3 := trans w1 w2 w3 h1 h2
  have h14 : R w1 w4 := trans w1 w3 w4 h13 h3
  exact ⟨w4, h14, hp⟩

/- Different relations and different world types -/
example
  (W : Type) (w1 w2 w3 : W)
  (S : Type) (s1 s2 : S)
  (R1 : W → W → Prop)
  (R2: W → W → Prop)
  (S1 : S → S → Prop)
  (h1 : R1 w1 w2)
  (h2 : R2 w1 w3)
  (h3 : S1 s1 s2) : True := by
  trivial
