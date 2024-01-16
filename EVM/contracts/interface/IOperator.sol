// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./IERC6672.sol";

interface IOperator {
    struct Redemption {
        IERC6672 token;
        uint256 tokenId;
        bytes32 redemptionId;
        string memo;
    }

    function redeem(Redemption calldata redemption) external;

    function safeRedeem(Redemption calldata redemption) external;
}
