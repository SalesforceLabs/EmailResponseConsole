Email Response Console for the Service Cloud
============================================

Introduction
------------
Email Response Console for Salesforce Service Cloud - or ERC – is a console tailored for agents that are focused primarily on email. The ERC can greatly improve agent productivity if...

- Your agents primarily respond to email
- The majority of your cases are “one and done”
- Salesforce Knowledge is a key resource for your email cases


The ERC is a collection of custom components for the Service Cloud Console tightly integrated with Salesforce Knowledge. With the ERC, agents can respond to emails leveraging Salesforce Knowledge on just one screen. This increases the productivity of your email focused Agents and improves call deflection by quickly getting the right knowledge article to your customers.


License
-------
ERC is published by Force.com Labs and is Copyright (c) 2011 Salesforce.com, Inc.

The app is available via the BSD license.  Contributions welcome. Contact labs at salesforce dot com or submit a pull request for details.

Note: significant contributions may require a [Contributor License Agreement](http://blogs.developerforce.com/labs/files/2011/08/Salesforce_OpenSource_Contributor_Agreement_20110610.pdf).  Don't worry: it's easy and painless.

*Source code will be available real soon!*


AppExchange Version
-------------------
ERC is available on the AppExchange both as a managed and an un-managed package.

- managed version: http://bit.ly/ERCmanaged
- unmanaged version: http://bit.ly/ERCunmanaged


Version History
---------------

*Version 3.5 - Not released yet*

- Updated the packaging with sample app, tab, layout, etc. for an easier trial type installation
- Added the support of pinned list view with detection of change of current tab
- Added keyboard shortcut support (navigate in the list of results, insert link/content)
- Added "Send Back To Queue" option for the user (can be disabled by the administrator)
- Removed the Case Feed support - experimental feature the is not stable enough and that introduced a dependency on Case Feed feature
- Move the case list view information message (on previous) down a bit
- Fix spacing issue in the case list view information message and make it black instead of red
- Fix the redundant feed items when an article is attached more than one time to the case
- Added a sample console footer component with KB navigation links
- Heavy refactoring of the KB component
- Removed redondant components HVEMCaseList...
- Reformatted the source code: tabs --> 4 spaces, cleaner indentation, etc.
- Increased the code coverage a bit
 
*Version 3 - AppExchange Release: 2012/07/19*

- Draft or rejected draft email icon in the case list view
- Better (more scalable) template navigation
- Fixed some missing static resource files
- Multiple reply-to addresses support (including a selection based on case attributes mapping)
- Ability to change case status without sending an email - aka "spam" management
- Support Knowledge with multi-lingual configuration
- Ability to optionally insert KB content (but no support for images yet) instead of links to articles
- better links to Knowledge articles with HTML emails
- [Experimental] optionally use the Case Feed email publisher instead of the ERC custom publisher

*Version 2 - AppExchange Release: 2012/04/02*

- Draft email support
- Email approval process support
- Various optimizations, enhancements and fixes

*Version 1*
Initial version, not published on the AppExchange
