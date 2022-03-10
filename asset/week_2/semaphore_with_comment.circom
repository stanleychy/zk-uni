pragma circom 2.0.0;

include "../node_modules/circomlib/circuits/poseidon.circom";
include "./tree.circom";

/**
 * identityNullifier and identityTrapdoor are private inputs
 * from the user 
 * They are hashed and form the user's secret, which also used 
 * to hash the identity commitment that stored in the Merkle Tree
 */
template CalculateSecret() {
    signal input identityNullifier;
    signal input identityTrapdoor;

    signal output out;

    component poseidon = Poseidon(2);

    poseidon.inputs[0] <== identityNullifier;
    poseidon.inputs[1] <== identityTrapdoor;

    out <== poseidon.out;
}

/**
 * Hash the user hashed secret and get the identity commitment
 * to be stored in the Merkle Tree
 */
template CalculateIdentityCommitment() {
    signal input secret;

    signal output out;

    component poseidon = Poseidon(1);

    poseidon.inputs[0] <== secret;

    out <== poseidon.out;
}

/**
 * Hash identityNullifier that can be used to identity a user
 * and externalNullifier which is public, to form a nullifier hash
 * for the signal broadcasting action so to prevent double-signaling
 */
template CalculateNullifierHash() {
    signal input externalNullifier;
    signal input identityNullifier;

    signal output out;

    component poseidon = Poseidon(2);

    poseidon.inputs[0] <== externalNullifier;
    poseidon.inputs[1] <== identityNullifier;

    out <== poseidon.out;
}

// nLevels must be < 32.
// nLevels is the predefined depth of the Merkle Tree
template Semaphore(nLevels) {
    // identityNullifier and identityTrapdoor are hashed as user secret
    signal input identityNullifier;
    signal input identityTrapdoor;

    // treePathIndices and treeSiblings are inputs to support the proof
    // of identity commitment existence
    signal input treePathIndices[nLevels];
    signal input treeSiblings[nLevels];

    // signalHash is the hash of signal being broadcasted
    // externalNullifier is a hash to prevent double-signalling
    signal input signalHash;
    signal input externalNullifier;

    // Output the root to verify the existence of user
    // and nullifierHash to uniquely identify a signal broadcasting action by a user
    // which can be used to prevent double-signalling
    signal output root;
    signal output nullifierHash;

    component calculateSecret = CalculateSecret();
    calculateSecret.identityNullifier <== identityNullifier;
    calculateSecret.identityTrapdoor <== identityTrapdoor;

    signal secret;
    secret <== calculateSecret.out;

    component calculateIdentityCommitment = CalculateIdentityCommitment();
    calculateIdentityCommitment.secret <== secret;

    component calculateNullifierHash = CalculateNullifierHash();
    calculateNullifierHash.externalNullifier <== externalNullifier;
    calculateNullifierHash.identityNullifier <== identityNullifier;

    // Provided the path to the indentity commitment, find the Merkle root
    // so to be used to verify the existence of the indentity commitment
    component inclusionProof = MerkleTreeInclusionProof(nLevels);
    inclusionProof.leaf <== calculateIdentityCommitment.out;

    for (var i = 0; i < nLevels; i++) {
        inclusionProof.siblings[i] <== treeSiblings[i];
        inclusionProof.pathIndices[i] <== treePathIndices[i];
    }

    root <== inclusionProof.root;

    // Dummy square to prevent tampering signalHash.
    signal signalHashSquared;
    signalHashSquared <== signalHash * signalHash;

    nullifierHash <== calculateNullifierHash.out;
}

/**
 * signalHash is the hash of signal that is being broadcasted
 * externalNullifier is a public input to ensure the signal can only be broadcasted once
 * 20 is the defined depth of Merkle Tree that can hold 2^20 leaves
 */
component main {public [signalHash, externalNullifier]} = Semaphore(20);
