pragma solidity 0.8.17;

import "forge-std/Test.sol";
import "../src/1_10_FMB.sol";

contract UnderflowTest is Test {

    /*
    Total supply: 1000000000
    A percentage: 8 -> 80_000_000
    TGE_A: 2_500_000

    totalAllocationForA = max * percentage / 100
	            	       8  *      8    / 100
		
    totalAllocation = 6_400_000
    */
    FlappyMoonBird bird = new FlappyMoonBird();
    uint256 public constant PRE_SEED_A_CLIFF = 6 * 30 days;


    address preSeedA = 0x1E3110f9Ea5db599b9d5BE89EEc14cCe33f809a8;

    //@note will underflow because vestedAmount < tokenReleased
    //@note we are calling just 10 days after the cliff, we won't get the max totalAllocation
    function test_claimPreA_poc() external {
        vm.startPrank(preSeedA);
        vm.warp(block.timestamp + PRE_SEED_A_CLIFF + 10 days);
        bird.claimPreA();
        vm.stopPrank();
    }

    //@note we are calling 30 days after the cliff, totalAllocation will be max
    function test_claimPreA_claim1() external {
        console.log("Balance Before:");
        console.log(bird.balanceOf(preSeedA));
        vm.startPrank(preSeedA);
        vm.warp(block.timestamp + PRE_SEED_A_CLIFF + 30 days);
        bird.claimPreA();
        // vm.warp(block.timestamp + PRE_SEED_A_CLIFF + 30 days + 30 days);
        // bird.claimPreA();
        vm.stopPrank();
        console.log("Balance After:");
        console.log(bird.balanceOf(preSeedA));
    }

    //@note as long as we claim after 30 days it wont revert but it will transfer 0 tokens
    function test_claimPreA_claim2() external {
        console.log("Balance Before:");
        console.log(bird.balanceOf(preSeedA));
        vm.startPrank(preSeedA);
        vm.warp(block.timestamp + PRE_SEED_A_CLIFF + 30 days);
        bird.claimPreA();
        vm.warp(block.timestamp + 30 days);
        bird.claimPreA();
        vm.warp(block.timestamp + 30 days);
        bird.claimPreA();
        vm.stopPrank();
        console.log(bird.balanceOf(preSeedA));
        console.log("Balance After:");
        console.log(bird.balanceOf(preSeedA));
    }
}
