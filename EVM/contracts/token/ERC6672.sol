// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC721, IERC165} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721Enumerable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import {EnumerableSet} from "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import {IERC6672} from "../interface/IERC6672.sol";

abstract contract ERC6672 is ERC721, ERC721Enumerable, IERC6672 {
    error ERC6672Unredeemable(
        address operator,
        bytes32 redemptionId,
        uint256 tokenId
    );
    error ERC6672Uncancelable(
        address operator,
        bytes32 redemptionId,
        uint256 tokenId
    );
    error ERC6672NoRedemptions(address operator, uint256 tokenId);
    error ERC6672NoOwner(uint256 tokenId);

    using EnumerableSet for EnumerableSet.Bytes32Set;

    bytes4 public constant IERC6672_ID = type(IERC6672).interfaceId;

    mapping(address => mapping(uint256 => mapping(bytes32 => bool))) redemptionStatus;
    mapping(address => mapping(uint256 => mapping(bytes32 => string)))
        public memos;
    mapping(address => mapping(uint256 => EnumerableSet.Bytes32Set)) redemptions;

    function isRedeemed(
        address operator,
        bytes32 redemptionId,
        uint256 tokenId
    ) external view virtual returns (bool) {
        return _isRedeemed(operator, redemptionId, tokenId);
    }

    function getRedemptionIds(
        address operator,
        uint256 tokenId
    ) external view virtual returns (bytes32[] memory) {
        if (redemptions[operator][tokenId].length() == 0) {
            revert ERC6672NoRedemptions(operator, tokenId);
        }
        return redemptions[operator][tokenId].values();
    }

    function redeem(
        bytes32 redemptionId,
        uint256 tokenId,
        string calldata memo
    ) external virtual {
        address operator = msg.sender;
        if (
            _isRedeemed(operator, redemptionId, tokenId) == true ||
            ownerOf(tokenId) == address(0)
        ) {
            revert ERC6672Unredeemable(operator, redemptionId, tokenId);
        }
        _update(operator, redemptionId, tokenId, memo, true);
        redemptions[operator][tokenId].add(redemptionId);
    }

    function cancel(
        bytes32 redemptionId,
        uint256 tokenId,
        string calldata memo
    ) external virtual {
        address operator = msg.sender;
        if (
            _isRedeemed(operator, redemptionId, tokenId) == false ||
            ownerOf(tokenId) == address(0)
        ) {
            revert ERC6672Uncancelable(operator, redemptionId, tokenId);
        }
        _update(operator, redemptionId, tokenId, memo, false);
        _removeRedemption(operator, redemptionId, tokenId);
    }

    function _isRedeemed(
        address operator,
        bytes32 redemptionId,
        uint256 tokenId
    ) internal view virtual returns (bool) {
        return redemptionStatus[operator][tokenId][redemptionId];
    }

    function _update(
        address operator,
        bytes32 redemptionId,
        uint256 tokenId,
        string calldata memo,
        bool isRedeemed_
    ) internal virtual {
        redemptionStatus[operator][tokenId][redemptionId] = isRedeemed_;
        memos[operator][tokenId][redemptionId] = memo;
        if (isRedeemed_) {
            emit Redeem(
                operator,
                tokenId,
                ownerOf(tokenId),
                redemptionId,
                memo
            );
        } else {
            emit Cancel(operator, tokenId, redemptionId, memo);
        }
    }

    function _update(
        address to,
        uint256 tokenId,
        address auth
    ) internal virtual override(ERC721, ERC721Enumerable) returns (address) {
        return ERC721Enumerable._update(to, tokenId, auth);
    }

    function _increaseBalance(
        address account,
        uint128 amount
    ) internal virtual override(ERC721, ERC721Enumerable) {
        ERC721Enumerable._increaseBalance(account, amount);
    }

    function _removeRedemption(
        address operator,
        bytes32 redemptionId,
        uint256 tokenId
    ) internal virtual {
        redemptions[operator][tokenId].remove(redemptionId);
    }

    function supportsInterface(
        bytes4 interfaceId
    )
        public
        view
        virtual
        override(ERC721Enumerable, IERC165, ERC721)
        returns (bool)
    {
        return
            interfaceId == type(ERC721).interfaceId ||
            interfaceId == type(IERC6672).interfaceId ||
            interfaceId == type(ERC721Enumerable).interfaceId ||
            super.supportsInterface(interfaceId);
    }
}
