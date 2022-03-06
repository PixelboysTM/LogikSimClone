public class Connection {

    boolean power = false;
    public int ID;
    public Node input,output;
    public InputHandle inputH;
    public OutputHandle outputH;
    public float x1,x2,y1,y2 = 0;
    public boolean selected = false;

    public Connection (Node input, InputHandle inputH, Node output, OutputHandle outputH ) {
        this.input = input;
        this.output = output;
        this.inputH = inputH;
        this.outputH = outputH;
        this.ID = getID();
    }

    public void DrawBefore(float zoom){
        strokeWeight(10*zoom);
        stroke(inputH.handleColor, selected ? 150 : 0);
        //line(inputH.lx, inputH.ly, inputH.lx - 20, inputH.ly);
        line(inputH.lx - 20*zoom, inputH.ly, outputH.lx + 20*zoom, outputH.ly);
        //line(outputH.lx + 20, outputH.ly, outputH.lx, outputH.ly);
    }
    public void Draw(float zoom){
        x1 = inputH.lx - 20*zoom;
        y1 = inputH.ly;
        x2 = outputH.lx + 20*zoom;
        y2 = outputH.ly;
        noFill();
        strokeWeight(3*zoom);
        stroke(inputH.handleColor, 255);
        if (power && isPower) {
            stroke( 255,123,0, 255);
            // line(inputH.lx, inputH.ly, inputH.lx - 20*zoom, inputH.ly);
            // line(inputH.lx - 20*zoom, inputH.ly, outputH.lx + 20*zoom, outputH.ly);
            // line(outputH.lx + 20*zoom, outputH.ly, outputH.lx, outputH.ly);
            bezier(inputH.lx, inputH.ly, inputH.lx - 50, inputH.ly, outputH.lx + 50, outputH.ly, outputH.lx, outputH.ly);
        }else
        if (inputH.handleColor != outputH.handleColor) {
            stroke(inputH.handleColor, 255);
            line(inputH.lx, inputH.ly, inputH.lx - 20*zoom, inputH.ly);
            gradiant_line(inputH.handleColor, outputH.handleColor, inputH.lx - 20*zoom, inputH.ly, outputH.lx + 20*zoom, outputH.ly);
            stroke(outputH.handleColor, 255);
            line(outputH.lx + 20*zoom, outputH.ly, outputH.lx, outputH.ly);

        }else {
            stroke( inputH.handleColor, 255);
            // line(inputH.lx, inputH.ly, inputH.lx - 20*zoom, inputH.ly);
            // line(inputH.lx - 20*zoom, inputH.ly, outputH.lx + 20*zoom, outputH.ly);
            // line(outputH.lx + 20*zoom, outputH.ly, outputH.lx, outputH.ly);
            bezier(inputH.lx, inputH.ly, inputH.lx - 50, inputH.ly, outputH.lx + 50, outputH.ly, outputH.lx, outputH.ly);

        }

        // bezier(inputH.lx, inputH.ly, inputH.lx - 50, inputH.ly, outputH.lx + 50, outputH.ly, outputH.lx, outputH.ly);
    }

    void gradiant_line( color s, color e, float x, float y, float xx, float yy ) {
  for ( int i = 0; i < 1000; i ++ ) {
    stroke( lerpColor( s, e, i/1000.0) );
    line( ((1000-i)*x + i*xx)/1000.0, ((1000-i)*y + i*yy)/1000.0, 
      ((1000-i-1)*x + (i+1)*xx)/1000.0, ((1000-i-1)*y + (i+1)*yy)/1000.0 );
  }
}

    public void Update(){
        if (outputH.isPowered) {
            power = true;
            inputH.isPowered = true;
        }else {
            power = false;
            inputH.isPowered = false;
        }
    }

}
