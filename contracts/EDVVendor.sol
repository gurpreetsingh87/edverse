// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "./EDVToken.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract EDVVendor is Ownable {
  EdverseToken edvToken;
  uint256 public tokensPerNativeCurrency = 100;
  event BuyTokens(address buyer, uint256 amountOfNativeCurrency, uint256 amountOfTokens);
  constructor(address tokenAddress) {
    edvToken = EdverseToken(tokenAddress);
  }

  function buyTokens() public payable returns (uint256 tokenAmount) {
    require(msg.value > 0, "You need to send some NativeCurrency to proceed");
    uint256 amountToBuy = msg.value * tokensPerNativeCurrency;

    uint256 vendorBalance = edvToken.balanceOf(address(this));
    require(vendorBalance >= amountToBuy, "Vendor contract has not enough tokens to perform transaction");

    (bool sent) = edvToken.transfer(msg.sender, amountToBuy);
    require(sent, "Failed to transfer token to user");
    
    emit BuyTokens(msg.sender, msg.value, amountToBuy);
    return amountToBuy;
  }
  function sellTokens(uint256 tokenAmountToSell) public {

    require(tokenAmountToSell > 0, "Specify an amount of token greater than zero");

    uint256 userBalance = edvToken.balanceOf(msg.sender);
    require(userBalance >= tokenAmountToSell, "You have insufficient tokens");

    uint256 amountOfNativeCurrencyToTransfer = tokenAmountToSell / tokensPerNativeCurrency;
    uint256 ownerNativeCurrencyBalance = address(this).balance;
    require(ownerNativeCurrencyBalance >= amountOfNativeCurrencyToTransfer, "Vendor has insufficient funds");
    (bool sent) = edvToken.transferFrom(msg.sender, address(this), tokenAmountToSell);
    require(sent, "Failed to transfer tokens from user to vendor");

    (sent,) = msg.sender.call{value: amountOfNativeCurrencyToTransfer}("");
    tokensPerNativeCurrency = tokensPerNativeCurrency + 1;
    require(sent, "Failed to send NativeCurrency to the user");
  }
  function getNumberOfTokensInNativeCurrency() public view returns(uint256) {
    return tokensPerNativeCurrency;
  }

  function withdraw() public onlyOwner {
    uint256 ownerBalance = address(this).balance;
    require(ownerBalance > 0, "No NativeCurrency present in Vendor");
    (bool sent,) = msg.sender.call{value: address(this).balance}("");
    require(sent, "Failed to withdraw");
  }
}
