pragma solidity ^0.4.15;

/**
 *  @author.. Stephen Lee <smlee.981@gmail.com>
 *  @title... New Hade Platform Token
 *  @date.... 2.2.18
 */

import './helpers/BasicToken.sol';
import './lib/SafeMath.sol';

/**
 *  @dev HadeCoin extends BasicERC20token to allow
 *  administrators (adminMultiSig) to mint and burn
 *  tokens. This is a fix that was requested by
 *  management in order to control supply around
 *  new crowd sale opportunities.
 */
contract HadeCoin is BasicToken {

    using SafeMath for uint256;

    /*
       STORAGE
    */

    // name of the token
    string public name = "HADE Platform";

    // symbol of token
    string public symbol = "HADE";

    // decimals
    uint8 public decimals = 18;

    // total supply of Hade Coin
    uint256 public totalSupply = 150000000 * 10**18;

    // multi sign address of founders which hold
    address public adminMultiSig;

    /*
       EVENTS
    */

    event ChangeAdminWalletAddress(uint256  _blockTimeStamp, address indexed _foundersWalletAddress);

    /*
       CONSTRUCTOR
    */

    function HadeCoin(address _adminMultiSig) public {

        adminMultiSig = _adminMultiSig;
        balances[adminMultiSig] = totalSupply;
    }

    /*
       MODIFIERS
    */

    modifier nonZeroAddress(address _to) {
        require(_to != 0x0);
        _;
    }

    modifier onlyAdmin() {
        require(msg.sender == adminMultiSig);
        _;
    }

    /*
       OWNER FUNCTIONS
    */

    // @title mint sends new coin to the specificed recepiant
    // @param _to is the recepiant the new coins
    // @param _value is the number of coins to mint
    function mint(address _to, uint256 _value) external onlyAdmin {

        require(_to != address(0));
        require(_value > 0);
        totalSupply += _value;
        balances[_to] += _value;
        Transfer(address(0), _to, _value);
    }

    // @title burn allows the administrator to burn their own tokens
    // @param _value is the number of tokens to burn
    // @dev note that admin can only burn their own tokens
    function burn(uint256 _value) external onlyAdmin {

        require(_value > 0 && balances[msg.sender] >= _value);
        totalSupply -= _value;
        balances[msg.sender] -= _value;
    }

    // @title changeAdminAddress allows to update the owner wallet
    // @param _newAddress is the address of the new admin wallet
    // @dev only callable by current owner
    function changeAdminAddress(address _newAddress)

    external
    onlyAdmin
    nonZeroAddress(_newAddress)
    {
        adminMultiSig = _newAddress;
        ChangeAdminWalletAddress(now, adminMultiSig);
    }

    // @title fallback reverts if a method call does not match
    // @dev reverts if any money is sent
    function() public {
        revert();
    }
}
