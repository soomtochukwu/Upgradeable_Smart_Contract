const
    { network } = require("hardhat"),
    { verify } = require("../utils/verify");

require("dotenv").config();

module.exports = async ({ getNamedAccounts, deployments }) => {
    // let implementation_contract_address;
    const
        { deployer } = await getNamedAccounts(),
        { deploy } = await deployments,
        { chainId } = network.config.chainId,

        /* 
        deploy implementation_contract 
        */
        implementation_contract = await deploy("implementation_contract", {
            from: deployer,
            args: [],
            log: true,
            waitConfirmations: network.config.blockConfirmations,
        }),

        // verify implementation_contract
        ETHERSCAN_KEY = process.env.ETHERSCAN_KEY;
    if (chainId !== 31337 && ETHERSCAN_KEY) {
        await verify(
            implementation_contract.address,
            [],
            "contracts/upgradableSmartContract.sol:implementation_contract"
        )
    };



    /* 
    deploy proxyContract
     */
    const proxyContract = await deploy("proxyContract", {
        from: deployer,
        args: [implementation_contract.address],
        log: true,
        waitConfirmations: network.config.blockConfirmations,
    });

    // verify proxyContract
    if (chainId !== 31337 && ETHERSCAN_KEY) {
        await verify(
            proxyContract.address,
            [implementation_contract.address],
            "contracts/upgradableSmartContract.sol:proxyContract"
        )
    };



    /* 
    deploy upgraded_implementation_contract
     */
    const upgraded_implementation_contract = await deploy("upgraded_implementation_contract", {
        from: deployer,
        args: [],
        log: true,
        waitConfirmations: network.config.blockConfirmations,
    });

    // verify upgraded_implementation_contract
    if (chainId !== 31337 && ETHERSCAN_KEY) {
        await verify(
            upgraded_implementation_contract.address,
            [],
            "contracts/upgradableSmartContract.sol:upgraded_implementation_contract"
        )
    }
}

module.exports.tags = ["all", "nft"]