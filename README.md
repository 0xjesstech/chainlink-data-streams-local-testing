## Chainlink Data Streams - a repo for testing integration locally

## Common Commands

### Build and Test
```bash
forge build         # Build all contracts
forge test          # Run all tests
forge test -vvv     # Run tests with verbose output
forge test --match-test testReportGenerator  # Run specific test
forge fmt           # Format code
```

### Development
```bash
forge script script/Script.s.sol  # Run deployment script
forge snapshot      # Generate gas usage snapshots
```

## Architecture Overview

This repository demonstrates Chainlink Data Streams using a local simulation environment (chainlink local) built on Foundry.

### Core Components

**DataStreamsConsumer** (`src/DataStreamsConsumer.sol`)
- Base consumer contract that verifies signed reports from Chainlink Data Streams
- Handles fee payment (both native ETH and LINK token options)
- Decodes report data and extracts price information
- Uses IVerifierProxy interface for report verification

**Local Simulation Setup** (`script/Script.s.sol`)
- DataStreamsLocalSimulator: Mock Chainlink environment
- MockReportGenerator: Generates signed reports with configurable fees and price data
- ClientReportsVerifier: Extended consumer contract for testing

### Data Flow Architecture

```
MockReportGenerator → SignedReport → DataStreamsConsumer → VerifierProxy → Verification
```

1. **Report Generation**: MockReportGenerator creates signed reports containing price data and fee information
2. **Fee Payment**: Consumer must have ETH or LINK tokens to pay verification fees
3. **Verification**: VerifierProxy validates the signed report and deducts fees
4. **Data Extraction**: Consumer decodes verified report to extract price data

### Key Dependencies

- **@chainlink/contracts**: Core Chainlink interfaces (IVerifierProxy, IFeeManager)
- **@chainlink-local**: Local simulation tools for development/testing
- **forge-std**: Foundry testing framework

### Report Structure

Reports contain:
- Feed ID and timestamps
- Native fee (ETH) and LINK fee amounts  
- Price data (benchmark, bid, ask)
- Expiration and validation periods

The verification process automatically handles fee payment and returns decoded report data that can be used by the consuming contract.
## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

- **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
- **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
- **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
- **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
