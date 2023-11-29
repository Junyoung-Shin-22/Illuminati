from qiskit import QuantumCircuit

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

def calc_gate():
    qc = QuantumCircuit(9,9)
    
    # initialize circuit
    for i in range(9):
        if i % 2 != 0:
            qc.x(i)
    
    
    for i in range(len(applied_gates[0])):
        gates = get_gates_at_idx(i)

        # Check if there are any effective gates
        effective_gates = []
        for gate in gates:
            if gate not in ["Identity", "Conditional", "NotConditional", "Empty"]:
                effective_gates = [gate, gates.index(gate)]

        # Pass if there's none (includes something useless like conditional identity)
        if not effective_gates:
            for idx in range(9): qc.i(idx) # 
            continue

        # Check if conditional/not_conditional in gates and save its idx
        cond_idx = -1
        not_conditional = False
        if "Conditional" in gates:
            cond_idx = gates.index("Conditional")
        elif "NotConditional" in gates:
            cond_idx = gates.index("NotConditional")
            not_conditional = True
            
        gate_name = effective_gates[0][0]
        gate_idx = effective_gates[0][1]

        match gate_name:
            case "Swap":
                src_idx =gate_idx
                dst_idx = effective_gates[1][1]
                qc.swap(src_idx, dst_idx)
                continue
            case "Observe":
                qc.measure(gate_idx, gate_idx)
                continue
            case "Not":
                if cond_idx != -1:
                    if not_conditional:
                        qc.x(cond_idx)
                        qc.cx(cond_idx, gate_idx)
                        qc.x(cond_idx)
                    else:
                        qc.cx(cond_idx, gate_idx)
                else:
                    qc.x(gate_idx)
            case "Hadamard":
                if cond_idx != -1:
                    if not_conditional:
                        qc.x(cond_idx)
                        qc.ch(cond_idx, gate_idx)
                        qc.x(cond_idx)
                    else:
                        qc.ch(cond_idx, gate_idx)
                else:
                    qc.h(gate_idx)


def get_gates_at_idx(idx):  # Any way to access by columns in Python?
    gates = []
    for array in applied_gates.values():
        gates.append(array[idx])
    return gates
