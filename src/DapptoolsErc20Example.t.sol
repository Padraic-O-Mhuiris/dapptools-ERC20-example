pragma solidity ^0.8.6;

import "ds-test/test.sol";

import "./DapptoolsErc20Example.sol";

contract DapptoolsErc20ExampleTest is DSTest {
    DapptoolsErc20Example example;

    function setUp() public {
        example = new DapptoolsErc20Example();
    }

    function testFail_basic_sanity() public {
        assertTrue(false);
    }

    function test_basic_sanity() public {
        assertTrue(true);
    }
}
