import Multiset
import Data.Text (splitOn)
import Data.List
import Data.Char


instance Eq a => Eq (MSet a) where
    (==) :: Eq a => MSet a -> MSet a -> Bool
    MS [] == MS [] = True
    MS (x:xs) == MS [] = False
    MS [] == MS (y:ys) = False
    MS (lst) == MS (lst2) = subeq (MS lst) (MS lst2) && subeq (MS lst2) (MS lst) -- se entrambe restituiscono True allora sono uguali

--sort the chars inside the string in alphabetical order
sortString s = sortBy (\a b -> compare a b) s
--from string to ciao of that string inside a MSet
mapToCiao lst = foldr (\x acc -> add acc (sortString (map toLower x))) (MS []) lst

--from Mset to string to be written in file
mapToString (MS []) = ""
mapToString (MS ((x,c):xs)) = "<" ++ (show x) ++ ">" ++ "-" ++ "<" ++ (show c) ++ ">" ++ "\n" ++ mapToString (MS xs)

readMSet filename = do 
   content <- (readFile filename) --reads file
   let s = lines content --from string to list of strings (line by line)
   let res = mapToCiao s;
   return res;

writeMSet filename mset = do 
    writeFile filename mset

main = do {
    m1 <- readMSet "C:\\Users\\given\\Desktop\\Appunti\\Advanced programming\\Assegnamento_2\\aux_files\\anagram.txt"; 
    m2 <- readMSet "C:\\Users\\given\\Desktop\\Appunti\\Advanced programming\\Assegnamento_2\\aux_files\\anagram-s1.txt"; 
    m3 <- readMSet "C:\\Users\\given\\Desktop\\Appunti\\Advanced programming\\Assegnamento_2\\aux_files\\anagram-s2.txt"; 
    m4 <- readMSet "C:\\Users\\given\\Desktop\\Appunti\\Advanced programming\\Assegnamento_2\\aux_files\\margana2.txt"; 
    if not (m1 == m4) && (elems m1 == elems m4) then putStrLn "Multisets m1 and m4 are not equal, but they have the same elements";
    else putStrLn "The condition on m1 and m4 is not True";
    writeMSet "C:\\Users\\given\\Desktop\\Appunti\\Advanced programming\\Assegnamento_2\\aux_files\\anag-out.txt" (mapToString m1);
    if m1 == (Multiset.union m2 m3) then putStrLn "Multiset m1 is equal to the union of multisets m2 and m3";
    else putStrLn "The condition on m1 and the union of m1 and m3 is not True";
    writeMSet "C:\\Users\\given\\Desktop\\Appunti\\Advanced programming\\Assegnamento_2\\aux_files\\gana-out.txt" (mapToString m4);
}
