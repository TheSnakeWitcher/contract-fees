//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18 ;
pragma abicoder v2;


import "@openzeppelin/contracts/utils/Context.sol" ;
import { SafeERC20 , IERC20 } from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol" ;
import { FeeChargerOptionERC20 } from "./options/FeeChargerOptionERC20.sol" ;


contract FeeChargerERC20Dynamic is FeeChargerOptionERC20 , Context {

    using SafeERC20 for IERC20 ;

    constructor(address feeToken_) FeeChargerOptionERC20(feeToken_) {}

    /**
     * @dev Non `reentrancy-safe` and non `address(0)-destination-safe`
     */
    function _chargeFees(address feeCollector, bytes calldata feeParams) internal virtual {
        address feePayer = _msgSender() ;
        uint256 fee = _calculateFee(feeParams) ;

        _feeToken.safeTransferFrom(feePayer,feeCollector,fee) ;
        emit FeeCharged(feePayer,address(_feeToken),fee) ;
    }

    /**
     * @param params are byte-encoded parameters needed to calculate current fee
     * @return current fee to charge by `_chargeFees()`
     */
    function _calculateFee(bytes calldata params) internal virtual returns (uint256) ;

}