const { expect } = require('chai');
const { ethers } = require('hardhat');

describe('ERC6672', function () {
    let nft;

    this.beforeEach(async function () {
        const NFT = await ethers.getContractFactory('TestNFT');
        nft = await NFT.deploy();
    });

    it('it should redeem a redemption', async function () {
        const accounts = await ethers.getSigners();
        await nft.safeMint(accounts[1].address);
        await nft.redeem(
            ethers.encodeBytes32String('test'),
            1,
            'Test redemption',
        );
        const isRedeemed = await nft.isRedeemed(
            accounts[0].address,
            ethers.encodeBytes32String('test'),
            1,
        );
        expect(isRedeemed).to.equal(true);
    });

    it('it should not redeem a redemption twice', async function () {
        const accounts = await ethers.getSigners();
        await nft.safeMint(accounts[1].address);
        await nft.redeem(
            ethers.encodeBytes32String('test'),
            1,
            'Test redemption',
        );
        const isRedeemed = await nft.isRedeemed(
            accounts[0].address,
            ethers.encodeBytes32String('test'),
            1,
        );
        console.log(`Redeemed: ${isRedeemed}`);
        await expect(nft.redeem(
            ethers.encodeBytes32String('test'),
            1,
            'Test redemption',
        )).to.be.revertedWithCustomError(nft, 'ERC6672Unredeemable')
            .withArgs(
                accounts[0].address,
                ethers.encodeBytes32String('test'),
                1,
            );
    });

    it('it should not redeem a redemption with wrong token id', async function () {
        const accounts = await ethers.getSigners();
        await nft.safeMint(accounts[1].address);
        await expect(nft.redeem(
            ethers.encodeBytes32String('test'),
            2,
            'Test redemption',
        )).to.be.revertedWithCustomError(nft, 'ERC721NonexistentToken');
    });
});
