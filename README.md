Preserve Related Files on Account, Contact, or Lead Merge
=========================================================

Overview
--------

Simple Account, Contact, and Lead triggers that move related Files to master record upon being merged.

As of this writing, Salesforce does not preserve Chatter or related Files during merge operation. The Files are left orphaned.

Inspired by [Gorav Seth](https://twitter.com/goravseth)'s realization of this on [Success Community](https://success.salesforce.com/0D53A00002uKsks),
I developed these simple triggers to demonstrate how to preserve and carry over the [Salesforce Files](https://developer.salesforce.com/docs/atlas.en-us.api.meta/api/sforce_api_objects_contentdocument.htm) to the master record post-merge.

Related Ideas:
* [Re-associated Related Files on Merged Accounts](https://success.salesforce.com/ideaView?id=0873A000000E7LCQA0)


Packaged Release History
========================

Release 1.1 (latest)
-----------
* Install package
  * [Production URL](https://login.salesforce.com/packaging/installPackage.apexp?p0=04tf40000004kVq)
  * [Sandbox URL](https://test.salesforce.com/packaging/installPackage.apexp?p0=04tf40000004kVq)
* Initial managed package offering

Installing the Source Code (Developers)
---------------------------------------

You may install the unmanaged code from GitHub and make any desired adjustments. You are responsible for ensuring unit tests meet your org's validation rules and other requirements.

* [Deploy from Github](https://githubsfdeploy.herokuapp.com)


Integrating into Apex Trigger Framework
---------------------------------------

If you deploy the unmanaged code from GitHub rather than install as managed package, here is how you can integrate this logic into your own trigger design. Deploy the triggers as-is, or integrate them into your own Apex trigger framework, to simply call the `SObjectFileMergeTriggerHandler` class for both the `before delete` and `after delete` trigger events.

    trigger AccountMergeTrigger on Account ( before delete, after delete ) {
        new SObjectFileMergeTriggerHandler().handleMerge();
    }

Technically, you can call the code for all events and the handler knows what to do, but minimally both the before/after delete events must be included.


Notice
======

This only supports Accounts, Contacts, and Leads. Or more specifically, any SObject that has `MasterRecordId` field
that designates the surviving record in a merge operation.
