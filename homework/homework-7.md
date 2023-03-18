# Security

1. Look at the following contract, there are a number of vulnerabilities and flaws. In your teams try to find all of the problems. You do not need to fix any of the problems.
[BadLottery](https://gist.github.com/extropyCoder/156a26c5ba5a9148dc38740eb43f7d60)

- Lack of access control, everyone can call the addNewPlayer function and register themselves as a player, even if they haven't paid the required 500000 wei. This means that non-paying players can easily manipulate the game, and the payout amount can be reduced.
- No validation of input data, the addNewPlayer function does not check if the _playerAddress parameter is a valid address, which can result in errors or unexpected behavior if the function is called with an invalid address.
- Lack of randomness, the pickWinner function obtains randomness from the block timestamp, which is insecure and can be manipulated by miners. This means that the game can be easily manipulated and the winners can be predicted.
- Lack of error handling, if a player transfer fails, the distributePrize function does not handle errors. This means that if there is an issue during the transfer, the entire function will fail and the remaining players will not be paid.
- No use of ERC20 standard
- No use of safe math