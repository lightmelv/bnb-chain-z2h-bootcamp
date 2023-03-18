# Solidity

1. Add a variable to hold the address of the deployer of the contract
2. Update that variable with the deployer's address when the contract is deployed.
3. Write an external function to return
- Address 0x000000000000000000000000000000000000dEaD if called by the deployer
- The deployer's address otherwise

```
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
```

# DogCoin Contract

```
// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.18;

contract DogCoin {
    uint256 _totalSupply;
    address owner;

    struct Payment {
        address recipient;
        uint256 amount;
    }

    mapping(address => uint256) balances;
    mapping(address => Payment) payments;

    modifier onlyOwner {
        require(msg.sender == owner, "Only owner can execute this action");
        _;
    }

    event totalSupply_increase(uint256);
    event transferEvent(address, uint256);

    constructor() {
        owner = msg.sender;
        _totalSupply = 2000000;
        balances[owner] = _totalSupply;
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function increaseTotalSupply(uint256 _amount) public onlyOwner {
        require(_amount % 1000 == 0, "Increasing Supply must be increment of 1000");
        _totalSupply += _amount;
        balances[owner] += _amount;
        emit totalSupply_increase(_totalSupply);
    }

    function balanceOf(address _tokenOwner) public view returns (uint256) {
        return balances[_tokenOwner];
    }

    // We don't need sender parameter because we can define it with msg.sender
    // If we implement the sender parameter, then everyone can transfer the token without sender permission
    function transfer(address _recipient, uint256 _amount) public{
        require(balances[msg.sender] > _amount, "Insufficient balance");
        balances[msg.sender] -= _amount;
        balances[_recipient] += _amount;

        payments[msg.sender] = Payment({
            recipient: _recipient, 
            amount: _amount
        });

        emit transferEvent(_recipient, _amount);
    }
}
```