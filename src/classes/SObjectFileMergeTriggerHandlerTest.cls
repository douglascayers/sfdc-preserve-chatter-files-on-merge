/*
Author: Doug Ayers
Website: https://douglascayers.com
GitHub: https://github.com/DouglasCAyers/sfdc-preserve-chatter-files-on-merge
License: BSD 3-Clause License
*/
@isTest
private class SObjectFileMergeTriggerHandlerTest {

    @isTest
    static void test_merge_accounts_document_already_shared() {

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

        ContentDocumentLink cdl1 = new ContentDocumentLink(
            linkedEntityId = acct1.id,
            contentDocumentId = cv.contentDocumentId,
            shareType = 'V'
        );

        ContentDocumentLink cdl2 = new ContentDocumentLink(
            linkedEntityId = acct2.id,
            contentDocumentId = cv.contentDocumentId,
            shareType = 'V'
        );

        insert new List<ContentDocumentLink>{ cdl1, cdl2 };

        Test.startTest();

        Database.merge( acct1, acct2 );

        Test.stopTest();

        System.assertEquals( 1, [ SELECT count() FROM ContentDocumentLink WHERE linkedEntityId = :acct1.id ] );

    }

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
/*
BSD 3-Clause License

Copyright (c) 2017, Doug Ayers
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

* Neither the name of the copyright holder nor the names of its
  contributors may be used to endorse or promote products derived from
  this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/