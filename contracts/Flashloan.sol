// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./aave/FlashLoanReceiverBase.sol";

contract Flashloan is FlashLoanReceiverBase {
    using SafeMath for uint256;

    event Log(string message, uint256 val);

    constructor(IPoolAddressesProvider _addressProvider) public FlashLoanReceiverBase(_addressProvider) {}

    function flashLoan(address asset, uint256 amount) external {
        uint256 bal = IERC20(asset).balanceOf(address(this));
        require(bal > amount, "bal <= amount");

        address receiver = address(this);

        address[] memory assets = new address[](1);
        assets[0] = asset;

        uint256[] memory amounts = new uint256[](1);
        amounts[0] = amount;

        // 0 = no debt, 1 = stable, 2 = variable
        // 0 = pay all loaned
        uint256[] memory modes = new uint256[](1);
        modes[0] = 0;

        address onBehalfOf = address(this);

        bytes memory params = ""; // extra data to pass abi.encode(...)
        uint16 referralCode = 0;

        POOL.flashLoan(receiver, assets, amounts, modes, onBehalfOf, params, referralCode);
    }

    function executeOperation(
        address[] calldata assets,
        uint256[] calldata amounts,
        uint256[] calldata premiums,
        address initiator,
        bytes calldata params
    ) external override returns (bool) {
        // do stuff here (arbitrage, liquidation, etc...)
        // abi.decode(params) to decode params
        for (uint256 i = 0; i < assets.length; i++) {
            emit Log("borrowed", amounts[i]);
            emit Log("fee", premiums[i]);

            uint256 amountOwing = amounts[i].add(premiums[i]);
            IERC20(assets[i]).approve(address(POOL), amountOwing);
        }
        // repay Aave
        return true;
    }
}
