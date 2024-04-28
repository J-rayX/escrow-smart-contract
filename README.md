# Escrow Smart Contract 

According to [Wikipedia](https://en.wikipedia.org/wiki/Escrow), Escrow is a contractual agreement between two transacting parties whereby a third party holds the funds and makes the disbursement based on certain agreed conditions. An example is a trust account holding funds in a person's name to pay taxes or insurance fees.

It is the bread and butter of Ethereum smart contracts. When a depositor initiates an escrow transaction, the value (Ether) is held in the escrow contract until the beneficiary has fulfilled an agreed task.


### Escrow Contract

This code demonstrates an escrow written in Solidity, the prominent language of the Ethereum Virtual Machine (EVM).  The contract is called `Escrow` in the `Escrow.sol` file:

```sol
contract Escrow{...}
```

### State Variables

Variables hold values that are persistently stored in the blockchain (the Ethereum ledger here). The smart contract in this code defines a `depositor` of value, a `beneficiary` of transferred value and an `arbiter` who alone can approve a transfer transaction. Therefore, they are defined early enough in the contract.

```sol
Contract Escrow {
    address public depositor;
    address public beneficiary;
    address public arbiter;
    ...
}
```
- the `address` data type in Solidity is a 20-byte value representing an Ethereum address. We used it for our variables here since they will be EOAs or smart contracts with an Ethereum address.


### Constructor and State Variables Initialization

Here, the state variables are initialized in the constructor of the contract. This is similar to how classes are defined in some object-oriented languages like C#.

```sol
contract Escrow {
    ...
    constructor(address _arbiter, address _beneficiary) payable {
        arbiter = _arbiter;
        beneficiary = _beneficiary;
        depositor = msg.sender;
    }
}
```

In the above code, the depositor deploys the contract and, the `msg.sender` address assumes the position of the depositor in our escrow contract. The `msg.sender` is a globally available identifier for the externally owned account (EOA) or another smart contract calling our escrow smart contract. Read more about the use of `msg.sender` in this [metaschool.so](https://metaschool.so/articles/solidity-basics-msg-sender/) answer by Munim Iftikhar.

The depositor being the deployer of the contract obtains the addresses of the arbiter and beneficiary and stores the addresses as arguments to our contract for storage as state variables.

It's noteworthy to point out that the `payable` keyword in the constructor code above identifies the contract as being able to pay the beneficiary after the arbiter approves the value transfer. The `payable` keyword is used in Solidity to signify the ability to accept ether. Ether is the denomination of payment for EVM computation.

### Arbiter and Transfer Approval

In the following code, we will write the logic to transfer the value in the escrow balance to the beneficiary whose address we saved in the state storage. This is how the arbiter will be able to approve the transfer of the deposit to the beneficiary. Let's create a function `approve()` for the process:

```sol
...

function approve() external {        
    uint balance = address(this).balance;
    (bool success, ) = beneficiary.call{ value: balance }("");
    require(success);
}
```

- the `external` keyword in the function definition indicates that the `approve()` function can only be used outside of the contract by other contracts.
- `address(this).balance` allows us to access the constructor's balance with its address using the `this` keyboard. This is the value in the escrow. In some languages like JavaScript, [this](https://en.wikipedia.org/wiki/This_(computer_programming)) keyword helps to access variables defined within a specified scope of usage.

- we made a **[message call]()** to beneficiary transfering the escrow balance to the beneficiary

- we used the `require(success)` line to handle when the `approve()` function executes successfully

### Arbiter Authorization

We need to allow only the arbiter to approve the deposit transfer. Therefore, we will create an Error to be returned once the arbiter is not the approver.

```sol
...
error NotAuthorized();

function approve() external {
    if(msg.sender != arbiter) revert NotAuthorized();
    ...
    require(success);
}
...
```

In the code above:

- we specify our custom error titled "NotAuthorized"

- In the approve() function, we used the `revert` keyword to throw NotAuthorized when the `msg.sender` of the deposit transfer is not the arbiter. The `msg.sender` signifies the address that is approving the transfer from the escrow to the beneficiary.

### Emitting Events

Events are a way to emit data for front-end systems and servers consuming or working with our contract. They can listen to events and get up-to-date information for their users and processes alike. Let us add an event, `Approved(uint)` which we will use to emit the escrow `balance` that the arbiter transfers to the beneficiary.

```sol
...
event Approved(uint);
...

function approve() external {
    ...
    emit Approved(balance);
}
```
