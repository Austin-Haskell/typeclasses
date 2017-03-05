

-- Applicatives

-- lists (default)

[(+3), (+4)] <*> [5, 6]

pure (+) <*> [3, 4] <*> [5, 6]

(+) <$> [3, 4] <*> [5, 6]

liftA2 (+) [3, 4] [5, 6]

-- Maybe

(Just (+4)) <*> Just 6

pure (+) <*> Just 4 <*> Just 6

(+) <$> Just 4 <*> Just 6

liftA2 (+) (Just 4) (Just 6)

-- tuple
("julie", (+4)) <*> (" rocks", 5)

(Two "julie" (+4)) <*> (Two " rocks" 5)

