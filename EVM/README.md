# [ERC-6672: Multi-redeemable NFTs](https://eips.ethereum.org/EIPS/eip-6672)

## Installation
To install the ERC-6672 package, run:

```
npm install --save @domin-network/contracts
```

## Usage
Import ERC-6672 into your Solidity project:
```solidity
import '@domin-network/contracts/tokens/ERC6672.sol';
```

Implement the ERC-6672 interface to create your multi-redeemable NFTs:
```solidity
contract MyNFT is ERC6672 {
    // Your implementation
}
```

## Example
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "../tokens/ERC6672.sol";

contract TestNFT is ERC6672, ERC721Burnable, Ownable {
    uint256 _tokenIdCounter;

    constructor() ERC721("TestNFT", "TNFT") Ownable(_msgSender()) {
        _tokenIdCounter = 1;
    }

    function safeMint(address to) public onlyOwner {
        uint256 tokenId = _tokenIdCounter;
        _tokenIdCounter++;
        _safeMint(to, tokenId);
    }

    function safeBatchMint(address to, uint256 count) public onlyOwner {
        for (uint256 i = 1; i <= count; i++) {
            safeMint(to);
        }
    }

    function _increaseBalance(
        address account,
        uint128 amount
    ) internal virtual override(ERC6672, ERC721) {
        ERC6672._increaseBalance(account, amount);
    }

    function _update(
        address to,
        uint256 tokenId,
        address auth
    ) internal virtual override(ERC6672, ERC721) returns (address) {
        return ERC721Enumerable._update(to, tokenId, auth);
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view virtual override(ERC6672, ERC721) returns (bool) {
        return
            interfaceId == type(ERC6672).interfaceId ||
            ERC721Enumerable.supportsInterface(interfaceId);
    }
}
```

## Features
Open Data Flexibility with Memo Field

One of the key features of ERC-6672 is the flexibility offered by its open data structure, particularly through the use of the `memo` field in the redemption process. This field can store a variety of data types and information, making it a versatile tool for different scenarios. Here are some examples of how the `memo` field can be utilized:

1. **Redeem** Location: Store details about the physical or virtual location where the NFT can be redeemed. This is particularly useful for event tickets or experiences that are tied to a specific place.
2. **Experience Details**: For NFTs that represent access to experiences (such as a concert, an art exhibit, or a workshop), the memo field can include information about the event, like the agenda, special instructions, or exclusive opportunities available to the NFT holder.
3. **Giveaway Details**: If the NFT is being used to redeem physical goods or giveaways, the memo field can detail the specific items being claimed, such as merchandise, limited edition products, or other tangible goods.
4. **Benefits Description**: The field can also describe the benefits or privileges that come with the NFT redemption, like VIP access, discounts on future purchases, or membership perks.
5. **Custom Messages**: The memo field can be used to include personalized messages or instructions from the issuer to the redeemer, adding a unique touch to the redemption process.
6. **Tracking and Record-Keeping**: It can serve as a tool for keeping records of each redemption, making it easier to track the history and usage of the NFT over time.

### Other Features

- **Multiple Redemption Scenarios**: ERC-6672 enables NFTs to be redeemed in various scenarios, broadening the use cases and enhancing the value of each NFT.
- **Backward Compatibility with ERC-721**: Ensures that ERC-6672 NFTs are compatible with existing ERC-721 infrastructure, providing a seamless integration into current NFT platforms and marketplaces.

## Practical Use Cases
1. **Event Ticketing**: Create NFTs that serve as digital tickets, which can be redeemed for entry to the event and additional benefits like backstage passes or exclusive merchandise.
2. **Loyalty Programs**: Use NFTs as part of a loyalty program, where each redemption offers different rewards, discounts, or experiences, encouraging repeated engagement.
3. **Collectibles and Merchandise**: Offer NFTs that can be redeemed for physical collectibles, creating a bridge between digital assets and tangible goods.

## Conclusion
ERC-6672's integration of the `memo` field provides a powerful way to enhance the utility and interactivity of NFTs, making them not just collectible items but gateways to a range of experiences and benefits. The standard's flexibility allows creators and developers to craft unique and engaging scenarios for NFT holders.

## Support
For support, please open an issue in the [GitHub repository](https://github.com/Domin-Network/contracts/issues)

## License
Distributed under the MIT License.