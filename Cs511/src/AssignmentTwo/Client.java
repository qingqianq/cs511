package Assignment2;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

public class Client {
    private int id;
    private List<Exercise> routine;
    public Client(int id) {
	this.id = id;
	this.routine = new LinkedList<Exercise>();
    }
    public void addExercise(Exercise e) {
	this.routine.add(e);
    }
    
    public static Client generateRandom(int id, Map<WeightPlateSize,Integer> noOfWeightPlateSize) {
	Client client = new Client(id);
	int n = (int)(Math.random() * 6) + 15;
	for (int i = 0; i < n; i++) {
	    client.routine.add(Exercise.generateRandom(noOfWeightPlateSize));
	}
	return client;
    }
    /*
     * When there are 2 source S left, and 2 clients A,B need 2 sources S each
     * Each of them execute 1 acquire and donot release, it may be deadlock.
     * Use mutex Semaphore(1). 
     */
    public void workout() throws InterruptedException {
	for (Exercise e : routine) {
	    Gym.mutex.acquire();
	    System.out.println("Client :" + this.id + " is using " + e.toString());
	    int sno = getSempahoreNo(e.getAt());
	    Gym.at[sno].acquire();
	    Map<WeightPlateSize, Integer> weight = e.getWeight();
	    for (WeightPlateSize size : weight.keySet()) {
		switch (size) {
		case SMALL_3KG:
		    for (int i = 0; i < weight.get(size); i++) {
			Gym.smallPlates.acquire();	
		    }
		    break;
		case MEDIUM_5KG:
		    for (int i = 0; i < weight.get(size); i++) {
			Gym.mediumPlates.acquire();
		    }
		    break;
		case LARGE_10KG:
		    for (int i = 0; i < weight.get(size); i++) {
			Gym.largePlates.acquire();
		    }
		    break;
		default:
		   throw new RuntimeException("err in count weightSize");
		}
	    }
	    Gym.showLeft();
	    Gym.mutex.release();
	    Thread.sleep(e.getDuration());
	    Gym.at[sno].release();
	    for (WeightPlateSize size : weight.keySet()) {
		switch (size) {
		case SMALL_3KG:
		    for (int i = 0; i < weight.get(size); i++) {
			Gym.smallPlates.release();	
		    }
		    break;
		case MEDIUM_5KG:
		    for (int i = 0; i < weight.get(size); i++) {
			Gym.mediumPlates.release();
		    }
		    break;
		case LARGE_10KG:
		    for (int i = 0; i < weight.get(size); i++) {
			Gym.largePlates.release();
		    }
		    break;
		default:
		   throw new RuntimeException("err in release weightSize");
		}
	    }
	    System.out.println("Client : " +this.id + " finishes " +e.toString());
	    Gym.showLeft();
	}
	System.out.println("Client :" + this.id + " finishes all exercise.");
    }
    private int getSempahoreNo(ApparatusType at) {
	switch (at) {
	case LEGPRESSMACHINE:		return 0;
	case BARBELL:			return 1;
	case HACKSQUATMACHINE:		return 2;
	case LEGEXTENSIONMACHINE:	return 3;
	case LEGCURLMACHINE:		return 4;
	case LATPULLDOWNMACHINE:		return 5;
	case PECDECKMACHINE:		return 6;
	case CABLECROSSOVERMACHINE:	return 7;
	default:
	    throw new RuntimeException("no case");
	}
    }
}
