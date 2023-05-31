pragma solidity 0.8.13;


contract CTF  {

   uint256[] public tokenTypes;

   constructor(uint x) {
       tokenTypes.push(type(uint256).max); //pushing 0 so to make array 1 indexed

       for(uint i=1;i<=x;i++) {
           tokenTypes.push(i);
       }

       //tokenTypes array will be [0xfffffff...,1,2,3,4,...,x]
       //valid values are from index [1,x]
       //0 index is invalid value and is not supposed to be used
   }



   function checkValidValue(uint256 x) public view returns(bool) {
       //assume that this function returns random bool value. 
       // for the purpose of demostation, I am making it deterministic based on block.timestamp, block.number and tx.gasprice for ease of understanding
       //but in real code, it is returning random bool value(true/false) based on chainlink oracle

       if(((block.timestamp + block.number + tx.gasprice + x)*(block.timestamp + block.number + tx.gasprice + x))% 2 == 0) {
           return true;
       } else {
           return false;
       }
   }

    function pickRandomTokenType(uint256 _randomNumber) internal view returns(uint256) { 
        uint256 randomNumberModded = _randomNumber % (tokenTypes.length - 1);
        if(checkValidValue(randomNumberModded + 1) == true) {
            return randomNumberModded + 1;
        } else {
            uint256 tokenType = randomNumberModded + 1 + 1;
            for (uint256 index = 1; index < tokenTypes.length - 1; index++) { //this checks for all values of tokenTypes array
                if(tokenType > tokenTypes.length - 1) tokenType = 1;
                if(checkValidValue(tokenType) == true)
                    return tokenType;
                else
                    tokenType = tokenType + index;
            }
        }
        return type(uint256).max;
    }

    function mintRandomType(address _to, uint256 _randomWord) external returns(uint256) {
        uint256 randomTokenType = pickRandomTokenType(_randomWord);
        require(randomTokenType != type(uint256).max, "No more NFTs available for minting");
        //if there is valid randomTokenType available, mint the NFT and return the minted token
        //mint
        return randomTokenType;
    }
}