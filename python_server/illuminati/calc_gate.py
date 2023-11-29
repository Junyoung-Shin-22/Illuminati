import qiskit

applied_gates = {
	0:[],
	1:[],
	2:[],
	3:[],
	4:[],
	5:[],
	6:[],
	7:[],
	8:[],
	9:[]
}

lamp_state = [ # |0> prob, |1> prob, is_observed
	[1,0, False],
	[0,1, False],
	[1,0, False],
	[0,1, False],
	[1,0, False],
	[0,1, False],
	[1,0, False],
	[0,1, False],
	[1,0, False],
]

def game_end():
    for i in range(len(applied_gates[0])):
        
        gates = get_gates_at_idx(i)
        
        # check if there are any effective gates
        effective_gates = []
        for gate in gates: 
            if gate != "Identity" and gate != "Conditional" and gate != "NotConditional" and gate != "Empty":
                effective_gates = [gate, gates.find(gate)]
        
        # pass if there's none. this includes smth useless like conditional identity
        if effective_gates.is_empty():
            continue
        # pass if the target lamp is already observed
        if lamp_state[effective_gates[0][1]][2]:
            continue
        
        # swap
        if effective_gates[0][0] == "Swap":
            swap_states(effective_gates)
            continue
        
        # observe
        if effective_gates[0][0] == "Observe":
            lamp_state[effective_gates[0][1]][2] = True # mark the lamp as observed
            continue
        
        # check if conditional/not_conditional in gates and save its idx
        cond_idx = -1
        not_conditional = False
        if "Conditional" in gates:
            cond_idx = gates.find("Conditional")
        elif "NotConditional" in gates:
            cond_idx = gates.find("NotConditional")
            not_conditional = True
        
        # apply the gate
        match effective_gates[0][0]:
            case "Hadamard":
                pass
            case "Not":
                pass
			
def swap_states(gate_info):
	pass
		
def get_gates_at_idx(idx): # any way to access by columns in godot?
	gates = []
	for array in applied_gates.values():
		gates.append(array[idx])
	return gates