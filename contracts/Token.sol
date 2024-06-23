// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract Token is ERC20Capped, ERC20Burnable {
    address payable public owner;

    uint256 public blockReward;

    constructor(
        uint256 _intialSupply,
        uint256 _maxSupply,
        uint256 _blockReward
    ) ERC20("Daniel", "DNL") ERC20Capped(_maxSupply * (10 ** decimals())) {
        owner = payable(msg.sender);
        blockReward = _blockReward * 10 ** decimals();
        _mint(owner, _intialSupply * (10 ** decimals()));
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Ownable: caller is not the owner");
        _;
    }

    function mintMinerReward() internal {
        _mint(block.coinbase, blockReward);
    }

    function _update(
        address _from,
        address _to,
        uint256 _value
    ) internal virtual override(ERC20, ERC20Capped) {
        if (_from != address(0) && _to != address(0) && _to != block.coinbase) {
            mintMinerReward();
        }
        super._update(_from, _to, _value);
    }

    function setBlockReward(uint256 _blockReward) public onlyOwner {
        blockReward = _blockReward * 10 ** decimals();
    }
}
