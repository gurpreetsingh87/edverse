// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";


contract EdverseToken is ERC20 {
    constructor() ERC20("EdverseToken", "EDV") {
        _mint(msg.sender, 1000 * 10 ** 18);
    }
}