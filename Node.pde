
public class Node {

    public int ID;
    public float x,y,width,height;
    public String text = "NODE";
    public boolean selected = false;
    public String nodeType = "UNDEFINED";

    public ArrayList<InputHandle> inputs = new ArrayList<InputHandle>();
    public ArrayList<OutputHandle> outputs = new ArrayList<OutputHandle>();
    public InputHandle inpH;
    public OutputHandle outH;
    

    Node (int x, int y) {
        this.x = x;
        this.y = y;
        this.width = 150;
        this.height = 200;
        this.ID = getID();

        inputs.add(new InputHandle('s', color(255,255,255)));
        inputs.add(new InputHandle('b', color(255,50,100)));

        outputs.add(new OutputHandle('s', color(255,255,255)));
        outputs.add(new OutputHandle('b', color(255,50,100)));

    }
    Node(){}

    public void Draw(float zoom){
        stroke(72, 87, 110, 255);
        strokeWeight(1*zoom);
        if (selected) {
            stroke(72, 87, 110, 255);
            strokeWeight(5*zoom);
        }
        
        fill(50, 50, 50, 255);
        rect(x*zoom, y*zoom, width*zoom, height*zoom, 8,8,8,8);
        noFill();
        fill(255);
        textSize(12*zoom);
        text(text, x*zoom + 10*zoom, y*zoom + 20*zoom );
        stroke(72, 87, 110, 255);
        strokeWeight(1*zoom);
        line(x*zoom, y*zoom + 25*zoom , (x*zoom + width*zoom), (y*zoom + 25*zoom));

        noStroke();
        float hy = y*zoom + 40*zoom;
        for (InputHandle h : inputs) {
            h.Draw(x*zoom+15*zoom, hy, zoom);  
            hy += 20*zoom;  
        }
        hy = y*zoom + 40*zoom;
        for (OutputHandle h : outputs) {
            h.Draw(int(x*zoom+width*zoom-15*zoom), hy, zoom); 
            hy += 20*zoom;   
        }
    }
    public boolean UpdateP(){return false;}

    public boolean Update(boolean make, char type, float zoom){
        outH = null;
        inpH = null;
        if (!make) {
            for (OutputHandle i : outputs){
                if(i.IsHover(zoom)){
                    outH = i;
                    return true; 
                }
            }
            for (InputHandle i : inputs){
                i.hover = false;
            }
            return false;
        }

        for (InputHandle i : inputs){
            if(i.IsHover(zoom)){
                if (i.type == type && !i.connected) {
                    inpH = i;
                    return true;
                }else {
                    i.hover = false;
                }
                
            }
        }
        
        return false;
    }
}
