# ZKU - Assignment 2

    Email - stanleychiu@protonmail.com
    Discord - HKerStanley#4125
    GitHub - https://github.com/HKerStanley/zk-uni (./asset/week_2)

## Question 1

1. Frist transactions are broadcasted and processed and validated by miners, then packed into a new block. This new block will be verified by blockchain validators after they come to an agreement of the order of events and confirm that transactions in the block are valid, block will be added to the blockchain which leads the blockchain to a new state.

2. 1.
   2.
   3.

## Question 2

1.  By definition, Semaphore is a system which allows any Ethereum user to signal their endorsement of an arbitrary string, revealing only that they have been previously approved to do so, and not their specific identity.

    Users register their identity with hash of public key and random secrets, which stores in a Merkle Tree for later verification. When broadcasting signal, users will provide zero-knowledge proof of their membership and theres an public nullifier to check if the signal has been broadcasted before.

    Example of applications can be messaging application, digital document signing and POAP (Proof-Of-Attendance Protocol)

2.  1.  Screenshot
        ![Alt text](screenshot_q2_2_1.png "Q2 Part 2 Task 1")

    2.  First we look at the public inputs: `externalNullifier` is a value being used when broadcasting a signal, to identify if it is the first time a user broadcasting

## Question 3

## Question 4

1. Tornado Cash's name is constantly brought up with criminal events like assets stealing or fraud, what is the team's stance for these kind of usage of their platform and how they put the balance between privacy and regulations?