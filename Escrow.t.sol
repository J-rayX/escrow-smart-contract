// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/Escrow.sol";

contract EscrowTest is Test {
    Escrow public escrow;
    address arbiter = address(2);
    address depositor = address(3);
    address payable beneficiary = payable(address(4));

    function setUp() public {
        hoax(depositor);
        escrow = new Escrow{value: 1 ether}(arbiter, beneficiary);
    }

    function testApprovalEvent() public {
        vm.prank(arbiter);
        vm.recordLogs();

        escrow.approve();

        Vm.Log[] memory entries = vm.getRecordedLogs();
        assertEq(entries.length, 1);
        assertEq(entries[0].topics[0], keccak256("Approved(uint256)"));
        assertEq(abi.decode(entries[0].data, (uint)), 1 ether);
    }
}
