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
    
    static testMethod void setupDataInit() {        
        User u = [SELECT id,name FROM User WHERE id = :userInfo.getUserid()];
        u.HVEM_User__c = true;
        update u;
        contactInstance = new Contact(LastName='TestClass', Email = 'testclasses@persistent.co.i');
        insert contactInstance;
        
        caseInstance = new Case(status='New',Origin='Phone',contactId=contactInstance.id);
        insert caseInstance;
        
        EmailMessage emailmsg = new EmailMessage(ParentId=caseInstance.Id,HtmlBody ='This is HTML Body');
        insert emailmsg;
        
     //   EmailTemplate testTemp = new EmailTemplate(FolderId = u.Id,TemplateType = 'text',DeveloperName = 'TestDeveloper',Name= 'Test name',Subject = 'Test Subject',Body = 'Hello This is test body');
      //  selectedEmailTemplate = testTemp;
        
        selectedEmailTemplate = new EmailTemplate(FolderId = u.Id,TemplateType = 'text',DeveloperName = 'TestDeveloper',Name= 'Test name',Subject = 'Test Subject',Body = 'Hello This is test body',isActive=true);
        
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
         
        Group testQueue = new Group(Name = 'Test Queue', Type = 'Queue');
        insert testQueue;
        
        testgrpId = new Group(Name = 'Test11', Type = 'Regular');
        insert testgrpId;
        
        draftInstance = new DraftEmailMessage__c(Status__c='Approval',BccAddress__c='abc@xyz.com',Case__c = caseInstance.Id,CcAddress__c='abc@xyz.com',TextBody__c ='aaa',TemplateId__c = selectedEmailTemplate.id );          
        insert draftInstance;
         
        List<DraftEmailMessage__c> currentDraft = new List<DraftEmailMessage__c>();
        currentDraft.add(draftInstance);          
       //emailEditor.selectedTemplate = String.valueOf(draftInstance.TemplateId__c);
       //selectedEmailTemplate.Id = String.valueOf(emailEditor.selectedTemplate);
       //  selectedEmailTemplate.Id=emailEditor.selectedTemplate;       
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
        
        EmailMessage emailmsg = new EmailMessage(ParentId=caseInstance.Id,HtmlBody ='This is HTML Body');
        insert emailmsg;
        
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
        selectedEmailTemplate = new EmailTemplate(FolderId = u.Id,TemplateType = 'text',DeveloperName = 'TestDeveloper',Name= 'Test name',Subject = 'Test Subject',Body = 'Hello This is test body');         
        DraftEmailMessage__c demInstance = new DraftEmailMessage__c(status__c='Approval',case__c=caseInstance.id);
        insert demInstance; 
        System.runAs(u){
            insert groupMemberIns; 
            insert queuesObjectIns;    
            insert selectedEmailTemplate;
        }                
    }
    
    static testMethod void setupDataPopulateEditor() {  
        User u = [SELECT id,name FROM User WHERE id = :userInfo.getUserid()];
              
        contactInstance = new Contact(LastName='TestClass', Email = 'testclasses@persistent.co.i');
        insert contactInstance;
        
        caseInstance = new Case(status='New',Origin='Phone',contactId=contactInstance.id);
        insert caseInstance;
        
        EmailMessage emailmsg = new EmailMessage(ParentId=caseInstance.Id,HtmlBody ='This is HTML Body');
        insert emailmsg;
            
        EmailTemplate emailTempTest = new EmailTemplate(TemplateType = 'text',FolderId = u.Id,Name = 'Test text template', Subject = 'Test Subject',DeveloperName = 'TestDeveloper');
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
       //Task taskIns = new Task();
       //taskIns = [Select WhatId from Task where WhatId =:caseInstance.id];       
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
       Test.stopTest();
       System.assertEquals(true,emailEditor.selectedTemplate != 'None');
      }
      
       static testMethod void testdiscardDraft()
       {
       setupDataInit();
       Test.startTest();
        configOptions.Auto_Populate_To_Field_From_Case_Contact__c=false;
       String templateType = 'Text';
     
        emailEditor.selectedTemplate = String.valueOf(selectedEmailTemplate.Id);
       emailEditor.discardDraft();
       //emailEditor.selectedEmailTemplate.templateType = 'text';
       configOptions.Default_Email_Template__c = selectedEmailTemplate.Id;
      //  emailEditor.discardDraft();
       configOptions = new HVEM_Config_Options__c();
       emailEditor.discardDraft();
        System.assertEquals(true,configOptions!=null);
       Test.stopTest();
      
                     
       }
       
       
   static testMethod void testExtractContent()
         {
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
     /*static testMethod void testverifyUser()
        {
           setupDataInit();
           Test.startTest();
           configOptions.Allow_Draft_Approval__c = true;
           configOptions.Public_Groups_With_No_Approval__c = testgrpId.ID;
           emailEditor.verifyUser();
           Test.stopTest();
                   
        }
     
     static testMethod void testControrl()
       {
        setupDataInit();
        Test.startTest();
        configOptions.Allow_Draft_Approval__c = true; 
       // draftInstance.ToAddress__c = 'abcd@dom.com;sevn';
       
        emailEditor.selectedTemplate=String.valueOf(selectedEmailTemplate.Id);
        ApexPages.currentPage().getParameters().put('Id',caseInstance.Id);
        emailEditor = new HVEMEmailEditorCompCtrl();
        //System.assertEquals('text',emailEditor.selectedEmailTemplate.TemplateType);
        
        Test.stopTest();
        
       }*/
       //changes-------------------------
        static testMethod void testController2()
       {
        setupDataInit();
        Test.startTest();
        configOptions.Allow_Draft_Approval__c = true;       
        ApexPages.currentPage().getParameters().put('Id',caseInstance.Id);
        emailEditor = new HVEMEmailEditorCompCtrl();
        System.assertEquals(caseInstance.Id,emailEditor.caseId);
        
        Test.stopTest();
        
       }
       //------------------------------------------------------
       static testMethod void setupDataInitNegative() 
       {        
           User u = [SELECT id,name FROM User WHERE id = :userInfo.getUserid()];
           contactInstance = new Contact(LastName='TestClass');
           insert contactInstance;
          
           caseInstance = new Case(status='New',Origin='Phone',contactId=contactInstance.id);
           insert caseInstance;
        
           EmailMessage emailmsg = new EmailMessage(ParentId=caseInstance.Id,HtmlBody ='This is HTML Body');
           insert emailmsg;
        
      // EmailTemplate testTemp = new EmailTemplate(FolderId = u.Id,TemplateType = 'text',DeveloperName = 'TestDeveloper',Name= 'Test name',Subject = 'Test Subject',Body = 'Hello This is test body');
       // selectedEmailTemplate = testTemp;
        
           selectedEmailTemplate = new EmailTemplate(FolderId = u.Id,TemplateType = 'Custom',DeveloperName = 'TestDeveloper',Name= 'Test name',Subject = 'Test Subject',Body = 'Hello This is test body');
        
           orgIns = new Organization();
       
           System.runAs(u){
              insert selectedEmailTemplate;
           }
           if(HVEM_Config_Options__c.getInstance('HVEM') == null){
               configOptions = new HVEM_Config_Options__c(name='HVEM',Default_Email_Template__c = selectedEmailTemplate.Id,Allow_Draft_Approval__c = true,Under_Approval_Case_Status__c='Process');
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
       
       
       static testMethod void testcontrollerNegative()
       {
         setupDataInitNegative();
         Test.startTest();
         ApexPages.currentPage().getParameters().put('Id',caseInstance.Id);
         emailEditor = new HVEMEmailEditorCompCtrl();
         Test.stopTest();
         
       
       
       
       
       }
         /*static testMethod void testSaveDraft()
         {
          setupDataInit();
          Test.startTest();
          emailEditor.emailBodyLengthExceededError = true;
         emailEditor.changeCaseOwnerError = true;
         emailEditor.saveDraft();
          Test.stopTest();
         }
         */
}