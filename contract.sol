pragma solidity ^0.8.28;

contract HelloWorld {

    event NewGaruda(uint garudaId, string name, uint dna);
    uint dnaDigit = 16;
    uint dnaModulus = 10 ** dnaDigit;

    struct Garuda {
        uint dna;
        string name;
    }
    Garuda[] public garudas;

    function _createGaruda(string memory _name, uint _dna) private {
        garudas.push(Garuda(_dna, _name));
        emit NewGaruda(garudas.length - 1, _name, _dna);
    }
    function _generateRandomDna(string memory _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }
    function createRandomGaruda(string memory _name) public {
        uint randDna = _generateRandomDna(_name);
        _createGaruda(_name, randDna);
    }
}
