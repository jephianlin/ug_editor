import json

''' Use these function to export a Sage Graph as a JSON string that can be used
by the graph editor and vice versa.'''

def graph_to_JSON(G_input):
    # in graph_editor all labels are strings
    G = G_input.relabel(str, inplace=False)
    data = {
        'vertices': G.vertices(),
        'edges': G.edges(),
        'pos': G.get_pos(),
        'name':'G'
    }
    return json.dumps(data)

def JSON_to_graph(json_data):
    data = json.loads(json_data)
    G = Graph()
    G.add_vertices(data['vertices'])
    G.add_edges(data['edges'])
    G.set_pos(data['pos'])
    return numberfy_graph(G);

def numberfy_graph(g):
    V=[int(v) for v in g.vertices()];
    E=[(int(i),int(j),k) for i,j,k in g.edges()];
    h=Graph([V,E]);
    g_pos=g.get_pos();
    if g_pos!=None:
        pos={v: g_pos["%s"%v] for v in V};
        h.set_pos(pos);
    return h;

### Line 23--32: Add by Jehian
### Below added for uncertain graphs;

def ugraph_to_JSON(g):
    """
    Input:
        g: an UncertainGraph;
    Output:
        encode g in a string of JSON format;
    """
    ### set "vertices":
    stg = '{"vertices": [';
    for v in g.vertices():
        stg += '"%s", '%v;
    stg = stg[0:-2];
    stg += ']';
    ### set "vertices":
    stg += ', "edges": [';
    for e in g.edges():
        stg += '["%s","%s","%s","edge"], '%(e[0],e[1],e[2]);
    for e in g.nonedges():
        stg += '["%s","%s","%s","nonedge"], '%(e[0],e[1],e[2]);
    stg = stg[0:-2];
    stg += ']';
    pos=g.get_pos();
    if pos != None:
        stg += ', "pos": {'
        for v in g.vertices():
            stg += '"%s":[%s,%s], '%(v,pos[v][0],-pos[v][1]); 
            ### note that the y axises in Sage and in JS is in opposite direction;
    stg = stg[0:-2];
    stg += '}';
    stg += ', "name": "G"} ';
    return stg;
    
def JSON_to_ugraph(json_data):
    data = json.loads(json_data);
    ge = Graph();
    ge.add_vertices(data['vertices']);
    ge.add_edges([(e[0],e[1],e[2]) for e in data['edges'] if e[3]=="edge"]);
    ge.set_pos(data['pos'])
    gn = Graph();
    gn.add_vertices(data['vertices']);
    gn.add_edges([(e[0],e[1],e[2]) for e in data['edges'] if e[3]=="nonedge"]);
    g=UncertainGraph(numberfy_graph(ge),numberfy_graph(gn));
    ### note that the y axises in Sage and in JS is in opposite direction;
    old_pos=g.get_pos();
    new_pos={v:[old_pos[v][0],-old_pos[v][1]] for v in g.vertices()};
    g.set_pos(new_pos);
    return g;
    