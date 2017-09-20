pragma solidity ^0.4.8;

// @address 0x831C198519997B58A89fE118988334FbDA430020
// The implementation for the Game ICO smart contract was inspired by
// the Ethereum token creation tutorial, the FirstBlood token, and the BAT token.

///////////////
// SAFE MATH //
///////////////

contract SafeMath {

    // assert no longer needed once solidity is on 0.4.10
//    function assert(bool assertion) internal {
//        if (!assertion) {
//            throw;
//        }
//    }

    function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
        uint256 z = x + y;
        require((z >= x) && (z >= y));
        return z;
    }

    function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {
        require(x >= y);
        uint256 z = x - y;
        return z;
    }

    function safeMult(uint256 x, uint256 y) internal returns(uint256) {
        uint256 z = x * y;
        require((x == 0)||(z/x == y));
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
    string public constant name = "Game.com Token";
    string public constant symbol = "GTC";
    uint256 public constant decimals = 18;
    string public version = "1.0";

    // Account for ether proceed.
    address public etherProceedsAccount = 0x0;
    address public multiWallet = 0x0;

    // These params specify the start, end, min, and max of the sale.
    bool public isFinalized;

    uint256 public window0TotalSupply = 0;
    uint256 public window1TotalSupply = 0;
    uint256 public window2TotalSupply = 0;
    uint256 public window3TotalSupply = 0;

    uint256 public window0StartTime = 0;
    uint256 public window0EndTime = 0;
    uint256 public window1StartTime = 0;
    uint256 public window1EndTime = 0;
    uint256 public window2StartTime = 0;
    uint256 public window2EndTime = 0;
    uint256 public window3StartTime = 0;
    uint256 public window3EndTime = 0;

    // setting the capacity of every part of ico
    uint256 public preservedTokens = 1300000000 * 10**decimals;
    uint256 public window0TokenCreationCap = 200000000 * 10**decimals;
    uint256 public window1TokenCreationCap = 200000000 * 10**decimals;
    uint256 public window2TokenCreationCap = 300000000 * 10**decimals;
    uint256 public window3TokenCreationCap = 0 * 10**decimals;

    // Setting the exchange rate for the ICO.
    uint256 public window0TokenExchangeRate = 5000;
    uint256 public window1TokenExchangeRate = 4000;
    uint256 public window2TokenExchangeRate = 3000;
    uint256 public window3TokenExchangeRate = 0;

    // Events for logging refunds and token creation.
    //event LogRefund(address indexed _to, uint256 _value);
    event CreateGameIco(address indexed _to, uint256 _value);
    event PreICOTokenPushed(address indexed _buyer, uint256 _amount);

    // constructor
    function GameICO()
    {
        totalSupply =  2000000000 * 10**decimals;
        isFinalized             = false;
        etherProceedsAccount    = msg.sender;
    }
    function adjustTime(
    uint256 _window0StartTime, uint256 _window0EndTime,
    uint256 _window1StartTime, uint256 _window1EndTime,
    uint256 _window2StartTime, uint256 _window2EndTime)
    {
        require(msg.sender == etherProceedsAccount);
        window0StartTime = _window0StartTime;
        window0EndTime = _window0EndTime;
        window1StartTime = _window1StartTime;
        window1EndTime = _window1EndTime;
        window2StartTime = _window2StartTime;
        window2EndTime = _window2EndTime;
    }
    function adjustSupply(uint256 _window0TotalSupply, uint256 _window1TotalSupply, uint256 _window2TotalSupply){
        require(msg.sender == etherProceedsAccount);
        window0TotalSupply = _window0TotalSupply;
        window1TotalSupply = _window1TotalSupply;
        window2TotalSupply = _window2TotalSupply;
    }
    function adjustCap(uint256 _preservedTokens, uint256 _window0TokenCreationCap, uint256 _window1TokenCreationCap, uint256 _window2TokenCreationCap){
        require(msg.sender == etherProceedsAccount);
        preservedTokens = _preservedTokens;
        window0TokenCreationCap = _window0TokenCreationCap;
        window1TokenCreationCap = _window1TokenCreationCap;
        window2TokenCreationCap = _window2TokenCreationCap;
    }
    function adjustRate(uint256 _window0TokenExchangeRate, uint256 _window1TokenExchangeRate, uint256 _window2TokenExchangeRate){
        require(msg.sender == etherProceedsAccount);
        window0TokenExchangeRate = _window0TokenExchangeRate;
        window1TokenExchangeRate = _window1TokenExchangeRate;
        window2TokenExchangeRate = _window2TokenExchangeRate;
    }
    function setProceedsAccount(address _newEtherProceedsAccount) {
        require(msg.sender == etherProceedsAccount);
        etherProceedsAccount = _newEtherProceedsAccount;
    }
    function setMultiWallet(address _newWallet){
        require(msg.sender == etherProceedsAccount);
        multiWallet = _newWallet;
    }

    function preICOPush(address buyer, uint256 amount) {
        require(msg.sender == etherProceedsAccount);

        uint256 tokens = 0;
        uint256 checkedSupply = 0;
        checkedSupply = safeAdd(window0TotalSupply, amount);
        require(window0TokenCreationCap >= checkedSupply);
        balances[buyer] += tokens;
        window0TotalSupply = checkedSupply;
        PreICOTokenPushed(buyer, amount);
    }

    function () payable {
        create();
    }
    function create() internal{
        require(!isFinalized);
        require(msg.value > 0.01 ether);
        uint256 tokens = 0;
        uint256 checkedSupply = 0;

        if(window0StartTime != 0 && window0EndTime != 0 && time() >= window0StartTime && time() <= window0EndTime){
            tokens = safeMult(msg.value, window0TokenExchangeRate);
            checkedSupply = safeAdd(window0TotalSupply, tokens);
            require(window0TokenCreationCap >= checkedSupply);
            balances[msg.sender] += tokens;
            window0TotalSupply = checkedSupply;
            CreateGameIco(msg.sender, tokens);
        }else if(window1StartTime != 0 && window1EndTime!= 0 && time() >= window1StartTime && time() <= window1EndTime){
            tokens = safeMult(msg.value, window1TokenExchangeRate);
            checkedSupply = safeAdd(window1TotalSupply, tokens);
            require(window1TokenCreationCap >= checkedSupply);
            balances[msg.sender] += tokens;
            window1TotalSupply = checkedSupply;
            CreateGameIco(msg.sender, tokens);
        }else if(window2StartTime != 0 && window2EndTime != 0 && time() >= window2StartTime && time() <= window2EndTime){
            tokens = safeMult(msg.value, window2TokenExchangeRate);
            checkedSupply = safeAdd(window2TotalSupply, tokens);
            require(window2TokenCreationCap >= checkedSupply);
            balances[msg.sender] += tokens;
            window2TotalSupply = checkedSupply;
            CreateGameIco(msg.sender, tokens);
        }else{
            require(false);
        }

    }

    function time() internal returns (uint) {
        return block.timestamp;
    }

    function today(uint startTime) internal returns (uint) {
        return dayFor(time(), startTime);
    }

    function dayFor(uint timestamp, uint startTime) internal returns (uint) {
        return timestamp < startTime ? 0 : safeSubtract(timestamp, startTime) / 24 hours + 1;
    }

    function withDraw(uint256 _value){
        require(msg.sender == etherProceedsAccount);
        if(multiWallet != 0x0){
            if (!multiWallet.send(_value)) require(false);
        }else{
            if (!etherProceedsAccount.send(_value)) require(false);
        }
    }

    function finalize() {
        require(!isFinalized);
        require(msg.sender == etherProceedsAccount);
        isFinalized = true;
        balances[etherProceedsAccount] += preservedTokens +
                                          window0TokenCreationCap - window0TotalSupply +
                                          window1TokenCreationCap - window1TotalSupply +
                                          window2TokenCreationCap - window2TotalSupply;
        if (!etherProceedsAccount.send(this.balance)) require(false);
    }

}


