// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;
import "./PatientInfo.sol";
import "./PractitionerInfo.sol";
contract Assign{
    address private owner;
    PatientInfo public patient_;
    Prac_Info public prac_;
    constructor(address patientInfo_address, address pracInfo_address){
        patient_ = PatientInfo(patientInfo_address);
        prac_ = Prac_Info(pracInfo_address);
    }
    
    //We need to make a set of functions in the form of modifiers that would allow us to take the opinion of both, prac and patient and then only the patientID will be appended in the Practitioner's list 
}    