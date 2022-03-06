pragma circom 2.0.0;

include "mimcsponge.circom";

template GetMerkleRoot(nLeaves) {
    signal input leaves[nLeaves];
    signal output root;

    component hashFunction = MiMCSponge(nLeaves, 220, 1);
    hashFunction.k <== 0;
    for (var i = 0; i < nLeaves; i++) {
        hashFunction.ins[i] <== leaves[i];
    }

    root <== hashFunction.outs[0];
 }

 component main {public [leaves]} = GetMerkleRoot(8);
