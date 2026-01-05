// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {
    DataStreamsLocalSimulator,
    MockVerifierProxy
} from "@chainlink-local/src/data-streams/DataStreamsLocalSimulator.sol";
import {MockReportGenerator} from "@chainlink-local/src/data-streams/MockReportGenerator.sol";
import {ClientReportsVerifier} from "src/ClientReportsVerifier.sol";

contract ClientReportsVerifierScript is Script {
    DataStreamsLocalSimulator public dataStreamsLocalSimulator;
    MockReportGenerator public mockReportGenerator;
    ClientReportsVerifier public clientReportsVerifier;
    int192 initialPrice = 1 ether;

    function run() public returns (DataStreamsLocalSimulator, MockReportGenerator, ClientReportsVerifier, int192) {
        dataStreamsLocalSimulator = new DataStreamsLocalSimulator();
        (,,, MockVerifierProxy mockVerifierProxy_,,) = dataStreamsLocalSimulator.configuration();

        mockReportGenerator = new MockReportGenerator(initialPrice);

        clientReportsVerifier = new ClientReportsVerifier(address(mockVerifierProxy_));
        return (dataStreamsLocalSimulator, mockReportGenerator, clientReportsVerifier, initialPrice);
    }
}
