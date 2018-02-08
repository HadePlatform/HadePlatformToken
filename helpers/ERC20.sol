pragma solidity ^ 0.4.15;

contract ERC20 {
  uint256 public totalSupply;
  function balanceOf(address who) external view returns (uint256);
  function transfer(address to, uint256 value) external;
  function allowance(address owner, address spender) external view returns (uint256);
  function transferFrom(address from, address to, uint256 value) external;
  function approve(address spender, uint256 value) external;
  event Transfer(address indexed from, address indexed to, uint256 value);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}
