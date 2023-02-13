/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package hamza.the_framework;
 
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;
import java.util.stream.Stream;

/**
 *
 * @author given
 * @param <K> keys
 * @param <V> values
 */
public abstract class JobScheduler<K,V> {
    
    public abstract Stream<AJob<K,V>> emit(String directory);
    public abstract void output(Stream<Pair<K,List<V>>> streamPairs);
    
    /*compute, which executes the jobs received from emit by invoking execute on 
    them, and returns a single stream of key/value pairs obtained by concatenating the 
    output of the jobs;*/
    public Stream<Pair<K,V>> compute(Stream<AJob<K,V>> jobStream){
       Stream<Pair<K,V>> stPair = Stream.of();
       jobStream.forEach(x -> Stream.concat(x.execute(),stPair));
       return stPair;
    };
    /*
    collect, which takes as input the output of compute and groups all the pairs with 
    the same keys in a single pair, having the same key and the list of all values;
    */
     public Stream<Pair<K,List<V>>> collect(Stream<Pair<K,V>> pairStream){
         List<Pair<K, List<V>>> tempList = new ArrayList<Pair<K,List<V>>>();
         var groupPair = pairStream.collect(Collectors.groupingBy(pair -> pair.key));
         groupPair.forEach((k,v) ->{ 
             var tempPairList = new ArrayList<V>();
             v.forEach(listPairs -> tempPairList.add(listPairs.value));
             tempList.add(new Pair(k,tempPairList));
             });   
         return tempList.stream();
     };
    
    
}