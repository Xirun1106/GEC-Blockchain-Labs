pragma solidity >=0.5.1 <0.6.0;
import "./ERC20.sol";

contract XYZCoin is ERC20 {
    string public name = "XYZCoin";
    string public symbol = "XYZ";
    uint8 public decimals = 0;
    uint256 public totalSupply = 1000;
    mapping(address => uint256) public balances;
    mapping(address => mapping(address => uint256)) public allowed;

    constructor() public {
        balances[msg.sender] = totalSupply;
        emit Transfer(address(0), msg.sender, totalSupply);
    }

    function balanceOf(address owner) public view returns (uint256) {
        return balances[owner];
    }
    function allowance(address owner, address spender) public view returns (uint256) {
        return allowed[owner][spender];
    }
    function transfer(address to, uint256 value) public returns (bool) {
        require(to != address(0), "Zero recipient");
        require(balances[msg.sender] >= value, "Insufficient balance");
        balances[msg.sender] -= value;
        balances[to] += value;
        emit Transfer(msg.sender, to, value);
        return true;
    }
    function approve(address spender, uint256 value) public returns (bool) {
        require(spender != address(0), "Zero spender");
        allowed[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }
    function transferFrom(address from, address to, uint256 value) public returns (bool) {
        require(to != address(0), "Zero recipient");
        require(balances[from] >= value, "Insufficient balance");
        require(allowed[from][msg.sender] >= value, "Not authorized");
        balances[from] -= value;
        allowed[from][msg.sender] -= value;
        balances[to] += value;
        emit Transfer(from, to, value);
        return true;
    }
}
