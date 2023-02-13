module Multiset  
( add  
, occs  
, elems  
, subeq  
, union   
, MSet(MS) 
) where 


data MSet a = MS [(a, Int)] deriving (Show)


empty :: MSet a
empty = MS []


--addHelper takes in input a list of pairs and a parameter of generic type that's an instance of Eq
--it adds the value to the MSet if doesn't exist, otherwise +1 on its multiplicity
addHelper :: (Eq a) => [(a, Int)] -> a -> [(a, Int)]
addHelper [] v = [(v,1)]
addHelper ((x,c):xs) v 
    | x == v = (x, c + 1) : xs
    | otherwise = (x,c) : addHelper xs v

--calls addHelper and put in an MSet Box
add :: Eq a => MSet a -> a -> MSet a
add (MS lst) v = MS (addHelper lst v)


--returns the number of occurences of a given element
occs :: Eq t => MSet t -> t -> Int
occs (MS lst) v = case (MS lst) of
    (MS []) -> 0
    (MS ((x,c):xs)) 
        | x == v -> c
        | otherwise -> occs (MS xs) v

--returns only the elements of the MSet, without their respective multiplicities.
elems :: MSet a -> [a]
elems (MS lst) = case (MS lst) of 
    (MS []) -> []
    (MS ((x,c):xs)) -> x: elems (MS xs)


--subeq mset1 mset2, returning True if each element of mset1 is also an element of mset2 with the same multiplicity at least. 
subeq :: Eq a => MSet a -> MSet a -> Bool
subeq (MS lst) (MS lst2) = case (MS lst) of
    (MS []) -> True
    (MS ((x,c):xs)) -> case filter (\(y,c1) -> y == x && c1 == c) lst2 of --if filter returns [], this means that the specific element is not part of
                                                                          --mset2 --> mset1 != mset2
        [] -> False
        _ -> subeq (MS xs) (MS lst2)


--unionHelper is a function that takes in input two lists of pairs (a,int).
--it scroll through the first list, calls the occs function with the current element on the 2nd list adds it to the multiplicity of that element
--and append the result to the recursive call done on "xs" and on the second list where the current element has been removed
unionHelper :: Eq a => [(a, Int)] -> [(a, Int)] -> [(a, Int)]
unionHelper  [] [] =  []
unionHelper (x:xs) [] = x:xs
unionHelper [] (y:ys) = y:ys
unionHelper ((x,c):xs) ys = (x,occs (MS ys) x + c) : unionHelper (xs) ( (filter (\(y1,c2) -> y1 /= x) ys))

--just calls unionHelper and put the result in an Mset box
union :: Eq a => MSet a -> MSet a -> MSet a
union (MS xs) (MS ys) = MS (unionHelper xs ys)

   
instance Foldable MSet where
        foldr :: (a -> b -> b) -> b -> MSet a -> b
        foldr _ acc (MS []) = acc
        foldr f acc (MS ((x,c):xs)) = foldr f (f x acc) (MS xs) 
        --foldr where i apply the function to the current element, the result of the application becomes the new accumuator

--mapMSet :: (a -> b) -> MSet a -> MSet b
--mapMSet f (MS lst) = MS (map (\(x,c) -> (f x, c)) lst)
--by applying the function to all elements of the Mset in this way we get problems with the "well-form" property
--for example : fmap (\x -> if odd x then True else True) (MS [(1,1),(22,3)])
--MS [(True,1),(True,3)] --> Well Form not satisfied
--on the other hand we can define a function that checks if the result is well formed, but this will not be usable with fmap since
-- we will have an error: "No instance for (Eq b) arising from a use of ‘mapMset’", means that mapMset needs that the return type is instance of Eq
-- if we try to modify "instance Functor MSet" in "instance Functor Eq a => Eq (MSet a)" we will get the error that fmap doesn't exist for it since
-- The type of fmap of Functor is fmap :: (a -> b) -> f a -> f b not mapMset :: Eq a => (t -> a) -> MSet t -> MSet a

mapMset :: Eq a => (t -> a) -> MSet t -> MSet a
mapMset f (MS []) = MS []
mapMset f (MS lst) = if isMSetWellFormed (map (\(x,c) -> (f x, c)) lst) == False then MS [] else MS ((map (\(x,c) -> (f x, c)) lst))

isMSetWellFormed :: Eq t => [(t, Int)] -> Bool
isMSetWellFormed [] = True
isMSetWellFormed ((x,c):xs) = if occs (MS xs) x > 0 then False else isMSetWellFormed xs

--instance Functor Eq a => Eq (MSet a) where 
  --  fmap  = mapMset 

