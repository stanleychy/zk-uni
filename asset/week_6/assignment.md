# ZKU - Assignment 6

    Email - stanleychiu@protonmail.com
    Discord - HKerStanley#4125
    GitHub - https://github.com/HKerStanley/zk-uni (./asset/week_6)

## Question 1: Interoperability trilemma

1.  Trustlessness - The security of the interop protocol is equal to the underlying domains.
    Extensibility - The design of the interop protocol can be extended and supported on any domain.
    Generalizeability - The design of the interop protocol is generalized, meaning that it is capable to handle arbitrary cross-domain data.

    For example, the Connext protocol choose to focus on trustlessness and extensibility as a locally verified protocol.

2.  The Connext protocol is trying to improve their generalizeability by making their locally verified NEXTP protocol act like a base layer. In such design users and developers can use this consistent interface across any domain, and generalize the solution by plugging in natively verified protocols on top of NXTP, just like a layer 2 of their NXTP protocol.

## Question 2: Ultra light clients

1. Full nodes will first commit to the entire accumulated blockchain history at each block. Such commitment can be captured in an append-only data structure known as a Merkle Mountain Range(MMR) and generate a zero knowledge proof of the commitment. The light client only need to sample a random number of blocks base on the current block header and the latest block header to verify the proof to sync up the blockchain state. new transactions can then be appended to the MMR, new root and zero knowledge proof will be generated so can be shared among light clients and verify each other to reach consensus for state transition.

2. For a bridge protocol to verify the state of the source chain and sync the state to destinated chain we want to minimize the amount of information needed to spped up the verification process. Such light client design as mentioned above allow the verifier on the destinated chain to only take the proof and latest commitment from the source chain, and require the relayer to only sample a small amount of blocks from the source chain for verification. This also decrease the level of dependency on the relayer for continuously forwarding all data from the source chain.

## Question 3: Horizon Bridge

1. Commented code here: <https://github.com/HKerStanley/zk-uni/tree/main/asset/week_6/horizon>

## Question 4: Rainbow Bridge

1.

2. Screenshot: ![Screenshot Q4-3](screenshot_q4_3.png "Q4 Part 3")

## Question 5: Thinking in ZK

1.
