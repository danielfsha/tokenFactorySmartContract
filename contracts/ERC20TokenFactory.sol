// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";

contract ERC20Token is ERC20Capped {
    constructor(
        string memory _name,
        string memory _ticker,
        uint256 _initalSupply,
        uint256 _totalSupply,
        address _to // Added to allow specifying recipient
    ) ERC20(_name, _ticker) ERC20Capped(_totalSupply * (10 ** decimals())) {
        _mint(_to, _initalSupply * (10 ** decimals()));
    }
}

contract ERC20TokenFactory {
    uint256 public tokenCount = 0;

    mapping(address => Token[]) public tokens;

    struct Token {
        string name;
        string ticker;
        uint256 initalSupply;
        uint256 totalSupply;
        address tokenDeploymentAddress;
        address to;
    }

    event TokenDeployed(
        string name,
        string ticker,
        uint256 initalSupply,
        uint256 totalSupply,
        address tokenDeploymentAddress,
        address deployer
    );

    function deployToken(
        string calldata _name,
        string calldata _ticker,
        uint256 _initalSupply,
        uint256 _totalSupply,
        address _to // Added to allow specifying recipient (optional)
    ) public {
        ERC20Token token = new ERC20Token(
            _name,
            _ticker,
            _initalSupply,
            _totalSupply,
            _to // Recipient for initial supply
        );

        tokens[msg.sender].push(
            Token(
                _name,
                _ticker,
                _initalSupply,
                _totalSupply,
                address(token),
                _to
            )
        ); // Update mapping with token details
        emit TokenDeployed(
            _name,
            _ticker,
            _initalSupply,
            _totalSupply,
            address(token),
            _to
        );
        tokenCount++;
    }

    function getTokensByUser(
        address _user
    ) public view returns (Token[] memory) {
        return tokens[_user];
    }

    function getTokenByAddress(
        address _tokenAddress
    ) public view returns (Token memory) {
        for (uint256 i = 0; i < tokens[msg.sender].length; i++) {
            if (tokens[msg.sender][i].tokenDeploymentAddress == _tokenAddress) {
                return tokens[msg.sender][i];
            }
        }
        revert("Token not found");
    }
}
