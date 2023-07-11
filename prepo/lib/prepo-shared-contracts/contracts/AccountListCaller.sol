// SPDX-License-Identifier: AGPL-3.0
pragma solidity =0.8.7; //@note add a space after the equal sign, it looks better

import "./interfaces/IAccountList.sol";
import "./interfaces/IAccountListCaller.sol";

contract AccountListCaller is IAccountListCaller {
  IAccountList internal _accountList;

  function setAccountList(IAccountList accountList) public virtual override { //@note anyone can call this function
    _accountList = accountList;
    emit AccountListChange(accountList);
  }

  function getAccountList() external view override returns (IAccountList) {
    return _accountList;
  }
}
