import 'dotenv/config';
import {HardhatUserConfig} from 'hardhat/types';
import 'hardhat-deploy';
import '@nomiclabs/hardhat-ethers';
import 'hardhat-gas-reporter';
import '@typechain/hardhat';
import 'solidity-coverage';
import 'hardhat-deploy-tenderly';
import {node_url, accounts, addForkConfiguration} from './utils/network';

const config: HardhatUserConfig = {
	solidity: {
		compilers: [
			{
				version: '0.8.17',
				settings: {
					optimizer: {
						enabled: true,
						runs: 2000,
					},
				},
			},
			{
				version: '0.8.4',
				settings: {
					optimizer: {
						enabled: true,
						runs: 2000,
					},
				},
			},
		],
	},
	namedAccounts: {
		deployer: 0,
		simpleERC20Beneficiary: 1,
	},
	networks: addForkConfiguration({
		hardhat: {
			initialBaseFeePerGas: 0,  },
		localhost: {
			url: node_url('localhost'),
			accounts: accounts(),
		},
		testnet: {
			url: 'https://rpc-mumbai.maticvigil.com/',
			accounts: ['209fc128ace6d0e23cced49765d02bced60cded2792f484bddb59baae9ebdf1c'],
		}, 
		mainnet: {
			url: 'https://polygon-rpc.com',
			accounts: ['209fc128ace6d0e23cced49765d02bced60cded2792f484bddb59baae9ebdf1c'],
		}, 
	}),
	paths: {
		sources: 'src',
	},
	gasReporter: {
		currency: 'USD',
		gasPrice: 100, 
		maxMethodDiff: 10,
	},
	typechain: {
		outDir: 'typechain',
		target: 'ethers-v5',
	},
	mocha: {
		timeout: 0,
	},  
};

export default config;
