// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract PatientInfo {
    address private owner;

    struct PatientRecord {
        string name; 
        uint age; 
        string nationality; 
        string gender; 
        string contactNumber; 
        string email; 
        uint patientID;
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
        string memory email
    ) public{
        require(age > 0 && age < 120, "Invalid age.");
        bool Verification;
        uint patientID = uint(keccak256(abi.encodePacked(block.timestamp,msg.sender,name))) % age;
        patients[msg.sender] = PatientRecord(name, age, nationality, gender, contactNumber, email, patientID, Verification = false);

    }
    function verification(address patient_address) public onlyOwner{
        require(patients[patient_address].Verification != true, "Already Verified");
        patients[patient_address].Verification = true;
    }
    function getPatientRecord(address patientAddress)
        public
        view
        onlyOwner
        verified
        returns (
            string memory name, 
            uint age,
            string memory nationality,
            string memory gender,
            string memory contactNumber, 
            string memory email,
            uint patientID
            ){
            return (
            patients[patientAddress].name,
            patients[patientAddress].age,
            patients[patientAddress].nationality,
            patients[patientAddress].gender,
            patients[patientAddress].contactNumber,
            patients[patientAddress].email,
            patients[patientAddress].patientID
        );
        }
    function authorize_prac(string memory prac_ID) public{
        
    }
}
