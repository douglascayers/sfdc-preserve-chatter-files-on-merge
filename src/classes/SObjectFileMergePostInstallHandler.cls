/**
 * Developed by Doug Ayers (douglascayers.com)
 */
public with sharing class SObjectFileMergePostInstallHandler implements InstallHandler {

    public void onInstall( InstallContext context ) {

        try {

            Boolean isNew = ( context.previousVersion() == null );

            // for new installs then populate the custom setting
            if ( isNew ) {

                Preserve_Files_On_Merge_Settings__c settings = Preserve_Files_On_Merge_Settings__c.getOrgDefaults();

                if ( String.isBlank( settings.id ) ) {

                    settings.Enable_Account_Trigger__c = true;
                    settings.Enable_Contact_Trigger__c = true;
                    settings.Enable_Lead_Trigger__c = true;

                    insert settings;

                }

            }

        } catch ( Exception e ) {

            // not really interested in the error
            // this is just a convenience to pre-populate custom setting

        }

    }

}