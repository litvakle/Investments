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

> Given the user adding a new transaction
When he saves it
He sees the transaction in a stored transactions

> Given the user adding a new transaction
When he cancels it
He doesn't see the transaction in a stored transactions

> Given the user adding a new transaction
When he specify transaction type, currency, ticket, quantity, price, sum
He is able to save a transaction

> Given the user adding a new transaction
When he tap 'Save' until all needed fields are filled
He sees an error message

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

### Save Transaction

Data:
- Date
- Type
- Currency
- Quantity
- Price
- Sum

Primary course (happy path)
1. Execute "SaveTransaction" command with above Data
2. System encodes Transaction to a stored
3. System saves transaction in a storage
4. System delivers successful result

Storage saving error (sad path)
1. System delivers saving error

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
