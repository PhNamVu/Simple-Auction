// We import Chai to use its asserting functions here.
const { expect } = require("chai");

describe("Auction contract", function () {

    let AuctionFactory;
    let auction;
    let owner;
    let addr1;
    let addr2;
    let addrs;

    beforeEach(async () => {
        AuctionFactory = awaitToken = await ethers.getContractFactory("SimpleAuction");
        [owner, addr1, addr2, ...addrs] = await ethers.getSigners();

        auction = await AuctionFactory.deploy();
    });

    it("should deploy", async () => {
        expect(auction.address).to.exist;
    });

    it("start a bid", async () => {
        await auction.connect(owner).start(10000000000);
    });

    describe("Bid", function() {
        it("should bid", async () => {
            await auction.connect(owner).start(10000000000);
            await auction.connect(addr1).bid({value: 11000000000});
            await auction.connect(addr2).bid({value: 12000000000});
        });

        it("should not bid if not started", async () => {
            await expect(auction.connect(addr1).bid({value: 11000000000})).to.be.reverted;
        });

        it("should not bid if not enough ether", async () => {
            await auction.connect(owner).start(10000000000);
            await expect(auction.connect(addr1).bid(10000000001)).to.be.reverted;
        });

    })

    describe("End", function() {    
        it("should end", async () => {
            await auction.connect(owner).start(1000);
            await auction.connect(addr1).bid({value: 11000000000});
            await auction.connect(owner).end();
        })

        it("should not end if not started", async () => {
            await expect(auction.connect(owner).end()).to.be.reverted;
        })
    })
   


});