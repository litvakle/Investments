# Investments

## BDD Specs

### Story: Transactions list

#### Narrative

>As a user of the App
>I want to store information about my transactions
>So I can see all my transactions in the App

##### Scenarios (acceptance criteria)

> Given the user with stored transactions
When the user enters 'Transactions'
He sees a list of stored transactions

> Given the user editing a stored transaction
When he saves it
He sees the transaction in a stored transactions

> Given the user removing a stored transaction
When he removes it
He doesn't see the transaction in a stored transactions

## Use cases

### Display Transactions

Data:
- Date interval

Primary course (happy path)
1. Execute "RetrieveTransactions" command with above Data
2. System encodes stored Transactions
3. System delivers successful result

Storage retrival error (sad path)
1. System delivers retrival error

### Delete Transaction

Data:
- Transaction (id)

Primary course (happy path)
1. Execute "DeleteTransaction" command with above Data
2. System encodes Transaction to a stored
3. System removes a stored transaction
4. System delivers successful result

Storage removal error (sad path)
1. System delivers removal error


### Story: Add new transaction

#### Narrative

>As a user of the App
>I want to ba able to add new transactions
>So I can store all new transactions in the app

##### Scenarios (acceptance criteria)

> Given the user adding a new transaction
When the user enters 'Quantity' and 'Price'
The system calculates 'Sum'

> Given the user adding a new transaction
When the user enters 'Sum'
The system calculates 'Price'

> Given the user adding a new transaction
When the user tap 'Save'
The system checks the correcthness of all fields

> Given the user adding a new transaction
When the user tap 'Save' and system validates all the fields
The system does not save transaction unitl all fields are correct

> Given the user adding a new transaction
When he saves it
He sees the transaction in a stored transactions

> Given the user adding a new transaction
When he cancels it
He doesn't see the transaction in a stored transactions

## Use cases

### Save Transaction

Data:
- Date
- Type
- Ticket
- Quantity
- Price
- Sum

Primary course (happy path)
1. Execute "SaveTransaction" command with above Data
2. System validates fields
- Ticket - 3 or 4 letters
- Quantity > 0
- Price > 0
- Sum > 0
3. System delivers successful result

Storage saving error (sad path)
1. System delivers error for each of velidating fields


### Story: Portfolio

#### Narrative

>As a user of the App
>I want to see summary information about my portfolio
>So I can simply understand what tickets I own and how much money I spent

##### Scenarios (acceptance criteria)

> Given the user with no transactions
When the user opens 'Portfolio'
He sees an empty view

> Given the user with stored transactions
When the user enters 'Portflio'
He sees a tickets list with total spent some for each ticket

## Use cases

### Display portfolio

Data:
- Date interval

Primary course (happy path)
1. Retrieve transactions from storage
2. Calculate total spent for each ticket
3. System delivers successful result

Storage retrival error (sad path)
1. System delivers retrival error
