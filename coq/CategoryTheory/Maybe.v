(*******************************************)
(*******************************************)
(****                                   ****)
(****   A proof that maybe is a monad   ****)
(****                                   ****)
(*******************************************)
(*******************************************)

Require Import FunctionalExtensionality.
Require Import Main.CategoryTheory.Functor.
Require Import Main.CategoryTheory.Monad.
Require Import Main.CategoryTheory.NaturalTransformation.
Require Import Main.CategoryTheory.Set.
Require Import Main.Tactics.

(* A maybe is a wrapper for value that might be missing. *)

Inductive maybe {x : Set} : Set :=
| nothing : @maybe x
| just : x -> @maybe x.

(* Here is a proof that maybe is a functor. *)

Definition maybeFunctor : @functor setCategory setCategory.
Proof.
  refine (
    newFunctor setCategory setCategory
    (@maybe)
    (fun x y f e =>
      match e with
      | nothing => nothing
      | just e => just (f e)
      end
    )
    _ _
  ); clean; apply functional_extensionality; intro; destruct x0; magic.
Defined.

(* This is the "return" natural transformation for maybe. *)

Definition maybeEta :
  @naturalTransformation setCategory setCategory idFunctor maybeFunctor.
Proof.
  refine (
    newNaturalTransformation setCategory setCategory idFunctor maybeFunctor
    (@just)
    _
  ).
  magic.
Defined.

(* This is the "join" natural transformation for maybe. *)

Definition maybeMu :
  @naturalTransformation
    setCategory
    setCategory
    (compFunctor maybeFunctor maybeFunctor)
    maybeFunctor.
Proof.
  refine (
    newNaturalTransformation
      setCategory
      setCategory
      (compFunctor maybeFunctor maybeFunctor)
      maybeFunctor
    (fun x e1 =>
      match e1 with
      | nothing => nothing
      | just e2 => e2
      end
    )
    _
  ).
  clean; apply functional_extensionality.
  destruct x0; magic.
Defined.

(* Now we can prove that maybe is a monad. *)

Definition maybeMonad : monad maybeEta maybeMu.
Proof.
  refine (
    newMonad setCategory maybeFunctor maybeEta maybeMu
    _ _ _
  );
  magic;
  apply functional_extensionality_dep;
  clean;
  apply functional_extensionality;
  destruct x0;
  magic.
Defined.
