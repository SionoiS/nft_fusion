// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "../contracts/Composable.sol";

contract Alloy is Ownable, ERC721URIStorage, Composable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // Mapping from token Id to array of indices.
    mapping(uint256 => uint256[]) private _tokenParts;

    constructor() ERC721("Alloy", "ALY") {}

    /// Mint a standard token
    function mintOre(string memory URI) public onlyOwner returns (uint256) {
        _tokenIds.increment();
        uint256 newId = _tokenIds.current();

        _safeMint(msg.sender, newId);
        _setTokenURI(newId, URI);

        return newId;
    }

    /// Mint a token redeemable only by a user who own the specified array of token Ids.
    function mintAlloy(uint256[] memory ids, string memory URI)
        public
        onlyOwner
        returns (uint256)
    {
        _tokenIds.increment();
        uint256 newId = _tokenIds.current();

        _safeMint(msg.sender, newId);
        _setTokenURI(newId, URI);
        _setRequirements(newId, ids);

        return newId;
    }

    /// Fuse multiple ore tokens, burning them in the process and get an alloy token.
    function fuse(uint256 tokenId) public {
        _compose(tokenId, msg.sender);

        safeTransferFrom(owner(), msg.sender, tokenId);
    }

    function _burn(uint256 tokenId)
        internal
        override(ERC721, ERC721URIStorage)
    {
        ERC721URIStorage._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return ERC721URIStorage.tokenURI(tokenId);
    }
}
