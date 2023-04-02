
var PractitionerInfo = artifacts.require("Prac_Info.sol");
module.exports = function(deployer) {
  deployer.deploy(PractitionerInfo);
};
