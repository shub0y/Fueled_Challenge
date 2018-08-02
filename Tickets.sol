pragma solidity ^0.4.21;

contract Tickets{
  struct Ticket{
    bool paidFor;
    address owner;
  }
  mapping(bytes32 => Ticket) public tickets;
  mapping(address => uint) public pendingTransaction;
  bool public releseEther;
  uint public ticketPrice;
  address public venueOwner;
  string public name;
  event TicketKey(bytes32 ticketKey);
  event CanPurchase(bool canPurchase);
  event PaidFor(bool paid);

  modifier onlyOwner(){
    require(msg.sender == venueOwner);
    _;
  }

  modifier notOwner(){
    require(msg.sender != venueOwner)
    _;
  }

  modifier releaseTrue(){
    require(releseEther);
    _;
  }


}
