# Preserve Chatter Files on Account, Contact, or Lead Merge

Simple Account, Contact, and Lead triggers that move Chatter Files to master record upon being merged.

<a href="https://githubsfdeploy.herokuapp.com">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png">
</a>

As of this writing, Salesforce does not preserve Chatter or related Files during merge operation. The Files are left orphaned.

Inspired by [Gorav Seth](https://twitter.com/goravseth)'s realization of this on [Success Community](https://success.salesforce.com/0D53A00002uKsks),
I developed these simple triggers to demonstrate how to preserve and carry over the [Chatter Files](https://developer.salesforce.com/docs/atlas.en-us.api.meta/api/sforce_api_objects_contentdocument.htm) to the master record post-merge.

# Usage

Deploy the triggers as-is, or integrate them into your own Apex trigger framework, to simply call the `SObjectFileMergeTriggerHandler` class
for both the `before delete` and `after delete` trigger events.

    trigger AccountMergeTrigger on Account ( before delete, after delete ) {
        new SObjectFileMergeTriggerHandler().handleMerge();
    }

Technically, you can call the code for all events and the handler knows what to do, but minimally both the before/after delete events must be included.

# Notice

Note, this only supports Accounts, Contacts, and Leads. Or more specifically, any SObject that has `MasterRecordId` field
that designates the surviving record in a merge operation.
