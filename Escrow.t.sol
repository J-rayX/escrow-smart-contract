// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../Escrow.sol";

contract EscrowTest is Test {
    Escrow public escrow;
    address arbiter = address(2);
    address depositor = address(3);
    address beneficiary = address(4);

    function setUp() public {
        vm.prank(depositor);
        escrow = new Escrow(arbiter, beneficiary);
    }

    function testAddresses() public {
        assertEq(escrow.arbiter(), arbiter);
        assertEq(escrow.depositor(), depositor);
        assertEq(escrow.beneficiary(), beneficiary);
    }
}
