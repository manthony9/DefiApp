pragma solidity ^0.5.0;

import "./DappToken.sol";
import "./DaiToken.sol";

contract TokenFarm {

    string public name =  "Dapp Token Farm";
    DappToken public dappToken;
    DaiToken public daiToken;
    address[] public stakers;
    address public owner;
    mapping(address => uint) public stakingBalance;
    mapping(address => bool) public hasStaked; 
    mapping(address => bool) public isStaking;
 
    constructor(DappToken _dappToken, DaiToken _daiToken) public {

        dappToken = _dappToken;
        daiToken = _daiToken;
        owner = msg.sender;


    }

    //Stake Tokens (Deposit)

    function stakeTokens(uint _amount) public {

        //require amount greater than 0
        require(_amount > 0, "amount cannot be 0");

        //transfer MockDai to contract for this staking
        daiToken.transferFrom(msg.sender, address(this), _amount);

        //updating stake balance
        stakingBalance[msg.sender] = stakingBalance[msg.sender] + _amount;

        if (!hasStaked[msg.sender]){

            stakers.push(msg.sender);
        }
        
        isStaking[msg.sender] = true;
        hasStaked[msg.sender] = true;


    }

    //Unstake Tokens (Withdraw)

    function unstakeToken() public {

        //get staking balance
        uint balance = stakingBalance[msg.sender];

        //require amount should be greater than zero    
        require(balance > 0, "staking balance must be greater than zero");

        //transfer Mock DAI tokens to this contract for staking
        daiToken.transfer(msg.sender, balance);

        //reset staking balance
        stakingBalance[msg.sender] = 0;

        //updates staking status
        isStaking[msg.sender] = false;

    }

    //Issuing Tokens (Interest)

    function issueToken() public{

        //make sure owner is the caller
        require(msg.sender == owner, "caller must be the owner"); 
        
        //issue tokens to all stakers
        for (uint i=0; i < stakers.length; i++){

            address recipient = stakers[i];
            uint balance = stakingBalance[recipient];
            
            if(balance > 0){

                dappToken.transfer(recipient, balance);
            }

        }
    }

}