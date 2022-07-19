// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";

contract EdverseToken is ERC20 {  
    constructor() ERC20("EdverseToken", "EDV")    // CREATING EDV TOKEN WITH INITIAL SUPPLY OF 10,000
    {
        _mint(msg.sender, 1000000000 * 10 ** 18);
    }
}
