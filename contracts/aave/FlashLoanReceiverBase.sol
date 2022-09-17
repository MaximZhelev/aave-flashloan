// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

import "./IFlashLoanReceiver.sol";
import "./IPoolAddressProvider.sol";
import "./IPool.sol";

abstract contract FlashLoanReceiverBase is IFlashLoanReceiver {
    using SafeERC20 for IERC20;
    using SafeMath for uint256;

    IPoolAddressesProvider public immutable ADDRESSES_PROVIDER;
    IPool public immutable POOL;

    constructor(IPoolAddressesProvider provider) {
        ADDRESSES_PROVIDER = provider;
        POOL = IPool(provider.getPool());
    }
}
