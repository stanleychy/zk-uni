# ZKU.ONE Week1 Assignment

## Question 1 - Intro to circom
1. Takes a 4 leaves input and get the Merkle Root

    get_merkle_root.circom
    ```
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

    component main {public [leaves]} = GetMerkleRoot(4);

    ```

    public.json
    ```
    [
        "1767591491111054304950637348678561461191266274283762027709516319108521879132",
        "1",
        "2",
        "3",
        "4"
    ]
    ```

    Verified with the deployed Verifier.sol on RemixIDE
    ![Alt text](screenshot_q1_1.png "a title")
2. 
## Question 2 - Minting an NFT and committing the mint data to a Merkle Tree
## Question 3 - Understanding and generating ideas about ZK technologies