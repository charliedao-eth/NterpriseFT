# NterpriseFT

Full-cycle data analysis of NFT sales, communities, socials and their interconnectedness.

## Usage

Install locally:
```shell
./scripts/install.sh
```
Or, build Docker image:
```shell
./scripts/build.sh
```
A simple example using the World of Women (WOW) NFT collection is in `./examples/transactions.py` and can be invoked using:
```shell
python ./examples/transactions.py
```

## Design

- Three classes are provided to perform end-to-end NFT analytics on arbitrary NFT contract addresses: ingestors, transformers and reporters.
- The ingestion and transformation classes are built on the Covalent API (more APIs will be supported soon).
- The ingestion classes pull raw data using third-party schemas and the transformation classes convert them into common analytic base schemas for downstream analyses.
- The reporting class leverages the common schemas so that the same reporting analytic functions can be applied across all NFT collections.

## Backlog

### Community

- Twitter followers over time
- Twitter posts over time
- Twitter engagement over time

### Price

- Mean token price over time
- Token price risk over time
- Token price distribution

### Owners

- Token transfers over time
- New and unique owners over time
- Mean duration between buy and sell events

### Decentralisation

- Top owners by number of tokens owned
- Top owners by value of owned tokens
- Top tokens by value
