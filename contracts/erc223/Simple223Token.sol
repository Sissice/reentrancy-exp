pragma solidity ^0.8.0;

import "./ERC223.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import "hardhat/console.sol";

contract Simple223Token is ERC223Token {
        constructor() ERC223Token("EP223", "EP2", 18) {
            console.log(
                "token owner/minter: %s , token address: , block timestamp: %o",
                msg.sender,
                block.timestamp
            );
            _mint(msg.sender, 500 * 10**18);
        }

}

contract Simple223Wallet {
    Simple223Token public token;
    mapping(address => uint256) public balanceOf;
    bool flag = true;

    constructor () {
        token = new Simple223Token();
        // 钱包初始余额 500
        balanceOf[address(this)] = 500 * 10**18;
    }

    function tokenReceived(
        address _from,
        uint256 _value,
        bytes memory _data
    ) public {
        require(msg.sender == address(token));
        require(balanceOf[_from] + _value >= balanceOf[_from]);

        balanceOf[_from] += _value;
    }

    // 可以领取一次100的空投
    function airdrop(address getAirdrop) public {
        require(flag);
        require(token.transfer(getAirdrop, 100 * 10**18));
        balanceOf[getAirdrop] += 100 * 10**18;
        balanceOf[address(this)] -= 100 * 10**18;
        console.log("balanceOf[getAirdrop]",balanceOf[getAirdrop]);
        console.log("balanceOf[this]",balanceOf[address(this)]);
        flag = false;
    }

    function withdraw(uint256 amount) public {
        require(balanceOf[msg.sender] >= amount);

        require(token.transfer(msg.sender, amount));
        console.log("balanceOf[msg.sender]",balanceOf[msg.sender]);
        balanceOf[msg.sender] -= amount;
    }

}
