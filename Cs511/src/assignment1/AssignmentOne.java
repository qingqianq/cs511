package assignment1;
import java.util.LinkedList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
/**
 * Group work
 * member name: Guangqi Qing and Bingying Chen
 */
public class AssignmentOne {
    private static LinkedList<Integer> results ;
    public static List<Integer> lprimes(List<Integer[]> intervals) throws InterruptedException{
	vertify(intervals);
	results = new LinkedList<>();
	int k = intervals.size();
	Thread[] threads = new Thread[k];
	Primefind[] pf = new Primefind[k];
	for (int i = 0; i < k; i++) {
	    Integer[] integers = intervals.get(i);
	    pf[i] = new Primefind(integers[0], integers[1]);
	    threads[i] = new Thread(pf[i]);
	    threads[i].start();
	}
	for (int i = 0; i < k; i++) {
	    threads[i].join();
	}
	for (Primefind primefind : pf) {
	    results.addAll(primefind.getPrimeList());
	}
	return results;
    }
    private static void vertify(List<Integer[]> intervals) {
	int temp = 2;
	for (Integer[] integers : intervals) {
	    if(integers.length != 2 || integers[0] >= integers[1] || temp > integers[0])
		throw new RuntimeException("Wrong integer list");
	    temp = integers[1];
	}
    }
    private static List<Integer[]> getList(String args) {
	LinkedList<Integer[]> list = new LinkedList<>();
	args = args.substring(1, args.length()-1);
	Pattern p = Pattern.compile("(\\[[^\\]]*\\])");
	Matcher m = p.matcher(args);
	while(m.find()) {
	    String s = m.group().substring(1, m.group().length()-1);
	    int index = s.indexOf(',');
	    int begin = Integer.parseInt(s.substring(0,index));
	    int end = Integer.parseInt(s.substring(index+1));
	    Integer[] temp = {begin,end};
	    list.add(temp);
	}
	return list;
    }
    public static void main(String[] args) throws InterruptedException {
	if(args.length != 1) {
	    System.out.println("wrong args input");
	    return;
	}
	List<Integer[]> list = getList(args[0]);
	List<Integer> primes = lprimes(list);
	for (Integer integer : primes) {
	    System.out.print(integer+" ");
	}
    }
}
