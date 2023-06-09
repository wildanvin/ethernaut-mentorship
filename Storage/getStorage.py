from web3 import Web3

alchemy_url = "http://127.0.0.1:8545"

# connect to an Ethereum node
w3 = Web3(Web3.HTTPProvider(alchemy_url))

# address of the smart contract
contract_address = '0xbAe048A5dCc2c75e1fF29735C7A86Dd247e5C785'

slot_0 = w3.eth.get_storage_at(contract_address, 0)
slot_1 = w3.eth.get_storage_at(contract_address, 1)
slot_2 = w3.eth.get_storage_at(contract_address, 2)
slot_3 = w3.eth.get_storage_at(contract_address, 3)
slot_4 = w3.eth.get_storage_at(contract_address, 4)
slot_5 = w3.eth.get_storage_at(contract_address, 5)
slot_6 = w3.eth.get_storage_at(contract_address, 6)
slot_7 = w3.eth.get_storage_at(contract_address, 7)
slot_8 = w3.eth.get_storage_at(contract_address, 8)
slot_9 = w3.eth.get_storage_at(contract_address, 80084422859880547211683076133703299733277748156566366325829078699459944778998)
slot_10 = w3.eth.get_storage_at(contract_address, 80084422859880547211683076133703299733277748156566366325829078699459944778999)


print(slot_0.hex())
print(slot_1.hex())
print(slot_2.hex())
print(slot_3.hex())
print(slot_4.hex())
print(slot_5.hex())
print(slot_6.hex())
print(slot_7.hex())
print(slot_8.hex())
print(slot_9.hex())
print(slot_10.hex())

