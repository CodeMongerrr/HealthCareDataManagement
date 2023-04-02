// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract PatientInfo {
    address private owner;
    struct PatientRecord {
        PersonalDetails personaldetails;
        uint patientID;
        bool Verification;
        MedicalRecord medicalRecord;
    }
    mapping(address => PatientRecord) private patients;
    struct MedicalRecord{
        string[] record_CIDs;
        bool display;
    }
    struct PersonalDetails{
        string name;
        uint age;
        string nationality;
        string gender;
        string contactNumber;
        string email;
    }
    struct LinkInfo {
        address practitioner;
        address patient;
        bool approved_by_pat;
        bool revoked_by_prac;
    }
    mapping(address => LinkInfo) private links;

    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "Only contract owner can perform this action."
        );
        _;
    }
    modifier verified() {
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
        PersonalDetails memory personaldetails,
        MedicalRecord memory medicalrecord
    ) public {
        require(personaldetails.age > 0 && personaldetails.age < 120, "Invalid age.");
        bool Verification;
        uint patientID = uint(
            keccak256(abi.encodePacked(block.timestamp, msg.sender, personaldetails.name))
        ) % personaldetails.age;
        patients[msg.sender] = PatientRecord(
            personaldetails,
            patientID,
            Verification = false,
            medicalrecord
        );
    }

    function verification(address patient_address) public onlyOwner {
        require(
            patients[patient_address].Verification != true,
            "Already Verified"
        );
        patients[patient_address].Verification = true;
    }

    function getPatientRecord(
        address patientAddress
    )
        public
        view
        verified
        returns (
            PersonalDetails memory personaldetails,
            uint patientID,
            MedicalRecord memory medicalRecord
        )
    {
        return (
            patients[patientAddress].personaldetails,
            patients[patientAddress].patientID,
            patients[patientAddress].medicalRecord
        );
    }

    function Medical_Records(bool access, address patientAddress) public{
        patients[patientAddress].medicalRecord.display = access;
    }
}
