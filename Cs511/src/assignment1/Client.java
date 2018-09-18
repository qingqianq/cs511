package assignment1;
import java.util.List;
import java.util.Map;




public class Client {
    private int id;
    private List<Exercise> routine;
    public Client(int id) {
	this.id = id;
    }
    public void addExercise(Exercise e) {
	routine.add(e);
    }
    
    public static Client generateRandom(int id, Map<WeightPlateSize,Integer> noOfWeightPlateSize) {
	Client client = new Client(id);
	return null;
    }
    
}
