pragma solidity ^0.4.21;

/**
 * @title Ticketing Smart Contract
 * @dev A contract for booking tickets and adding a venueOwner
 * using solidity
 */

contract Tickets {
  //Creating a struct for Ticket which will hold Owner address and whether paid or not
  struct Ticket {
    bool paidFor;
    address owner;
  }

  //Mapping for tickets to struct Tickets
  mapping(bytes32 => Ticket) public tickets;
  mapping(address => uint) public pendingTransactions;

  bool public releaseEther; // releaseEther will be used to evaluate the state of the tx
  uint public ticketPrice;  // Var for storing ticket Price
  address public venueOwner; // Var for storing venueOwner
  string public name; // Name of the venue
  event TicketKey(bytes32 ticketKey); // Event to generate a ticket key
  event CanPurchase(bool canPurchase); // A certain can purchase a ticket or not
  event PaidFor(bool paid);

  // Only owner modifier for function
  modifier onlyOwner() {
    require(msg.sender == venueOwner);
    _;
  }

  // For those who are not owner of the venue
  modifier notOwner() {
    require(msg.sender != venueOwner);
    _;
  }

  //Changing the state
  modifier releaseTrue() {
    require(releaseEther);
    _;
  }

  //Constructor for creating the ticket with a venue name
  constructor (uint price, string title) public {
    ticketPrice = price;
    name = title;
    venueOwner = msg.sender;
    releaseEther = false;
  }

  //Unlocking Ether to purchase ticket for a specific address(Owner)
  function unlockEther(bytes32 hash) releaseTrue public notOwner {
    uint amount = pendingTransactions[msg.sender];
    pendingTransactions[msg.sender] = 0;
    venueOwner.transfer(amount);
    tickets[hash].paidFor = true;
    emit PaidFor(true);
}

  function () public {
    releaseEther = false;
  }

  //Allowing purchase for that address
  function allowPurchase() public onlyOwner {
    releaseEther = true;
    emit CanPurchase(releaseEther);
  }

  // Creating tickets for the venue or event
  function createTicket() public payable onlyOwner {
    if (msg.value == ticketPrice) {
      pendingTransactions[msg.sender] = msg.value;
      bytes32 hash = keccak256(abi.encodePacked(msg.sender));
      tickets[hash] = Ticket(false, msg.sender);
      emit TicketKey(hash);
    }
  }

  // Will display if any transactions are pending for a specific address
  function getTransaction() constant public returns (uint) {
    return pendingTransactions[msg.sender];
  }

 // Retrieve owner address
  function getOwner(bytes32 hash) constant public returns (address) {
    return tickets[hash].owner;
  }

  // Retreive Ticket Price
  function getTicketPrice() constant public returns (uint) {
    return ticketPrice;
  }

  // Get owner address
  function getOwnerAddress() onlyOwner constant public returns (address) {
    return venueOwner;
  }

  // Get event name
  function getEventName() constant public returns (string) {
    return name;
  }

}
