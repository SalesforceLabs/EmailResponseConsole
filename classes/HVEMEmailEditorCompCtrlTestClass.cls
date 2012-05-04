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
private class HVEMEmailEditorCompCtrlTestClass {            
    static HVEMEmailEditorCompCtrl emailEditor;
    static Contact contactInstance;
    static Case caseInstance;
    static Organization orgInstance;
    static EmailTemplate selectedEmailTemplate;
    static HVEM_Config_Options__c configOptions;
    static String emailBody;
    static DraftEmailMessage__c draftInstance;
    static String additionalTo;
    static List<EmailTemplate> emailTemplateList;
    static Organization orgIns;
    static Group testgrpId;
    public Id loggedUser; 
    public String selectedTemplate;
    public String caseStatus;
    public boolean changeCaseOwnerError;
    public boolean emailBodyLengthExceededError; 
    public List<String> additionalToList;
    static Contact contactInstance1;
    static List<GroupMember> loggedInUserQueueList;
    static String finalQueueId;
    public boolean includeThread;
    static List<EmailMessage> emailMessageList;
    static boolean isSuperUser;
    static String queueGroupId;  
    static GroupMember groupMemberObj;
    static Folder folderObj;
    static EmailTemplate emailTempTest;
    
    public static void setupDataInit() {        
        User u = [SELECT id,name FROM User WHERE id = :userInfo.getUserid()];
        u.HVEM_User__c = true;
        update u;
        contactInstance = new Contact(LastName='TestClass', Email = 'testclasses@persistent.co.i');
        insert contactInstance;
        caseInstance = new Case(status='New',Origin='Phone',contactId=contactInstance.id);
        insert caseInstance;
        EmailMessage emailmsg = new EmailMessage(ParentId=caseInstance.Id,HtmlBody ='This is HTML Body');
        insert emailmsg;
        selectedEmailTemplate = new EmailTemplate(FolderId = u.Id,TemplateType = 'text',DeveloperName = 'TestDeveloper',Name= 'Test name',Subject = 'Test Subject',Body = 'Hello This is test body',isActive=true);
        orgIns = new Organization();
        System.runAs(u){
            insert selectedEmailTemplate;
        }
        if(HVEM_Config_Options__c.getInstance('HVEM') == null){
            configOptions = new HVEM_Config_Options__c(name='HVEM',Default_Email_Template__c = selectedEmailTemplate.Id,Allow_Draft_Approval__c = false,Default_Email_Folder__c='None');
            insert configOptions;
        }
        else{
            configOptions = HVEM_Config_Options__c.getInstance('HVEM');
        }
        emailBody = 'Sample text for Email Body.';
        configOptions.Allow_Draft_Approval__c = true;
        ApexPages.currentPage().getParameters().put('Id',caseInstance.Id);
        ApexPages.currentPage().getParameters().put('isdtp','vw');
        emailEditor = new HVEMEmailEditorCompCtrl(); 

        emailTemplateList = new List<EmailTemplate>();
        emailEditor.emailTemplateList.add(selectedEmailTemplate); 

        Group testQueue = new Group(Name = 'Test Queue', Type = 'Queue');
        insert testQueue;

        testgrpId = new Group(Name = 'Test11', Type = 'Regular');
        insert testgrpId;

        draftInstance = new DraftEmailMessage__c(Status__c='Approval',BccAddress__c='abc@xyz.com',Case__c = caseInstance.Id,CcAddress__c='abc@xyz.com',TextBody__c ='aaa',TemplateId__c = selectedEmailTemplate.id );          
        insert draftInstance;

        List<DraftEmailMessage__c> currentDraft = new List<DraftEmailMessage__c>();
        currentDraft.add(draftInstance); 
        
        emailEditor.folders = configOptions.Default_Email_Folder__c; 
               
    }
    public static void setupData(){
        contactInstance = new Contact(LastName='TestClass', Email = 'testclasses@persistent.co.i');
        insert contactInstance;

        caseInstance = new Case(status='New',Origin='Phone',contactId=contactInstance.id);
        insert caseInstance;

        EmailMessage emailmsg = new EmailMessage(ParentId=caseInstance.Id,HtmlBody ='This is HTML Body');
        insert emailmsg;

        ApexPages.currentPage().getParameters().put('Id',caseInstance.Id);
        emailEditor = new HVEMEmailEditorCompCtrl();     

        draftInstance = new DraftEmailMessage__c(BccAddress__c='abc@xyz.com',Case__c = caseInstance.Id,CcAddress__c='abc@xyz.com');  
        insert draftInstance; 
        List<DraftEmailMessage__c> currentDraft = new List<DraftEmailMessage__c>();
        currentDraft.add(draftInstance);   
    } 
    public static void setupDataSendAndNext(){
        User u = [SELECT id,name FROM User WHERE id = :userInfo.getUserid()];        
        contactInstance = new Contact(LastName='TestClass', Email = 'testclasses@persistent.co.i');
        insert contactInstance;

        caseInstance = new Case(status='New',Origin='Phone',contactId=contactInstance.id);
        insert caseInstance;

        EmailMessage emailmsg = new EmailMessage(ParentId=caseInstance.Id,HtmlBody ='This is HTML Body');
        insert emailmsg;

        Group testQueue = new Group(Name = 'Test Queue', Type = 'Queue');
        insert testQueue;

        ApexPages.currentPage().getParameters().put('Id',caseInstance.Id);
        ApexPages.currentPage().getParameters().put('isdtp','vw');
        emailEditor = new HVEMEmailEditorCompCtrl();     
        emailEditor.includeThread = true;
        emailEditor.emailBody = 'Hello This is test Email body';
        emailEditor.caseInstance = caseInstance;
        emailEditor.additionalToAddress = 'abc@xyz.com';
        emailEditor.ccAddress= 'abc@xyz.com';
        emailEditor.bccAddress= 'abc@xyz.com';
        emailEditor.finalQueueId= 'idSelectedQueue_' + testQueue.Id;
        testgrpId = new Group(Name = 'Test1', Type = 'Regular');
        insert testgrpId;

        emailEditor.configOptions = new HVEM_Config_Options__c();
        emailEditor.configOptions.Allow_Draft_Approval__c = true;
        emailEditor.configOptions.Name = 'Test Config1';
        emailEditor.configOptions.Public_Groups_With_No_Approval__c = testgrpId.Id;
        upsert emailEditor.configOptions;
        selectedEmailTemplate = new EmailTemplate(FolderId = u.Id,TemplateType = 'text',DeveloperName = 'TestDeveloper',Name= 'Test name',Subject = 'Test Subject',Body = 'Hello This is test body');
    }

    public static void setupDataSendAndNextPositive(){
        User u = [SELECT id,name FROM User WHERE id = :userInfo.getUserid()];        

        contactInstance = new Contact(LastName='TestClass', Email = 'testclasses@persistent.co.i');
        insert contactInstance;

        caseInstance = new Case(status='New',Origin='Phone',contactId=contactInstance.id);
        insert caseInstance;
        
        EmailMessage emailmsg = new EmailMessage(ParentId=caseInstance.Id,HtmlBody ='This is HTML Body',CcAddress='abcg@bb.com',ToAddress='defg@cc.com',Subject='test',FromAddress='xyz@aa.com');
        insert emailmsg;
        System.assertEquals(true,emailmsg!=null);
        Group testQueue = new Group(Name = 'Test Queue', Type = 'Queue');
        insert testQueue;

        ApexPages.currentPage().getParameters().put('Id',caseInstance.Id);
        emailEditor = new HVEMEmailEditorCompCtrl();     
        emailEditor.includeThread = true;
        emailEditor.emailBody = 'Hello This is test Email body';
        emailEditor.caseInstance = caseInstance;
        emailEditor.additionalToAddress = 'abc@xyz.com';
        emailEditor.ccAddress= 'abc@xyz.com';
        emailEditor.bccAddress= 'abc@xyz.com';
        emailEditor.finalQueueId= 'idSelectedQueue_' + testQueue.Id;
        emailEditor.configOptions = new HVEM_Config_Options__c();
        emailEditor.configOptions.Allow_Draft_Approval__c = false;
        emailEditor.configOptions.Name = 'Test Config';
        upsert emailEditor.configOptions;
        emailEditor.caseStatus='Escalated'; 
        GroupMember groupMemberIns = new GroupMember(GroupID=testQueue.id,UserOrGroupId=u.id); 
        QueuesObject queuesObjectIns = new QueuesObject(QueueId=testQueue.id,SobjectType='case');        
       
        DraftEmailMessage__c demInstance = new DraftEmailMessage__c(status__c='Approval',case__c=caseInstance.id);
        insert demInstance; 
         selectedEmailTemplate = new EmailTemplate(FolderId = u.Id,TemplateType = 'text',DeveloperName = 'TestDeveloper',Name= 'Test name',Subject = 'Test Subject',Body = 'Hello This is test body');         
        System.runAs(u){
            insert groupMemberIns; 
            insert queuesObjectIns;    
            insert selectedEmailTemplate;
        }   
            
    }

    public static void setupDataPopulateEditor() {  
        User u = [SELECT id,name FROM User WHERE id = :userInfo.getUserid()];

        contactInstance = new Contact(LastName='TestClass', Email = 'testclasses@persistent.co.i');
        insert contactInstance;

        caseInstance = new Case(status='New',Origin='Phone',contactId=contactInstance.id);
        insert caseInstance;

        EmailMessage emailmsg = new EmailMessage(ParentId=caseInstance.Id,HtmlBody ='This is HTML Body');
        insert emailmsg;

        emailTempTest = new EmailTemplate(TemplateType = 'text',FolderId = u.Id,Name = 'Test text template', Subject = 'Test Subject',DeveloperName = 'TestDeveloper');
        System.runAs(u){
            insert emailTempTest;
        }    
        ApexPages.currentPage().getParameters().put('Id',caseInstance.Id);
        emailEditor = new HVEMEmailEditorCompCtrl(); 
        emailEditor.selectedTemplate = emailTempTest.Id;
    }

    public static testMethod void getCaseStatusFieldValuesTest(){
        setupData(); 
        Test.startTest(); 
        List<SelectOption> selectOptionList = emailEditor.getCaseStatusFieldValues();       
        Test.stopTest();
        System.assertEquals(true,selectOptionList.size() > 0);
    }
    static testMethod void sendAndNextActionTest(){
        setupDataSendAndNext(); 
        Test.startTest(); 
        emailEditor.sendAndNextAction();
        System.assertEquals( emailEditor.bccAddress, 'abc@xyz.com');
        Test.stopTest();

    }

    static testMethod void sendAndNextActionPositiveTest(){
        setupDataSendAndNextPositive(); 
        Test.startTest(); 
        emailEditor.sendAndNextAction();
        Task taskIns = new Task();
        taskIns = [Select WhatId from Task where WhatId =:caseInstance.id];
        emailEditor.selectedEmailTemplate = selectedEmailTemplate;
        emailEditor.sendAndNextAction();
        Test.stopTest();
        System.assertNotEquals(null,taskIns);
    }
    static testMethod void getEmailTemplatesTest(){
        setupData(); 
        Test.startTest(); 
        List<SelectOption> emailTemplateList1 = emailEditor.getEmailTemplates();       
        Test.stopTest();
        System.assertEquals(true,emailTemplateList1.size() > 0);
    }

    static testMethod void populateEditorTest(){
        setupDataPopulateEditor(); 
        Test.startTest(); 
        emailEditor.populateEditor();
        System.assertEquals(true,emailEditor.selectedTemplate != 'None');
        emailEditor.selectedTemplate = '';
        emailEditor.populateEditor();
        Test.stopTest();
      
    }

    static testMethod void testdiscardDraft(){
        setupDataInit();
        Test.startTest();
        configOptions.Auto_Populate_To_Field_From_Case_Contact__c=false;
        String templateType = 'Text';
        emailEditor.selectedTemplate = String.valueOf(selectedEmailTemplate.Id);
        emailEditor.discardDraft();
        configOptions.Default_Email_Template__c = selectedEmailTemplate.Id;
        emailEditor.discardDraft();
        System.assertEquals(true,configOptions!=null);
        Test.stopTest();
    }
  
    static testMethod void testExtractContent(){
        setupDataInit();
        Test.startTest();
        List<String> contentList=new List<String>();
        String fullHtml = '<input type="hidden" ' + ' id=\"text_body_hidden\" ' + 'name=\"text_body_hidden\"' + '<input type="button"' + 'id=\"testDiv\"' + 'title=\"text_body_button\"' +'input type="checkbox"' + 'id=\"test\"'; 
        String templateType = 'Text';
        String valueString = emailEditor.extractContent(templateType,fullHtml);
        System.assertEquals(True,valueString!=null);
        templateType = 'custom';
        fullHtml = '<input type="hidden" ' + ' id=\"html_body_hidden\" ' + 'name=\"html_body_hidden\"'+ '<input type="button"' + 'id=\"testDiv\"' + 'title=\"text_body_button\"';
        emailEditor.extractContent(templateType,fullHtml);
        Test.stopTest();
    }
    
    static testMethod void testControllerElsePart(){
        setupDataInit();
        Test.startTest();
        configOptions.Allow_Draft_Approval__c = true;       
        ApexPages.currentPage().getParameters().put('Id',caseInstance.Id);
        emailEditor = new HVEMEmailEditorCompCtrl();
        System.assertEquals(caseInstance.Id,emailEditor.caseId);
        Test.stopTest();

    }
    static testMethod void setupDataInitNegative(){        
        User u = [SELECT id,name FROM User WHERE id = :userInfo.getUserid()];
        contactInstance = new Contact(LastName='TestClass');
        insert contactInstance;

        caseInstance = new Case(status='New',Origin='Phone',contactId=contactInstance.id);
        insert caseInstance;

        EmailMessage emailmsg = new EmailMessage(ParentId=caseInstance.Id,HtmlBody ='This is HTML Body');
        insert emailmsg;

        selectedEmailTemplate = new EmailTemplate(FolderId = u.Id,TemplateType = 'Custom',DeveloperName = 'TestDeveloper',Name= 'Test name',Subject = 'Test Subject',Body = 'Hello This is test body');

        orgIns = new Organization();

        System.runAs(u){
            insert selectedEmailTemplate;
        }
        if(HVEM_Config_Options__c.getInstance('HVEM') == null){
            configOptions = new HVEM_Config_Options__c(name='HVEM',Default_Email_Template__c = selectedEmailTemplate.Id,Allow_Draft_Approval__c = true,Under_Approval_Case_Status__c='Process',Auto_Populate_To_Field_From_Case_Contact__c=false);
            insert configOptions;
        }
        else{
            configOptions = HVEM_Config_Options__c.getInstance('HVEM');
        }
        emailBody = 'Sample text for Email Body.';
        configOptions.Allow_Draft_Approval__c = true;
        ApexPages.currentPage().getParameters().put('Id',caseInstance.Id);
        emailEditor = new HVEMEmailEditorCompCtrl(); 

        emailTemplateList = new List<EmailTemplate>();
        emailEditor.emailTemplateList.add(selectedEmailTemplate); 

        Group testQueue = new Group(Name = 'Test Queue', Type = 'Queue');
        insert testQueue;

        testgrpId = new Group(Name = 'Test11', Type = 'Regular');
        insert testgrpId;

        draftInstance = new DraftEmailMessage__c(Status__c='Approval',BccAddress__c='abc@xyz.com',Case__c = caseInstance.Id,CcAddress__c='abc@xyz.com');  
        draftInstance.TemplateId__c = 'abscs';
        draftInstance.TextBody__c ='aaa';
        draftInstance.ToAddress__c='abcd@dot.com;pqrstd@co.in;';
        insert draftInstance; 
        List<DraftEmailMessage__c> currentDraft = new List<DraftEmailMessage__c>();
        currentDraft.add(draftInstance);  

        contactInstance1 = new Contact(LastName='TestClass1',Email='abcd@dot.com');
        insert contactInstance1;

        List<String> additionalToList = new List<String>();
        String [] str1=draftInstance.ToAddress__c.split(';',2);
        additionalToList.add(str1[0]);
        System.assertEquals(true,additionalToList.size()>0);
        contactInstance1.Email = additionalToList[0];
        emailEditor.selectedTemplate = configOptions.Default_Email_Template__c; 

    }

    static testMethod void testconstructorNegativePart(){
        setupDataInitNegative();
        Test.startTest();
        ApexPages.currentPage().getParameters().put('Id',caseInstance.Id);
        emailEditor = new HVEMEmailEditorCompCtrl();
        System.assertEquals(true,emailEditor.configOptions!=null);
        Test.stopTest();

    }

    public static void setupDataSendAndNextElsePart(){
        User u = [SELECT id,name FROM User WHERE id = :userInfo.getUserid()];        

        selectedEmailTemplate = new EmailTemplate(FolderId = u.Id,TemplateType = 'custom',DeveloperName = 'Test1Developer',Name= 'Test name1',Subject = 'Test Subject',Body = 'Hello This is test body');         


        contactInstance = new Contact(LastName='TestClass', Email = 'testclasses@persistent.co.i');
        insert contactInstance;

        caseInstance = new Case(Status='New',Origin='Phone',contactId=contactInstance.id);
        insert caseInstance;

        EmailMessage emailmsg = new EmailMessage(ParentId=caseInstance.Id,HtmlBody ='');
        insert emailmsg;

        Group testQueue1 = new Group(Name = 'Test2', Type = 'Regular');
        insert testQueue1;

        ApexPages.currentPage().getParameters().put('Id',caseInstance.Id);
        emailEditor = new HVEMEmailEditorCompCtrl();     
        emailEditor.includeThread = true;
        emailEditor.emailBody = 'Hello This is test Email body';
        emailEditor.caseInstance = caseInstance;
        emailEditor.additionalToAddress = 'abc@xyz.com';
        emailEditor.ccAddress= 'abc@xyz.com';
        emailEditor.bccAddress= 'abc@xyz.com';
        emailEditor.finalQueueId= 'idSelectedQueue_' + testQueue1.Id;
        emailEditor.configOptions = new HVEM_Config_Options__c();
        emailEditor.configOptions.Allow_Draft_Approval__c = false;
        emailEditor.configOptions.Name = 'Test Config';
        upsert emailEditor.configOptions;
        emailEditor.caseStatus='Escalated'; 
        GroupMember groupMemberIns = new GroupMember(GroupID=testQueue1.id,UserOrGroupId=u.id); 
        QueuesObject queuesObjectIns = new QueuesObject(QueueId=testQueue1.id,SobjectType='case'); 
        System.runAs(u){
            insert groupMemberIns; 
            insert queuesObjectIns;    
            insert selectedEmailTemplate;
        }  

        loggedInUserQueueList = new List<GroupMember>();
        loggedInUserQueueList.add(groupMemberIns);
        emailEditor.finalQueueId = loggedInUserQueueList[0].Group.Id;
        draftInstance = new DraftEmailMessage__c(Status__c='Draft',BccAddress__c='abc@xyz.com',Case__c = caseInstance.Id,CcAddress__c='abc@xyz.com',TextBody__c ='',HtmlBody__c='<div>Hi</div>',TemplateId__c = selectedEmailTemplate.id );          
        insert draftInstance;
        emailEditor.isSuperUser = true;
    }

    static testMethod void testSendAndNextElse(){
        setupDataSendAndNextElsePart();
        Test.startTest(); 
        emailEditor.sendAndNextAction();
        System.assertEquals(true,loggedInUserQueueList.size()>0);
        System.assertEquals('Draft',draftInstance.Status__c);
        emailEditor.additionalToAddress = 'abc@xyz.com;xyz';
        emailEditor.ccAddress = 'abc@xyz.com;pqr';
        emailEditor.bccAddress = 'abc@xyz.com;aa';
        emailEditor.sendAndNextAction();
        Test.stopTest();
    }
    
    public static void setUpDataForConstructorElse(){
        User u = [SELECT id,name FROM User WHERE id = :userInfo.getUserid()];
        u.HVEM_User__c = true;
        update u;
        contactInstance = new Contact(LastName='TestClass', Email = 'testclasses@persistent.co.i');
        insert contactInstance;

        caseInstance = new Case(status='New',Origin='Phone',contactId=contactInstance.id);
        insert caseInstance;

        EmailMessage emailmsg = new EmailMessage(ParentId=caseInstance.Id,HtmlBody ='This is HTML Body');
        insert emailmsg;

        selectedEmailTemplate = new EmailTemplate(FolderId = u.Id,TemplateType = 'custom',DeveloperName = 'TestDeveloper',Name= 'Test name',Subject = 'Test Subject',Body = 'Hello This is test body',isActive=true);

        orgIns = new Organization();

        System.runAs(u){
            insert selectedEmailTemplate;
        }
        if(HVEM_Config_Options__c.getInstance('HVEM') == null){
            configOptions = new HVEM_Config_Options__c(name='HVEM',Default_Email_Template__c = selectedEmailTemplate.Id,Allow_Draft_Approval__c = false,Auto_Populate_To_Field_From_Case_Contact__c = false);
            insert configOptions;
        }
        else{
            configOptions = HVEM_Config_Options__c.getInstance('HVEM');
        }
        emailBody = 'Sample text for Email Body.';
        configOptions.Allow_Draft_Approval__c = true;
        ApexPages.currentPage().getParameters().put('Id',caseInstance.Id);
        ApexPages.currentPage().getParameters().put('isdtp','vw');
        emailEditor = new HVEMEmailEditorCompCtrl(); 

        emailTemplateList = new List<EmailTemplate>();
        emailEditor.emailTemplateList.add(selectedEmailTemplate); 

        Group testQueue = new Group(Name = 'Test Queue', Type = 'Queue');
        insert testQueue;

        testgrpId = new Group(Name = 'Test11', Type = 'Regular');
        insert testgrpId;

        draftInstance = new DraftEmailMessage__c(Status__c='Approval',BccAddress__c='abc@xyz.com',Case__c = caseInstance.Id,CcAddress__c='abc@xyz.com',TextBody__c ='',HtmlBody__c='<div>Hi</div>',TemplateId__c = selectedEmailTemplate.id );          
        insert draftInstance;

        List<DraftEmailMessage__c> currentDraft = new List<DraftEmailMessage__c>();
        currentDraft.add(draftInstance);    
        emailEditor.selectedTemplate = 'none';      
    }  

    static testMethod void testConstructorElseForCustomType(){
        setUpDataForConstructorElse();
        Test.startTest();
        ApexPages.currentPage().getParameters().put('Id',caseInstance.Id);
        emailEditor = new HVEMEmailEditorCompCtrl();
        System.assertEquals(true,configOptions!=null);
        Test.stopTest();

    }  
   static void setUpDataForSelectedTempNull(){
        User u = [SELECT id,name FROM User WHERE id = :userInfo.getUserid()];
        u.HVEM_User__c = true;
        update u;
        contactInstance = new Contact(LastName='TestClass', Email = 'testclasses@persistent.co.i');
        insert contactInstance;

        caseInstance = new Case(status='New',Origin='Phone',contactId=contactInstance.id);
        insert caseInstance;

        EmailMessage emailmsg = new EmailMessage(ParentId=caseInstance.Id,HtmlBody ='This is HTML Body');
        insert emailmsg;

        selectedEmailTemplate = new EmailTemplate(FolderId = u.Id,TemplateType = 'custom',DeveloperName = 'TestDeveloper',Name= 'Test name',Subject = 'Test Subject',Body = 'Hello This is test body',isActive=true);

        orgIns = new Organization();

        System.runAs(u){
            insert selectedEmailTemplate;
        }
        if(HVEM_Config_Options__c.getInstance('HVEM') == null){
            configOptions = new HVEM_Config_Options__c(name='HVEM',Default_Email_Template__c = selectedEmailTemplate.Id,Allow_Draft_Approval__c = false);
            insert configOptions;
        }
        else{
            configOptions = HVEM_Config_Options__c.getInstance('HVEM');
        }
        emailBody = 'Sample text for Email Body.';
        configOptions.Allow_Draft_Approval__c = true;
        ApexPages.currentPage().getParameters().put('Id',caseInstance.Id);
        ApexPages.currentPage().getParameters().put('isdtp','vw');
        emailEditor = new HVEMEmailEditorCompCtrl(); 

        emailTemplateList = new List<EmailTemplate>();
        emailEditor.emailTemplateList.add(selectedEmailTemplate); 

        testgrpId = new Group(Name = 'Test11', Type = 'Regular');
        insert testgrpId;

        draftInstance = new DraftEmailMessage__c(Status__c='Approval',BccAddress__c='abc@xyz.com',Case__c = caseInstance.Id,CcAddress__c='abc@xyz.com',TextBody__c ='',HtmlBody__c='<div>Hi</div>',TemplateId__c ='');          
        insert draftInstance;

        List<DraftEmailMessage__c> currentDraft = new List<DraftEmailMessage__c>();
        currentDraft.add(draftInstance);    
        emailEditor.selectedTemplate = 'none';      
    }  

    static testMethod void testConstructorForSelectTempNull(){
        setUpDataForSelectedTempNull();
        Test.startTest();
        ApexPages.currentPage().getParameters().put('Id',caseInstance.Id);
        emailEditor = new HVEMEmailEditorCompCtrl(); 
        draftInstance = new DraftEmailMessage__c(Status__c='Approval',BccAddress__c='abc@xyz.com',Case__c = caseInstance.Id,CcAddress__c='abc@xyz.com',TextBody__c ='This is a Example for Testing',HtmlBody__c='',TemplateId__c ='none');          
        upsert draftInstance;
        ApexPages.currentPage().getParameters().put('Id',caseInstance.Id);
        emailEditor = new HVEMEmailEditorCompCtrl(); 
        System.assertEquals('HVEM',configOptions.Name);
        Test.stopTest();

    }    
    static testMethod void testTemplateNavigationMethods(){
         setupDataInit();
         Test.startTest();
         emailEditor.initializeEmailTemplate();
         System.assertEquals(true,emailEditor.folders!=null);
         emailEditor.folders = null;
         emailEditor.initializeEmailTemplate();
         emailEditor.getEmailFolders();
         System.assertEquals(true,emailEditor.folderList!=null);
         emaileditor.folderList = null;
         emailEditor.folders = null;
         emailEditor.initializeEmailTemplate();
         emailEditor.getEmailTemplatefolders();
         emailEditor.getEmailTemplatesList();
         emailEditor.folders = 'None';
         emailEditor.getEmailTemplatesList();
         System.assertEquals(true,emailEditor.folders!=null);
         Test.stopTest();
     }
   static void setUpDataConfigNullInConstructor(){
        User u = [SELECT id,name FROM User WHERE id = :userInfo.getUserid()];
        u.HVEM_User__c = true;
        update u;
        contactInstance = new Contact(LastName='TestClass', Email = 'abcd@xyz.com');
        insert contactInstance;

        caseInstance = new Case(status='New',Origin='Phone',contactId=contactInstance.id);
        insert caseInstance;

        EmailMessage emailmsg = new EmailMessage(ParentId=caseInstance.Id,HtmlBody ='This is HTML Body');
        insert emailmsg;
        
        draftInstance = new DraftEmailMessage__c(Status__c='Approval',ToAddress__c='abcd@xyz.com;',BccAddress__c='abc@xyz.com',Case__c = caseInstance.Id,CcAddress__c='abc@xyz.com',TextBody__c ='This is a Example for Testing',HtmlBody__c='',TemplateId__c ='none');          
        insert draftInstance; 
                
        selectedEmailTemplate = new EmailTemplate(FolderId = u.Id,TemplateType = 'text',DeveloperName = 'TestDeveloper',Name= 'Test name',Subject = 'Test Subject',Body = 'Hello This is test body',isActive=true);

        System.runAs(u){
            insert selectedEmailTemplate;
        }
        if(HVEM_Config_Options__c.getInstance('HVEM') == null){
            configOptions = new HVEM_Config_Options__c(name='HVEM',Default_Email_Template__c = selectedEmailTemplate.Id ,Allow_Draft_Approval__c = false);
            upsert configOptions;
        }
        else{
            configOptions = HVEM_Config_Options__c.getInstance('HVEM');
        }
        emailBody = 'Sample text for Email Body.';
        configOptions.Allow_Draft_Approval__c = true;
        ApexPages.currentPage().getParameters().put('Id',caseInstance.Id);
        ApexPages.currentPage().getParameters().put('isdtp','vw');
        emailEditor = new HVEMEmailEditorCompCtrl(); 

        emailTemplateList = new List<EmailTemplate>();
        emailEditor.emailTemplateList.add(selectedEmailTemplate); 

        List<DraftEmailMessage__c> currentDraft = new List<DraftEmailMessage__c>();
        currentDraft.add(draftInstance);    
        emailEditor.selectedTemplate = configOptions.Default_Email_Template__c;    
         }
    
    static testMethod void testConfigNullInConstructor(){
        setupDataInit();
        Test.startTest();
        configOptions.Auto_Populate_To_Field_From_Case_Contact__c=false;
        emailEditor = new HVEMEmailEditorCompCtrl();
        List<HVEM_Config_Options__c> configList = new List<HVEM_Config_Options__c>();
        configList = [select Id from HVEM_Config_Options__c];
        delete configList;
        emailEditor = new HVEMEmailEditorCompCtrl();
        System.assertEquals(true,configOptions!=null);
        Test.stopTest();
     }
   static testMethod void testselectTemplateConstructor(){
       setUpDataConfigNullInConstructor();
       Test.startTest();
       emailEditor = new HVEMEmailEditorCompCtrl();
       System.assertEquals('abcd@xyz.com',contactInstance.Email);
       Test.stopTest();
     }
   static void setUpDataForConstructor(){
        User u = [SELECT id,name FROM User WHERE id = :userInfo.getUserid()];
        u.HVEM_User__c = true;
        update u;
        contactInstance = new Contact(LastName='TestClass', Email = 'abcd@xyz.com');
        insert contactInstance;

        caseInstance = new Case(status='New',Origin='Phone',contactId=contactInstance.id);
        insert caseInstance;
        List<DraftEmailMessage__c> draftList = [select Id from DraftEmailMessage__c];
        delete draftList; 
        
        draftInstance = new DraftEmailMessage__c(Status__c='Draft',ToAddress__c='abcd@xyz.com;',BccAddress__c='abc@xyz.com',Case__c = caseInstance.Id,CcAddress__c='abc@xyz.com',TextBody__c ='',HtmlBody__c='',TemplateId__c ='none');          
        upsert draftInstance; 
                
        selectedEmailTemplate = new EmailTemplate(FolderId = u.Id,TemplateType = 'text',DeveloperName = 'TestDeveloper',Name= 'Test name',Subject = 'Test Subject',Body = 'Hello This is test body',isActive=true);

        System.runAs(u){
            insert selectedEmailTemplate;
        }
        List<HVEM_Config_Options__c> listconfig = [select Id from HVEM_Config_Options__c];
        delete listconfig;
         
        if(HVEM_Config_Options__c.getInstance('HVEM') == null){
            configOptions = new HVEM_Config_Options__c(name='HVEM',Default_Email_Template__c = selectedEmailTemplate.Id ,Allow_Draft_Approval__c = true);
            insert configOptions;
        }
        else{
            configOptions = HVEM_Config_Options__c.getInstance('HVEM');
        }
       
        ApexPages.currentPage().getParameters().put('Id',caseInstance.Id);
        ApexPages.currentPage().getParameters().put('isdtp','vw');
        emailEditor = new HVEMEmailEditorCompCtrl(); 
      
         }
     static testMethod void testElseConstructor(){ 
           setUpDataForConstructor();
           Test.startTest();
           emailEditor = new HVEMEmailEditorCompCtrl();
           System.assertNotEquals('None',emailEditor.selectedTemplate);
           System.assertEquals(true,configOptions!=null);
           emailEditor.sendAndNextAction();
           Test.stopTest();
     }
      
   static void dataForNullTextBody(){
        User u = [SELECT id,name FROM User WHERE id = :userInfo.getUserid()];
        u.HVEM_User__c = true;
        update u;
        contactInstance = new Contact(LastName='TestClass', Email = 'abcd@xyz.com');
        insert contactInstance;

        caseInstance = new Case(status='New',Origin='Phone',contactId=contactInstance.id);
        insert caseInstance;

        draftInstance = new DraftEmailMessage__c(Status__c='Approval',ToAddress__c='abcd@xyz.com;',BccAddress__c='abc@xyz.com',Case__c = caseInstance.Id,CcAddress__c='abc@xyz.com',TextBody__c ='',HtmlBody__c='<div><label>hello</label></div>',TemplateId__c ='none');          
        upsert draftInstance; 
                
        selectedEmailTemplate = new EmailTemplate(FolderId = u.Id,TemplateType = 'text',DeveloperName = 'TestDeveloper',Name= 'Test name',Subject = 'Test Subject',Body = 'Hello This is test body',isActive=true);
        
        System.runAs(u){
           upsert selectedEmailTemplate;
        }
        if(HVEM_Config_Options__c.getInstance('HVEM') == null){
            configOptions = new HVEM_Config_Options__c(name='HVEM',Default_Email_Template__c = selectedEmailTemplate.Id ,Allow_Draft_Approval__c = true);
            upsert configOptions;
        }
        else{
            configOptions = HVEM_Config_Options__c.getInstance('HVEM');
        }
         
        ApexPages.currentPage().getParameters().put('Id',caseInstance.Id);
        ApexPages.currentPage().getParameters().put('isdtp','vw');
        emailEditor = new HVEMEmailEditorCompCtrl(); 
       }
    
    static testMethod void testNullTextBody(){
        dataForNullTextBody();
        Test.startTest();
        emailEditor = new HVEMEmailEditorCompCtrl();
        System.assertEquals(true,draftInstance.HtmlBody__c!=null);
        Test.stopTest();
        }
   
   static void dataForHtmlBodyNotNull(){
    
        User u = [SELECT id,name FROM User WHERE id = :userInfo.getUserid()];
        u.HVEM_User__c = true;
        update u;
        contactInstance = new Contact(LastName='TestClass', Email = 'abcd@xyz.com');
        insert contactInstance;

        caseInstance = new Case(status='New',Origin='Phone',contactId=contactInstance.id);
        insert caseInstance;
 
        selectedEmailTemplate = new EmailTemplate(FolderId = u.Id,TemplateType = 'text',DeveloperName = 'TestDeveloper',Name= 'Test name',Subject = 'Test Subject',Body = 'Hello This is test body',isActive=true);
        
        System.runAs(u){
           upsert selectedEmailTemplate;
        }
        
        draftInstance = new DraftEmailMessage__c(Status__c='Approval',ToAddress__c='abcd@xyz.com;',BccAddress__c='abc@xyz.com',Case__c = caseInstance.Id,CcAddress__c='abc@xyz.com',TextBody__c ='',HtmlBody__c='<div><label>hello</label></div>',TemplateId__c =selectedEmailTemplate.Id);          
        upsert draftInstance; 
        if(HVEM_Config_Options__c.getInstance('HVEM') == null){
            configOptions = new HVEM_Config_Options__c(name='HVEM',Default_Email_Template__c = selectedEmailTemplate.Id ,Allow_Draft_Approval__c = true);
            upsert configOptions;
        }
        else{
            configOptions = HVEM_Config_Options__c.getInstance('HVEM');
        }
      
        ApexPages.currentPage().getParameters().put('Id',caseInstance.Id);
        ApexPages.currentPage().getParameters().put('isdtp','vw');
        emailEditor = new HVEMEmailEditorCompCtrl(); 

       }
    
    static testMethod void testNotNullHtmlBody(){
        dataForHtmlBodyNotNull();
        Test.startTest();
        emailEditor = new HVEMEmailEditorCompCtrl();
        System.assertEquals(true,draftInstance.HtmlBody__c!=null);
        Test.stopTest();
        } 
   static void dataForCustomTemplateType(){
        User u = [SELECT id,name FROM User WHERE id = :userInfo.getUserid()];
        u.HVEM_User__c = true;
        update u;
        contactInstance = new Contact(LastName='TestClass', Email = 'abcd@xyz.com');
        insert contactInstance;

        caseInstance = new Case(status='New',Origin='Phone',contactId=contactInstance.Id);
        insert caseInstance;
                     
        selectedEmailTemplate = new EmailTemplate(FolderId = u.Id,TemplateType = 'custom',DeveloperName = 'TestDeveloper',Name= 'Test name',Subject = 'Test Subject',Body = 'Hello This is test body',isActive=true);
        
        System.runAs(u){
           upsert selectedEmailTemplate;
        }
        draftInstance = new DraftEmailMessage__c(Status__c='Draft',ToAddress__c='abcd@xyz.com;',BccAddress__c='abc@xyz.com',Case__c = caseInstance.Id,CcAddress__c='abc@xyz.com',TextBody__c ='hello',HtmlBody__c='',TemplateId__c =selectedEmailTemplate.Id);          
        upsert draftInstance; 
        if(HVEM_Config_Options__c.getInstance('HVEM') == null){
            configOptions = new HVEM_Config_Options__c(name='HVEM',Default_Email_Template__c = selectedEmailTemplate.Id ,Allow_Draft_Approval__c = false);
            upsert configOptions;
        }
        else{
            configOptions = HVEM_Config_Options__c.getInstance('HVEM');
        }
        
        ApexPages.currentPage().getParameters().put('Id',caseInstance.Id);
        ApexPages.currentPage().getParameters().put('isdtp','vw');
        emailEditor = new HVEMEmailEditorCompCtrl(); 
        EmailMessage emailmsg = new EmailMessage(ParentId=caseInstance.Id,HtmlBody ='This is HTML Body',CcAddress='abcg@bb.com',ToAddress='defg@cc.com',Subject='test',FromAddress='xyz@aa.com');
        insert emailmsg;
        emailEditor.includeThread = true;
        emailMessageList =  new List<EmailMessage>();
        emailMessageList.add(emailmsg);
        emailEditor.emailSubject = '';
        emailEditor.emailBody='this is a email text body';
       }
    
    static testMethod void testCustomTemplateType(){
        dataForCustomTemplateType();
        Test.startTest();
        emailEditor = new HVEMEmailEditorCompCtrl();
        System.assertEquals(true,configOptions!=null);
        configOptions.Allow_Draft_Approval__c = false;
        upsert configOptions;
        delete emailMessageList;
        emailEditor.emailSubject = '';
        emailEditor.emailBody='this is a email text body';
        emailEditor.sendAndNextAction();
        Test.stopTest();
        }   
   
  }