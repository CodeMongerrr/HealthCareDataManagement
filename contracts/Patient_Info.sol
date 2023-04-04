// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;
import "./PractitionerInfo.sol";
contract PatientInfo {
    address private owner;
    Prac_Info private practitioner_;
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
    function newcontract(address pracInfo_address) public verified{
        practitioner_ = Prac_Info(pracInfo_address);
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
    function verification(address patient_address) public {
        require(patients[patient_address].Verification != true, "Already Verified");
        patients[patient_address].Verification = true;
    }
    function getPatientRecord(address patientAddress)
        public
        view
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
    function getPatientRecord_for_prac(address patientAddress)
        private
        view
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
}