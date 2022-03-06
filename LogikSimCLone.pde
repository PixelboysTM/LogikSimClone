
ArrayList<Node> selection = new ArrayList<Node>();
ArrayList<Node> nodes = new ArrayList<Node>();
ArrayList<Connection> connectionsLs = new ArrayList<Connection>();
ArrayList<Connection> selConnections = new ArrayList<Connection>();
ArrayList<Node> history = new ArrayList<Node>();

boolean isPower = false;
String path = "";
int menenuBarHeigth = 25;

int mouseState = 0;
int inputMode = InputMode.MOVE;
float zoom = 1;

CreateNode createNode;

//Offset:
float offsetX;
float offsetY;


int width;;
int height;
int gridSize = 100;
OutputHandle oHandel;
Node oNode;
InputHandle iHandel;
Node iNode;
void settings(){
//  width = displayWidth;
//  height = displayHeight;
width = 1200;
height = 900;
  size(width, height);
  
}
void setup(){ 
  //nodes.add(new Node(10,10));
  
  PImage icon = loadImage("icon.png");
  surface.setIcon(icon);
  surface.setTitle("Logik Simulator!");
  surface.setResizable(true);
  if (args != null) {
    path = args[0];
    LoadFile(false);
  }
}

void InputMove(){
  boolean h = false;
  oHandel = null;
      oNode = null;
  for(Node n : nodes){
    if( n.Update(false, ' ', zoom)){
      oHandel = n.outH;
      oNode = n;
      h = true;
    }
  }

  if (h && mousePressed == true && mouseButton == LEFT && mouseState == 0) {
    mouseState = 0;
    inputMode = InputMode.CONNECTION;
    return;
  }

  
  if (mousePressed == true && mouseButton == LEFT) {
    cursor(HAND);   
    if (mouseState == 0) {
      mouseState = 1;
      SelectionHandle();
    }else if (mouseState == 1) {  
      MoveSelected();    
    }
  }else if (mousePressed == true && mouseButton == RIGHT) {
    inputMode = InputMode.CREATE_NODE;
    mouseState = 0;
  }else if (mousePressed == true && mouseButton == CENTER){
    for (Node n : nodes) {
      n.x += (mouseX - pmouseX);
      n.y += (mouseY - pmouseY);
      offsetX += (mouseX - pmouseX);
      offsetY += (mouseY - pmouseY);
      if (offsetX > gridSize){
        offsetX -= gridSize;
      }
      if (offsetY > gridSize){
        offsetY -= gridSize;
      }
      if (offsetX < -gridSize){
        offsetX += gridSize;
      }
      if (offsetY < -gridSize){
        offsetY += gridSize;
      }
    }
  }else {
    mouseState = 0;
    cursor(ARROW);
    if((selection.size() > 0 || selConnections.size() > 0) && keyPressed == true && key == DELETE){
      for (int i = 0; i < selection.size(); ++i) {
        Node n = selection.get(i);
        for (Connection c : connectionsLs) {
          if (c.input == n) {
            selConnections.add(c);
          }
          if (c.output == n) {
            selConnections.add(c);
          }
        }
        nodes.remove(selection.get(i)); 
      }
      selection = new ArrayList<Node>();
      
      for (int c = 0; c < selConnections.size(); ++c) {
        selConnections.get(c).inputH.connected = false;
        connectionsLs.remove(selConnections.get(c));
      }
      selConnections = new ArrayList<Connection>();
    }
  }
}
void InputCreate(){
  if (mouseState == 0) {
    createNode = new CreateNode(mouseX, mouseY);
    mouseState = 1;
  }
  Node[] n = createNode.CreateCall();
  if (n.length == 1) {
    if (n[0] != null) {
      nodes.add(n[0]);
      history.add(nodes.get(nodes.size() - 1));
    }
    inputMode = InputMode.MOVE;
    mouseState = 0;
  } 
}
void InputConnection(){
  boolean h = false;
  iHandel = null;
      iNode = null;
  for(Node n : nodes){
    if( n.Update(true, oHandel.type, zoom)){
      iHandel = n.inpH;
      iNode = n;
      h = true;
    }
  }
  if (h && mousePressed == true && mouseButton == LEFT) {
    mouseState = 0;
    inputMode = InputMode.CONNECTION;
  }

  if (mousePressed == true && mouseButton == LEFT) {
    InputHandle ih = new InputHandle(oHandel.type, oHandel.handleColor);
    ih.lx = mouseX;
    ih.ly = mouseY;
    Connection c = new Connection(null,ih , null, oHandel );
    c.Draw(zoom);
  }else {
    if (iNode != null) {
      iHandel.connected = true;
      Connection con = new Connection(iNode, iHandel, oNode, oHandel);
      connectionsLs.add(con);
    }
    inputMode = InputMode.MOVE;
  }
}


void InputHandling(){
  if (mouseY > menenuBarHeigth) {
  

  if (inputMode == InputMode.MOVE){
    InputMove();
  }else if (inputMode == InputMode.CREATE_NODE) {
    InputCreate();
  }else if (inputMode == InputMode.CONNECTION) {
    InputConnection();
  }else{
    
    }
  }else {
    HandleMenuBar();
  }
  
}


void HandleMenuBar(){
 
}
void SelectionHandle(){
  selection = new ArrayList<Node>();
  for (Node n : nodes) {
    int px = mouseX;
    int py = mouseY;
    float rx = n.x*zoom;
    float ry = n.y*zoom;
    float rw = n.width*zoom;
    float rh = n.height*zoom;

    if (px >= rx &&  px <= rx + rw && py >= ry && py <= ry + rh) {   
        selection.add(n);
        n.selected = true;
    }else {
      n.selected = false;
    }
  }
  selConnections = new ArrayList<Connection>();
  for (Connection c : connectionsLs){
    float px = mouseX;
    float py = mouseY;

    float x1 = c.x1;
    float x2 = c.x2;
    float y1 = c.y1;
    float y2 = c.y2;

    float d1 = dist(px, py, x1, y1);
    float d2 = dist(px, py, x2, y2);
    float lineLen = dist(x1, y1, x2, y2);
    float buffer = 0.5*zoom;

    c.selected = false;
    if (d1+d2 >= lineLen-buffer && d1+d2 <= lineLen+buffer) {
      c.selected = true;
      selConnections.add(c);
    }
  }
}
void MoveSelected(){
    for (Node n : selection){
    n.x += (mouseX - pmouseX);
    n.y += (mouseY - pmouseY);
  }
}

void draw(){
  surface.setTitle("Logik Simulator!");
  width = displayWidth;
  height = displayHeight;
  background(50, 50, 50, 255);
  DrawGrid();

  noFill();
  for(Connection con : connectionsLs){
    con.DrawBefore(zoom);
    con.Draw(zoom);
  }
  for(Node n : nodes){
    n.Draw(zoom);
  }

  DrawMenuBar();

  if (isPower) {
    noFill();
    stroke(255,123,0,255);
    strokeWeight(3);
    line(0, menenuBarHeigth, width, menenuBarHeigth);
    fill(255,123,0,255);
    textSize(14);
    text("Power mode", 225, menenuBarHeigth - 8);
    PowerInputHandling();
  
  }else{
    InputHandling();
  }
}

void PowerInputHandling(){
  for (Connection c : connectionsLs) {
    c.Update();
  }

  boolean action = false;
  for (Node n : nodes) {
    if (n.UpdateP()) {
      action = true;
    }

  }

  if (!action && mousePressed == true && (mouseButton == LEFT || mouseButton == CENTER)) {
    for (Node n : nodes) {
      n.x += (mouseX - pmouseX);
      n.y += (mouseY - pmouseY);
      offsetX += (mouseX - pmouseX);
      offsetY += (mouseY - pmouseY);
      if (offsetX > gridSize){
        offsetX -= gridSize;
      }
      if (offsetY > gridSize){
        offsetY -= gridSize;
      }
      if (offsetX < -gridSize){
        offsetX += gridSize;
      }
      if (offsetY < -gridSize){
        offsetY += gridSize;
      }
    }
  }
}

void DrawMenuBar(){
  fill(50, 50, 50, 255);
  rect(0, 0, width, menenuBarHeigth);
  strokeWeight(1);
  stroke(0, 255);
  line(0, menenuBarHeigth, width, menenuBarHeigth);


  //SaveButton
  fill(100, 100, 100, 255);
  if (mouseX >= 3 && mouseX <= 53 && mouseY <= menenuBarHeigth - 8 ) {
    fill(150, 150, 150, 255);
  }
  strokeWeight(0);
  rect(3, 4, 50 ,  menenuBarHeigth - 8 ,2,2,2,2);
  fill(255);
  textSize(10);
  text("Save File", 6, menenuBarHeigth - 8);

  //SaveAsButton
  fill(100, 100, 100, 255);
  if (mouseX >= 65 && mouseX <= 106 && mouseY <= menenuBarHeigth - 8 ) {
    fill(150, 150, 150, 255);
  }
  strokeWeight(0);
  rect(56, 4, 50 ,  menenuBarHeigth - 8 ,2,2,2,2);
  fill(255);
  textSize(10);
  text("Save As", 59, menenuBarHeigth - 8);

  //SaveAsButton
  fill(100, 100, 100, 255);
  if (mouseX >= 109 && mouseX <= 164 && mouseY <= menenuBarHeigth - 8 ) {
    fill(150, 150, 150, 255);
  }
  strokeWeight(0);
  rect(109, 4, 55 ,  menenuBarHeigth - 8 ,2,2,2,2);
  fill(255);
  textSize(10);
  text("Open File", 112, menenuBarHeigth - 8);

  //Reset Zoom
  fill(100, 100, 100, 255);
  if (mouseX >= 167 && mouseX <= 167+55 && mouseY <= menenuBarHeigth - 8 ) {
    fill(150, 150, 150, 255);
  }
  strokeWeight(0);
  rect(167, 4, 55 ,  menenuBarHeigth - 8 ,2,2,2,2);
  fill(255);
  textSize(10);
  text("Scale: " + str(zoom).substring(0,3), 170, menenuBarHeigth - 8);
}

void DrawGrid(){
  strokeWeight(1);
  stroke(0,0,0,255);
  for (int i = 0; i < (width / (gridSize * zoom)) + 4*gridSize; ++i) {
    line(i*(gridSize * zoom) + offsetX - 2*gridSize , 0, i*(gridSize * zoom) + offsetX - 2*gridSize, height);
  }
  for (int i = 0; i < (height / (gridSize * zoom)) + 4*gridSize; ++i) {
    line(0, i*(gridSize * zoom) + offsetY - 2*gridSize, width, i*(gridSize * zoom) + offsetY - 2*gridSize);
  }

  strokeWeight(0.5);
  stroke(10,10,10,255);
  for (int i = 0; i < (width / ((gridSize * zoom)/5)) + 4*gridSize; ++i) {
    line(i*((gridSize * zoom)/5) + offsetX - 2*gridSize, 0, i*((gridSize * zoom)/5) + offsetX - 2*gridSize, height);
  }
  for (int i = 0; i < (height / ((gridSize * zoom)/5)) + 4*gridSize; ++i) {
    line(0, i*((gridSize * zoom)/5) + offsetY - 2*gridSize, width, i*((gridSize * zoom)/5) + offsetY - 2*gridSize);
  }

  //only for fun;
  strokeWeight(0.2);
  stroke(25,25,25,255);
  for (int i = 0; i < (width / ((gridSize * zoom)/25)) + 4*gridSize; ++i) {
    line(i*((gridSize * zoom)/25) + offsetX - 2*gridSize, 0, i*((gridSize * zoom)/25) + offsetX - 2*gridSize, height);
  }
  for (int i = 0; i < (height / ((gridSize * zoom)/25)) + 4*gridSize; ++i) {
    line(0, i*((gridSize * zoom)/25) + offsetY - 2*gridSize, width, i*((gridSize * zoom)/25) + offsetY - 2*gridSize);
  }
}

void mouseWheel(MouseEvent event){
  float e = event.getCount();
  if (inputMode == InputMode.MOVE) {
    zoom += e/50;
    if (zoom < 0.5){
      zoom = 0.5;
    }else if (zoom > 2) {
      zoom = 2;
    }
    
  }else if (inputMode == InputMode.CREATE_NODE){
    createNode.Scroll(e);
  }
}

boolean isStrg = false;
boolean isShift = false;

void keyPressed() {
  if (keyCode == 17) {
    isStrg = true;
  }else if (keyCode == 16) {
    isShift = true;
  }else if (keyCode == 83 && isStrg && !isShift) {
    SaveFile(false);
  }else if (keyCode == 83 && isStrg && isShift) {
    SaveFile(true);
  }else if (keyCode == 79 && isStrg && !isShift) {
    LoadFile(true);
  }else if (keyCode == 80) {
    isPower = !isPower;
  }else if (keyCode == 90 && isStrg && !isShift) {
    Node n = history.get(history.size() -1);
    for (Connection c : connectionsLs) {
      if (c.input == n) {
        selConnections.add(c);
      }
      if (c.output == n) {
        selConnections.add(c);
      }
    }
    nodes.remove(n); 
    selection = new ArrayList<Node>();
    for (int c = 0; c < selConnections.size(); ++c) {
      selConnections.get(c).inputH.connected = false;
      connectionsLs.remove(selConnections.get(c));
    }
    selConnections = new ArrayList<Connection>();
    history.remove(n);
  }
}

void keyReleased() {
  if (keyCode == 17) {
    isStrg = false;
  }else if (keyCode == 16) {
    isShift = false;
  }
}

boolean lineLine(float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4) {

  // calculate the direction of the lines
  float uA = ((x4-x3)*(y1-y3) - (y4-y3)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));
  float uB = ((x2-x1)*(y1-y3) - (y2-y1)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));

  // if uA and uB are between 0-1, lines are colliding
  if (uA >= 0 && uA <= 1 && uB >= 0 && uB <= 1) {

    // optionally, draw a circle where the lines meet
    float intersectionX = x1 + (uA * (x2-x1));
    float intersectionY = y1 + (uA * (y2-y1));

    return true;
  }
  return false;
}

void mousePressed() {
  if ( mouseButton == LEFT ) {
    //SaveButton
    if (mouseX >= 3 && mouseX <= 53 && mouseY <= menenuBarHeigth - 8 ) {
    SaveFile(false);
    }
    //SaveAsButton
    if (mouseX >= 65 && mouseX <= 106 && mouseY <= menenuBarHeigth - 8 ) {
    SaveFile(true);
    }
    //OpenButton
    if (mouseX >= 109 && mouseX <= 164 && mouseY <= menenuBarHeigth - 8 ) {
    LoadFile(true);
    }
    //Reset Zoom
    if (mouseX >= 167 && mouseX <= 167+55 && mouseY <= menenuBarHeigth - 8 ) {
    zoom = 1;
    }
  }
}