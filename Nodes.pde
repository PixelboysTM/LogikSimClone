
public class SwitchNode extends Node {

    int mState = 0;
    boolean power = false;
    boolean hover = false;
    public SwitchNode (int x, int y) {
        this.x = x;
        this.y = y;
        this.width = 80;
        this.height = 60;
        this.text = "SWITCH";
        this.nodeType = "Switch_Node";
        this.ID = getID();

        outputs.add(new OutputHandle('w', color(255,255,255)));
    }

    public void Draw(float zoom){
        if (hover && isPower) {
            selected = true;
        }else if (!hover && isPower) {
            selected = false;
        }
        text = "SWITCH " + (power ? "1" : "0"); 
        super.Draw(zoom);
    }

    public boolean UpdateP(){
        if (mouseX >= this.x*zoom &&         // right of the left edge AND
            mouseX <= this.x*zoom + this.width*zoom &&    // left of the right edge AND
            mouseY >= this.y*zoom &&         // below the top AND
            mouseY <= this.y*zoom + this.height*zoom) {
            hover = true;
            if (mousePressed == true && mouseButton == LEFT && mState == 0) {
                power = !power;
                mState++;
            }else if(!(mousePressed == true && mouseButton == LEFT)){
                mState = 0;
            }
        }else {
            hover = false;
        }
        for (OutputHandle o : outputs) {
            o.isPowered = power;
        }
        return hover;
    }

}

public class LampNode extends Node {

    boolean power = false;
    public LampNode (int x, int y) {
        this.x = x;
        this.y = y;
        this.width = 80;
        this.height = 60;
        this.text = "LAMP OFF";
        this.nodeType = "Lamp_Node";
        this.ID = getID();

        inputs.add(new InputHandle('w', color(255,255,255)));
    }

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
        if (power && isPower) {
            fill(255, 123, 0, 255);
        }else {
        fill(255);
        }
        textSize(12*zoom);
        text(text, x*zoom + 10*zoom, y*zoom + 20*zoom );
        stroke(72, 87, 110, 255);
        strokeWeight(1*zoom);
        line(x*zoom, y*zoom + 25*zoom , (x*zoom + width*zoom), (y*zoom + 25*zoom));

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


        if (isPower && power) {
            text = "LAMP ON";
        }else {
            text = "LAMP OFF";
        }
    }
    public boolean UpdateP(){
        power = inputs.get(0).isPowered;
        return false;
    }
}

public class AndGateNode extends Node {

    boolean power = false;
    public AndGateNode (int x, int y) {
        this.x = x;
        this.y = y;
        this.width = 80;
        this.height = 80;
        this.text = "AND";
        this.nodeType = "And_Node";
        this.ID = getID();

        inputs.add(new InputHandle('w', color(255,255,255)));
        inputs.add(new InputHandle('w', color(255,255,255)));

        outputs.add(new OutputHandle('w', color(255,255,255)));
    }

    public void Draw(float zoom){
        super.Draw(zoom);
    }

    public boolean UpdateP(){
        boolean a = inputs.get(0).isPowered;
        boolean b = inputs.get(1).isPowered;
        power = a && b;
        outputs.get(0).isPowered = power;
        return false;
    }
}

public class OrGateNode extends Node {

    boolean power = false;
    public OrGateNode (int x, int y) {
        this.x = x;
        this.y = y;
        this.width = 80;
        this.height = 80;
        this.text = "OR";
        this.nodeType = "Or_Node";
        this.ID = getID();

        inputs.add(new InputHandle('w', color(255,255,255)));
        inputs.add(new InputHandle('w', color(255,255,255)));

        outputs.add(new OutputHandle('w', color(255,255,255)));
    }

    public void Draw(float zoom){
        super.Draw(zoom);
    }

    public boolean UpdateP(){
        boolean a = inputs.get(0).isPowered;
        boolean b = inputs.get(1).isPowered;
        power = a || b;
        outputs.get(0).isPowered = power;
        return false;
    }
}

public class XOrGateNode extends Node {

    boolean power = false;
    public XOrGateNode (int x, int y) {
        this.x = x;
        this.y = y;
        this.width = 80;
        this.height = 80;
        this.text = "XOR";
        this.nodeType = "XOr_Node";
        this.ID = getID();

        inputs.add(new InputHandle('w', color(255,255,255)));
        inputs.add(new InputHandle('w', color(255,255,255)));

        outputs.add(new OutputHandle('w', color(255,255,255)));
    }

    public void Draw(float zoom){
        super.Draw(zoom);
    }

    public boolean UpdateP(){
        boolean a = inputs.get(0).isPowered;
        boolean b = inputs.get(1).isPowered;
        power = (a || b) && !(a && b);
        outputs.get(0).isPowered = power;
        return false;
    }
}

public class NotGateNode extends Node {

    boolean power = false;
    public NotGateNode (int x, int y) {
        this.x = x;
        this.y = y;
        this.width = 50;
        this.height = 55;
        this.text = "NOT";
        this.nodeType = "Not_Node";
        this.ID = getID();

        inputs.add(new InputHandle('w', color(255,255,255)));

        outputs.add(new OutputHandle('w', color(255,255,255)));
    }

    public void Draw(float zoom){
        super.Draw(zoom);
    }

    public boolean UpdateP(){
        power = !inputs.get(0).isPowered;
        outputs.get(0).isPowered = power;
        return false;
    }
}

public class HalfAdderNode extends Node {

    boolean power = false;
    public HalfAdderNode (int x, int y) {
        this.x = x;
        this.y = y;
        this.width = 95;
        this.height = 80;
        this.text = "HALF ADDER";
        this.nodeType = "HalfAdder_Node";
        this.ID = getID();

        inputs.add(new InputHandle('w', color(255,255,255)));
        inputs.add(new InputHandle('w', color(255,255,255)));

        outputs.add(new OutputHandle('w', color(255,255,255)));
        outputs.add(new OutputHandle('w', color(100,100,100)));

    }

    public void Draw(float zoom){
        super.Draw(zoom);
    }

    public boolean UpdateP(){
        boolean a = inputs.get(0).isPowered;
        boolean b = inputs.get(1).isPowered;
        power = (a || b) && !(a && b);
        outputs.get(0).isPowered = power;
        outputs.get(1).isPowered = (a && b);
        return false;
    }
}

public class FullAdderNode extends Node {

    boolean power = false;
    public FullAdderNode (int x, int y) {
        this.x = x;
        this.y = y;
        this.width = 95;
        this.height = 90;
        this.text = "FULL ADDER";
        this.nodeType = "FullAdder_Node";
        this.ID = getID();

        inputs.add(new InputHandle('w', color(255,255,255)));
        inputs.add(new InputHandle('w', color(255,255,255)));
        inputs.add(new InputHandle('w', color(255,255,255)));

        outputs.add(new OutputHandle('w', color(255,255,255)));
        outputs.add(new OutputHandle('w', color(100,100,100)));

    }

    public void Draw(float zoom){
        super.Draw(zoom);
    }

    public boolean UpdateP(){
        boolean a = inputs.get(0).isPowered;
        boolean b = inputs.get(1).isPowered;
        boolean c = inputs.get(2).isPowered;
        power = (c && ( a ^ b)) || ( a && b);
        outputs.get(1).isPowered = power;
        outputs.get(0).isPowered = a ^ b ^ c;
        return false;
    }
}

public class FlipFlopNode extends Node {

    boolean power = true;
    public FlipFlopNode (int x, int y) {
        this.x = x;
        this.y = y;
        this.width = 95;
        this.height = 90;
        this.text = "FLIP FLOP";
        this.nodeType = "FlipFlop_Node";
        this.ID = getID();

        inputs.add(new InputHandle('w', color(255,255,255)));
        inputs.add(new InputHandle('w', color(255,255,255)));
        inputs.add(new InputHandle('w', color(255,255,255)));

        outputs.add(new OutputHandle('w', color(255,255,255)));
        outputs.add(new OutputHandle('w', color(255,255,255)));

    }

    public void Draw(float zoom){
        super.Draw(zoom);
    }

    public boolean UpdateP(){
        boolean j = inputs.get(0).isPowered;
        boolean c = inputs.get(1).isPowered;
        boolean k = inputs.get(2).isPowered;
        boolean out = false;
        if ((power != c) && !c) {
            if (!j && k) {
                out = false;
            }else if (j && !k) {
                out = true;
            }else if (k && j) {
                out = !outputs.get(0).isPowered;
            }else if (!j && !k) {
                out = outputs.get(0).isPowered;
            }
            outputs.get(0).isPowered = out;
            outputs.get(1).isPowered = !out;
        }
        power = c;
        return false;
    }
}

public class DecoderNode extends Node {

    int lastHigh = 0;
    public DecoderNode (int x, int y) {
        this.x = x;
        this.y = y;
        this.width = 95;
        this.height = 195;
        this.text = "DECODER";
        this.nodeType = "Decoder_Node";
        this.ID = getID();

        inputs.add(new InputHandle('w', color(255,255,255)));
        inputs.add(new InputHandle('w', color(255,255,255)));
        inputs.add(new InputHandle('w', color(255,255,255)));

        outputs.add(new OutputHandle('w', color(255,255,255)));
        outputs.add(new OutputHandle('w', color(255,255,255)));
        outputs.add(new OutputHandle('w', color(255,255,255)));
        outputs.add(new OutputHandle('w', color(255,255,255)));
        outputs.add(new OutputHandle('w', color(255,255,255)));
        outputs.add(new OutputHandle('w', color(255,255,255)));
        outputs.add(new OutputHandle('w', color(255,255,255)));
        outputs.add(new OutputHandle('w', color(255,255,255)));
    }

    public void Draw(float zoom){
        super.Draw(zoom);
    }

    public boolean UpdateP(){
        int a = int((inputs.get(0).isPowered ? 1 : 0 )  + (inputs.get(1).isPowered ? 1 : 0 ) * 2 + ( inputs.get(2).isPowered ? 1 : 0) * 4);
        outputs.get(lastHigh).isPowered = false;
        outputs.get(a).isPowered = true;
        lastHigh = a;
        return false;
    }
}

public class DecoderTaktNode extends Node {

    boolean power = true;
    int lastHigh = 0;
    public DecoderTaktNode (int x, int y) {
        this.x = x;
        this.y = y;
        this.width = 95;
        this.height = 195;
        this.text = "DECODER (T)";
        this.nodeType = "DecoderTakt_Node";
        this.ID = getID();

        inputs.add(new InputHandle('w', color(255,255,255)));
        inputs.add(new InputHandle('w', color(255,255,255)));
        inputs.add(new InputHandle('w', color(255,255,255)));
        inputs.add(new InputHandle('w', color(255,255,255)));

        outputs.add(new OutputHandle('w', color(255,255,255)));
        outputs.add(new OutputHandle('w', color(255,255,255)));
        outputs.add(new OutputHandle('w', color(255,255,255)));
        outputs.add(new OutputHandle('w', color(255,255,255)));
        outputs.add(new OutputHandle('w', color(255,255,255)));
        outputs.add(new OutputHandle('w', color(255,255,255)));
        outputs.add(new OutputHandle('w', color(255,255,255)));
        outputs.add(new OutputHandle('w', color(255,255,255)));
    }

    public void Draw(float zoom){
        super.Draw(zoom);
    }

    public boolean UpdateP(){
        boolean c = inputs.get(3).isPowered;
        if ((power != c) && !c) {
            int a = int((inputs.get(0).isPowered ? 1 : 0 )  + (inputs.get(1).isPowered ? 1 : 0 ) * 2 + ( inputs.get(2).isPowered ? 1 : 0) * 4);
            outputs.get(lastHigh).isPowered = false;
            outputs.get(a).isPowered = true;
            lastHigh = a;
        }
        power = c;
        return false;
    }
}

public class DelayNode extends Node {

    boolean power = false;
    public DelayNode (int x, int y) {
        this.x = x;
        this.y = y;
        this.width = 60;
        this.height = 55;
        this.text = "DELAY";
        this.nodeType = "Delay_Node";
        this.ID = getID();

        inputs.add(new InputHandle('w', color(255,255,255)));

        outputs.add(new OutputHandle('w', color(255,255,255)));
    }

    public void Draw(float zoom){
        super.Draw(zoom);
    }

    public boolean UpdateP(){
        outputs.get(0).isPowered = power;
        power = inputs.get(0).isPowered;
        return false;
    }
}

public class ClockNode extends Node {

    int tick = 0;
    public ClockNode (int x, int y) {
        this.x = x;
        this.y = y;
        this.width = 60;
        this.height = 55;
        this.text = "CLOCK";
        this.nodeType = "Clock_Node";
        this.ID = getID();

        inputs.add(new InputHandle('w', color(255,255,255)));

        outputs.add(new OutputHandle('w', color(255,255,255)));
    }

    public void Draw(float zoom){
        super.Draw(zoom);
    }

    public boolean UpdateP(){

        if (!inputs.get(0).isPowered){
            if (tick == 0) {
                outputs.get(0).isPowered = true;
            }else {
                outputs.get(0).isPowered = false;
            }
            tick++;
        }
        if (tick > 10) {
            tick = 0;
        }
        return false;
    }
}

public class ShiftRegisterNode extends Node {

    boolean power = false;
    int[] as = new int[]{0,0,0,0,0};
    int[] bs = new int[]{0,0,0,0,0};
    public ShiftRegisterNode (int x, int y) {
        this.x = x;
        this.y = y;
        this.width = 200;
        this.height = 95;
        this.text = "SHIFT REGISTER";
        this.nodeType = "ShiftRegister_Node";
        this.ID = getID();

        inputs.add(new InputHandle('w', color(255,255,255)));
        inputs.add(new InputHandle('w', color(255,255,255)));
        inputs.add(new InputHandle('w', color(255,255,255)));

        outputs.add(new OutputHandle('w', color(255,255,255)));
        outputs.add(new OutputHandle('w', color(255,255,255)));
        outputs.add(new OutputHandle('w', color(255,255,255)));
    }

    public void Draw(float zoom){
        super.Draw(zoom);
        float xv = x*zoom;
        float yv = y*zoom;
        strokeWeight(2);
        stroke(72, 87, 110, 255);
        line(xv + 25*zoom, yv + 40*zoom, xv + width*zoom - 25*zoom, yv + 40*zoom);
        line(xv + 25*zoom, yv + 80*zoom, xv + width*zoom - 25*zoom, yv + 80*zoom);
        line(xv + 25*zoom, yv + 40*zoom, xv + 25*zoom, yv + 80*zoom);
        line(xv + width*zoom - 25*zoom, yv + 40*zoom, xv + width*zoom - 25*zoom, yv + 80*zoom);
        line(xv + 62.5*zoom, yv + 40*zoom, xv + 62.5*zoom, yv + 80*zoom);
        line(xv + 137.5*zoom, yv + 40*zoom, xv + 137.5*zoom, yv + 80*zoom);
        line(xv + 100*zoom, yv + 40*zoom, xv + 100*zoom, yv + 80*zoom);

        line(xv + 25*zoom, yv + ((height + 25) /2) *zoom, xv + width * zoom - 25*zoom, yv + ((height + 25) /2) *zoom);

        textSize(12);
        fill(255);
        text(as[0], xv + 40*zoom, yv + 55*zoom);
        text(as[1], xv + 77.5*zoom, yv + 55*zoom);
        text(as[2], xv + 115*zoom, yv + 55*zoom);
        text(as[3], xv + 152.5*zoom, yv + 55*zoom);

        text(bs[0], xv + 40*zoom, yv + 75*zoom);
        text(bs[1], xv + 77.5*zoom, yv + 75*zoom);
        text(bs[2], xv + 115*zoom, yv + 75*zoom);
        text(bs[3], xv + 152.5*zoom, yv + 75*zoom);
    }

    public boolean UpdateP(){
        boolean c = inputs.get(1).isPowered;
        outputs.get(1).isPowered = c;
        if (power != c && !c) {
            int a = inputs.get(0).isPowered ? 1 : 0;
            int b = inputs.get(2).isPowered ? 1 : 0;
            int[] asn = new int[5];
            asn[0] = a;
            asn[1] = as[0];
            asn[2] = as[1];
            asn[3] = as[2];
            asn[4] = as[3];
            as = asn;
            int[] bsn = new int[5];
            bsn[0] = b;
            bsn[1] = bs[0];
            bsn[2] = bs[1];
            bsn[3] = bs[2];
            bsn[4] = bs[3];
            bs = bsn;
            outputs.get(0).isPowered = boolean(as[4]);
            outputs.get(2).isPowered = boolean(bs[4]);
        }
        
        power = c;
        return false;
    }
}