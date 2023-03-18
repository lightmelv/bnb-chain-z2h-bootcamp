### Badger coin contract
1. Create an BEP20 contract with the following details :
	Name : "BadgerCoin"
	Symbol : "BC"
	Decimals : 18
	Initial supply : 1000000 tokens
   Deploy this to a test network and exchange some with your colleagues.
   You may inherit from Open Zeppelin contracts.

```
// SPDX-License-Identifier: None

pragma solidity ^0.8.0;

import "@openzeppelin/contracts@4.8.2/token/ERC20/ERC20.sol";

contract BadgerCoin is ERC20 {
    constructor() ERC20("BadgerCoin", "BC") {
        _mint(msg.sender, 1000000000000000000000000);
    }
}
```

### Verification
1. Take one of the contracts you created in the previous homework and deploy it to BSC test net.
2. Find your deployed contract on the block explorer
3. Verify your contract, using verify and publish
4. Interact with your contract using the 'Read Contract' and 'Write Contract' tabs.

[https://testnet.bscscan.com/token/0x94B5BCF42A756Bfc1661553A9B3cC987D8ae2CBa#code](https://testnet.bscscan.com/token/0x94B5BCF42A756Bfc1661553A9B3cC987D8ae2CBa#code)
