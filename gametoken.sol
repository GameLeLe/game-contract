pragma solidity ^0.4.8;

// The implementation for the Game ICO smart contract was inspired by
// the Ethereum token creation tutorial, the FirstBlood token, and the BAT token.

///////////////
// SAFE MATH //
///////////////

contract SafeMath {

    // assert no longer needed once solidity is on 0.4.10
    function assert(bool assertion) internal {
        if (!assertion) {
            throw;
        }
    }

    function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
        uint256 z = x + y;
        assert((z >= x) && (z >= y));
        return z;
    }

    function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {
        assert(x >= y);
        uint256 z = x - y;
        return z;
    }

    function safeMult(uint256 x, uint256 y) internal returns(uint256) {
        uint256 z = x * y;
        assert((x == 0)||(z/x == y));
        return z;
    }

}


////////////////////
// STANDARD TOKEN //
////////////////////

contract Token {
    uint256 public totalSupply;
    function balanceOf(address _owner) constant returns (uint256 balance);
    function transfer(address _to, uint256 _value) returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
    function approve(address _spender, uint256 _value) returns (bool success);
    function allowance(address _owner, address _spender) constant returns (uint256 remaining);
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}

/*  ERC 20 token */
contract StandardToken is Token {

    mapping (address => uint256) balances;
    mapping (address => mapping (address => uint256)) allowed;

    function transfer(address _to, uint256 _value) returns (bool success) {
        if (balances[msg.sender] >= _value && _value > 0) {
            balances[msg.sender] -= _value;
            balances[_to] += _value;
            Transfer(msg.sender, _to, _value);
            return true;
        } else {
            return false;
        }
    }

    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
            balances[_to] += _value;
            balances[_from] -= _value;
            allowed[_from][msg.sender] -= _value;
            Transfer(_from, _to, _value);
            return true;
        } else {
            return false;
        }
    }

    function balanceOf(address _owner) constant returns (uint256 balance) {
        return balances[_owner];
    }

    function approve(address _spender, uint256 _value) returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }
}

/////////////////////
//GAME.COM ICO TOKEN//
/////////////////////

contract GameICO is StandardToken, SafeMath {
    // Descriptive properties
    string public constant name = "Game.com ICO Token";
    string public constant symbol = "GAMECOMICO";
    uint256 public constant decimals = 18;
    string public version = "1.0";

    // Account for ether proceed.
    address public etherProceedsAccount;

    // These params specify the start, end, min, and max of the sale.
    bool public isFinalized;

    uint256 public window0TotalSupply;
    uint256 public window1TotalSupply;
    uint256 public window2TotalSupply;
    uint256 public window3TotalSupply;

    uint256 public window0StartTime;
    uint256 public window0EndTime;
    uint256 public window1StartTime;
    uint256 public window1EndTime;
    uint256 public window2StartTime;
    uint256 public window2EndTime;
    uint256 public window3StartTime;
    uint256 public window3EndTime;

    // setting the capacity of every part of ico
    uint256 public constant preservedTokens = 300000000 * 10**decimals;
    uint256 public constant window0TokenCreationCap = 200000000 * 10**decimals;
    uint256 public constant window1TokenCreationCap = 100000000 * 10**decimals;
    uint256 public constant window2TokenCreationCap = 100000000 * 10**decimals;
    uint256 public constant window3TokenCreationCap = 300000000 * 10**decimals;

    // Setting the exchange rate for the ICO.
    uint256 public constant window0TokenExchangeRate = 5000;
    uint256 public constant window1TokenExchangeRate = 4000;
    uint256 public constant window2TokenExchangeRate = 3000;
    uint256 public constant window3TokenExchangeRate = 0;

    // Events for logging refunds and token creation.
    //event LogRefund(address indexed _to, uint256 _value);
    event CreateGameIco(address indexed _to, uint256 _value);

    // constructor
    function GameICO(address _etherProceedsAccount,
        uint256 _window0StartTime, uint256 _window0EndTime,
        uint256 _window1StartTime, uint256 _window1EndTime,
        uint256 _window2StartTime, uint256 _window2EndTime,
        uint256 _window3StartTime, uint256 _window3EndTime)
    {
        isFinalized             = false;
        etherProceedsAccount    = _etherProceedsAccount;
        totalSupply             = 0;
        window0TotalSupply      = 0;
        window1TotalSupply      = 0;
        window2TotalSupply      = 0;
        window3TotalSupply      = 0;
    }
    function setTimeAttributes(
        uint256 _window0StartTime, uint256 _window0EndTime,
        uint256 _window1StartTime, uint256 _window1EndTime,
        uint256 _window2StartTime, uint256 _window2EndTime,
        uint256 _window3StartTime, uint256 _window3EndTime)
    {
        require(msg.sender == etherProceedsAccount);
        window0StartTime = _window0StartTime;
        window0EndTime = _window0EndTime;
        window1StartTime = _window1StartTime;
        window1EndTime = _window1EndTime;
        window2StartTime = _window2StartTime;
        window2EndTime = _window2EndTime;
        window3StartTime = _window3StartTime;
        window3EndTime = _window3EndTime;
    }
    function setProceedsAccount(address _newEtherProceedsAccount){
        require(msg.sender == etherProceedsAccount);
        etherProceedsAccount = _newEtherProceedsAccount;
    }

    function () payable {
        create();
    }
    function create() payable{
        require(!isFinalized);
        require(msg.value > 0);
        uint256 tokens = 0;
        uint256 checkedSupply = 0;

        if(time() >= window0StartTime && time() <= window0EndTime){
            tokens = safeMult(msg.value, window0TokenExchangeRate);
            checkedSupply = safeAdd(window0TotalSupply, tokens);
            require(window0TokenCreationCap >= checkedSupply);
            balances[msg.sender] += tokens;
            window0TotalSupply = checkedSupply;
            CreateGameIco(msg.sender, tokens);
        }else if(time() >= window1StartTime && time() <= window1EndTime){
            tokens = safeMult(msg.value, window1TokenExchangeRate);
            checkedSupply = safeAdd(window1TotalSupply, tokens);
            require(window1TokenCreationCap >= checkedSupply);
            balances[msg.sender] += tokens;
            window1TotalSupply = checkedSupply;
            CreateGameIco(msg.sender, tokens);
        }else if(time() >= window2StartTime && time() <= window2EndTime){
            //special case
            //with the days changing, it's a linear function about the window2TokenExchangeRate
            uint whichDay = today(window2StartTime);
            uint exchangeRate = window2TokenExchangeRate - (whichDay-1)*50;
            tokens = safeMult(msg.value, exchangeRate);
            checkedSupply = safeAdd(window2TotalSupply, tokens);
            require(window2TokenCreationCap >= checkedSupply);
            balances[msg.sender] += tokens;
            window2TotalSupply = checkedSupply;
            CreateGameIco(msg.sender, tokens);
        }else if(time() >= window3StartTime && time() <= window3EndTime){
            //TODO

        }else{
            throw;
        }

    }

    function time() constant returns (uint) {
        return block.timestamp;
    }

    function today(uint startTime) constant returns (uint) {
        return dayFor(time(), startTime);
    }

    function dayFor(uint timestamp, uint startTime) constant returns (uint) {
        return timestamp < startTime ? 0 : safeSubtract(timestamp, startTime) / 24 hours + 1;
    }

    function finalize() {
        require(!isFinalized);
        require(msg.sender == etherProceedsAccount);
        isFinalized = true;
        if (!etherProceedsAccount.send(this.balance)) throw;
    }

}


