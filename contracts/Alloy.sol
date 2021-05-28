// contracts/GameItem.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Alloy is Ownable, ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // Mapping from token Id to array of indices.
    mapping(uint256 => uint256[]) private _tokenParts;

    constructor() ERC721("Alloy", "ALY") {}

    /// Mint a token redeemable only by a user who own the specified array of token Ids.
    function mintAlloy(uint256[] memory ids, string memory tokenURI)
        public
        onlyOwner
        returns (uint256)
    {
        _tokenIds.increment();
        uint256 newId = _tokenIds.current();

        _mint(msg.sender, newId);
        _setTokenURI(newId, tokenURI);
        _tokenParts[newId] = ids;

        return newId;
    }

    /// Fuse multiple tokens, burning them in the process and get a more exclusive token.
    function fuse(uint256 tokenId) public {
        uint256[] storage parts = _tokenParts[tokenId];

        uint256 i = parts.length;
        for (i; i > 0; i--) {
            uint256 id = parts[i];

            require(ownerOf(id) == msg.sender); //Would this revert the burn in previous iteration???

            _burn(id);
        }

        safeTransferFrom(owner(), msg.sender, tokenId);
    }
}
