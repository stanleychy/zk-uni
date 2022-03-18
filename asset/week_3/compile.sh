# Compile the circom template file
circom triangle_jump.circom --r1cs --wasm --sym --c

# Use NodeJS to generate witness
cd triangle_jump_js
node generate_witness.js triangle_jump.wasm ../input.json witness.wtns

# Copy the generated witness to root folder for easier access
cp witness.wtns ../witness.wtns
cd ..

# Powers of Tau
# Use snarkjs to start a "powers of tau" ceremony
snarkjs powersoftau new bn128 12 pot12_0000.ptau -v

# Contribute to the ceremony
snarkjs powersoftau contribute pot12_0000.ptau pot12_0001.ptau --name="First contribution" -v

# Phase 2
# Start the generation of phase 2
snarkjs powersoftau prepare phase2 pot12_0001.ptau pot12_final.ptau -v

# Start a new .zkey file that will contain the proving and verification keys together with all phase 2 contributions
snarkjs groth12 setup triangle_jump.r1cs pot12_final.ptau triangle_jump_0000.zkey

# Contribute to the phase 2 of the ceremony
snarkjs zkey contribute triangle_jump_0000.zkey triangle_jump_0001.zkey --name="Contributor One" -v

# Export the verification key
snarkjs zkey export verificationkey triangle_jump_0001.zkey verification_key.json

# Generating a Proof
# Generates a Groth16 proof
# proof.json: it contains the proof.
# public.json: it contains the values of the public inputs and outputs
snarkjs groth16 prove triangle_jump_0001.zkey witness.wtns proof.json public.json

# Verifying a Proof
# Should see "snarkJS: OK!"
snarkjs groth16 verify verification_key.json public.json proof.json

# Generate the Solidity code that allows verifying proofs on Ethereum blockchain
snarkjs zkey export solidityverifier triangle_jump_0001.zkey verifier.sol

# Use snarkjs to generate the parameters of the verifyProof call to Verifier smart contract
snarkjs generatecall
