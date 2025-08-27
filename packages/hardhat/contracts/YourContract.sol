// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract YourContract {
    address public immutable owner;

    // Basic state variables
    string public greeting = "Hello, Mandala Chain!";
    uint256 public counter = 0;
    bool public isActive = true;

    // Advanced state variables
    mapping(address => uint256) public userBalances;
    mapping(address => string) public userNames;
    mapping(uint256 => Task) public tasks;

    address[] public registeredUsers;
    uint256[] public completedTaskIds;

    uint256 public nextTaskId = 1;
    uint256 public totalRewards = 0;

    // Structs
    struct Task {
        uint256 id;
        string description;
        uint256 reward;
        address assignee;
        bool completed;
        uint256 createdAt;
    }

    struct UserProfile {
        string name;
        uint256 balance;
        uint256 tasksCompleted;
        bool isRegistered;
    }

    // Events
    event GreetingChanged(address indexed changer, string newGreeting);
    event UserRegistered(address indexed user, string name);
    event TaskCreated(uint256 indexed taskId, string description, uint256 reward);
    event TaskCompleted(uint256 indexed taskId, address indexed completer);
    event RewardClaimed(address indexed user, uint256 amount);
    event FundsDeposited(address indexed depositor, uint256 amount);

    // Modifiers
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    modifier onlyActive() {
        require(isActive, "Contract is not active");
        _;
    }

    modifier onlyRegistered() {
        require(bytes(userNames[msg.sender]).length > 0, "User not registered");
        _;
    }

    constructor(address _owner) {
        owner = _owner;
    }

    // READ FUNCTIONS

    function getGreeting() public view returns (string memory) {
        return greeting;
    }

    function getCounter() public view returns (uint256) {
        return counter;
    }

    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function getUserProfile(address user) public view returns (UserProfile memory) {
        return UserProfile({
            name: userNames[user],
            balance: userBalances[user],
            tasksCompleted: getCompletedTasksCount(user),
            isRegistered: bytes(userNames[user]).length > 0
        });
    }

    function getTask(uint256 taskId) public view returns (Task memory) {
        return tasks[taskId];
    }

    function getAllRegisteredUsers() public view returns (address[] memory) {
        return registeredUsers;
    }

    function getCompletedTasks() public view returns (uint256[] memory) {
        return completedTaskIds;
    }

    function getCompletedTasksCount(address user) public view returns (uint256) {
        uint256 count = 0;
        for (uint256 i = 0; i < completedTaskIds.length; i++) {
            if (tasks[completedTaskIds[i]].assignee == user) {
                count++;
            }
        }
        return count;
    }

    function isUserRegistered(address user) public view returns (bool) {
        return bytes(userNames[user]).length > 0;
    }

    function getActiveTasksCount() public view returns (uint256) {
        uint256 count = 0;
        for (uint256 i = 1; i < nextTaskId; i++) {
            if (!tasks[i].completed) {
                count++;
            }
        }
        return count;
    }

    // WRITE FUNCTIONS

    function setGreeting(string memory _newGreeting) public payable onlyActive {
        require(bytes(_newGreeting).length > 0, "Greeting cannot be empty");
        greeting = _newGreeting;
        counter++;

        // Optional: reward the caller with any sent value
        if (msg.value > 0) {
            userBalances[msg.sender] += msg.value;
        }

        emit GreetingChanged(msg.sender, _newGreeting);
    }

    function registerUser(string memory _name) public {
        require(bytes(_name).length > 0, "Name cannot be empty");
        require(!isUserRegistered(msg.sender), "User already registered");

        userNames[msg.sender] = _name;
        registeredUsers.push(msg.sender);

        emit UserRegistered(msg.sender, _name);
    }

    function createTask(string memory _description, uint256 _reward) public payable onlyRegistered {
        require(bytes(_description).length > 0, "Description cannot be empty");
        require(_reward > 0, "Reward must be greater than 0");
        require(msg.value >= _reward, "Must send enough value to cover reward");

        uint256 taskId = nextTaskId++;
        tasks[taskId] = Task({
            id: taskId,
            description: _description,
            reward: _reward,
            assignee: address(0),
            completed: false,
            createdAt: block.timestamp
        });

        totalRewards += _reward;

        emit TaskCreated(taskId, _description, _reward);
    }

    function assignTask(uint256 _taskId, address _assignee) public onlyOwner {
        require(_taskId < nextTaskId, "Task does not exist");
        require(!tasks[_taskId].completed, "Task already completed");
        require(isUserRegistered(_assignee), "Assignee not registered");

        tasks[_taskId].assignee = _assignee;
    }

    function completeTask(uint256 _taskId) public onlyRegistered {
        require(_taskId < nextTaskId, "Task does not exist");
        require(tasks[_taskId].assignee == msg.sender, "Not assigned to you");
        require(!tasks[_taskId].completed, "Task already completed");

        tasks[_taskId].completed = true;
        completedTaskIds.push(_taskId);

        // Reward the completer
        userBalances[msg.sender] += tasks[_taskId].reward;

        emit TaskCompleted(_taskId, msg.sender);
    }

    function claimReward() public onlyRegistered {
        uint256 balance = userBalances[msg.sender];
        require(balance > 0, "No rewards to claim");
        require(address(this).balance >= balance, "Contract insufficient balance");

        userBalances[msg.sender] = 0;
        payable(msg.sender).transfer(balance);

        emit RewardClaimed(msg.sender, balance);
    }

    function incrementCounter() public {
        counter++;
    }

    function resetCounter() public onlyOwner {
        counter = 0;
    }

    function toggleActive() public onlyOwner {
        isActive = !isActive;
    }

    function updateUserName(string memory _newName) public onlyRegistered {
        require(bytes(_newName).length > 0, "Name cannot be empty");
        userNames[msg.sender] = _newName;
    }

    function depositFunds() public payable {
        require(msg.value > 0, "Must send some value");
        emit FundsDeposited(msg.sender, msg.value);
    }

    // Emergency functions
    function emergencyWithdraw() public onlyOwner {
        payable(owner).transfer(address(this).balance);
    }

    function emergencyPause() public onlyOwner {
        isActive = false;
    }

    // Receive function to accept direct transfers
    receive() external payable {
        emit FundsDeposited(msg.sender, msg.value);
    }

    fallback() external payable {
        emit FundsDeposited(msg.sender, msg.value);
    }
}
