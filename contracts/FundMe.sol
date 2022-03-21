//SPDX-License-Identifier: MIT

pragma solidity >=0.6.6 <0.9.0;

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol"; //this is importing the sol from NPM chainlink repo https://github.com/smartcontractkit/chainlink.git
import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol";  
//This code, is defined as interface, only has function name and return type 

//solidity doesnt know how to interact between contracts, 


//interfaces compile down to ABI.  ABI tells solidity  and other programming langages how it can interact with another contract.  Any time you interact with another smark contract you need ABI.
//to interact wiht interface, the same way as struct or var

contract FundMe {
    using SafeMathChainlink for uint256; //library applied to uint256 types.

    mapping(address => uint) public addressToAmountFunded;
    address[] public funders;
    address public owner;

    constructor() public {
        owner = msg.sender;    
    }

    //modifiers change the behaviour of functions in a declarative way

    function fund() public payable { //payableindicates that funds are able to be transfered.

        uint256 minimumUSD = 50*(10**18);

        require(getConversionRate(msg.value) >= minimumUSD,"You need to spend more ETH");// THis is the most robust method to validate a check condition.

        addressToAmountFunded[msg.sender] += msg.value; //msg.sender are available for all contracts same with msg.value

        funders.push(msg.sender);
        //To set minimum value via usd or another currency relative to ETH we will need a mechanism to get the conversion rate
        //Where can we get this? Enter Chainlink.  
    }
    
    function getVersion() public view returns(uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        return priceFeed.version();
    }

    function getPrice() public view returns(uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        (,int256 answer,,,) = priceFeed.latestRoundData(); //we can just leave , for variables we do not need to actually use from the price feed function call.

        return uint256(answer*10000000000); //there are 8 implied decimals
    }

    function getConversionRate(uint256 ethAmount) public view returns(uint256){
        uint256 ethPrice = getPrice();
        uint256 ethAMountInUsd  = (ethPrice * ethAmount)/1000000000000000000;
        return ethAMountInUsd;
    }

    modifier onlyOwner {
        require(msg.sender == owner,"You are not the owner of the contract");
        _;
    }
    function withdraw() payable public {
        msg.sender.transfer(address(this).balance); //whoever called withdraw, transfer them all of our money/
        //for loop| initialization| test condition|iteration step
        for (uint256 funderIndex = 0;funderIndex <funders.length;funderIndex++){ //start at index of 0, do while index < funder length
            address funder = funders[funderIndex];
            addressToAmountFunded[funder]=0;
        }

        funders = new address[](0);
    }

}