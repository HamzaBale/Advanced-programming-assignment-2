/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package hamza.the_framework;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.stream.Collectors;

import java.util.stream.Stream;
import org.apache.commons.io.FilenameUtils;

/**
 *
 * @author given
 */
public class wordProcessor<K,V> extends JobScheduler<K,V> {

    
    public wordProcessor(){};
    
    @Override
    public Stream<AJob<K,V>> emit(String directory) {
        File dir = new File(directory);
        File[] filesInDir = dir.listFiles();
        List<AJob<K,V>> jobs = new ArrayList<AJob<K,V>>(); 
        for(int i = 0; i < filesInDir.length; i++){            
            if(filesInDir[i].isFile() && FilenameUtils.getExtension(filesInDir[i].getName()).contains("txt")){ 
                jobs.add(new JobS(filesInDir[i].getPath()));}
        }
        return jobs.stream();
        
    }

    @Override
    public void output(Stream<Pair<K,List<V>>> streamPairs) {
         FileWriter fileW = openFile("count_anagrams.txt");

         streamPairs
                 .map(x -> new Pair<K,Integer>(x.key,x.value.size()))
                 .forEach(pair -> {
             try {
                 fileW.append("<"+pair.key+">"+"-<"+pair.value+">\n");
             } catch (IOException ex) {
                 ex.printStackTrace();
             }
         });
                 
    }
    
    private FileWriter openFile(String filePath){
         try {
      File myObj = new File(filePath);
      myObj.createNewFile();
      FileWriter fileW =  new FileWriter(filePath);
      return fileW;
    } catch (IOException ex) {
      System.out.println("An error occurred.");
      ex.printStackTrace();
      return null;
    }
       
    }
    
}
