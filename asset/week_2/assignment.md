# ZKU - Assignment 2

    Email - stanleychiu@protonmail.com
    Discord - HKerStanley#4125
    GitHub - https://github.com/HKerStanley/zk-uni (./asset/week_2)

## Question 1

1. As blockchain is essentially a state machine, any state change is a process of taking inputs, execute the state transition function which can be a simple transaction or smart contract function, that miners or validators will verify the validity. Once majority of them reach an agreement, the chain state will be updated and permanently stored. Anyone should be able to reach the current state of the blockchain by re-executing all transactions. Such re-execution nature meaning that all input data must be public and backup for validation, which bring up privacy concern, hard to scale and limitation on efficiency in both storage and computation. ZK based verification solve above mentioned problem as the input data can be remain private. Also greatly improve the performance as the zero knowledge proof is the only thing needed to be verify

2. A ZK VM is a circuit that takes part of the input of a program, so that a prover can be able to show that with given a set of inputs, they have correctly executed the program code on said inputs.

   ![Alt text](screenshot_q1_2.png "Q1 Part 2")

## Question 2

1.  By definition, Semaphore is a system which allows any Ethereum user to signal their endorsement of an arbitrary string, revealing only that they have been previously approved to do so, and not their specific identity.

    Users register their identity with hash of public key and random secrets, which stores in a Merkle Tree for later verification. When broadcasting signal, users will provide zero-knowledge proof of their membership and theres an public nullifier to check if the signal has been broadcasted before.

    Example of applications can be messaging application, digital document signing and POAP (Proof-Of-Attendance Protocol)

2.  1.  Screenshot of all test passed on main branch, commit `3bce72f` is failing `addWhistleblower` and `removeWhistleblower`
        ![Alt text](screenshot_q2_2_1.png "Q2 Part 2 Task 1")

    2.  Commented version of `semaphore.circom` : <https://github.com/HKerStanley/zk-uni/blob/main/asset/week_2/semaphore_with_comment.circom>

3.  Authenticated on Elefria

    ![Alt text](screenshot_q2_3.png "Q2 Part 3")

    1. User can lost or expose their secret, just like how they lost or expose their wallet seedphrase or private key. Its is also possible for users to run out of gas, as register and login are all transactions on the blockchain.

    2. I think Elefria can support auto-download of the user secret which encrypted with user's private key, so that the secret key saving process can be automated and prevent human error.

## Question 3

1. For `tornado-trees` it is simply an Merkle Tree implementation, which I believe is how Tornado Cash used to verify if a deposit exist and if a withdrawal is valid. But for `tornado-nova` it also act as a mixer, which is an improvement of the prior version because a mixer support users to deposit and withdraw custom amount of fund.

2. 1. `TreeUpdateArgsHasher.circom` is a circuit to create a SHA256 hash for the smart contract process and validation, which should be the `argsHash` in `TornadoTrees.sol` function `updateWithdrawalTree`. For a withdrawal tree update we need to provide the previous Merkle root, the new Merkle root, the path to the inserted subtree and data of the withdrawal event(block number, address of withdrawal, and the transaction has). These data are passed to the circuit to generate a snark proof, and in the smart contract it will in fact perform the same process, then verify if the samrt contract inputs lead to the same result as the snark proof. If its valid, the smart contract will store the updated Merkle root and complete an update. In the process the smart contract also emit the update event data so it is easier to reconstruct or verify the state of the Merkle Tree.

   2. Snark friendly hash function like Poseidon is expensive on-chain. To optimize the gas fee of a transaction, the process needs to be more dependent to the snark side. Computing SHA256 hash for snark is really heavy that requires a special machine to build the circuit, but once the circuit is built generating a proof with SHA256 hash is managable. This is also a good thing as the difficulty to setup give some level of protection to the protocol.

3. 1. Theres an error when I run with Windows WSL2 so I switch to use my Mac and all test passed.
      ![Alt text](screenshot_q3_3_1.png "Q3 Part 3 Task 1")

   2. I worte the test script in `custom.text.js` and copied it to this assignment folder: <https://github.com/HKerStanley/zk-uni/blob/main/asset/week_2/custom.test.js>
      ![Alt text](screenshot_q3_3_2.png "Q3 Part 3 Task 2")

4. L1Unwrapper is act as a bridge between L1 and the Gnosis Chain. When users withdraw assets from Tornado Cash Nova, the token will be unwrapped on L1 so that users can use them as they wish. The bridge will be able to collect transaction fee from the withdrawal(unwrap) process from user.

## Question 4

1. Tornado Cash's name is constantly brought up with criminal events like assets stealing or fraud, what is the team's stance for these kind of usage and how they put the balance between privacy and regulations?

2. It is hard to develop and maintain such one single circuit for all dapps, but there should be a set of circuits for a dapp domain. I am thinking this set of circuit like the programming language, that developers can leverage this set of well defined circuits to develop dapps. I believe in the future we will have many different set of circuits for zk-dapp development, just like today we have so many different programming language for different purpose.
