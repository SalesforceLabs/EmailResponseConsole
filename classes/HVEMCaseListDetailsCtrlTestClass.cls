/*
Copyright (c) 2012, salesforce.com, Inc.
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, 
are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice, 
    this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright notice, 
    this list of conditions and the following disclaimer in the documentation 
    and/or other materials provided with the distribution.
    * Neither the name of the salesforce.com, Inc. nor the names of its contributors 
    may be used to endorse or promote products derived from this software 
    without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. 
IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, 
INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, 
BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF 
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE 
OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED 
OF THE POSSIBILITY OF SUCH DAMAGE.

*/

@isTest
public class HVEMCaseListDetailsCtrlTestClass{
    static HVEMCaseListDetailsCtrl HVEMCaseListDetailsCtrlObj;
    static Case caseObj;
    static Case caseObjNew;
    static User userObj;
    static GroupMember grpMemberObj;
    static Group grpObj;
    static GroupMember grpMemberObjNew;
    static Group grpObjNewInit;
    static Group grpObjNew;
    static DraftEmailMessage__c demObj;
    static boolean isDrafts;
    static List<case> loggedInUserCaseList;
    static List<DraftEmailMessage__c> draftsEmailList;
    static List<Case> casesInQueueList;
    static Case selectedCase;
    static Id caseId;
    static EmailMessage EmailMessageObj;
    static HVEM_Config_Options__c configoptions;
      
    public HVEMCaseListDetailsCtrlTestClass(){
       HVEMCaseListDetailsCtrlObj.queueId = userInfo.getUserId();
    }
    static void setupDataInit(){
        HVEMCaseListDetailsCtrlObj = new HVEMCaseListDetailsCtrl(); 
        HVEMCaseListDetailsCtrlObj.draftsEmailList = new List< DraftEmailMessage__c>();
        HVEMCaseListDetailsCtrlObj.queueId = '' + userInfo.getUserId();
        HVEMCaseListDetailsCtrlObj.queuePageId = '' + userInfo.getUserId();
        userObj = [SELECT Id, Name FROM USER WHERE Id=:userInfo.getUserId()];
        caseObj = new Case(status='New',Origin='Phone');
        insert caseObj;
       
        demObj = new DraftEmailMessage__c();
        
        System.runAs(userObj){
            grpObj = new Group(Name='TestGroup', Type='Queue');
            insert grpObj;
            grpMemberObj = new GroupMember(UserOrGroupId=userObj.Id,GroupId=grpObj.Id);
            insert grpMemberObj;
        }
        
       HVEMCaseListDetailsCtrlObj.caseId = caseObj.Id;
       
        selectedCase = new Case(Subject ='abcd');
        insert selectedCase;
        caseId = selectedCase.Id; 
       
      
      
      }
    
    static void setupDataRefreshCaseQueueList(){
        HVEMCaseListDetailsCtrlObj = new HVEMCaseListDetailsCtrl(); 
        HVEMCaseListDetailsCtrlObj.queueId = '' + userInfo.getUserId();
        HVEMCaseListDetailsCtrlObj.refreshListParam = 'fromRefresh';
        userObj = [SELECT Id, Name FROM USER WHERE Id=:userInfo.getUserId()];        
        grpObjNewInit = new Group(Name='TestGroupNewInit', Type='Queue');
        insert grpObjNewInit;
        if(HVEM_Config_Options__c.getInstance('HVEM') == null){
            HVEMCaseListDetailsCtrlObj.configoptions = new HVEM_Config_Options__c(name='HVEM', Allow_Draft_Approval__c = true);
            insert HVEMCaseListDetailsCtrlObj.configoptions;
        }                        
        
        System.runAs(userObj){
            grpObj = new Group(Name='TestGroup', Type='Queue');
            insert grpObj;
            grpObjNew = new Group(Name='TestGroupNew', Type='Queue');
            insert grpObjNew;
            grpMemberObj = new GroupMember(UserOrGroupId=userObj.Id,GroupId=grpObj.Id);
            insert grpMemberObj;
            grpMemberObjNew = new GroupMember(UserOrGroupId=userObj.Id,GroupId=grpObjNew.Id);
            insert grpMemberObjNew;
            QueueSobject queueSObjectInstance = new QueueSobject(QueueId = grpObjNew.id, SobjectType = 'Case');
            insert queueSObjectInstance;
            caseObj = new Case(status='New',Origin='Phone', ownerId = grpObjNew.id);
            insert caseObj;
        }
        DraftEmailMessage__c DEMInstance = new DraftEmailMessage__c(case__c = caseObj.id,status__c = 'approval',ToAddress__c='test@hvem.com',EmailTemplate_Type__c='None',HtmlBody__c='');                                                                                  
        insert DEMInstance;
        EmailMessage emailInstance = new EmailMessage(parentId=caseObj.id,status='3');
        insert emailInstance;
        
    }
    
    static testmethod void testRefreshCaseQueueList(){
        setupDataRefreshCaseQueueList();
        ApexPages.currentPage().getParameters().put('Id',caseObj.Id); 
        test.startTest();
        HVEMCaseListDetailsCtrlObj.refreshCaseQueueList();     
        System.assertEquals(true, HVEMCaseListDetailsCtrlObj.loggedUserInstance != null);
        /*List<Case> caseDeleteList = [select id from case];
        delete caseDeleteList; 
        HVEMCaseListDetailsCtrlObj.refreshCaseQueueList(); */
        test.stopTest(); 
       
    }
    
    static testmethod void testHVEMCaseListDetailsCtrlInit(){
        setupDataInit();
        ApexPages.currentPage().getParameters().put('Id',caseObj.Id); 
        test.startTest();
        HVEMCaseListDetailsCtrlObj = new HVEMCaseListDetailsCtrl();        
        test.stopTest();
        System.assertEquals(true, HVEMCaseListDetailsCtrlObj.loggedUserInstance != null);
    }
    
     static testmethod void testAssignCaseFromQueue(){
        setupDataInit();
        ApexPages.currentPage().getParameters().put('Id',caseObj.Id); 
        test.startTest();
        HVEMCaseListDetailsCtrlObj.assignCaseFromQueue();
        List<Case> caseList = [Select id from case where OwnerId = :userInfo.getUserId()];                
        System.assertEquals(true, caseList.size() > 0);
        List<Case> caseDeleteList = [select id from case];
        delete caseDeleteList;
        HVEMCaseListDetailsCtrlObj.assignCaseFromQueue();
        test.stopTest();
       
    }
    
    static testmethod void testStoreSelectedQueuePageId(){
        setupDataInit();
        ApexPages.currentPage().getParameters().put('Id',caseObj.Id); 
        test.startTest();
        HVEMCaseListDetailsCtrlObj.storeSelectedQueuePageId();
        test.stopTest();
        System.assertEquals(true, HVEMCaseListDetailsCtrlObj.queuePageId != null);
    }
    static testMethod void testdata()
    {    
       HVEMCaseListDetailsCtrlObj = new HVEMCaseListDetailsCtrl(); 
       HVEMCaseListDetailsCtrlObj.draftsEmailList = new List< DraftEmailMessage__c>();
       HVEMCaseListDetailsCtrlObj.loggedInUserCaseList= new List<case>();
       
       caseObj = new Case(status='Draft',Origin='Phone');
       insert caseObj;
       HVEMCaseListDetailsCtrlObj.loggedInUserCaseList.add(caseObj);
       demObj = new DraftEmailMessage__c(Status__c = 'Draft',Case__c = caseObj.id);
       insert demObj;
       HVEMCaseListDetailsCtrlObj.draftsEmailList.add(demObj);
       
       caseObj = new Case(status='Closed',Origin='Phone');
       insert caseObj;
      
      // HVEMCaseListDetailsCtrlObj.casesInQueueList=new List<Case>();
        List<String> fields = new List<String>(); 
        
        List<EmailMessage> latestEmailSentList = new List<EmailMessage>();
        EmailMessageObj = new EmailMessage();
    }
  
    static testMethod void testdraftsCaseListFunc()
    {
     setupDataInit();
     test.startTest();
     HVEMCaseListDetailsCtrlObj.draftsCaseListFunc();
     System.assertEquals(true, HVEMCaseListDetailsCtrlObj.loggedUserInstance != null);
      testdata();
     HVEMCaseListDetailsCtrlObj.draftsCaseListFunc();
     System.assertEquals(true,HVEMCaseListDetailsCtrlObj.loggedInUserCaseList.size()>0);
      System.assertEquals(true,HVEMCaseListDetailsCtrlObj.draftsEmailList.size()>0);
     System.assertEquals(true,demObj.Status__c=='Draft'); 
     test.stopTest();
    }
    static testMethod void testdraftsCaseList()
    {
     setupDataInit();
     test.startTest();
     HVEMCaseListDetailsCtrlObj.isDrafts=false;
     HVEMCaseListDetailsCtrlObj.draftsCaseListFunc();
     System.assertEquals(true, HVEMCaseListDetailsCtrlObj.loggedUserInstance != null);
     test.stopTest();
    }
  static testMethod void testcontroller()
    {
      testdata();
      test.startTest();
      HVEMCaseListDetailsCtrlObj = new HVEMCaseListDetailsCtrl();
      System.assertEquals(true, HVEMCaseListDetailsCtrlObj.loggedUserInstance != null);
      test.stopTest();
    }
    
 static testMethod void testOpenCaseDetailsPrimaryTab()
    {
     setupDataInit();
     test.startTest();
     System.assertEquals(true, HVEMCaseListDetailsCtrlObj.selectedCase!= null);
     HVEMCaseListDetailsCtrlObj.openCaseDetailsPrimaryTab();
     test.stopTest();
    }
    
   /* static testMethod void testRefreshCaseQueueList2()
    {
        setupDataInit();
        ApexPages.currentPage().getParameters().put('Id',caseObj.Id); 
      //latestEmailSentList =  new List<EmailMessage>();
        test.startTest();
        HVEMCaseListDetailsCtrlObj.refreshCaseQueueList();                
        test.stopTest(); 
       // System.assertEquals(true, HVEMCaseListDetailsCtrlObj.loggedUserInstance != null);
    }*/
    
   /* static testmethod void testAssignCaseFromQueueNegative(){
        testdata();
        ApexPages.currentPage().getParameters().put('Id',caseObj.Id); 
        test.startTest();
        HVEMCaseListDetailsCtrlObj.assignCaseFromQueue();
        test.stopTest();
       
    }
    */
}