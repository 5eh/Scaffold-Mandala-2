<div align="center">
  <img src="./packages/nextjs/public/Mandala.png" alt="Mandala Chain Logo" width="100" height="100">
</div>

# Mandala Chain Web3 Development Toolkit

A comprehensive Web3 application development framework for Mandala Chain, a Polkadot parachain with EVM compatibility. This toolkit enables rapid deployment and testing of decentralized applications on Mandala's infrastructure.

## Overview

Mandala Chain is a PolkadotVM-based parachain that provides full EVM compatibility, allowing developers to deploy Ethereum-style smart contracts while benefiting from Polkadot's interoperability and security. This development toolkit provides everything needed to build, test, and deploy applications on the Mandala network.

## Features

- **EVM Compatible Smart Contracts**: Deploy Solidity contracts on Mandala Chain
- **RPC Integration**: Direct blockchain connection via HTTPS endpoints
- **Interactive Development Environment**: Built-in contract debugging and testing tools
- **Testnet Ready**: Pre-configured for Mandala testnet deployment
- **Type-Safe Development**: Full TypeScript support throughout the stack

## Quick Start

### Prerequisites

- Node.js 18+ or 20+ (avoid Node.js 23+ due to Hardhat compatibility issues)
- Yarn package manager
- Git

### Installation

Follow these steps to set up your development environment:

#### 1. Clone the Repository

```bash
git clone https://github.com/5eh/Scaffold-Mandala-2
cd Scaffold-Mandala-2
```

#### 2. Install Dependencies

```bash
yarn install
```

#### 3. Install Hardhat Dependencies

```bash
cd packages/hardhat
yarn install
```

#### 4. Install Next.js Dependencies

```bash
cd packages/nextjs
yarn install
```

#### 5. Start the Frontend Development Server

```bash
# From packages/nextjs directory
yarn dev
```

The application will be available at `http://localhost:3000`

#### 6. Deploy Smart Contracts to Mandala Testnet

```bash
# From packages/hardhat directory
yarn deploy --network mandala
```

## Network Configuration

### Testnet (Current Default)

The toolkit is pre-configured for Mandala testnet:

- **Network**: Mandala Paseo Testnet
- **Chain ID**: 4818
- **Currency**: KPGT (18 decimals)
- **RPC Endpoint**: `https://rpc2.paseo.mandalachain.io`
- **Block Explorer**: `https://explorer.paseo.mandalachain.io`

### RPC Connection

The framework uses HTTPS requests to connect to Mandala's RPC endpoints:

```javascript
// Primary RPC endpoint
const RPC_URL = "https://rpc2.paseo.mandalachain.io";

// Alternative endpoints for redundancy
const BACKUP_RPC_URLS = [
  "https://rpc1.paseo.mandalachain.io",
  "https://rpc.paseo.mandalachain.io"
];
```

### Mainnet Deployment

**Important**: This toolkit is currently configured for testnet only. When ready for production deployment to Mandala mainnet, update the RPC endpoints and network configuration in your environment files.

For mainnet deployment, you will need to:
1. Update RPC URLs to mainnet endpoints
2. Configure mainnet chain ID and currency settings
3. Use production-grade private key management
4. Verify all contracts before deployment

## Architecture

### Directory Structure

```
packages/
├── hardhat/              # Smart contract development
│   ├── contracts/        # Solidity contracts
│   ├── deploy/          # Deployment scripts
│   ├── test/            # Contract tests
│   └── hardhat.config.js # Network configuration
├── nextjs/              # Frontend application
│   ├── app/             # Next.js app router
│   │   └── api/rpc/     # RPC proxy endpoint
│   ├── components/      # React components
│   └── contracts/       # Generated contract types
└── docs/               # Documentation
```

### Key Components

**RPC Proxy**: Built-in proxy server handles CORS issues and provides reliable blockchain connectivity.

**Contract Debugging**: Interactive interface at `/debug` for testing deployed contracts.

**Block Explorer**: Local blockchain explorer at `/blockexplorer` for transaction monitoring.

## Development Workflow

### 1. Smart Contract Development

Create your contracts in `packages/hardhat/contracts/`:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract MyDApp {
    string public name = "My Mandala DApp";
    mapping(address => uint256) public balances;

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }
}
```

### 2. Testing

```bash
cd packages/hardhat
yarn test
```

### 3. Deployment

```bash
yarn deploy --network mandala
yarn generate  # Generate TypeScript types
```

### 4. Frontend Integration

The frontend automatically detects deployed contracts and generates interaction interfaces.

## Environment Setup

Create `.env` file in `packages/hardhat/`:

!!! Before manually importing your private key, you can do `yarn generate` and import your key, to then encrypt it automagically !!!


```bash
# Deployment private key
DEPLOYER_PRIVATE_KEY=0x1234567890abcdef...

# Optional: Custom RPC endpoint
RPC_URL=https://rpc2.paseo.mandalachain.io

# WalletConnect project ID (optional)
NEXT_PUBLIC_WALLET_CONNECT_PROJECT_ID=your_project_id
```

**Security Note**: Never commit private keys to version control. Use environment variables and keep `.env` files in `.gitignore`.

## Troubleshooting

### Common Issues

**CORS Errors**: The built-in RPC proxy automatically handles CORS issues with Mandala's endpoints.

**Transaction Failures**: Mandala chain includes circuit breaker protections. If transactions fail, try reducing gas limits or waiting before retrying.

**Contract Not Found**: After deployment, run `yarn generate` to update contract types, then restart the frontend.

**Node.js Compatibility**: Use Node.js versions 18 or 20. Newer versions may cause Hardhat compatibility issues.

### Network Connectivity

Test your connection to Mandala testnet:

```bash
curl -X POST https://rpc2.paseo.mandalachain.io \
  -H "Content-Type: application/json" \
  -d '{"method":"eth_blockNumber","params":[],"id":1,"jsonrpc":"2.0"}'
```

## API Reference

### RPC Endpoints

All RPC calls are proxied through the Next.js API route for CORS handling:

```javascript
// Frontend usage
const response = await fetch('/api/rpc', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    method: 'eth_getBalance',
    params: [address, 'latest'],
    id: 1,
    jsonrpc: '2.0'
  })
});
```

### Explorer API Integration

Direct integration with Mandala's explorer API:

```bash
# Get account information
curl https://explorer.paseo.mandalachain.io/api/v2/addresses/{address}

# Get contract details
curl https://explorer.paseo.mandalachain.io/api/v2/smart-contracts/{address}
```

## Contributing

This toolkit is actively maintained and welcomes contributions:

- Bug fixes and improvements
- Additional contract templates
- Enhanced UI components
- Documentation updates
- Network optimization features

## Resources

- [Mandala Chain Documentation](https://docs.mandalachain.io)
- [Polkadot Documentation](https://docs.polkadot.network)
- [Hardhat Documentation](https://hardhat.org/docs)
- [Next.js Documentation](https://nextjs.org/docs)

## License

MIT License - see LICENSE file for details.

## Support

For issues and questions:
1. Check the troubleshooting section above
2. Review Mandala Chain documentation
3. Open an issue in this repository
