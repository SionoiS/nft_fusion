// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "../contracts/Composable.sol";

contract Alloy is Ownable, Composable, ERC721URIStorage, ERC721Enumerable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIds;

    constructor() ERC721("Alloy", "ALY") {}

    /// Mint a standard token
    function mintOre(string memory URI) public onlyOwner returns (uint256) {
        uint256 newId = _tokenIds.current();
        _tokenIds.increment();

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
        uint256 newId = _tokenIds.current();
        _tokenIds.increment();

        _safeMint(msg.sender, newId);
        _setTokenURI(newId, URI);
        _setRequirements(newId, ids);

        return newId;
    }

    /// Fuse multiple ore tokens, burning them in the process and get an alloy token.
    function fuse(uint256 tokenId) public {
        _compose(tokenId, msg.sender);

        _approve(msg.sender, tokenId);

        safeTransferFrom(owner(), msg.sender, tokenId);
    }

    function _burn(uint256 tokenId)
        internal
        virtual
        override(ERC721, ERC721URIStorage)
    {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
