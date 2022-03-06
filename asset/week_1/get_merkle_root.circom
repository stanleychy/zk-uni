pragma circom 2.0.0;

include "mimcsponge.circom";

template GetMerkleRoot(nLeaves) {
    signal input leaves[nLeaves];
    signal output root;

    var nRuns = nLeaves / 2;

    component hashFunction;
    component hashFunctions[2];

    if (nRuns == 1) {
        hashFunction = MiMCSponge(2, 220, 1);
        hashFunction.k <== 0;
        hashFunction.ins[0] <== leaves[0];
        hashFunction.ins[1] <== leaves[1];
        root <== hashFunction.outs[0];
    } else {
        hashFunction = MiMCSponge(2, 220, 1);
        hashFunctions[0] = GetMerkleRoot(nRuns);
        hashFunctions[1] = GetMerkleRoot(nRuns);
        for (var i = 0; i < nRuns; i++) {
            hashFunctions[0].leaves[i] <== leaves[i];
            hashFunctions[1].leaves[i] <== leaves[nRuns + i];
        }
        hashFunction.k <== 0;
        hashFunction.ins[0] <== hashFunctions[0].root;
        hashFunction.ins[1] <== hashFunctions[1].root;
        root <== hashFunction.outs[0];
    }
 }

 component main {public [leaves]} = GetMerkleRoot(8);
