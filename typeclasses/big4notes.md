---
title: Notes on the Big 4
---

# Monoid 

A binary associative operation with an identity value.

```haskell
class Monoid a where
  mempty :: a
  -- the identity value for the operation
  mappend :: a -> a -> a
  -- binary associative operation
  {-# MINIMAL mempty, mappend #-}
```
-- For most types, if there is a possible monoid, there are at least two possible monoids. Roughly speaking, these will be additive/disjunctive and multiplicative/conjunctive.  
-- The Data.Monoid module has a bunch of newtypes to preserve unique pairing between a type (name) and the typeclass.


# Functor  

- Most typically thought of as the ability to apply a function to a value or values inside a data structure (a data constructor), with `fmap` being a generalization of `map`.  
- Probably better to think of it as applying a type constructor to the input type and result type of a function. (Why this is true may not be obvious until we see the Functor of the function type, though.)

```haskell
class Functor (f :: * -> *) where
-- notice the kind information
  fmap :: (a -> b) -> f a -> f b
  -- applies type constructor f to type a and type b
  (<$) :: a -> f b -> f a
  {-# MINIMAL fmap #-}
```
- Only types of kind `* -> *` can have a`Functor` instance. In a type of kind `*`, there is no `a` to apply the `f` to (or to be the first argument to the function); for a type with more stars (e.g., `* -> * -> *`), there would be a sort of "extra" argument. 
- So, for higher-kinded types of more than two stars, we partially apply the type constructor as the `f` structure. 

# Applicative

Another variety of functor. This time the `(a -> b)` function is itself embedded in an `f` data structure. So, for example, we're applying a list of functions to a list of values to return a list of results.

# Monad

Yet another variety of functor (there are many, FWIW)