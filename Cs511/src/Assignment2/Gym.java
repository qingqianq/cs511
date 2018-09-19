package Assignment2;
import java.util.HashMap;
import java.util.HashSet;
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
    static Semaphore smallPlates;
    static Semaphore mediumPlates;
    static Semaphore largePlates;
    static Semaphore[] at;

    public Gym() {
	noOfWeightPlates = new HashMap<WeightPlateSize,Integer>();
	noOfWeightPlates.put(WeightPlateSize.SMALL_3KG, 110);
	noOfWeightPlates.put(WeightPlateSize.MEDIUM_5KG, 90);
	noOfWeightPlates.put(WeightPlateSize.LARGE_10KG, 75);
	executor = Executors.newFixedThreadPool(GYM_SIZE);
	at = new Semaphore[ApparatusType.values().length];
	for (int i = 0; i < at.length; i++) {
	    at[i] = new Semaphore(5);
	}
	clients = new HashSet<Integer>(GYM_REGISTERED_CLIENTS);
	for (int i = 0; i < GYM_SIZE; i++) {
	    int cid = (int) (Math.random() * GYM_REGISTERED_CLIENTS) + 1;
	    clients.add(cid);
	}
	System.out.println("The num of client is " + clients.size());
    }    
    
    public void run() {
	for (Integer id : clients) {
	    executor.execute(new Runnable() {
	        
	        @Override
	        public void run() {
	    		Client client = Client.generateRandom(id, noOfWeightPlates);
	    		try {
			    client.workout();
			} catch (InterruptedException e) {
			    e.printStackTrace();
			}
	        }
	    });
	}
    }
   
}
