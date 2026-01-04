//SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test, console2} from "forge-std/Test.sol";
import {DataStreamsScript} from "script/Script.s.sol";
import {DataStreamsLocalSimulator} from "@chainlink-local/src/data-streams/DataStreamsLocalSimulator.sol";
import {MockReportGenerator} from "@chainlink-local/src/data-streams/MockReportGenerator.sol";
import {ClientReportsVerifier} from "@chainlink-local/src/test/data-streams/ClientReportsVerifier.sol";

contract DataStreamsTest is Test {
    DataStreamsScript public dataStreamsScript;

    DataStreamsLocalSimulator public dataStreamsLocalSimulator;
    MockReportGenerator public mockReportGenerator;
    ClientReportsVerifier public consumer;
    int192 initialPrice;
    uint256 constant LINK_FUNDS = 100 ether;

    function setUp() public {
        dataStreamsScript = new DataStreamsScript();
        (dataStreamsLocalSimulator, mockReportGenerator, consumer, initialPrice) = dataStreamsScript.run();
        dataStreamsLocalSimulator.requestLinkFromFaucet(address(consumer), LINK_FUNDS);
    }

    function testReportGeneratorInitialization() public {
        int192 lastDecodedPriceBefore = consumer.lastDecodedPrice();
        console2.log("Last Decoded Price Starts at 0:", lastDecodedPriceBefore);
        assertEq(lastDecodedPriceBefore, 0);
    }

    function testReportGeneratorInitialUpdate() public {
        (bytes memory signedReportV3,) = mockReportGenerator.generateReportV3();

        consumer.verifyReport(signedReportV3);

        int192 lastDecodedPriceAfter = consumer.lastDecodedPrice();
        console2.log("Last Decoded Price after initial report:", lastDecodedPriceAfter);
        assertEq(lastDecodedPriceAfter, initialPrice);
    }

    function testReportGeneratorUpdates() public {
        int192 lastDecodedPriceBefore = consumer.lastDecodedPrice();
        console2.log("Last Decoded Price before update:", lastDecodedPriceBefore);

        int192 newPrice = initialPrice + 1000;

        mockReportGenerator.updatePrice(newPrice);
        (bytes memory signedReportV3,) = mockReportGenerator.generateReportV3();

        consumer.verifyReport(signedReportV3);

        int192 lastDecodedPriceAfter = consumer.lastDecodedPrice();
        console2.log("Last Decoded Price after update:", lastDecodedPriceAfter);

        assertEq(newPrice, lastDecodedPriceAfter);
    }
}
