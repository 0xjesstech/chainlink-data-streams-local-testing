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

    function setUp() public {
        dataStreamsScript = new DataStreamsScript();
        (
            dataStreamsLocalSimulator,
            mockReportGenerator,
            consumer,
            initialPrice
        ) = dataStreamsScript.run();
    }

    function testReportGenerator() public {
        mockReportGenerator.updateFees(1 ether, 0.5 ether);
        (bytes memory signedReportV3, ) = mockReportGenerator
            .generateReportV3();

        dataStreamsLocalSimulator.requestLinkFromFaucet(
            address(consumer),
            1 ether
        );

        consumer.verifyReport(signedReportV3);

        int192 lastDecodedPrice = consumer.lastDecodedPrice();
        assertEq(lastDecodedPrice, initialPrice);
    }
}
