// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.11;

/**
 * @title HelloWorld
 * @dev Store an unsigned integer and then retrieve it
 */
contract HelloWorld {

    // Unsigned integer store
    uint256 private number;

    /**
     * @dev Store value in variable
     * @param _number value to store
     */
    function store(uint256 _number) public {
        number = _number;
    }

    /**
     * @dev Return value 
     * @return value of 'number'
     */
    function retrieve() public view returns (uint256){
        return number;
    }
}