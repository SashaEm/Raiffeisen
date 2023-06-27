// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

abstract contract RaiffeisenBank is IERC20, AccessControl{

    IERC20 public _hryvniaAddress;
    uint256 public _depositPercentage = 5000;
    uint256 constant DAY = 86400;

    struct Deposit{
        uint256 amount;
        uint256 timestamp;
    }
    mapping (address => Deposit) public _deposits;

    constructor(IERC20 hryvniaAddress){
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _hryvniaAddress = hryvniaAddress;
    }

    function deposit(uint256 amount) public virtual returns (bool){
        _hryvniaAddress.transferFrom(msg.sender, address(this), amount);
        _deposits[msg.sender] = Deposit(amount, block.timestamp);
        return true;
    }

    function withdraw() public virtual returns (bool){

        _hryvniaAddress.transfer(msg.sender, calculateWithdrawAmount());
        _deposits[msg.sender] = Deposit(0, 0);
    }

    function calculateWithdrawAmount() public view returns (uint256){
        uint256 depositAmount = _deposits[msg.sender].amount;
        uint256 depositTimestamp = _deposits[msg.sender].timestamp;
        uint256 depositDays = (block.timestamp - depositTimestamp) / DAY;
        uint256 depositPercentage = depositDays * _depositPercentage;
        uint256 withdrawAmount = depositAmount + (depositAmount * depositPercentage / 1000000);
        return withdrawAmount;
    }
}