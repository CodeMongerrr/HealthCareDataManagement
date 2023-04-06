// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;
import "./PatientInfo.sol";

contract Prac_Info {
    address private owner;
    PatientInfo private patient_;
    mapping(address => mapping(address => bool)) private access;
    struct Prac_Record {
        string name;
        uint age;
        string gender;
        string contactNumber;
        string prac_ID;
        string[] patientIDs;
        bool Verification;
    }
    mapping(address => Prac_Record) private pracs;

    struct MedicalRecord{
        address[] hash;
    }
    mapping(address => MedicalRecord) private records;
    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "Only Contract Owner can perform this action"
        );
        _;
    }

    modifier verified() {
        require(
            pracs[msg.sender].Verification != false,
            "The Practitioner needs to be Verified first"
        );
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function newcontract(address patientInfo_address) public onlyOwner {
        patient_ = PatientInfo(patientInfo_address);
    }

    function create_Prac_Record(
        string memory name,
        uint age,
        string memory gender,
        string memory contactNumber,
        string memory prac_ID,
        string[] memory patientIDs
    ) public {
        require(age > 0 && age < 120, "Invalid Age");
        bool Verification;
        pracs[msg.sender] = Prac_Record(
            name,
            age,
            gender,
            contactNumber,
            prac_ID,
            patientIDs,
            Verification = false
        );
    }

    function verification(address prac_address) public {
        require(pracs[prac_address].Verification != true, "Already Verified");
        pracs[prac_address].Verification = true;
    }

    function get_prac_record(
        address prac_address
    )
        public
        view
        onlyOwner
        verified
        returns (
            string memory name,
            uint age,
            string memory gender,
            string memory contactNumber,
            string memory prac_ID,
            string[] memory patientIDs
        )
    {
        return (
            pracs[prac_address].name,
            pracs[prac_address].age,
            pracs[prac_address].gender,
            pracs[prac_address].contactNumber,
            pracs[prac_address].prac_ID,
            
            pracs[prac_address].patientIDs
        );
    }

    function get_pat_record(
        address patientAddress
    )
        public
        view
        onlyOwner
        returns (
            string memory name,
            uint patientID,
            address[] memory prac_Ids,
            bool prac_side,
            bool pat_side
        )
    {
        return (patient_.getPatientRecord_for_prac(patientAddress));
    }
    function grantAccess(address patientaddress, bool permission) public{
        patient_.grantAccess(msg.sender, permission, patientaddress);
    }

    function getMedicalRecords(address patientaddress) public view onlyOwner returns(address[] memory){
        return(patient_.approved(patientaddress, msg.sender));
    }
    function addRecord(address patientaddress,address hash, address practioneraddress) public onlyOwner{
        patient_.addRecord(patientaddress, hash, practioneraddress);
    }
    
}