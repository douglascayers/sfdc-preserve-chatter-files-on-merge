/**
 * In merge operation of Accounts, Contacts, or Leads,
 * designed to move Salesforce Files from the merged (deleted)
 * records into the master (preserved) records.
 *
 * Inspired by Gorav Seth, https://success.salesforce.com/0D53A00002uKsks
 *
 * Developed by Doug Ayers, douglascayers.com
 */
public with sharing class SObjectFileMergeTriggerHandler {

    // static variable preserves values across all trigger events
    // for a given transaction, resets per each transaction context
    // map key = sobject id
    // map values = related content documents
    private static Map<ID, List<ContentDocumentLink>> contentDocumentLinksMap = new Map<ID, List<ContentDocumentLink>>();

    /**
     * Rather than repeat these same lines of code in each
     * trigger for Accounts, Contacts, and Leads, this lets
     * those triggers essentially be one-liners to this method.
     */
    public void handleMerge() {

        if ( Trigger.isBefore ) {

            if ( Trigger.isDelete ) {

                handleBeforeDelete( Trigger.old );

            }

        } else if ( Trigger.isAfter ) {

            if ( Trigger.isDelete ) {

                handleAfterDelete( Trigger.old );

            }

        }

    }

    /**
     * Remember all the content document links for the records being deleted
     * in the event that the records are being deleted due to merge event.
     * If the records are being merged then we will see the 'masterRecordId'
     * field populated on the records in the 'after delete' method.
     *
     * We must query and remember the related records because those links
     * will be severed after the 'before delete' event and thus the files
     * will be orphaned (or left related to any other records, just not these).
     */
    public void handleBeforeDelete( List<SObject> records ) {

        System.debug( 'handle before delete ' );

        Set<ID> recordIds = new Set<ID>();
        for ( SObject record : records ) {
            recordIds.add( record.id );
        }

        // build map of all content document links for each record being deleted
        // and cache them in the static class variable so that it is available
        // during the 'after delete' trigger event method
        for ( ContentDocumentLink cdl : [ SELECT id, linkedEntityId, contentDocumentId, shareType FROM ContentDocumentLink WHERE linkedEntityId IN :recordIds ] ) {

            List<ContentDocumentLink> cdls = contentDocumentLinksMap.get( cdl.linkedEntityId );
            if ( cdls == null ) {
                cdls = new List<ContentDocumentLink>();
            }
            cdls.add( cdl );

            contentDocumentLinksMap.put( cdl.linkedEntityId, cdls );

        }

        System.debug( contentDocumentLinksMap );

    }

    /**
     * Iterates over the deleted records and for any who have
     * related content document links in the cached map then builds
     * a new list of content document links to relate to the master records.
     */
    public void handleAfterDelete( List<SObject> records ) {

        System.debug( 'handle after delete ' );

        System.debug( contentDocumentLinksMap );

        List<ContentDocumentLink> contentDocumentLinksToInsert = new List<ContentDocumentLink>();

        for ( SObject record : records ) {

            String masterRecordId = String.valueOf( record.get( 'masterRecordId' ) );

            // was record deleted because it was merged into another?
            if ( String.isNotBlank( masterRecordId ) ) {

                // share deleted record's content documents with master record
                List<ContentDocumentLink> cdls = contentDocumentLinksMap.get( record.id );

                if ( cdls != null ) {

                    for ( ContentDocumentLink cdl : cdls ) {

                        contentDocumentLinksToInsert.add( new ContentDocumentLink(
                            linkedEntityId = masterRecordId,
                            contentDocumentId = cdl.contentDocumentId,
                            shareType = cdl.shareType
                        ));

                    }

                }

            }

        }

        if ( contentDocumentLinksToInsert.size() > 0 ) {
            insert contentDocumentLinksToInsert;
        }

    }

}