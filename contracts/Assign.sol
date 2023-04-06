// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;
import "./PatientInfo.sol";
import "./PractitionerInfo.sol";

contract Assign {
    address private owner;
    PatientInfo public patient_;
    Prac_Info public prac_;
    mapping(address => mapping(address => bool)) private access;

    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "Only contract owner can perform this action."
        );
        _;
    }

    function newcontract(address patientInfo_address,address pracInfo_address) public {
        owner = msg.sender;
        patient_ = PatientInfo(patientInfo_address);
        prac_ = Prac_Info(pracInfo_address);
    }

    function grantAccess(address patient, address practitioner) public {
        access[patient][practitioner] = true;
    }

    function revokeAccess(address patient, address practitioner) public {
        access[patient][practitioner] = false;
    }
    
    function checkAccess(
        address patient,
        address practitioner
    ) public view returns (bool) {
        return access[patient][practitioner];
    }
}
