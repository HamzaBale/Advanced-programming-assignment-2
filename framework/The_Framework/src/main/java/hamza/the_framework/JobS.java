/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package hamza.the_framework;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Scanner;
import java.util.regex.Pattern;
import java.util.stream.Stream;

/**
 *
 * @author given
 * @param <K> key
 * @param <V> value
 */
public class JobS<K,V> extends AJob<K,V> {
    private String filepath;
    
    public JobS(String filepath){
        this.filepath = filepath;
    }
        
    @Override
    public Stream<Pair<K, V>> execute() {
        
        List<String> lst = readFile();
        return lst.stream().map(val -> new Pair(ciao(val),val));
    }

    private List<String> readFile(){
        Pattern regAlpha = Pattern.compile("[^a-zA-Z]");
        List<String> returnList = new ArrayList<String>();
        try {
      File fileRead = new File(this.filepath);
      Scanner myReader = new Scanner(fileRead);
      while (myReader.hasNext()) {
        String strIn = myReader.next();
        if(strIn.length() > 4 && strIn.matches("[a-zA-Z]+")) returnList.add(strIn);
      }
      myReader.close();
    } catch (FileNotFoundException e) {
        e.printStackTrace();
    }
        return returnList;
        
    }
    
    private String ciao(String str){
        char[] tempChars = str.toLowerCase().toCharArray();
        Arrays.sort(tempChars);
        return new String(tempChars);
    }
    
}
