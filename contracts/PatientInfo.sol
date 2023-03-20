// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract HealthCareDataManagement {
    address private owner;

    struct PatientRecord {
        string name; // full name of the individual
        uint age; // date of birth of the individual (format: YYYY-MM-DD)
        string nationality; // nationality of the individual
        string gender; // gender of the individual
        string contactNumber; // contact number of the individual
        string email; // email address of the individual
        string add;
        uint Verification;
    }
    mapping(address => PatientRecord) private patients;

    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "Only contract owner can perform this action."
        );
        _;
    }
    modifier verified(){
        require(
            patients[msg.sender].Verification != 0,
            "The Patient needs to be verified first"
        );
        _;
    }
    constructor() {
        owner = msg.sender;
    }
    function createRecord(
        string memory name, 
        uint age,
        string memory nationality,
        string memory gender,
        string memory contactNumber, 
        string memory email,
        string memory add
     
    ) public{
        require(age > 0 && age < 120, "Invalid age.");
        uint Verification;
        patients[msg.sender] = PatientRecord(name, age, nationality, gender, contactNumber, email, add, Verification = 0);

    }
}
