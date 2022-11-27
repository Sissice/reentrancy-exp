const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");
const { expect } = require("chai");
const { ensureERC1820 } = require("../utils/Hardhat-erc1820");

describe("Simple777 Wallet", function () {
    async function deploy() {
        // 部署erc1820
        await ensureERC1820(hre.network.provider)

        // 部署erc777代币合约
        const MyToken = await hre.ethers.getContractFactory("Simple777Token");
        const token = await MyToken.deploy();

        await token.deployed();

        console.log("token contract deployed to:", token.address);

        // 部署钱包合约
        const Wallet = await hre.ethers.getContractFactory("Simple777Recipient");
        const wallet = await Wallet.deploy(token.address);

        await wallet.deployed();

        console.log("wallet contract deployed to:", wallet.address);

        const [owner] = await ethers.getSigners();
        return { token, wallet, owner };
    }

    describe("Check constructor arguments", function () {
        it("Should has the right name", async function () {
            //您可以通过使用固定装置来避免代码重复并提高测试套件的性能。
            //fixture 是一个设置函数，仅在第一次调用时运行。
            //在随后的调用中，Hardhat 不会重新运行它，而是会将网络状态重置为最初执行夹具后的状态。
            const { token, wallet, owner } = await loadFixture(deploy);
            expect(await token.name()).to.equal("EP777");
        })

    })

    describe("DoneStuff ", function () {
        it("Should get notified by ERC777 transfer", async function () {
            const { token, wallet, owner } = await loadFixture(deploy);

            const amount = 10
            const data = JSON.stringify({
                staking_positions: [
                    { duration: "1y" }
                ]
            });

            // 验证发送代币后是否回调了Simple777Recipient合约中的tokensReceived函数
            const receipt = await token.send(wallet.address, amount, [])
            await expect(receipt).to.emit(wallet, 'DoneStuff')
        });
    });

    describe("Attack ", function () {
        it("Should reentrancy", async function () {
            const { token, wallet, owner } = await loadFixture(deploy);

            const Attack = await hre.ethers.getContractFactory("Attack777");
            const attack = await Attack.deploy(token.address);

            await attack.deployed();

            console.log("attack contract deployed to:", attack.address);

            console.log("before attack,the attacker balance",await token.balanceOf(attack.address))

            const receipt = await attack.attack()
            console.log("after attack,the attacker balance",await token.balanceOf(attack.address))

        });
    });

});
