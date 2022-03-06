IntList IDs = new IntList();

int getID(){
    int id = -1;

    boolean a = true;
    while (a) {
        a = false;
        id  = int(random(10, 99999999999L));
        for (int i : IDs) {
            if (id == i) {
                a = true;
            }
        }
    }
    IDs.append(id);
    return id;
}

void ReloadIdRegister(){
    IntList newIds = new IntList();
    for (Node n : nodes) {
        newIds.append(n.ID);
        for (InputHandle ih : n.inputs) {
            newIds.append(ih.ID);
        }
        for (OutputHandle oh : n.outputs) {
            newIds.append(oh.ID);
        }
    }
    for (Connection c : connectionsLs) {
        newIds.append(c.ID);
    }
    IDs = newIds;
}