const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

const ERC20TokenFactoryModule = buildModule("ERC20TokenFactoryModule", (m) => {
  const ERC20TokenFactory = m.contract("ERC20TokenFactory");

  return { ERC20TokenFactory };
});

module.exports = ERC20TokenFactoryModule;