// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.6.0 <0.9.0;

contract Banking101 {
    mapping(address => uint256) user_account_balances;
    uint256 deposits_total;
    address bank_manager;
    
    event e_deposit(address _from, uint256 amount);
    event e_withdraw(address _from, uint256 amount);
    event e_transfer(address _from, address _to, uint256 amount);

    constructor() {
        bank_manager = msg.sender;
    }

    modifier only_owner {
        require(msg.sender == bank_manager);
        _;
    }

    function deposit() public payable {
        user_account_balances[msg.sender] += msg.value;
        deposits_total += msg.value;
        emit e_deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) public {
        address payable client = payable(msg.sender);
        if (verify_balance(client, amount)){
            client.transfer(amount);
            user_account_balances[msg.sender] -= amount;
            deposits_total -= amount;
            emit e_withdraw(msg.sender, amount);
        }
    }

    function transfer_funds(uint256 amount, address destination_account) public {
        if (verify_balance(msg.sender, amount)){
            user_account_balances[msg.sender] -= amount;
            user_account_balances[destination_account] += amount;
            emit e_transfer(msg.sender, destination_account, amount);
        }
    }

    function get_deposits_total() public view only_owner returns (uint256) {
        return deposits_total;
    }

    function get_balance() public view returns (uint256) {
        return user_account_balances[msg.sender];
    }

    function verify_balance(address _a, uint256 amount) private view returns (bool) {
        return user_account_balances[_a] >= amount;
    }
}