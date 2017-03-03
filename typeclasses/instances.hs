-- instances.hs
-- import Data.Monoid (<>)


-- for a Maybe type

data Possibly a =
    LolNope
  | Yup a
  deriving (Eq, Show)

instance Monoid (Possibly a) where
    mempty = LolNope
    mappend _ LolNope = LolNope
    mappend LolNope _ = LolNope
    mappend (Yup a) (Yup b) = Yup a

instance Functor Possibly where
  fmap _ LolNope = LolNope
  fmap f (Yup a) = Yup (f a)

instance Applicative Possibly where
    pure = Yup
    _ <*> LolNope = LolNope
    LolNope <*> _ = LolNope
    Yup func <*> Yup a = Yup (func a)

instance Monad Possibly where
  -- return = pure
  (>>=) LolNope _ = LolNope
  (>>=) (Yup a) func = func a
--  >>= :: Possibly a -> (a -> Possibly b) -> Possibly b

-- for an Either type

data Sum a b =
    First a
  | Second b
  deriving (Eq, Show)

instance Functor (Sum a) where
  fmap _ (First a) = First a
  fmap f (Second b) = Second (f b)

instance Applicative (Sum a) where
  pure = Second
  (<*>) _ (First a) = First a
  (<*>) (First a) _ = First a
  (<*>) (Second f) (Second b) = Second (f b)

instance Monad (Sum a) where
  return = pure
  (>>=) (First a) _ = First a
  (>>=) (Second a) f = f a


-- some product types

-- similar to tuple (or function!)

data Two a b = Two a b deriving (Eq, Show)

instance Functor (Two a) where
  fmap f (Two a b) = Two a (f b)

instance Monoid a => Applicative (Two a) where
  pure x = Two mempty x
  (<*>) (Two a f) (Two a' b) = Two (mappend a a') (f b)



-- something a bit different 

data Pair a = Pair a a deriving (Eq, Show)

instance Functor Pair where
  fmap f (Pair a b) = Pair (f a) (f b)

instance Applicative Pair where
  pure x = Pair x x
  (<*>) (Pair f f') (Pair a a') = Pair (f a) (f' a')
