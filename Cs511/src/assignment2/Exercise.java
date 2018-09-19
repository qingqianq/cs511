package Assignment2;
import java.util.HashMap;
import java.util.Map;

public class Exercise {

    private ApparatusType at;
    private Map<WeightPlateSize,Integer> weight;
    private int duration;
    
    public ApparatusType getAt() {
        return at;
    }
    public Map<WeightPlateSize, Integer> getWeight() {
        return weight;
    }
    public int getDuration() {
        return duration;
    }
    public Exercise(ApparatusType at, Map<WeightPlateSize,Integer> weight, int duration ) {
	this.at = at;
	this.weight = weight;
	this.duration = duration;
    }
    public static Exercise generateRandom(Map<WeightPlateSize, Integer> weight) {
	ApparatusType at = Enums.random(ApparatusType.class);
	int duration = (int)(Math.random() * 1000) + 1000;
	weight = new HashMap<WeightPlateSize,Integer>();
//	
//	
	Exercise e = new Exercise(at, weight, duration);
	return e;
    }
    
}
