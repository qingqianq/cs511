package Assignment2;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Random;




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
    public void workout() throws InterruptedException {
	for (Exercise e : routine) {
	    int sno = getSempahoreNo(e.getAt());
	    Gym.at[sno].acquire();
	    Map<WeightPlateSize, Integer> weight = e.getWeight();
	    for
	}
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
