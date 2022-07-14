// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "../node_modules/@openzeppelin/contracts/utils/math/SafeMath.sol";

contract AccessRegistry {

    address public admin;
    address[] public signatories;
    mapping(address => bool) public isSignatory;
    /*variable to get minimum no of signatories to authorize a transaction*/
    uint256 minNoOfSignReq;
    constructor(address[] memory _signatories) payable{
        admin=msg.sender;
        require(_signatories.length>3,"Total no of signatories should be greater than or equal to 3");
        /*declaring the signatories*/
        for (uint i = 0; i < _signatories.length; i++) {
            isSignatory[_signatories[i]]=true;
        }

        /*calculating the minimum no of signatories to authorize a transaction*/
        uint256 mul=SafeMath.mul(_signatories.length,60);
        minNoOfSignReq=SafeMath.div(mul,100);
        signatories=_signatories;
    }

/*function to add signatory*/
    function addSignatory(address _signatory) public {
        signatories.push(_signatory);
        isSignatory[_signatory]=true;
    }


/*function to revoke signatory*/
    function revokeSignatory(address _signatory) public {
        for (uint i = 0; i < signatories.length; i++) {
            if (signatories[i]==_signatory) {
                break;
            }
        }
        signatories.pop();
        isSignatory[_signatory]=false;
    }
    function updateMinSignNo() public {
       
        uint256 mul=SafeMath.mul(signatories.length,60);
        minNoOfSignReq=SafeMath.div(mul,100);
    }


/*function to transfer signatory*/
    function transferSignatory(address _from ,address _to) public {
         for (uint i = 0; i < signatories.length; i++) {
            if (signatories[i]==_from) {
                signatories[i]=_to;
                break;
            }
        }
    }

/*function to renounce signatory*/
    function renounce(address _admin)  public {
        admin=_admin;
    }

/*function to get signatories*/
    function getSignatories() public view returns (address[] memory){
        return signatories;
    }

/*function to get admin*/
     function getAdmin() public view returns (address){
        return admin;
    }
}