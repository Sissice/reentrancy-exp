pragma solidity ^0.8.0;

import "./Simple20Token.sol";
import "hardhat/console.sol";


contract Simple20Bank {
    mapping(address => uint) public balances;
    Simple20Token public token;

    constructor() public payable {
        token = new Simple20Token();
        // 钱包初始余额 10
        balances[address(this)] = 10 * 10**18;
    }

    //接收资金转入
    function deposit() public payable {
        token.mint(address(this),msg.value);
//        require(token.transfer(address(this),msg.value),"transfer failed");
        console.log("token.balanceOf(address(this))",token.balanceOf(address(this)));
        balances[msg.sender] += msg.value;
    }

    //提款
    function withdraw(uint _amount) public {
        unchecked{
            require(balances[msg.sender] >= _amount);
            console.log("msg.sender",msg.sender);
            console.log("balances[msg.sender]",balances[msg.sender]);
            console.log("token.balanceOf(msg.sender)",token.balanceOf(msg.sender));
            (bool success, ) = msg.sender.call{value: _amount}("");
            require(success, "Failed to send Ether");
            // 0.8.0版本默认检查整数溢出，需要添加unchecked才能复现
            balances[msg.sender] -= _amount;
            token.burn(address(this),_amount);
        }
    }

    //查询余额
    function getBalance() public view returns(uint) {
        return address(this).balance;
    }
}
