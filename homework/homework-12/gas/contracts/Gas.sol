// SPDX-License-Identifier: UNLICENSED
// Answers https://gist.github.com/extropyCoder/ec38af44a25b3d63e622083a21f7f6fe
pragma solidity 0.8.0;

import "./Ownable.sol";

contract GasContract is Ownable {
    uint256 public totalSupply = 0; // cannot be updated
    uint256 paymentCounter = 0;
    address contractOwner;
    address[5] public administrators;

    enum PaymentType {
        Unknown,
        BasicPayment,
        Refund,
        Dividend,
        GroupPayment
    }

    PaymentType constant defaultPayment = PaymentType.Unknown;

    History[] paymentHistory; // when a payment was updated

    struct Payment {
        bool adminUpdated;
        PaymentType paymentType;
        uint256 amount;
        uint256 paymentID;
        address recipient;
        address admin; // administrators address
        string recipientName; // max 8 characters
    }

    struct History {
        uint256 lastUpdate;
        uint256 blockNumber;
        address updatedBy;
    }
    
    struct ImportantStruct {
        uint256 valueA; // max 3 digits
        uint256 valueB; // max 3 digits
        uint256 bigValue;
    }

    mapping(address => uint256) balances;
    mapping(address => Payment[]) payments;
    mapping(address => ImportantStruct) whiteListStruct;    
    mapping(address => uint256) public whitelist;

    event AddedToWhitelist(address userAddress, uint256 tier);

    modifier onlyAdminOrOwner() {
        address senderOfTx = msg.sender;
        if (checkForAdmin(senderOfTx)) {
            require(checkForAdmin(senderOfTx), "Caller not admin");
            _;
        } else if (senderOfTx == contractOwner) {
            _;
        } else {
            revert("Caller not owner");
        }
    }

    modifier checkIfWhiteListed(address sender) {
        address senderOfTx = msg.sender;
        require(senderOfTx == sender, "Caller not the sender");
        uint256 usersTier = whitelist[senderOfTx];
        require(usersTier > 0, "the user is not whitelisted");
        require(usersTier < 4, "the user is not whitelisted");
        _;
    }

    event supplyChanged(address indexed, uint256 indexed);
    event Transfer(address recipient, uint256 amount);
    event PaymentUpdated(
        address admin,
        uint256 ID,
        uint256 amount,
        string recipient
    );
    event WhiteListTransfer(address indexed);

    constructor(address[] memory _admins, uint256 _totalSupply) {
        contractOwner = msg.sender;
        totalSupply = _totalSupply;

        for (uint256 ii = 0; ii < administrators.length; ii++) {
            if (_admins[ii] != address(0)) {
                administrators[ii] = _admins[ii];
                if (_admins[ii] == contractOwner) {
                    balances[contractOwner] = totalSupply;
                } else {
                    balances[_admins[ii]] = 0;
                }
                if (_admins[ii] == contractOwner) {
                    emit supplyChanged(_admins[ii], totalSupply);
                } else if (_admins[ii] != contractOwner) {
                    emit supplyChanged(_admins[ii], 0);
                }
            }
        }
    }

    function getPaymentHistory() public view returns (History[] memory paymentHistory_) {
        return paymentHistory;
    }

    function checkForAdmin(address _user) public view returns (bool admin_) {
        bool admin = false;
        for (uint256 ii = 0; ii < administrators.length; ii++) {
            if (administrators[ii] == _user) {
                admin = true;
            }
        }
        return admin;
    }

    function balanceOf(address _user) public view returns (uint256 ) {
        return balances[_user];
    }

    function getTradingMode() public pure returns (bool mode_) {
        return true;
    }

    function addHistory(address _updateAddress, bool _tradeMode) public returns (bool status_, bool tradeMode_) {
        History memory history;
        history.blockNumber = block.number;
        history.lastUpdate = block.timestamp;
        history.updatedBy = _updateAddress;
        paymentHistory.push(history);
        
        return (true, _tradeMode);
    }

    function getPayments(address _user) public view returns (Payment[] memory payments_) {
        require(_user != address(0), "User is not valid");
        return payments[_user];
    }

    function transfer(
        address _recipient,
        uint256 _amount,
        string calldata _name
    ) public returns (bool status_) {
        address senderOfTx = msg.sender;
        require(balances[senderOfTx] >= _amount, "Sender has insufficient Balance");
        require(bytes(_name).length < 9, "Max address length is 8 chars");
        balances[senderOfTx] -= _amount;
        balances[_recipient] += _amount;
        emit Transfer(_recipient, _amount);
        Payment memory payment;
        payment.admin = address(0);
        payment.adminUpdated = false;
        payment.paymentType = PaymentType.BasicPayment;
        payment.recipient = _recipient;
        payment.amount = _amount;
        payment.recipientName = _name;
        payment.paymentID = ++paymentCounter;
        payments[senderOfTx].push(payment);
        
        return true;
    }

    function updatePayment(
        address _user,
        uint256 _ID,
        uint256 _amount,
        PaymentType _type
    ) public onlyAdminOrOwner {
        require(_ID > 0, "ID must be greater than 0");
        require(_amount > 0, "Amount must be greater than 0");
        require(_user != address(0), "Administrator must have a valid non zero address");

        address senderOfTx = msg.sender;

        for (uint256 ii = 0; ii < payments[_user].length; ii++) {
            if (payments[_user][ii].paymentID == _ID) {
                payments[_user][ii].adminUpdated = true;
                payments[_user][ii].admin = _user;
                payments[_user][ii].paymentType = _type;
                payments[_user][ii].amount = _amount;
                bool tradingMode = getTradingMode();
                addHistory(_user, tradingMode);
                emit PaymentUpdated(senderOfTx, _ID, _amount, payments[_user][ii].recipientName);
            }
        }
    }

    function addToWhitelist(address _userAddrs, uint256 _tier) public onlyAdminOrOwner {
        require(_tier < 255, "tier level must < 255");
        whitelist[_userAddrs] = _tier;
        if (_tier > 3) {
            whitelist[_userAddrs] -= _tier;
            whitelist[_userAddrs] = 3;
        } else if (_tier == 1) {
            whitelist[_userAddrs] -= _tier;
            whitelist[_userAddrs] = 1;
        } else if (_tier > 0 && _tier < 3) {
            whitelist[_userAddrs] -= _tier;
            whitelist[_userAddrs] = 2;
        }
        
        emit AddedToWhitelist(_userAddrs, _tier);
    }

    function whiteTransfer(
        address _recipient,
        uint256 _amount,
        ImportantStruct memory _struct
    ) public checkIfWhiteListed(msg.sender) {
        address senderOfTx = msg.sender;
        require(balances[senderOfTx] >= _amount, "Sender has insufficient Balance");
        require(_amount > 3, "Amount must be bigger than 3");
        balances[senderOfTx] -= _amount;
        balances[_recipient] += _amount;
        balances[senderOfTx] += whitelist[senderOfTx];
        balances[_recipient] -= whitelist[senderOfTx];

        whiteListStruct[senderOfTx] = ImportantStruct(0, 0, 0);
        ImportantStruct storage newImportantStruct = whiteListStruct[senderOfTx];
        newImportantStruct.valueA = _struct.valueA;
        newImportantStruct.bigValue = _struct.bigValue;
        newImportantStruct.valueB = _struct.valueB;
        emit WhiteListTransfer(_recipient);
    }
}
