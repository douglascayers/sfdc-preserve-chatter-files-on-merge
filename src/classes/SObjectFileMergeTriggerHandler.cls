/*
Author: Doug Ayers
Website: https://douglascayers.com
GitHub: https://github.com/DouglasCAyers/sfdc-preserve-chatter-files-on-merge
License: BSD 3-Clause License
*/
/**
 * In merge operation of Accounts, Contacts, or Leads,
 * designed to move Salesforce Files from the merged (deleted)
 * records into the master (preserved) records.
 */
public with sharing class SObjectFileMergeTriggerHandler {

    // static variable preserves values across all trigger events
    // for a given transaction, resets per each transaction context
    // map key = sobject id
    // map values = related content documents
    private static Map<ID, List<ContentDocumentLink>> contentDocumentLinksMap = new Map<ID, List<ContentDocumentLink>>();

    // -----------------------------------------------------

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

    // -----------------------------------------------------

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

        Set<ID> recordIds = new Set<ID>();
        for ( SObject record : records ) {
            recordIds.add( record.id );
        }

        // build map of all content document links for each record being deleted
        // and cache them in the static class variable so that it is available
        // during the 'after delete' trigger event method
        for ( List<ContentDocumentLink> cdls : [ SELECT id, linkedEntityId, contentDocumentId, shareType, visibility FROM ContentDocumentLink WHERE linkedEntityId IN :recordIds ] ) {
            for ( ContentDocumentLink cdl : cdls ) {
                addElementToListInMap( contentDocumentLinksMap, cdl.linkedEntityId, cdl );
            }
        }

    }

    // -----------------------------------------------------

    /**
     * Iterates over the deleted records and for any who have
     * related content document links in the cached map then builds
     * a new list of content document links to relate to the master records.
     */
    public void handleAfterDelete( List<SObject> records ) {

        Set<ID> masterRecordIds = new Set<ID>();

        for ( SObject record : records ) {

            String masterRecordId = String.valueOf( record.get( 'masterRecordId' ) );

            // was record deleted because it was merged into another?
            if ( String.isNotBlank( masterRecordId ) ) {
                masterRecordIds.add( masterRecordId );
            }

        }

        // map of master record ids and which document ids have already been shared to them
        // so that we can avoid re-sharing documents to same entity again (will cause error if we did)
        Map<ID, Set<ID>> masterContentDocumentLinksMap = new Map<ID, Set<ID>>();

        for ( List<ContentDocumentLink> cdls : [ SELECT id, linkedEntityId, contentDocumentId, shareType, visibility, isDeleted FROM ContentDocumentLink WHERE linkedEntityId IN :masterRecordIds ] ) {
            for ( ContentDocumentLink cdl : cdls ) {
                addElementToSetInMap( masterContentDocumentLinksMap, cdl.linkedEntityId, cdl.contentDocumentId );
            }
        }

        List<ContentDocumentLink> contentDocumentLinksToInsert = new List<ContentDocumentLink>();

        for ( SObject record : records ) {

            String masterRecordId = String.valueOf( record.get( 'masterRecordId' ) );

            // was record deleted because it was merged into another?
            if ( String.isNotBlank( masterRecordId ) ) {

                // share deleted record's content documents with master record
                List<ContentDocumentLink> cdls = contentDocumentLinksMap.get( record.id );

                if ( cdls != null ) {

                    for ( ContentDocumentLink cdl : cdls ) {

                        Set<ID> alreadySharedDocumentIds = masterContentDocumentLinksMap.get( masterRecordId );

                        if ( alreadySharedDocumentIds == null || !alreadySharedDocumentIds.contains( cdl.contentDocumentId ) ) {

                            contentDocumentLinksToInsert.add( new ContentDocumentLink(
                                linkedEntityId = masterRecordId,
                                contentDocumentId = cdl.contentDocumentId,
                                shareType = cdl.shareType,
                                visibility = cdl.visibility
                            ));

                        }

                    }

                }

            }

        }

        if ( contentDocumentLinksToInsert.size() > 0 ) {
            insert contentDocumentLinksToInsert;
        }

    }

    // -----------------------------------------------------

    /**
     * Convenience method for the idiom of adding elements to a list in a map.
     */
    private static void addElementToListInMap( Map<ID, List<ContentDocumentLink>> someMap, ID someKey, ContentDocumentLink someValue ) {

        List<ContentDocumentLink> someList = someMap.get( someKey );

        if ( someList == null ) {
            someList = new List<ContentDocumentLink>();
        }

        someList.add( someValue );

        someMap.put( someKey, someList );

    }

    /**
     * Convenience method for the idiom of adding elements to a set in a map.
     */
    private static void addElementToSetInMap( Map<ID, Set<ID>> someMap, ID someKey, ID someValue ) {

        Set<ID> someList = someMap.get( someKey );

        if ( someList == null ) {
            someList = new Set<ID>();
        }

        someList.add( someValue );

        someMap.put( someKey, someList );

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