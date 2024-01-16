// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IERC721Enumerable} from "@openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol";

interface IERC6672 is IERC721Enumerable {
    event Redeem(
        address indexed operator,
        uint256 indexed tokenId,
        address redeemer,
        bytes32 redemptionId,
        string memo
    );

    event Cancel(
        address indexed operator,
        uint256 indexed tokenId,
        bytes32 redemptionId,
        string memo
    );

    function isRedeemed(
        address operator,
        bytes32 redemptionId,
        uint256 tokenId
    ) external view returns (bool);

    function getRedemptionIds(
        address operator,
        uint256 tokenId
    ) external view returns (bytes32[] memory);

    function redeem(
        bytes32 redemptionId,
        uint256 tokenId,
        string calldata memo
    ) external;

    function cancel(
        bytes32 redemptionId,
        uint256 tokenId,
        string calldata memo
    ) external;
}
