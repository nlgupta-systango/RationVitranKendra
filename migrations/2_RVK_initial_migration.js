const Migrations = artifacts.require("RationVitranKendra");

module.exports = function (deployer) {
  deployer.deploy(Migrations);
};
