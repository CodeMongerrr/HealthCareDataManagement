// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract HealthCareDataManagement {
    address private owner;
    uint256 private patientCount;

    struct Patient{
        string name;
        uint256 age;
        string ailment;
        bool isHospitalized;
        string[] record;
        address[] authorizedPersonnel;
    }
    mapping(address => Patient) private patients;

    event PatientRecordCreated(
        address indexed patientAddress,
        string name,
        uint256 age,
        string ailment,
        bool isHospitalized,
        string[] record
    );
    event PatientRecordUpdated(
        address indexed patientAddress,
        string name,
        uint256 age,
        string ailment,
        bool isHospitalized,
        string[] record
    );
    event PersonnelAuthorized(
        address indexed patientAddress,
        address indexed personnelAddress
    );
    event PersonnelAuthorizationRevoked(
        address indexed patientAddress,
        address indexed personnelAddress
    );
    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "Only contract owner can perform this action."
        );
        _;
    }

    modifier patientExists() {
        require(
            patients[msg.sender].age != 0,
            "Patient record does not exist."
        );
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function createPatientRecord(
        string memory name,
        uint256 age,
        string memory ailment,
        bool isHospitalized,
        string[] memory record
    ) public {
        require(age > 0 && age < 120, "Invalid age.");
        patients[msg.sender] = Patient(
            name,
            age,
            ailment,
            isHospitalized,
            record,
            new address[](0)
        );
        patientCount++;
        emit PatientRecordCreated(
            msg.sender,
            name,
            age,
            ailment,
            isHospitalized, 
            record
        );
    }

    function getPatientRecord(address patientAddress)
        public
        view
        onlyOwner
        returns (
            string memory,
            uint256,
            string memory,
            bool,
            string[] memory,
            address[] memory
            
        )
    {
        require(
            patients[patientAddress].age != 0,
            "Patient record does not exist."
        );
        return (
            patients[patientAddress].name,
            patients[patientAddress].age,
            patients[patientAddress].ailment,
            patients[patientAddress].isHospitalized,
            patients[patientAddress].record,
            patients[patientAddress].authorizedPersonnel
            
        );
    }
    function hashPDF(string memory parameter) external returns (string memory) {
        bytes memory result;
        // Execute external Python function
        (bool success, bytes memory data) = address(this).call(
            abi.encodeWithSignature("functions\\hash_function.py\\hash_pdf(string)", parameter)
        );
        // Handle external function execution result
        require(success, "External function call failed");
        result = data;
        // Convert bytes result to string
        string memory strResult = string(result);
        // Return result
        return strResult;
    }

    function executePythonFunction(string memory parameter, string memory name,
        uint256 age,
        string memory ailment,
        bool isHospitalized) public {
        // Validate and sanitize the input parameter before executing the Python function

        // Build the command to execute the Python function, passing the parameter
        string memory hashvalue = string(abi.encodePacked("hash_function.py", parameter));
        updatePatientRecord(name,
        age,
        ailment,
        isHospitalized,
        hashvalue);
    }

    /*function callPythonFunction(string file_path) public returns (bytes32) {
        // Import the Python module
        string memory code = "from functions\\hash_function.py import hash_pdf";

        // Execute the Python code
        exec(code);

        // Call the Python function with the arguments
        string memory arg = new string;
        arg = file_path;
        bytes memory resultBytes = abicoder.encode_abi((bytes32)(new bytes32), arg);
        string memory resultString = string(resultBytes);
        bytes memory result = abi.encodeWithSignature("hash_pdf(String)", file_path);
        
        // Decode the result using ABIE Coder
        bytes32 memory decodedResult = new bytes32;
        abicoder.decode_abi((bytes32)(new bytes32), bytes(result), decodedResult);

        // Return the result
        return decodedResult;
    }*/

    function appendRecord(string memory hashvalue) public {
        uint256 len = patients[msg.sender].record.length;
        string[] memory newRecord = new string[](len + 1);
        for (uint256 i = 0; i < len; i++) {
            newRecord[i] = patients[msg.sender].record[i];
        }
        newRecord[len] = hashvalue;
        patients[msg.sender].record = newRecord;
       
    }

    function stringToBytes32(string memory str) public pure returns (bytes32 result) {
        bytes memory temp = bytes(str);
        assembly {
            result := mload(add(temp, 32))
    }
}


    function updatePatientRecord(
        string memory name,
        uint256 age,
        string memory ailment,
        bool isHospitalized,
        string memory hashvalue
    ) public patientExists {
        string[] memory record;
        patients[msg.sender].record.push(hashvalue);
        emit PatientRecordUpdated(
            msg.sender,
            name,
            age,
            ailment,
            isHospitalized,
            record
        );
    }

    function authorizePersonnel(address personnelAddress) public patientExists {
        require(personnelAddress != address(0), "Invalid personnel address.");
        for (
            uint256 i = 0;
            i < patients[msg.sender].authorizedPersonnel.length;
            i++
        ) {
            if (
                patients[msg.sender].authorizedPersonnel[i] == personnelAddress
            ) {
                revert("Personnel already authorized.");
            }
        }
        patients[msg.sender].authorizedPersonnel.push(personnelAddress);
        emit PersonnelAuthorized(msg.sender, personnelAddress);
    }

    function revokeAuthorization(address personnelAddress)
        public
        patientExists
    {
        require(personnelAddress != address(0), "Invalid personnel address.");
        for (
            uint256 i = 0;
            i < patients[msg.sender].authorizedPersonnel.length;
            i++
        ) {
            if (
                patients[msg.sender].authorizedPersonnel[i] == personnelAddress
            ) {
                patients[msg.sender].authorizedPersonnel[i] = patients[
                    msg.sender
                ].authorizedPersonnel[
                        patients[msg.sender].authorizedPersonnel.length - 1
                    ];
                patients[msg.sender].authorizedPersonnel.pop();
                emit PersonnelAuthorizationRevoked(
                    msg.sender,
                    personnelAddress
                );
                return;
            }
        }
    }
}
