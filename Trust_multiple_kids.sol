pragma solidity =0.8.1;

contract Trust {
    
    struct Kid {
        uint amount;
        uint maturity;
        bool paid;
    }
    
    mapping(address => Kid) public kids;
    mapping(address => uint) public amounts;
    mapping(address => uint) public maturities;
    mapping(address => bool) public paid;
    address public admin;
    
    constructor() {
        admin = msg.sender;
    }
    
    function addKid(address kid, uint timeToMaturity) external payable {
        
        require(msg.sender == admin, 'only admin');
        require(amounts[msg.sender] == 0, 'kid already exist');
        
        amounts[kid] = msg.value;
        maturities[kid] = block.timestamp + timeToMaturity; 
    }
    
    function withdraw() external {
        
        require(maturities[msg.sender] <= block.timestamp, 'too early');
        require(amounts[msg.sender] > 0, 'only kid can withdraw');
        require(paid[msg.sender] == false, 'paid already');
        
        paid[msg.sender] = true;
        
        payable(msg.sender).transfer(amounts[msg.sender]);
    }
}