pragma solidity ^0.8.9;

import "hardhat/console.sol";

import "@openzeppelin/contracts/token/ERC777/ERC777.sol";

/**
 * @title Simple777Token
 * @dev Very simple ERC777 Token example, where all tokens are pre-assigned to the creator.
 * Note they can later distribute these tokens as they wish using `transfer` and other
 * `ERC20` or `ERC777` functions.
 * Based on https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/examples/SimpleToken.sol
 */
contract Simple777Token is ERC777 {
    /**
     * @dev Constructor that gives msg.sender all of existing tokens.
     */
    uint maxMints = 2000 * 10**18;

    constructor() ERC777("EP777", "EP7", new address[](0)) {
        console.log(
            "token owner/minter: %s , token address: , block timestamp: %o",
            msg.sender,
            block.timestamp
        );
        _mint(msg.sender, 100 * 10**18, "", "");

    }

    function mint(
        address account,
        uint256 amount,
        bytes memory userData,
        bytes memory operatorData
    ) public returns (bool) {
        require(maxMints >= totalSupply());
        _mint(account, amount, userData, operatorData);
        console.log("msg.sender",msg.sender);
        return true;
    }

    function safeTransfer(address recipient, uint256 amount) public virtual returns (bool) {
        send(recipient,amount,"");
        return true;
    }
}
