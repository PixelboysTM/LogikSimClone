


public class Handle {

    public boolean isPowered = false;
    public int ID;
    public float lx,ly = 0;
    public boolean hover = false;
    public char type = ' ';
    public color handleColor = color(255, 255, 255);
    public Handle (char type, color handleColor) {
        this.type = type;
        this.handleColor = handleColor;
        this.ID = getID();
    }

    public void Draw(float x, float y, float zoom){
        lx = x;
        ly = y;
        if (hover){
            if (isPowered && isPower) {
                fill(255,123,0, 100);
            }else {
                fill(handleColor, 100);
            }
            ellipse(x, y, 15*zoom, 15*zoom);
        }

        strokeWeight(0);
        if (isPowered && isPower) {
                fill(255,123,0);
            }else {
                fill(handleColor);
            }
        ellipse(x, y, 10*zoom, 10*zoom);
    }

    public boolean IsHover(float zoom){
        float distX = mouseX - lx;
        float distY = mouseY - ly;
        float distance = sqrt( (distX*distX) + (distY*distY) );

        if (distance <= 10*zoom) {
            hover = true;
            return true;
        }
        hover = false;
        return false;
    } 
}

public class InputHandle extends Handle {

    public boolean connected = false;
    public InputHandle (char type , color handleColor) {
        super(type,handleColor);
    }

    public void Draw(float x, float y, float zoom){
        if (isPowered && isPower) {
            fill(255,123,0);
        }else {
            fill(handleColor);
        }
        rect(x+2*zoom, y-3*zoom, (x - 8*zoom) - (x+2*zoom) , (y + 3*zoom) - (y-3*zoom), 1,1,1,1);
        super.Draw(x,y, zoom);
    }
}

public class OutputHandle extends Handle {

    public OutputHandle (char type , color handleColor) {
        super(type,handleColor);
    }

    public void Draw(float x, float y, float zoom){
        if (isPowered && isPower) {
            fill(255,123,0);
        }else {
            fill(handleColor);
        }
        rect(x-2*zoom, y-3*zoom, (x + 8*zoom) - (x-2*zoom) , (y + 3*zoom) - (y-3*zoom), 1,1,1,1);
        super.Draw(x,y, zoom);
    }
}
