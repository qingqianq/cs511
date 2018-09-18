package assignment1;
import java.util.LinkedList;
import java.util.List;

public class Primefind implements Runnable{
	private Integer start;
	private Integer end;
	private List<Integer> primes;
	public Primefind(Integer startNum, Integer endNum) {
	    start = startNum;
	    end = endNum;
	}
	public Boolean isPrime(int n) {
	    if(n < 2)
		return false;
	    for(int i = 2; i <= Math.sqrt(n); i++) {
		if (n % i == 0)
		    return false;
	    }
	    return true;
	}
	public List<Integer> getPrimeList(){
	    return primes;
	}
	public void run() {
	    if(primes == null)
		primes = new LinkedList<Integer>();
	    for (int i = start; i < end; i++) {
		if(isPrime(i)) {
		    primes.add(i);
		}
	    }
	}
}
