// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.11;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

/**
 * @title MerkleNFT
 * @dev Completely On-chain NFT with Merkle Tree transaction proof
 */
contract MerkleNFT is ERC721URIStorage {
    using Strings for uint256;

    // Incremental counter for generating token id
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // Set total supply of NFT so the Merkle Tree array can be initialized with appropriate size
    uint256 private _totalSupply = 8;

    // A Merkle Tree array with size 16 can store up to 8 leaves
    bytes32[] private _merkleTree = new bytes32[](16);

    // An array to store the leaves
    bytes32[] private _leaves = new bytes32[](_totalSupply);

    // Stores the current Merkle Root
    bytes32 private _merkleRoot;

    constructor() ERC721("MerkleNFT", "MNFT") {}

    /**
     * @dev Mint an NFT to any address
     * @param to receiver address of the NFT
     */
    function mint(address to) public returns (uint256) {
        require(to != address(0), "Receiver address is 0");
        require(_tokenIds.current() < _totalSupply, "Sold out");

        uint256 newItemId = _tokenIds.current();
        _tokenIds.increment();

        _mint(to, newItemId);
        commitToMerkleTree(
            keccak256(
                abi.encode(msg.sender, to, newItemId, tokenURI(newItemId))
            ),
            newItemId
        );

        return newItemId;
    }

    /**
     * @dev Get the tokenURI of the NFT in json format, which means on-chain metadata
     * @param tokenId of the NFT
     */
    function tokenURI(uint256 tokenId)
        public
        pure
        override
        returns (string memory)
    {
        bytes memory dataURI = abi.encodePacked(
            '{"name": "Merkle NFT #',
            tokenId.toString(),
            '", "description": "A Simple NFT with Merkle Tree Proof."}'
        );

        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(dataURI)
                )
            );
    }

    /**
     * @dev Should only be called by mint function that updates the merkle tree
     * @param hash Computed hash by keccak256 hash function with msg.sender, receiver address, tokenId, and tokenURI
     * @param index of the NFT
     */
    function commitToMerkleTree(bytes32 hash, uint256 index) private {
        _leaves[index] = hash;
        _merkleTree[index] = hash;
        for (uint256 i = _totalSupply; i < _merkleTree.length; i++) {
            _merkleTree[i] = keccak256(
                abi.encode(
                    _merkleTree[(i - _totalSupply) * 2],
                    _merkleTree[(i - _totalSupply) * 2 + 1]
                )
            );
        }
        _merkleRoot = _merkleTree[_leaves.length * 2 - 2];
    }

    /**
     * @dev Get _merkleRoot value
     */
    function getMerkleRoot() public view returns (bytes32) {
        return _merkleRoot;
    }

    /**
     * @dev Get _merkleTree value by index
     * @param index index of query value from _merkleTree
     */
    function getMerkleTreeValue(uint256 index) public view returns (bytes32) {
        return _merkleTree[index];
    }

    /**
     * @dev Get _leaves value by index
     * @param index index of query value from _leaves
     */
    function getLeaveValue(uint256 index) public view returns (bytes32) {
        return _leaves[index];
    }
}
