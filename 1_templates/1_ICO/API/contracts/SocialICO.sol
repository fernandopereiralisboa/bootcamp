pragma solidity ^0.4.13;

contract SocialICO {
	using SafeMath for uint256;
	
	string public name = "Social ICO"; 
    string public symbol = "SICO";
    uint8 public decimals = 18;
	
	address public owner;

	uint256 public tokensPerEther = 2;

	uint256 public maxICOCap = 30 ether;
	uint256 public minICOCap = 10 ether;

	struct Investidor {
		uint256 val;
		bool isInvestor;
	}
	
	mapping(address => uint256) public balances;
	mapping(address => Investidor) public invested;
	
	uint256 private distributedAmount = 0;
	uint256 private icoWeiRaised = 0;
	uint256 private stakeApproved = 0;

	bool private ended = false;
	bool private approved = false;

	event EventDonated(address indexed _who, uint256 _amount);
	event EventApproved(address indexed _who);
	event EventDrain(address indexed _who, uint256 _amount);
    
	modifier onlyOwner() {
		require(msg.sender == owner);
		_;
	}

	modifier isWorking() {
		require(icoWeiRaised < maxICOCap);
		_;
	}

	modifier isApproved() {
		require(approved);
		_;
	}

	modifier isInvestor() {
		require(invested[msg.sender].isInvestor);
		_;
	}

	function SocialICO() {
		owner = msg.sender;
	}
	
	function()
		payable 
		isWorking
	{		
		EventDonated(msg.sender, msg.value);
	}

	function Approve() 
		isInvestor
	{		
		EventApproved(msg.sender);
	}

	function CheckApproval() returns (bool){
		return approved;
	}

	function Drain() 
		onlyOwner
		isApproved
	{
		EventDrain(owner, weiAmount);
	}

	function Raised() returns (uint256){
		return icoWeiRaised;
	}

	function getBalance() constant returns (uint256) {
		return balances[msg.sender];
	}
}

library SafeMath {
	function times(uint256 x, uint256 y) internal returns (uint256) {
		uint256 z = x * y;
		assert(x == 0 || (z / x == y));
		return z;
	}
	
	function plus(uint256 x, uint256 y) internal returns (uint256) {
		uint256 z = x + y;
		assert(z >= x && z >= y);
		return z;
	}

  	function div(uint256 a, uint256 b) internal constant returns (uint256) {
	    // assert(b > 0); // Solidity automatically throws when dividing by 0
	    uint256 c = a / b;
	    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
	    return c;
  	}
}