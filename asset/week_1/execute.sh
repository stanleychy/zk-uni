# Compile the circom template file
circom get_merkle_root.circom  --r1cs --wasm --sym --c

# Use NodeJS to generate witness
cd get_merkle_root_js
node generate_witness.js get_merkle_root.wasm ../input.json witness.wtns

# Copy the generated witness to root folder for easier access
cp witness.wtns ../witness.wtns
cd ..

# Powers of Tau
# Use snarkjs to start a "powers of tau" ceremony
snarkjs powersoftau new bn128 16 pot16_0000.ptau -v

# Contribute to the ceremony
snarkjs powersoftau contribute pot16_0000.ptau pot16_0001.ptau --name="First contribution" -v

# Phase 2
# Start the generation of phase 2
snarkjs powersoftau prepare phase2 pot16_0001.ptau pot16_final.ptau -v

# Start a new .zkey file that will contain the proving and verification keys together with all phase 2 contributions
snarkjs groth16 setup get_merkle_root.r1cs pot16_final.ptau get_merkle_root_0000.zkey

# Contribute to the phase 2 of the ceremony
snarkjs zkey contribute get_merkle_root_0000.zkey get_merkle_root_0001.zkey --name="Contributor One" -v

# Export the verification key
snarkjs zkey export verificationkey get_merkle_root_0001.zkey verification_key.json

# Generating a Proof
# Generates a Groth16 proof
# proof.json: it contains the proof.
# public.json: it contains the values of the public inputs and outputs
snarkjs groth16 prove get_merkle_root_0001.zkey witness.wtns proof.json public.json

# Verifying a Proof
# Should see "snarkJS: OK!"
snarkjs groth16 verify verification_key.json public.json proof.json

# Generate the Solidity code that allows verifying proofs on Ethereum blockchain
snarkjs zkey export solidityverifier get_merkle_root_0001.zkey verifier.sol

# Use snarkjs to generate the parameters of the verifyProof call to Verifier smart contract
snarkjs generatecall
