//SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test, console2} from "forge-std/Test.sol";
import {ClientReportsVerifierScript} from "script/ClientReportsVerifierScript.s.sol";
import {DataStreamsLocalSimulator} from "@chainlink-local/src/data-streams/DataStreamsLocalSimulator.sol";
import {MockReportGenerator} from "@chainlink-local/src/data-streams/MockReportGenerator.sol";
import {ClientReportsVerifier} from "src/ClientReportsVerifier.sol";

contract DataStreamsTest is Test {
    ClientReportsVerifierScript public clientReportsVerifierScript;

    DataStreamsLocalSimulator public dataStreamsLocalSimulator;
    MockReportGenerator public mockReportGenerator;
    ClientReportsVerifier public clientReportsVerifier;
    int192 initialPrice;
    bytes signedReportV3;
    uint256 constant LINK_FUNDS = 100 ether;

    function setUp() public {
        clientReportsVerifierScript = new ClientReportsVerifierScript();
        (dataStreamsLocalSimulator, mockReportGenerator, clientReportsVerifier, initialPrice) =
            clientReportsVerifierScript.run();
        dataStreamsLocalSimulator.requestLinkFromFaucet(address(clientReportsVerifier), LINK_FUNDS);
        (signedReportV3,) = mockReportGenerator.generateReportV3();
    }

    function testReportVerifier() public {
        clientReportsVerifier.verifyReport(signedReportV3);

        int192 lastDecodedPriceAfter = clientReportsVerifier.lastDecodedPrice();
        console2.log("Last Decoded Price after initial report verification:", lastDecodedPriceAfter);
        assertEq(lastDecodedPriceAfter, initialPrice);
    }
}
