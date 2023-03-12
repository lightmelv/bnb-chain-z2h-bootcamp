# Solidity

1. Add a variable to hold the address of the deployer of the contract
2. Update that variable with the deployer's address when the contract is deployed.
3. Write an external function to return
- Address 0x000000000000000000000000000000000000dEaD if called by the deployer
- The deployer's address otherwise

    // SPDX-License-Identifier: None

    pragma solidity 0.8.17;


    contract BootcampContract {

        address owner;

        constructor () {
            owner = msg.sender;
        }

        function getAddress() public view returns (address) {
            if (msg.sender == owner) {
                return address(0x000000000000000000000000000000000000dEaD);
            } else {
                return owner;
            }
        }
    }