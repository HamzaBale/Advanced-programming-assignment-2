/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Project/Maven2/JavaApp/src/main/java/${packagePath}/${mainClassName}.java to edit this template
 */

package hamza.the_framework;

import java.util.List;
import java.util.stream.Stream;

/**
 *
 * @author given
 */
public class The_Framework{

    public static void main(String[] args) {
        wordProcessor wp = new wordProcessor();
        Stream<AJob> streamAJob  = wp.emit("C:\\Users\\given\\Desktop\\Appunti\\Advanced programming\\Assegnamento_2\\framework\\aux_files\\Books");
        streamAJob.forEach(job ->{
            Stream<Pair> streamPair = job.execute();
            wp.output(wp.collect(streamPair));
               
        });
        System.out.println("Hello World!");
    }

}
