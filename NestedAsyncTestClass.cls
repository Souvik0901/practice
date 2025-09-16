public class UpdateAccountQueueableLevel2 implements Queueable {
    public void execute(QueueableContext context) {
        List<Account> accounts = [SELECT Id, Name FROM Account WHERE Name = 'Updated Account'];
        for(Account acc : accounts) {
            acc.Name = 'Final Updated Account';
        }
        update accounts;
    }
}

-----------------------------------------------------------------------
public class UpdateAccountQueueableLevel1 implements Queueable {
    public void execute(QueueableContext context) {
        List<Account> accounts = [SELECT Id, Name FROM Account WHERE Name = 'Test Account'];
        for(Account acc : accounts) {
            acc.Name = 'Updated Account';
        }
        update accounts;

        // Enqueue another async job
        System.enqueueJob(new UpdateAccountQueueableLevel2());
    }
}

-------------------------------------------------------------------------

@isTest
public class UpdateAccountQueueableNestedTest {
    @isTest
    static void testNestedQueueable() {
        // Arrange
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        // Act
        Test.startTest();
        System.enqueueJob(new UpdateAccountQueueableLevel1());
        Test.stopTest();  // Only the first Queueable runs synchronously here

        // Assert
        Account updatedAcc = [SELECT Id, Name FROM Account WHERE Id = :acc.Id];
        
        // This assertion will pass because Level 1 job ran synchronously
        System.assertEquals('Updated Account', updatedAcc.Name);

        // This assertion will fail because Level 2 job did not run synchronously in the test context
        System.assertNotEquals('Final Updated Account', updatedAcc.Name);
    }
}
-------------------------------------------------------------------------------

the collection and synchronous execution of Asynchronous Apex applies only
between Test.startTest() and Test.stopTest(). Any further asynchronous code that's enqueued by the asynchronous operations that are
executed at Test.stopTest() is not executed synchronously in the context of the unit test. The following example shows we cannot put
assert on the nested asynchronous code.
