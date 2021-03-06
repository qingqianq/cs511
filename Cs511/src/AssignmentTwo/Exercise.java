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
    public static Exercise generateRandom(Map<WeightPlateSize, Integer> resourceMap) {
	ApparatusType at = Enums.random(ApparatusType.class);
	int duration = (int)(Math.random() * 500) + 200;
	Map<WeightPlateSize,Integer> weight = new HashMap<>();
	for (WeightPlateSize weightKind : resourceMap.keySet()) {
	    weight.put(weightKind, 0);
	}
	for (int i = 0; i < Math.random() * 9 + 1; i++) {
	    WeightPlateSize wps = Enums.random(WeightPlateSize.class);
	    weight.put(wps,weight.get(wps)+1);
	}
	return new Exercise(at, weight, duration);
    }
    @Override
    public String toString() {
	return at + " ApparatusType" +", "+ weight.get(WeightPlateSize.SMALL_3KG) + " of 3kg size, "+
		weight.get(WeightPlateSize.MEDIUM_5KG) + " of 5kg size, "+  weight.get(WeightPlateSize.LARGE_10KG) +" of 10kg size," +
		"duration = " + duration +"ms";
    }
    
}
