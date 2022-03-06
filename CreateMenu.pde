
public class MenuItem {

    public String path;
    public Node sample;

    public MenuItem (String path, Node sample) {
        this.path = path;
        this.sample = sample;
    }

    public void Draw(float x, float y, float width, boolean highlight){
        if (highlight) {
            strokeWeight(0);
            fill(100,100,100,255);
            rect(x, y, width, 25);
        }
        
        strokeWeight(1);
        stroke(0, 0, 0, 255);
        line(x, y, x + width, y);
        line(x, y + 25 , x + width, y + 25);

        fill(255);
        
        int wrapper = path.length();
        if (path.length() > 28 ){
            wrapper = 28;
        }
        text(path.substring(0,wrapper), x + 5, y + 20);
        // if (texts.length > todraw + 1){
        //     strokeWeight(2.4);
        //     stroke(80,80,80,255);
        //     line(x + width - 12, y + 7 , x + width - 5, y + 12);
        //     line(x + width - 12, y + 18 , x + width - 5, y + 12);
            
        // }

    }

}

public class CreateNode extends Node {

    ArrayList<MenuItem> items = new ArrayList<MenuItem>();
    MenuItem hovered;
    String path = "";
    int scrollIndex = 0;

    public CreateNode (int x, int y) {
        this.x = x - (150/2);
        this.y = y;
        this.width = 200;
        this.height = 250;
        this.text = "Create Node";

        items.add(new MenuItem("Switch", new SwitchNode(x,y)));
        items.add(new MenuItem("Lamp", new LampNode(x,y)));
        items.add(new MenuItem("And Gate", new AndGateNode(x,y)));
        items.add(new MenuItem("Or Gate", new OrGateNode(x,y)));
        items.add(new MenuItem("XOr Gate", new XOrGateNode(x,y)));
        items.add(new MenuItem("Inverter", new NotGateNode(x,y)));
        items.add(new MenuItem("Half Adder", new HalfAdderNode(x,y)));
        items.add(new MenuItem("Full Adder", new FullAdderNode(x,y)));
        items.add(new MenuItem("Flip Flop", new FlipFlopNode(x,y)));
        items.add(new MenuItem("Decoder", new DecoderNode(x,y)));
        items.add(new MenuItem("Decoder (T)", new DecoderTaktNode(x,y)));
        items.add(new MenuItem("Delay", new DelayNode(x,y)));
        items.add(new MenuItem("Clock", new ClockNode(x,y)));
        items.add(new MenuItem("Shift Register", new ShiftRegisterNode(x,y)));

    }
    public void Scroll(float i){
        if (i < 0 && scrollIndex > 0) {
            scrollIndex--;
        }else if (i > 0 && scrollIndex < items.size() - 1) {
            scrollIndex++;
        }
    }

    public Node[] CreateCall(){
        stroke(87, 110, 72, 255);
        strokeWeight(3);
        fill(50, 50, 50, 255);
        rect(x, y, width, height, 8,8,8,8);
        fill(255);
        textSize(12);
        text(text, x + 20, y + 20 );
        strokeWeight(1);
        line(x, y + 25 , x + width, y + 25);



        //TODO: Update
        float py = y + 25;

        for (int i = scrollIndex; i < items.size(); i++) {
            MenuItem m = items.get(i);
            if(py + 25 > y + height){continue;}

            int px = mouseX;
            int py2 = mouseY;
            float rx = x;
            float ry = py;
            float rw = width;
            float rh = 25;

            if (px >= rx &&  px <= rx + rw && py2 >= ry && py2 <= ry + rh) {   
                m.Draw(x,py,width, true);
                hovered = m;
            }else {
                m.Draw(x,py,width, false);
                if (hovered == m) {
                    hovered = null;
                }
            }
            py += 25;
        }

        if (mousePressed == true && mouseButton == LEFT) {
            if (hovered != null) {
                Node[] n = new Node[1];
                n[0] = hovered.sample;
                return n;
                
            }else {
                return new Node[1];
            }
        }

        stroke(87, 110, 72, 255);
        strokeWeight(3);
        noFill();
        rect(x, y, width, height, 8,8,8,8);
        strokeWeight(1);
        line(x, y + 25 , x + width, y + 25);
        return new Node[2];
    }
}
