// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";

contract SimpleAuction is Ownable {
    event Start();
    event End();
    event Bid(address indexed sender, uint256 amount);

    bool public ended;
    bool public started;
    uint256 public auctionId;
    uint256 public startPrice;
    uint256 public highestBid;
    address public highestBidder;

    mapping(address => uint256) private bids;

    struct Auction {
        uint256 id;
        uint256 startPrice;
        uint256 endPrice;
        address bidders;
    }

    mapping(uint256 => Auction) public auctionHistory;

    constructor() {
        auctionId = 1;
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function start(uint256 startingBid) external onlyOwner {
        require(!started, "Already started!");
        highestBid = startPrice = startingBid;
        started = true;
        ended = false;
        emit Start();
    }

    function bid() external payable {
        require(started, "Not Started.");
        require(msg.value > highestBid);

        if (highestBidder != address(0)) {
            bids[highestBidder] += highestBid;
            // return ether to previous bidder
            (bool sent, ) = payable(highestBidder).call{value: highestBid}("");
            require(sent, "Could not return ether");
        }

        highestBid = msg.value;
        highestBidder = msg.sender;
        console.log(4);
        emit Bid(highestBidder, highestBid);
    }

    function end() external onlyOwner {
        require(started, "You need to start first!");
        require(!ended, "Auction already ended");

        auctionHistory[auctionId] = Auction(
            auctionId,
            startPrice,
            highestBid,
            highestBidder
        );
        auctionId++;

        ended = true;
        started = false;
        highestBidder = address(0);
        emit End();
    }
}
