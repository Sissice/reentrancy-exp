const { expect } = require("chai");

describe("Simple223 Wallet", function () {
    describe("Attack ", function () {
        it("Should reentrancy", async function () {
            // 部署erc223代币合约
            const [owner] = await ethers.getSigners();

            const Wallet = await hre.ethers.getContractFactory("Simple223Wallet",owner);
            const wallet = await Wallet.deploy();

            await wallet.deployed();

            console.log("wallet contract deployed to:", wallet.address);

            tokenAdd = await wallet.token();
            console.log("token contract deployed to:", tokenAdd);

            const token = await hre.ethers.getContractAt("Simple223Token", tokenAdd);

            const Attack = await hre.ethers.getContractFactory("Attack223");
            const attack = await Attack.deploy(wallet.address);

            await attack.deployed();

            console.log("attack contract deployed to:", attack.address);

            console.log("before attack,the owner balance",await token.balanceOf(wallet.address))
            console.log("before attack,the attacker balance",await token.balanceOf(attack.address))
            //
            const receipt = await attack.exp()
            console.log("before attack,the owner balance",await token.balanceOf(wallet.address))
            console.log("after attack,the attacker balance",await token.balanceOf(attack.address))

        });
    });

});
