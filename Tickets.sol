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

  constructor (uint price, string title) public{
    ticketPrice = price;
    name = title;
    venueOwner = msg.sender;
    releaseEther = false;
  }

  function unlockEther (bytes32 hash) releaseTrue public notOwner{
    uint amount = pendingTransaction[msg.sender];
    pendingTransaction[msg.sender] = 0;
    venueOwner.transfer(amount);
    tickets[hash].paidFor = true;
    emit paidFor(true);
  }

  function () public {
    releaseEther = false;
  }

  function allowPurchase() public onlyOwner{
    releseEther = True;
    emit canPurchase(releseEther);
  }

  function createTicket() public payable onlyOwner{
    if (msg.value == ticketPrice) {
      pendingTransactions[msg.sender] = msg.value;
      bytes32 hash = keccak256(abi.encodePacked(msg.sender));
      tickets[hash] = Ticket(false, msg.sender);
      emit TicketKey(hash);
    }
  }

  function getTransaction() constant public returns (uint){
    return pendingTransaction[msg.sender];
  }

  function getOwner(bytes32 hash) constant public returns (address){
    return tickets[hash].owner;
  }

  function getTicketPrice() constant public return (uint){
    return ticketPrice;
  }

  function getOwnerAdress() onlyOwner constant public returns (address){
    return venueOwner;
  }

  function getEventName() constant public returns (string){
    return name;
  }

}
