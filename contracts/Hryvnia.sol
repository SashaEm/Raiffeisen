// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract Hryvnia is ERC20, AccessControl{

    uint256 public _currentSupply;

    constructor(string memory name, string memory symbol, uint256 currentSupply)ERC20(name, symbol){
        _currentSupply = currentSupply;
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    function mint(address owner, uint256 amount) public onlyRole(DEFAULT_ADMIN_ROLE){
        _mint(owner, amount);
    }

    function burn(address owner, uint256 amount) public onlyRole(DEFAULT_ADMIN_ROLE){
        _burn(owner, amount);
    }
}