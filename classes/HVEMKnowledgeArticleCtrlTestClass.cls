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
private class HVEMKnowledgeArticleCtrlTestClass {
    static HVEMKnowledgeArticleCtrl HVEMKnowledgeArticleCtrlInstance;
    static Case caseInstance;
    static Organization orgInstance;
    static EmailTemplate selectedEmailTemplate;
    static HVEM_Config_Options__c configOptions;
    static String prepareWithDataCategoryString;
  
    static testMethod void setupDataInitPositive(){

        HVEM_Config_Options__c configIns = new HVEM_Config_Options__c();
        configIns.name = 'Case Mapping';        
        configIns.Case_Mappin_API__c = 'Status:New >> CategoryTest:All' ;
        configIns.Case_Mapping_Label__c = 'Status:New >> CategoryTest:All' ; 
        insert configIns;  
        String apiName = 'Status:New >> Category1:A;;';
        caseInstance = new Case(status='New',Origin='Phone',Subject = 'Test Subject');
        insert caseInstance;
        ApexPages.currentPage().getParameters().put('Id',caseInstance.Id);
        HVEMKnowledgeArticleCtrlInstance = new HVEMKnowledgeArticleCtrl();
        HVEMKnowledgeArticleCtrlInstance.getArticleTypesDevName();
        System.assertEquals(caseInstance.id,HVEMKnowledgeArticleCtrlInstance.caseId);
    }

    static testMethod void setupDataInit(){
        User u = [SELECT id,name FROM User WHERE id = :userInfo.getUserid()];
        caseInstance = new Case(status='New',Origin='Phone',Subject = 'Test Subject');
        insert caseInstance;
        EmailMessage emailmsg = new EmailMessage(ParentId=caseInstance.Id,HtmlBody ='This is HTML Body');
        insert emailmsg;
        EmailTemplate testTemp = new EmailTemplate(FolderId = u.Id,TemplateType = 'text',DeveloperName = 'TestDeveloper',Name= 'Test name',Subject = 'Test Subject',Body = 'Hello This is test body');
        selectedEmailTemplate = testTemp;
        System.runAs(u){
            insert testTemp;
        }
        if(HVEM_Config_Options__c.getInstance('HVEM') == null){
            configOptions = new HVEM_Config_Options__c(name='HVEM',Default_Email_Template__c = selectedEmailTemplate.Id, Data_Category_Group_Filter__c = 'ABC , DEF', Article_Types_Filter__c = 'FAQ , TEST');
            insert configOptions;
        }
        else{
            configOptions = HVEM_Config_Options__c.getInstance('HVEM');
        }


        ApexPages.currentPage().getParameters().put('Id',caseInstance.Id);
        HVEMKnowledgeArticleCtrlInstance = new HVEMKnowledgeArticleCtrl();
        System.assertEquals(caseInstance.id,HVEMKnowledgeArticleCtrlInstance.caseId);
        HVEMKnowledgeArticleCtrlInstance.getArticleTypesDevName();
    }

    /*static testMethod void setupDataInitNegative(){
        caseInstance = new Case(status='New',Origin='Phone');
        insert caseInstance;
        //ApexPages.currentPage().getParameters().put('Id',caseInstance.Id);
       // HVEMKnowledgeArticleCtrlInstance = new HVEMKnowledgeArticleCtrl();
       // System.assertEquals(caseInstance.id,HVEMKnowledgeArticleCtrlInstance.caseId);
        HVEMKnowledgeArticleCtrlInstance.attachArticle();
    }*/
    /*static void setupDataForAttachArticle(){
        User u = [SELECT id,name FROM User WHERE id = :userInfo.getUserid()];
        caseInstance = new Case(status='New',Origin='Phone',Subject = 'Test Subject');
        insert caseInstance;
        EmailMessage emailmsg = new EmailMessage(ParentId=caseInstance.Id,HtmlBody ='This is HTML Body');
        insert emailmsg;
        EmailTemplate testTemp = new EmailTemplate(FolderId = u.Id,TemplateType = 'text',DeveloperName = 'TestDeveloper',Name= 'Test name',Subject = 'Test Subject',Body = 'Hello This is test body');
        selectedEmailTemplate = testTemp;
        System.runAs(u){
            insert testTemp;
        }
        if(HVEM_Config_Options__c.getInstance('HVEM') == null){
            configOptions = new HVEM_Config_Options__c(name='HVEM',Default_Email_Template__c = selectedEmailTemplate.Id, Data_Category_Group_Filter__c = 'ABC , DEF', Article_Types_Filter__c = 'FAQ , TEST');
            insert configOptions;
        }
        else{
            configOptions = HVEM_Config_Options__c.getInstance('HVEM');
        }

        
        ApexPages.currentPage().getParameters().put('Id',caseInstance.Id);
        HVEMKnowledgeArticleCtrlInstance = new HVEMKnowledgeArticleCtrl();
        
        
    }
   static testMethod void  testAttachArticle(){
        setupDataForAttachArticle();
        Test.startTest();
        
        HVEMKnowledgeArticleCtrlInstance.filterArticleList();
        //assertEquals(true,KnowledgeArticlesList.size()>0); 
        
        Test.stopTest();
    
    }*/

}