// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;
import "./PractitionerInfo.sol";
contract PatientInfo {
    address private owner;
    Prac_Info private practitioner_;
    struct PatientRecord {
        string name; 
        uint age; 
        string gender; 
        string contactNumber; 
        uint patientID;
        bool Verification;
        bool prac_side;
        address[] prac_Ids;
        bool pat_side;
    }
    mapping(address => PatientRecord) private patients;

    struct MedicalRecord{
        address[] hash;
    }
    mapping(address => MedicalRecord) private records;
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
        string memory gender,
        string memory contactNumber, 
        address[] memory prac_Ids
    ) public{
        require(age > 0 && age < 120, "Invalid age.");
        bool Verification;
        bool prac_side;
        bool pat_side;
        uint patientID = uint(keccak256(abi.encodePacked(block.timestamp,msg.sender,name))) % age;
        patients[msg.sender] = PatientRecord(name, age, gender, contactNumber, patientID, Verification = false, prac_side = false, prac_Ids, pat_side = false);

    }
    function verification(address patient_address) public {
        require(patients[patient_address].Verification != true, "Already Verified");
        patients[patient_address].Verification = true;
    }
    function getPatientRecord_for_prac(address patientAddress)
        external
        view
        returns (
            string memory name,
            uint patientID,
            address[] memory prac_Ids,
            bool prac_side,
            bool pat_side
            ){
            return (
            patients[patientAddress].name,
            patients[patientAddress].patientID,
            patients[patientAddress].prac_Ids,
            patients[patientAddress].prac_side,
            patients[patientAddress].pat_side

        );
        }
    function grantAccess(address practioneraddress, bool permission, address patientaddress) external {
        patients[patientaddress].prac_side = permission;
        if(patients[patientaddress].prac_Ids.length != 0){
            patients[patientaddress].prac_Ids.pop;
        }
        patients[patientaddress].prac_Ids.push(practioneraddress);
        patients[patientaddress].pat_side = permission;
    }

    function approved(address patientaddress, address practitioneraddress) public view returns(address[] memory){
        require(patients[patientaddress].pat_side == true, "You do not have access to this record") ;
        return(
            records[patientaddress].hash
        );
    }
    function addRecord(address patientaddress, address hash, address practioneraddress) public verified{
        require(patients[patientaddress].prac_Ids[0] == practioneraddress, "You are not authorized to add a Record");
        records[patientaddress].hash.push(hash);
    }
}