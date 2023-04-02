import hashlib
from web3 import Web3


web3 = Web3(Web3.HTTPProvider('http://127.0.0.1:7545'))
print(web3.eth.block_number)
address = '0xeBBA150433dB9C465D064c95e3c4573d1f0D227f'
balance = web3.eth.get_balance(address)
print(web3.from_wei(balance, 'ether'))
patientInfo_contract = "0xd9145CCE52D386f254917e481eB44e9943F39138"
patientInfo_ABI = [
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "name",
				"type": "string"
			},
			{
				"internalType": "uint256",
				"name": "age",
				"type": "uint256"
			},
			{
				"internalType": "string",
				"name": "nationality",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "gender",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "contactNumber",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "email",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "add",
				"type": "string"
			}
		],
		"name": "createRecord",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [],
		"stateMutability": "nonpayable",
		"type": "constructor"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "patientAddress",
				"type": "address"
			}
		],
		"name": "getPatientRecord",
		"outputs": [
			{
				"internalType": "string",
				"name": "name",
				"type": "string"
			},
			{
				"internalType": "uint256",
				"name": "age",
				"type": "uint256"
			},
			{
				"internalType": "string",
				"name": "nationality",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "gender",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "contactNumber",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "email",
				"type": "string"
			}
		],
		"stateMutability": "view",
		"type": "function"
	}
]
patientInfo = web3.eth.contract(address = patientInfo_contract, abi = patientInfo_ABI)
#practitionerInfo_contract = ""
#practitionerInfo_ABI = []
#practitionerInfo = web3.eth.contract(address = practitionerInfo_contract, abi = practitionerInfo_ABI)
#assign_contract = ""
#assign_ABI = []
#assign_contract = web3.eth.contract(address = assign_contract, abi = assign_ABI)

file_path = ""
def hash_pdf( file_path):
    with open(file_path, 'rb') as file:
        file_contents = file.read()
        hash_value = hashlib.sha256(file_contents).hexdigest()
        return hash_value

print(hash_pdf("Girl.txt"))

patientInfo.create_Pat_Record(hash_pdf("Girl.txt"), 35, "American", "Male", "+1-555-555-5555", "john.smith@email.com")
print(patientInfo.getPatientRecord("0xeBBA150433dB9C465D064c95e3c4573d1f0D227f"))




