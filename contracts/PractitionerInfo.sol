// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract Prac_Info{
    address private owner;
    struct Prac_Record{
        string name;
        uint age;
        string nationality;
        string gender;
        string  contactNumber;
        string email;
        string prac_ID;
        string patientIDs;
        bool Verification;
    }
    mapping(address => Prac_Record) private pracs;

    modifier onlyOwner(){
        require(
            msg.sender == owner, "Only Contract Owner can perform this action"
        );
        _;
    }

    modifier verified(){
        require(
            pracs[msg.sender].Verification != false, 
            "The Prac_ needs to be Verified first"
        );
        _;
    }

    constructor(){
        owner = msg.sender;
    }

    function create_Prac_Record(
        string memory name,
        uint age,
        string memory nationality,
        string memory gender,
        string memory contactNumber,
        string memory email,
        string memory prac_ID,
        string memory patientIDs
    ) public{
        require(age > 0 && age < 120, "Invalid Age");
        bool Verification;
        pracs[msg.sender] = Prac_Record(name, age, nationality, gender, contactNumber, email, prac_ID, patientIDs, Verification = false);
    }

    function verification(address prac_address) public onlyOwner{
        require(pracs[prac_address].Verification != true, "Already Verified");
        pracs[prac_address].Verification = true;
    }

    function get_prac_record(address prac_address) public view onlyOwner verified
    returns(
        string memory name,
        uint age,
        string memory nationality,
        string memory gender,
        string memory contactNumber,
        string memory email,
        string memory prac_ID,
        string memory patientIDs
    ){
        
    }
}