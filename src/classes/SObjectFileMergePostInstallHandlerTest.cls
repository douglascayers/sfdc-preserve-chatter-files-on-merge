/**
 * Developed by Doug Ayers (douglascayers.com)
 */
@isTest
private class SObjectFileMergePostInstallHandlerTest {

    @isTest
    static void test_new_install() {

        Test.startTest();

        Test.testInstall( new SObjectFileMergePostInstallHandler(), null );

        Test.stopTest();

        Preserve_Files_On_Merge_Settings__c settings = Preserve_Files_On_Merge_Settings__c.getOrgDefaults();

        System.assert( String.isNotBlank( settings.id ), 'id should not be blank' );
        System.assertEquals( true, settings.Enable_Account_Trigger__c );
        System.assertEquals( true, settings.Enable_Contact_Trigger__c );
        System.assertEquals( true, settings.Enable_Lead_Trigger__c );

    }

    @isTest
    static void test_upgrade() {

        Preserve_Files_On_Merge_Settings__c preSettings = Preserve_Files_On_Merge_Settings__c.getOrgDefaults();
        preSettings.Enable_Account_Trigger__c = false;
        preSettings.Enable_Contact_Trigger__c = false;
        preSettings.Enable_Lead_Trigger__c = false;

        upsert preSettings;

        Test.startTest();

        Test.testInstall( new SObjectFileMergePostInstallHandler(), new Version( 1, 0 ) );

        Test.stopTest();

        Preserve_Files_On_Merge_Settings__c postSettings = Preserve_Files_On_Merge_Settings__c.getOrgDefaults();

        System.assertEquals( preSettings.id, postSettings.id );
        System.assertEquals( preSettings.Enable_Account_Trigger__c, postSettings.Enable_Account_Trigger__c );
        System.assertEquals( preSettings.Enable_Contact_Trigger__c, postSettings.Enable_Contact_Trigger__c );
        System.assertEquals( preSettings.Enable_Lead_Trigger__c, postSettings.Enable_Lead_Trigger__c );

    }

}