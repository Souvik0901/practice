// 25. Test Restricted User permissions by using System.runAs() that helps to impersonate as other users
// 26. System.runAs() is required for each testmethod as per PMD Rules

// 22. For bulk record insertion, create separate methods in TestHelper itself with no of records to create as a parameter – It will help
reducing complexity of test setup methods in the test classes for bulk record testing against trigger, batch etc.

// 23. Perform Unit Test for the classes
➢ Test each conditional branch (including ternary operators)
➢ Test Positive Scenarios for every expected permutation
➢ Test Negative Scenarios(Ex:- negative amount or future date limitation)
➢ Test the boundary conditions
➢ Test Valid and Invalid method inputs
➢ Test with Single Record
➢ Test with Bulk Records : - Test Triggers, Invocable Methods, Batches, Dag Jobs with 200 records. Other Bulkified methods can
be tested with at least 20 records.
➢ Test Exception blocks - In order to cover the catch block, try to create scenario in test class which will lead to exception in actual
class.
➢ Each Test method should have a proper assert to validate the exact return value.
➢ Write comments for each test method stating not only what is supposed to be tested, but the assumptions the tester made about
the data, the expected outcome, and so on.
➢ The example in next slide shows the possible test cases to cover all the scenarios. Though without testInvalidInput testmethod the
test coverage was 100%, but we should still add this test to validate input parameters.


1.Do not insert records in the TestHelper methods, just return the instance and do the DML inside setup method of test class. It
helps creating records in bulk using the same helper method inside for loop and insert the records together in a list.
2.Test method should be static and have void return type.
3.(seeAllData = true) might be required for classes fetching Reports & Dashboards. It is acceptable only in such cases.
