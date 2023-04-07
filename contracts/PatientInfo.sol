// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;
import "./PractitionerInfo.sol";

contract PatientInfo {
    address private owner;
    Prac_Info private practitioner_;
    struct PatientRecord {
        string name;
        uint256 age;
        string gender;
        string contactNumber;
        uint256 patientID;
        bool Verification;
        address prac_Id;
        bool pat_side;
    }
    mapping(address => PatientRecord) private patients;

    struct MedicalRecord {
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
    modifier verified() {
        require(
            patients[msg.sender].Verification != false ,
            "The Patient needs to be verified first"
        );
        _;
    }
    modifier linked() {
        require(
            patients[msg.sender].pat_side == true,
            "The Patient has not given access"
        );
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function newcontract(address pracInfo_address) public  {
        practitioner_ = Prac_Info(pracInfo_address);
    }

    function create_Pat_Record(
        string memory name,
        uint256 age,
        string memory gender,
        string memory contactNumber
    ) public {
        require(age > 0 && age < 120, "Invalid age.");
        bool Verification;
        address prac_Id = address(0);
        bool pat_side;
        uint256 patientID = uint256(
            keccak256(abi.encodePacked(block.timestamp, msg.sender, name))
        ) % age;
        patients[msg.sender] = PatientRecord(
            name,
            age,
            gender,
            contactNumber,
            patientID,
            Verification = false,
            prac_Id,
            pat_side = false
        );
    }

    function verification(address patient_address) public {
        require(
            patients[patient_address].Verification != true,
            "Already Verified"
        );
        patients[patient_address].Verification = true;
    }

    function getPatientRecord_for_prac(address patientAddress)
        external
        view
        returns (
            string memory name,
            uint256 patientID,
            address prac_Id,
            bool pat_side
        )
    {
        return (
            patients[patientAddress].name,
            patients[patientAddress].patientID,
            patients[patientAddress].prac_Id,
            patients[patientAddress].pat_side
        );
    }

    function grantaccess(address practitioneraddress, address patientaddress)
        external
        verified
    {
        require(
            patients[patientaddress].prac_Id == practitioneraddress,
            "The practitioner has not yet requested for the access"
        );
        patients[patientaddress].pat_side = true;
    }

    function pending_requests(address practioneraddress, address patientaddress)
        external
    {
        patients[patientaddress].prac_Id = practioneraddress;
    }

    function get_prac_record(address practitioneraddress)
        public
        view
        returns (
            string memory name,
            uint age,
            string memory gender,
            string memory contactNumber,
            uint prac_ID,
            address[] memory patientIDs
        )
    {
        return (practitioner_.get_prac_record(practitioneraddress));
    }

    function addrecord(
        address practioneraddress,
        address hash,
        address patientaddress
    ) external {
        records[patientaddress].hash.push(hash);
    }

    function accessrecords(address practioneraddress, address patientaddress)
        external
        view
        returns (address[] memory)
    {
        require(patients[patientaddress].pat_side == true, "The patient has not authorized you for the access");
        return (records[patientaddress].hash);
    }
}
