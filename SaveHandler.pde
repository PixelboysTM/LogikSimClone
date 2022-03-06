

void SaveFile(boolean useDialog){
    if (path == "" || useDialog) {
        selectOutput("Sav as", "SavePath");
    }else {
        JSONObject json = GetJson();
        saveJSONObject(json, path);
        surface.setTitle("Logik Simulator! (Saved!)");
        println("Saved");
    }
}

void LoadFile(boolean useDialog){
    if (useDialog || path == "") {
        selectInput("Open File", "LoadPath" );
    }else {
        SetJson();
    }
}

void SavePath(File s){
    if (selection != null) {
        path = s.getAbsolutePath();
        println("File Path: " + path);
        SaveFile(false);
    }
}

void LoadPath(File s){
    if (selection != null) {
        path = s.getAbsolutePath();
        println("File Path: " + path);
        LoadFile(false);
    }
}

JSONObject GetJson(){
    JSONObject json = new JSONObject();

    json.setFloat("zoom", zoom);
    json.setFloat("offsetX", offsetX);
    json.setFloat("offsetY", offsetY);
    JSONArray nodesJS = new JSONArray();
    JSONArray connectionsJS = new JSONArray();

    for (int i = 0; i < nodes.size(); i++) {
        Node n = nodes.get(i);
        JSONObject obj = new JSONObject();
        obj.setString("type", n.nodeType);
        obj.setFloat("Xpos", n.x);
        obj.setFloat("Ypos", n.y);
        obj.setFloat("width", n.width);
        obj.setFloat("height", n.height);
        obj.setInt("ID", n.ID);
        JSONArray handlesI = new JSONArray();
        for (int y = 0; y < n.inputs.size(); ++y) {
            InputHandle h = n.inputs.get(y);
            JSONObject hobj = new JSONObject();
            hobj.setFloat("lx", h.lx);
            hobj.setFloat("ly", h.ly);
            hobj.setInt("type", h.type);
            hobj.setInt("color", h.handleColor);
            hobj.setBoolean("connected", h.connected);
            hobj.setInt("ID", h.ID);
            handlesI.setJSONObject(y, hobj);
        }
        obj.setJSONArray("InputHandlePoints", handlesI);

        JSONArray handlesO = new JSONArray();
        for (int y = 0; y < n.outputs.size(); ++y) {
            OutputHandle h = n.outputs.get(y);
            JSONObject hobj = new JSONObject();
            hobj.setFloat("lx", h.lx);
            hobj.setFloat("ly", h.ly);
            hobj.setInt("type", h.type);
            hobj.setInt("color", h.handleColor);
            hobj.setInt("ID", h.ID);
            handlesO.setJSONObject(y, hobj);
        }
        obj.setJSONArray("OutputHandlePoints", handlesO);

        nodesJS.setJSONObject(i, obj);
    }
    json.setJSONArray("nodes", nodesJS);
    
    for (int i = 0; i < connectionsLs.size(); ++i) {
        Connection c = connectionsLs.get(i);
        JSONObject conObj = new JSONObject();
        conObj.setInt("ID", c.ID);
        conObj.setInt("InputID", c.input.ID);
        conObj.setInt("OutputID", c.output.ID);
        conObj.setInt("InputHID", c.inputH.ID);
        conObj.setInt("OutputHID", c.outputH.ID);
        connectionsJS.setJSONObject(i, conObj);
    }
    json.setJSONArray("connections", connectionsJS);

    return json;
}

void SetJson(){
    JSONObject json = loadJSONObject(path);
    zoom = json.getFloat("zoom");
    offsetX = json.getFloat("offsetX");
    offsetY = json.getFloat("offsetY");
    //Node loading
    ArrayList<Node> nodesOBJ = new ArrayList<Node>();
    JSONArray nodesJS = json.getJSONArray("nodes");

    for (int i = 0; i < nodesJS.size(); ++i) {
        JSONObject nodeOBJ = nodesJS.getJSONObject(i);
        Node n = CreateNodeOfType(nodeOBJ.getString("type"));
        n.y = nodeOBJ.getFloat("Ypos");
        n.x = nodeOBJ.getFloat("Xpos");
        n.width = nodeOBJ.getFloat("width");
        n.height = nodeOBJ.getFloat("height");
        n.ID = nodeOBJ.getInt("ID");

        JSONArray inputsHandleOBJ = nodeOBJ.getJSONArray("InputHandlePoints");
        ArrayList<InputHandle> iHandles = new ArrayList<InputHandle>();
        for (int u = 0; u < inputsHandleOBJ.size(); ++u) {
            JSONObject hobj = inputsHandleOBJ.getJSONObject(u);
            InputHandle h = new InputHandle(char(hobj.getInt("type")), hobj.getInt("color"));
            h.connected = hobj.getBoolean("connected");
            h.ID = hobj.getInt("ID");
            h.lx = hobj.getFloat("lx");
            h.ly = hobj.getFloat("ly");
            iHandles.add(h);
        }
        n.inputs = iHandles;

        JSONArray outputsHandleOBJ = nodeOBJ.getJSONArray("OutputHandlePoints");
        ArrayList<OutputHandle> oHandles = new ArrayList<OutputHandle>();
        for (int u = 0; u < outputsHandleOBJ.size(); ++u) {
            JSONObject hobj = outputsHandleOBJ.getJSONObject(u);
            OutputHandle h = new OutputHandle(char(hobj.getInt("type")), hobj.getInt("color"));
            h.ID = hobj.getInt("ID");
            h.lx = hobj.getFloat("lx");
            h.ly = hobj.getFloat("ly");
            oHandles.add(h);
        }
        n.outputs = oHandles;

        nodesOBJ.add(n);
    }

    nodes = nodesOBJ;

    //Load connections
    ArrayList<Connection> connectionsLsObj = new ArrayList<Connection>();
    JSONArray connectionsOBJ = json.getJSONArray("connections");
    for (int i = 0; i < connectionsOBJ.size(); ++i) {
        JSONObject cOBJ = connectionsOBJ.getJSONObject(i);
        int inputId = cOBJ.getInt("InputID");
        int inputHId = cOBJ.getInt("InputHID");
        Node inputNodeN = null; 
        InputHandle inputhandleH = null;
        for (Node n : nodes) {
            if (n.ID == inputId) {
                inputNodeN = n;
                for (InputHandle ih : n.inputs) {
                    if (ih.ID == inputHId) {
                        inputhandleH = ih;
                        break;
                    }
                }
                break;
            }
        }

        int outputId = cOBJ.getInt("OutputID");
        int outputHId = cOBJ.getInt("OutputHID");
        Node outputNodeN = null; 
        OutputHandle outputHandleH = null;
        for (Node n : nodes) {
            if (n.ID == outputId) {
                outputNodeN = n;
                for (OutputHandle oh : n.outputs) {
                    if (oh.ID == outputHId) {
                        outputHandleH = oh;
                        break;
                    }
                }
                break;
            }
        }
        
        
        int cId = cOBJ.getInt("ID");
        Connection c = new Connection(inputNodeN, inputhandleH, outputNodeN, outputHandleH);
        c.ID = cId;
        connectionsLsObj.add(c);
    }
    connectionsLs = connectionsLsObj;
    ReloadIdRegister();
}

Node CreateNodeOfType(String type){
    switch (type) {
        case "UNDEFINED" :
            return new Node(0,0);
        case "Switch_Node" :
            return new SwitchNode(0,0);		
        case "Lamp_Node" :
            return new LampNode(0,0);
        case "And_Node" :
            return new AndGateNode(0,0);	
        case "Or_Node" :
            return new OrGateNode(0,0);
        case "XOr_Node" :
            return new XOrGateNode(0,0);
        case "Not_Node" :
            return new NotGateNode(0,0);
        case "HalfAdder_Node" :
            return new HalfAdderNode(0,0);
        case "FullAdder_Node" :
            return new FullAdderNode(0,0);
        case "FlipFlop_Node" :
            return new FlipFlopNode(0,0);
        case "Decoder_Node" :
            return new DecoderNode(0,0);
        case "DecoderTakt_Node" :
            return new DecoderTaktNode(0,0);
        case "Delay_Node" :
            return new DelayNode(0,0);
        case "Clock_Node" :
            return new ClockNode(0,0);
        case "ShiftRegister_Node" :
            return new ShiftRegisterNode(0,0);
    }
    println("ERROR Type not found! " + type);
    return null;
}