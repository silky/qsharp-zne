﻿namespace qsharp_zne {

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Diagnostics;

    @EntryPoint()
    operation CheckFold() : Unit {
        use q = Qubit[4];
        ApplyTest(q);
        //let result = MResetZ(q[0]);
        //Message($"{result}");
        GlobalFold(ApplyTest, 3)(q);
        let results = MultiM(q);
        ResetAll(q);
        Message($"{results}");
    }
    
    
    operation HelloQ() : Result {
        use msg = Qubit();
        use here = Qubit();
        use there = Qubit();
        X(msg);
        H(here);
        //return MResetZ(here);
         CNOT(here, there);
         CNOT(msg, here);
         H(msg);
        Z(msg);
        if M(msg) == One  { Z(there); }
        if M(here) == One { X(there); }
        Z(there);
         return M(there);
    }

    operation ApplyX() : Result {
        use q = Qubit();
        X(q);
        return MResetZ(q);
        
        //ApplyToEach(X, q);
        //MultiM(q);
        //Reset(q);
    }

    operation ApplyTest(target : Qubit[]) : Unit
    is Adj + Ctl {
        //X(target[0]);
        H(target[0]);
        DumpMachine();
    }


    function GlobalFold(op : (Qubit[]=>Unit is Adj), scaleFactor : Int) 
    : (Qubit[]=>Unit is Adj) {
        //Figuring out how many "pairs" of operations to repeat
        let numPairs = (scaleFactor - 1) / 2;

        //[op, adj op, op, adj op,...]
        let foldedOperationArray = [op] + Flattened(ConstantArray(numPairs, [op, Adjoint(op)]));

        return (BoundA(foldedOperationArray));
        //return RepeatA(op, scaleFactor, _);
    }

}

