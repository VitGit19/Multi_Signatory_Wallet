// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "../node_modules/@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./AccessRegistry.sol";
import "hardhat/console.sol";

contract Multi_Sig_Wallet is AccessRegistry {

    /* trasaction object stucture*/
    struct Transaction {
        address destination;
        uint256 value;
        bool executed;
        bytes data;
    }

    uint256 public transtnCount;
    mapping(uint256 => Transaction) public transactions;
    Transaction[] public validTranstns;
    mapping(uint256 => mapping(address => bool)) public authorisations;

    /*authorisation count for each transaction*/
    mapping(uint256 => uint256) public transtnAuthorisationCount;

    event Recieved(address indexed sender, uint256 value);
    event Submission(uint256 indexed transtnId);
    event Authorisation(address indexed sender, uint256 indexed transtnId);
    event Execution(uint256 indexed transtnId);
    event ExecutionFailure(uint256 indexed transtnId);

    constructor(address[] memory _signatories) payable AccessRegistry(_signatories){
        
    }

     fallback() external payable {
        if (msg.value > 0) {
            emit Recieved(msg.sender, msg.value);
        }
    }

    receive() external payable {
        if (msg.value > 0) {
            emit Recieved(msg.sender, msg.value);
        }
    }

    modifier isSignatoryMod(address _signatory) {
        require (isSignatory[_signatory]==true, "not authorised for this action" );
        _;
    }

    modifier isAthoriseMod(address _signatory, uint256 transtnId ){
        require (authorisations[transtnId][_signatory]==false, "You have already approved the transaction" );
        _;
    }
/*submit transaction*/
    function submitTranstn(address _destination , uint256 _value , bytes memory _data) public isSignatoryMod(msg.sender) returns (uint256 transtnId){
        transtnId+=transtnCount;
         console.log(transtnId);
        transactions[transtnId]= Transaction({
            destination:_destination,
            value:_value,
            data:_data,
            executed:false
        });
        
        emit Submission(transtnId);
        transtnCount+=1;
        transtnAuthorisationCount[transtnId]=0;
       authoriseTranstn(transtnId); 
  
        return transtnId;
    }

/*authorise the transaction*/
    function authoriseTranstn(uint256 transtnId) public isSignatoryMod(msg.sender) isAthoriseMod(msg.sender,transtnId) {
        authorisations[transtnId][msg.sender]=true;
        transtnAuthorisationCount[transtnId]+=1;
        emit Authorisation(msg.sender, transtnId);
        executionTranstn(transtnId);
    }

/*execution of transaction after authorisation*/
    function executionTranstn(uint256 transtnId)  public isSignatoryMod(msg.sender) {
     /*when min no of signatories authorise then a transaction gets executed*/
        if ( transtnAuthorisationCount[transtnId]>minNoOfSignReq) {
            
             Transaction storage transtn = transactions[transtnId];
             transtn.executed=true;
            (bool success, ) = transtn.destination.call{value: transtn.value}(transtn.data);
            if (success) {
                validTranstns.push(transtn);
                emit Execution(transtnId);
            } else {
                emit ExecutionFailure(transtnId);
                transtn.executed = false;
            }

        }
 
       
    }
}