pragma solidity ^0.4.21;

contract Tickets{
  struct Ticket{
    bool paidFor;
    address owner;
  }
  mapping(bytes32 => Ticket) public tickets;
  mapping(address => uint) public pendingTransaction;
}
