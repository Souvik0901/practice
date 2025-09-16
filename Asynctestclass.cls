public class UpdateAccountQueueable implements Queueable {

    public void execute(QueueableContext context) {
        List<Account> accounts = [SELECT Id, Name FROM Account WHERE Name = 'Test Account'];
        for(Account acc : accounts) {
            acc.Name = 'Updated Account';
        }
        update accounts;
    }
}


----------------------------------------------------------------

@isTest
public class UpdateAccountQueueableTest {

    @isTest
    static void testQueueable() {

        // Arrange
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        // Act
        Test.startTest();
        System.enqueueJob(new UpdateAccountQueueable());
        Test.stopTest();  // The Queueable runs synchronously here

        // Assert
        Account updatedAcc = [SELECT Id, Name FROM Account WHERE Id = :acc.Id];
        System.assertEquals('Updated Account', updatedAcc.Name, 'Account name should be updated');
    }
}

------------------------------------------------------------------

Salesforce has provided a framework to force asynchronous code to execute synchronously for testing: We enclose our test code between Test.startTest() and Test.stopTest().

When stopTest() is executed, these collected asynchronous processes are then run synchronously and complete before control returns to our code. Hence
for Asynchronous Apex, put all your asserts after the Test.stopTest() method.



