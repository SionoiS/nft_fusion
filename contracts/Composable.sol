// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

abstract contract Composable is ERC721 {
    // Mapping from token Id to array of ids.
    mapping(uint256 => uint256[]) private _tokenParts;

    function _setRequirements(uint256 tokenId, uint256[] memory ids)
        internal
        virtual
    {
        uint256 len = ids.length;

        for (uint256 i = 0; i < len; i++) {
            require(_exists(ids[i]), "THis token does not exist");
        }

        _tokenParts[tokenId] = ids;
    }

    /// Returns an array of token Ids needed to compose this token.
    function getRequirements(uint256 tokenId)
        public
        view
        virtual
        returns (uint256[] memory)
    {
        return _tokenParts[tokenId];
    }

    /// Is this token a composition
    function isComposition(uint256 tokenId) public view virtual returns (bool) {
        return _tokenParts[tokenId].length != 0;
    }

    function _compose(uint256 tokenId, address user) internal virtual {
        uint256 len = _tokenParts[tokenId].length;

        require(len > 0, "This is not a redeemable token");

        for (uint256 i = 0; i < len; i++) {
            uint256 id = _tokenParts[tokenId][i];

            require(
                ownerOf(id) == user,
                "The user is not the owner of all the constituent tokens"
            );

            _burn(id);
        }
    }
}
