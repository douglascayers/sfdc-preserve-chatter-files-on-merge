/**
 * Inspired by Gorav Seth, https://success.salesforce.com/0D53A00002uKsks
 *
 * Developed by Doug Ayers, douglascayers.com
 */
@isTest
private class SObjectFileMergeTriggerHandlerTest {

    @isTest
    static void test_merge_accounts_trigger_enabled() {

        Preserve_Files_On_Merge_Settings__c settings = Preserve_Files_On_Merge_Settings__c.getInstance();
        settings.Enable_Account_Trigger__c = true;
        upsert settings;

        Account acct1 = new Account(
            name = 'Account 1'
        );

        Account acct2 = new Account(
            name = 'Account 2'
        );

        insert new List<Account>{ acct1, acct2 };

        ContentVersion cv = new ContentVersion(
            versionData = Blob.valueOf( 'Hello World' ),
            title = 'Message',
            pathOnClient = '/'
        );

        insert cv;

        cv = [ SELECT id, contentDocumentId FROM ContentVersion WHERE id = :cv.id ];

        ContentDocumentLink cdl = new ContentDocumentLink(
            linkedEntityId = acct2.id,
            contentDocumentId = cv.contentDocumentId,
            shareType = 'V'
        );

        insert cdl;

        Test.startTest();

        Database.merge( acct1, acct2 );

        Test.stopTest();

        System.assertEquals( 1, [ SELECT count() FROM ContentDocumentLink WHERE linkedEntityId = :acct1.id ] );

    }

    @isTest
    static void test_merge_accounts_trigger_disabled() {

        Preserve_Files_On_Merge_Settings__c settings = Preserve_Files_On_Merge_Settings__c.getInstance();
        settings.Enable_Account_Trigger__c = false;
        upsert settings;

        Account acct1 = new Account(
            name = 'Account 1'
        );

        Account acct2 = new Account(
            name = 'Account 2'
        );

        insert new List<Account>{ acct1, acct2 };

        ContentVersion cv = new ContentVersion(
            versionData = Blob.valueOf( 'Hello World' ),
            title = 'Message',
            pathOnClient = '/'
        );

        insert cv;

        cv = [ SELECT id, contentDocumentId FROM ContentVersion WHERE id = :cv.id ];

        ContentDocumentLink cdl = new ContentDocumentLink(
            linkedEntityId = acct2.id,
            contentDocumentId = cv.contentDocumentId,
            shareType = 'V'
        );

        insert cdl;

        Test.startTest();

        Database.merge( acct1, acct2 );

        Test.stopTest();

        System.assertEquals( 0, [ SELECT count() FROM ContentDocumentLink WHERE linkedEntityId = :acct1.id ] );

    }

    @isTest
    static void test_merge_contacts_trigger_enabled() {

        Preserve_Files_On_Merge_Settings__c settings = Preserve_Files_On_Merge_Settings__c.getInstance();
        settings.Enable_Contact_Trigger__c = true;
        upsert settings;

        Contact cont1 = new Contact(
            firstName = 'Contact 1',
            lastName = 'Test'
        );

        Contact cont2 = new Contact(
            firstName = 'Contact 2',
            lastName = 'Test'
        );

        insert new List<Contact>{ cont1, cont2 };

        ContentVersion cv = new ContentVersion(
            versionData = Blob.valueOf( 'Hello World' ),
            title = 'Message',
            pathOnClient = '/'
        );

        insert cv;

        cv = [ SELECT id, contentDocumentId FROM ContentVersion WHERE id = :cv.id ];

        ContentDocumentLink cdl = new ContentDocumentLink(
            linkedEntityId = cont2.id,
            contentDocumentId = cv.contentDocumentId,
            shareType = 'V'
        );

        insert cdl;

        Test.startTest();

        Database.merge( cont1, cont2 );

        Test.stopTest();

        System.assertEquals( 1, [ SELECT count() FROM ContentDocumentLink WHERE linkedEntityId = :cont1.id ] );

    }

    @isTest
    static void test_merge_contacts_trigger_disabled() {

        Preserve_Files_On_Merge_Settings__c settings = Preserve_Files_On_Merge_Settings__c.getInstance();
        settings.Enable_Contact_Trigger__c = false;
        upsert settings;

        Contact cont1 = new Contact(
            firstName = 'Contact 1',
            lastName = 'Test'
        );

        Contact cont2 = new Contact(
            firstName = 'Contact 2',
            lastName = 'Test'
        );

        insert new List<Contact>{ cont1, cont2 };

        ContentVersion cv = new ContentVersion(
            versionData = Blob.valueOf( 'Hello World' ),
            title = 'Message',
            pathOnClient = '/'
        );

        insert cv;

        cv = [ SELECT id, contentDocumentId FROM ContentVersion WHERE id = :cv.id ];

        ContentDocumentLink cdl = new ContentDocumentLink(
            linkedEntityId = cont2.id,
            contentDocumentId = cv.contentDocumentId,
            shareType = 'V'
        );

        insert cdl;

        Test.startTest();

        Database.merge( cont1, cont2 );

        Test.stopTest();

        System.assertEquals( 0, [ SELECT count() FROM ContentDocumentLink WHERE linkedEntityId = :cont1.id ] );

    }

    @isTest
    static void test_merge_leads_trigger_enabled() {

        Preserve_Files_On_Merge_Settings__c settings = Preserve_Files_On_Merge_Settings__c.getInstance();
        settings.Enable_Lead_Trigger__c = true;
        upsert settings;

        Lead ld1 = new Lead(
            firstName = 'Lead 1',
            lastName = 'Test',
            company = 'Acme'
        );

        Lead ld2 = new Lead(
            firstName = 'Lead 2',
            lastName = 'Test',
            company = 'Acme'
        );

        insert new List<Lead>{ ld1, ld2 };

        ContentVersion cv = new ContentVersion(
            versionData = Blob.valueOf( 'Hello World' ),
            title = 'Message',
            pathOnClient = '/'
        );

        insert cv;

        cv = [ SELECT id, contentDocumentId FROM ContentVersion WHERE id = :cv.id ];

        ContentDocumentLink cdl = new ContentDocumentLink(
            linkedEntityId = ld2.id,
            contentDocumentId = cv.contentDocumentId,
            shareType = 'V'
        );

        insert cdl;

        Test.startTest();

        Database.merge( ld1, ld2 );

        Test.stopTest();

        System.assertEquals( 1, [ SELECT count() FROM ContentDocumentLink WHERE linkedEntityId = :ld1.id ] );

    }

    @isTest
    static void test_merge_leads_trigger_disabled() {

        Preserve_Files_On_Merge_Settings__c settings = Preserve_Files_On_Merge_Settings__c.getInstance();
        settings.Enable_Lead_Trigger__c = false;
        upsert settings;

        Lead ld1 = new Lead(
            firstName = 'Lead 1',
            lastName = 'Test',
            company = 'Acme'
        );

        Lead ld2 = new Lead(
            firstName = 'Lead 2',
            lastName = 'Test',
            company = 'Acme'
        );

        insert new List<Lead>{ ld1, ld2 };

        ContentVersion cv = new ContentVersion(
            versionData = Blob.valueOf( 'Hello World' ),
            title = 'Message',
            pathOnClient = '/'
        );

        insert cv;

        cv = [ SELECT id, contentDocumentId FROM ContentVersion WHERE id = :cv.id ];

        ContentDocumentLink cdl = new ContentDocumentLink(
            linkedEntityId = ld2.id,
            contentDocumentId = cv.contentDocumentId,
            shareType = 'V'
        );

        insert cdl;

        Test.startTest();

        Database.merge( ld1, ld2 );

        Test.stopTest();

        System.assertEquals( 0, [ SELECT count() FROM ContentDocumentLink WHERE linkedEntityId = :ld1.id ] );

    }

}