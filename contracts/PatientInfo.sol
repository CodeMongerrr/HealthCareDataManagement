// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract PatientInfo {
    address private owner;

    struct PatientRecord {
        string name; // full name of the individual
        uint age; // date of birth of the individual (format: YYYY-MM-DD)
        string nationality; // nationality of the individual
        string gender; // gender of the individual
        string contactNumber; // contact number of the individual
        string email; // email address of the individual
        string add;
        bool Verification;
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
            patients[msg.sender].Verification != false,
            "The Patient needs to be verified first"
        );
        _;
    }
    constructor() {
        owner = msg.sender;
    }
    function create_Pat_Record(
        string memory name, 
        uint age,
        string memory nationality,
        string memory gender,
        string memory contactNumber, 
        string memory email,
        string memory add
     
    ) public{
        require(age > 0 && age < 120, "Invalid age.");
        bool Verification;
        patients[msg.sender] = PatientRecord(name, age, nationality, gender, contactNumber, email, add, Verification = false);

    }
    function verification(address patient_address) public onlyOwner{
        require(patients[patient_address].Verification != true, "Already Verified");
        patients[patient_address].Verification = true;
    }
    function getPatientRecord(address patientAddress)
        public
        view
        onlyOwner
        returns (
            string memory name, 
            uint age,
            string memory nationality,
            string memory gender,
            string memory contactNumber, 
            string memory email
            ){
            require(
                patients[patientAddress].age != 0, "Patient Record does not exist"
            );
            require(
                patients[patientAddress].Verification == true, "Patient is not Verified yet"
            );
            return (
            patients[patientAddress].name,
            patients[patientAddress].age,
            patients[patientAddress].nationality,
            patients[patientAddress].gender,
            patients[patientAddress].contactNumber,
            patients[patientAddress].email
            
        );
        }
}
