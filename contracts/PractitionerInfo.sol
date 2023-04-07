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
        uint prac_ID;
        address[] patientIDs;
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
        address[] memory patientIDs
    ) public {
        require(age > 0 && age < 120, "Invalid Age");
        bool Verification;
        uint256 prac_ID = uint256(
            keccak256(abi.encodePacked(block.timestamp, msg.sender, name))
        ) % age;
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

    function verification(address prac_address) public onlyOwner{
        require(pracs[prac_address].Verification != true, "Already Verified");
        pracs[prac_address].Verification = true;
    }

    function get_prac_record(
        address prac_address
    )
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
        returns (
            string memory name,
            uint patientID,
            address prac_Ids,
            bool pat_side
        )
    {
        return (patient_.getPatientRecord_for_prac(patientAddress));
    }

    function addRecord(address practitioneraddress,address hash,  address patientaddress) public verified{
        patient_.addrecord(practitioneraddress, hash, patientaddress);
    }

    function askforaccess(address practitioneraddress, address patientaddress) public verified{
        patient_.pending_requests(practitioneraddress, patientaddress);
    }

    function accessrecords(address practitioneraddress, address patientaddress) public verified{
        patient_.accessrecords(practitioneraddress, patientaddress);
        pracs[practitioneraddress].patientIDs.push(patientaddress);

    }
    function is_prac_linked(address practitioneraddress, address patientaddress) external returns(address[] memory){
        return(
            pracs[practitioneraddress].patientIDs
        );
    }
}