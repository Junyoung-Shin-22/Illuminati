from qiskit import QuantumCircuit
from qiskit.primitives import Sampler

GATE_HANDLERS = None

def transpose_list(ls):
    t = []
    for i in range(len(ls[0])):
        t.append([row[i] for row in ls])
    
    return t

def parse_applied_gates(applied_gates):
    parsed_gates = []

    for i, row in enumerate(applied_gates):
        cond_type = None
        gate = None

        source_qbit = None
        target_qbit = None

        for j in range(len(row)):
            if applied_gates[i][j] in ("Identity", "Not", "Hadamard", "Observe"):
                gate = applied_gates[i][j]
                target_qbit = j
            
            elif applied_gates[i][j] in ("Conditional", "NotConditional"):
                cond_type = applied_gates[i][j]
                source_qbit = j
            
            elif applied_gates[i][j] in ("Swap",):
                gate = "Swap"
                if source_qbit is not None:
                    source_qbit = j
                else:
                    target_qbit = j
        
        parsed_gates.append({
            'cond_type': cond_type,
            'gate': gate,
            'source_qbit': source_qbit,
            'target_qbit': target_qbit,
        })
            
    return parsed_gates

def calc_gate(parsed_gates):
    # initialize circuit
    qc = QuantumCircuit(9,9)
    # for i in range(9):
    #     if i % 2 != 0:
    #         qc.x(i)
    
    for operation in parsed_gates:
        gate = operation['gate']
        cond = operation['cond_type']

        src = operation['source_qbit']
        dst = operation['target_qbit']

        GATE_HANDLERS[gate](qc, cond, src, dst)
    
    return qc

def _handle_identity(qc, cond, src, dst):
    pass

def _handle_not(qc, cond, src, dst):
    if cond is not None:
        if cond == 'NotConditional':
            qc.x(src)
            qc.cx(src, dst)
            qc.x(src)
        else:
            qc.cx(src, dst)
    else:
        qc.x(dst)

def _handle_hadamard(qc, cond, src, dst):
    if cond is not None:
        if cond == 'NotConditional':
            qc.x(src)
            qc.ch(src, dst)
            qc.x(src)
        else:
            qc.ch(src, dst)
    else:
        qc.h(dst)

def _handle_swap(qc, cond, src, dst):
    qc.swap(src, dst)

def _handle_observe(qc, cond, src, dst):
    qc.measure(dst, dst)


GATE_HANDLERS = {
    "Identity": _handle_identity,
    "Not": _handle_not,
    "Hadamard": _handle_hadamard,
    "Swap": _handle_swap,
    "Observe": _handle_observe,
}

if __name__ == '__main__':
    applied_gates = [
        ["Empty", "Empty"],
        ["Hadamard", "Conditional"],
        ["Empty", "Empty"],
        ["Empty", "Empty"],
        ["Empty", "Empty"],
        ["Empty", "Empty"],
        ["Empty", "Empty"],
        ["Empty", "Empty"],
        ["Empty", "Not"]
    ]
    parsed_gates = parse_applied_gates(transpose_list(applied_gates))
    # print(*parsed_gates, sep= '\n')
    qc = calc_gate(parsed_gates)
    qc.measure_all(inplace=True, add_bits=False)
    
    sampler = Sampler()
    
    job = sampler.run(qc)
    result = job.result()
    dist = result.quasi_dists[0]
    
    for i in dist:
        print(f"qbits: {i:09b} | p={dist[i]}")
