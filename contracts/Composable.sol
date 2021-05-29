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
        uint256[] storage parts = _tokenParts[tokenId];

        uint256 i = parts.length;
        for (i; i > 0; i--) {
            uint256 id = parts[i];

            require(ownerOf(id) == user); //Would this revert the burn in previous iteration???

            _burn(id);
        }
    }
}
