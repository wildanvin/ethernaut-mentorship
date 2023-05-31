// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/CTF.sol";

contract CTFTest is Test {
    CTF public ctf;
    uint public tokensAvailable = 2;

    function setUp() public {
        ctf = new CTF(tokensAvailable);
    }

    function testSimpleMint() public view {
        uint a = ctf.mintRandomType(101);
        //console.log("mintRandomType Output",a);
    }

    function testFuzzMint(uint256 _number) public view {
        uint a = ctf.mintRandomType(_number);
        //console.log("mintRandomType Output",a);
        
    }

    function testForLoopMint() public view {
        for (uint i = 0; i <= tokensAvailable*10; i++ ){
            uint a = ctf.mintRandomType(i);
            //console.log("mintRandomType Output",a);
        }
    } 
}
