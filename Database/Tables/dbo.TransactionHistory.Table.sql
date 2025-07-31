/****
  Holds a history of the users financial transactions.
  
  History:
    - Added Column RecordedDTTM to track when the record was added to the table.
****/

IF NOT EXISTS ( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'TransactionHistory' )
BEGIN
CREATE TABLE dbo.TransactionHistory
(
     AccountId       INT          NOT NULL 
	,Debit           MONEY            NULL
	,Credit          MONEY            NULL
	,TransactionDTTM DATETIME2(0) NOT NULL
    ,RecordedDTTM    DATETIME2(0) NOT NULL
	,FOREIGN KEY ( AccountId) 
	 REFERENCES dbo.Account
);
END
GO
