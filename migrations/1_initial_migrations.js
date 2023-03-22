const Migrations= artifacts.require("Migrations");

module.exports = function(deployer) {
  deployer.deploy(Migrations);
};

var PatientInfo = artifacts.require("PatientInfo.sol");

module.exports = function(deployer) {
  deployer.deploy(PatientInfo);
};

var PractitionerInfo = artifacts.require("Prac_Info.sol");

module.exports = function(deployer) {
  deployer.deploy(PractitionerInfo);
};

var Assign = artifacts.require("Assign.sol");

module.exports = function(deployer) {
  deployer.deploy(Assign);
};

