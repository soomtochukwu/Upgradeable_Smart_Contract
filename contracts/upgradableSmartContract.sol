// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

// freeContract
contract implementation_contract {
    address admin;
    mapping(address => uint256) public usersBalance;

    constructor() {
        admin = msg.sender;
    }

    function setBalance(uint _value) public {
        usersBalance[msg.sender] += _value;
    }

    function viewAdmin() public view returns (address) {
        return admin;
    }

    function name() public view virtual returns (string memory) {
        return "implementation_contract";
    }

    function symbol() public view virtual returns (string memory) {
        return "impl";
    }
}

// contract proxyToken
contract proxyContract {
    address public admin;
    mapping(address => uint256) public usersBalance;
    address public implContract;

    constructor(address _implContract) {
        require(_implContract != address(0), "INVALID IMPLEMENTATION ADDRESS");
        admin = msg.sender;
        implContract = _implContract;
    }

    modifier onlyOwner() {
        require(msg.sender == admin, "NOT A VALID CALLER");
        _;
    }

    function setBalance(uint256 _value) public {
        (bool success, ) = implContract.delegatecall(
            abi.encodeWithSignature("setBalance(uint256)", _value)
        );
        require(success, "FUNCTION CALL FAILED");
    }

    function upgradeContract(address _newImpl) external onlyOwner {
        require(_newImpl != address(0), "INVALID ADDRESS");
        implContract = _newImpl;
    }

    function name() public view virtual returns (string memory) {
        return "proxyContract";
    }

    function symbol() public view virtual returns (string memory) {
        return "PC";
    }
}

// contract paidContract
contract upgraded_implementation_contract {
    address public admin;
    mapping(address => uint256) public usersBalance;

    constructor() {
        admin = msg.sender;
    }

    function setBalance(uint _value) public {
        uint ninetyPercent = (_value * 90) / 100;
        usersBalance[msg.sender] += ninetyPercent;
        usersBalance[admin] += _value - ninetyPercent;
    }

    function name() public view virtual returns (string memory) {
        return "upgraded_implementation_contract";
    }

    function symbol() public view virtual returns (string memory) {
        return "uImpl";
    }
}
