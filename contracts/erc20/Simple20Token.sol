pragma solidity ^0.8.0;

import "hardhat/console.sol";

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @title Simple777Token
 * @dev Very simple ERC777 Token example, where all tokens are pre-assigned to the creator.
 * Note they can later distribute these tokens as they wish using `transfer` and other
 * `ERC20` or `ERC777` functions.
 * Based on https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/examples/SimpleToken.sol
 */
contract Simple20Token is ERC20 {
    /**
     * @dev Constructor that gives msg.sender all of existing tokens.
     */
    uint maxMints = 2000 * 10**18;
    address owner;

    constructor() ERC20("EP20", "EP20") {
        console.log(
            "token owner/minter: %s , token address: , block timestamp: %o",
            msg.sender,
            block.timestamp
        );
        _mint(msg.sender, 10 * 10**18);
        owner = msg.sender;

    }

    function mint(address account, uint256 amount) public {
        require(owner == msg.sender);
        _mint(account,amount);
    }

    function burn(address account, uint256 amount) public {
        require(owner == msg.sender);
        _burn(account,amount);
    }

}
