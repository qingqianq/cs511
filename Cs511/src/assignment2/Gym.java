package assignment2;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Semaphore;

public class Gym  implements Runnable{
    private static final int GYM_SIZE = 30;
    private static final int GYM_REGISTERED_CLIENTS = 10000;
    private Map<WeightPlateSize,Integer> noOfWeightPlates;
    private Set<Integer> clients;
    private ExecutorService executor;
    private Semaphore smallPlates;
    private Semaphore mediumPlates;
    private Semaphore largePlates;
    private Semaphore gymUsers;
    public Gym() {
	smallPlates = new Semaphore(110);
	mediumPlates = new Semaphore(90);
	largePlates = new Semaphore(75);
	executor = Executors.newFixedThreadPool(GYM_SIZE);
    }    
    
    public void run() {
	executor.execute(new Runnable() {
	    @Override
	    public void run() {
		
	    }
	});
    }
}
