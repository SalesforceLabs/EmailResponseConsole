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
    static HVEM_Config_Options__c configIns;
    static ID kaID;
    static ID caseID;

     public static testMethod void testchannelVisibility(){
        setupDataInitPositive();
        Test.startTest();
        HVEMKnowledgeArticleCtrlInstance.channelVisibility();
        System.assertEquals(true,HVEMKnowledgeArticleCtrlInstance.IsVisiblePKB);
        HVEMKnowledgeArticleCtrlInstance.PKBChannelVisible = 'NotAvailable';
        HVEMKnowledgeArticleCtrlInstance.PRMChannelVisible = 'NotAvailable';
        HVEMKnowledgeArticleCtrlInstance.CSPChannelVisible = 'NotAvailable';
        HVEMKnowledgeArticleCtrlInstance.channelVisibility();
        Test.stopTest();
     }
     public static testMEthod void testControllerElse(){
        setupDataInit();
        Test.startTest();
        HVEMKnowledgeArticleCtrlInstance = new HVEMKnowledgeArticleCtrl();
        System.assertEquals(true,configOptions!=null);
        List<HVEM_Config_Options__c> configInsLst = new List<HVEM_Config_Options__c>();
        configInsLst = [select Id from HVEM_Config_Options__c];
        delete configInsLst;
        HVEMKnowledgeArticleCtrlInstance = new HVEMKnowledgeArticleCtrl();
        Test.stopTest();
     }
     public static void setDatafilterArticleList(){
        User u = [SELECT id,name FROM User WHERE id = :userInfo.getUserid()];
        caseInstance = new Case(status='New',Origin='Phone',Subject = '');
        upsert caseInstance;
        if(HVEM_Config_Options__c.getInstance('HVEM') == null){
            configOptions = new HVEM_Config_Options__c(name='HVEM',Data_Category_Group_Filter__c = 'CategoryTest , DEF', Article_Types_Filter__c = 'FAQ , TEST');
            insert configOptions;
        }
        else{
            configOptions = HVEM_Config_Options__c.getInstance('HVEM');
        }


        ApexPages.currentPage().getParameters().put('Id',caseInstance.Id);
        HVEMKnowledgeArticleCtrlInstance = new HVEMKnowledgeArticleCtrl();
     }
     public static testMethod void testfilterArticleList(){
        setDatafilterArticleList();
        Test.startTest();
        HVEMKnowledgeArticleCtrlInstance = new HVEMKnowledgeArticleCtrl();
        System.assertEquals(null,HVEMKnowledgeArticleCtrlInstance.subjectFilter);
        Test.stopTest();
     }
     public static testMethod void testUserLanguagesList(){
        setupDataInit();
        Test.startTest();
        List<SelectOption> selectOptionList = HVEMKnowledgeArticleCtrlInstance.getUserLanguagesList();
        System.assertEquals(true,selectOptionList.size()>0);
        System.assertEquals(true,configOptions!=null);
        Test.stopTest();
     }
     public static testMethod void testUserLanguagesListElse(){
        setupDataInit();
        Test.startTest();
        List<HVEM_Config_Options__c> configInsLst = new List<HVEM_Config_Options__c>();
        configInsLst = [select Id from HVEM_Config_Options__c];
        delete configInsLst;
        List<SelectOption> selectOptionList =  HVEMKnowledgeArticleCtrlInstance.getUserLanguagesList();
        System.assertEquals(true,configOptions!=null);
        Test.stopTest();
     }

    public static testMethod void testAttachArticle(){
        setupDataInit();
        HVEMKnowledgeArticleCtrlInstance.CaseId = caseID;
        HVEMKnowledgeArticleCtrlInstance.selectedKaId = kaID;
        Test.startTest();
        HVEMKnowledgeArticleCtrlInstance.attachArticle();

        List<CaseArticle> ca = [select id from CaseArticle where CaseId = :caseID and KnowledgeArticleId = :kaID];

        System.assertEquals(true,ca.size()==1);
        Test.stopTest();
    }

    private static void setupDataInitPositive(){
        configIns = new HVEM_Config_Options__c();
        configIns.name = 'Case Mapping';
        configIns.Case_Mappin_API__c = 'Status:New >> CategoryTest:All' ;
        configIns.Case_Mapping_Label__c = 'Status:New >> CategoryTest:All' ;
        configIns.Languages_Selected__c = 'English,en_US';
        insert configIns;
        String apiName = 'Status:New >> Category1:A;;';
        caseInstance = new Case(status='New',Origin='Phone',Subject = 'Test Subject');
        insert caseInstance;
        ApexPages.currentPage().getParameters().put('Id',caseInstance.Id);
        HVEMKnowledgeArticleCtrlInstance = new HVEMKnowledgeArticleCtrl();
        HVEMKnowledgeArticleCtrlInstance.getArticleTypesDevName();
        System.assertEquals(caseInstance.id,HVEMKnowledgeArticleCtrlInstance.caseId);
        HVEMKnowledgeArticleCtrlInstance.IsVisiblePKB = true;
        HVEMKnowledgeArticleCtrlInstance.IsVisiblePRM  = true;
        HVEMKnowledgeArticleCtrlInstance.IsVisibleCSP  = true;
        HVEMKnowledgeArticleCtrlInstance.PKBChannelVisible = 'Available';
        HVEMKnowledgeArticleCtrlInstance.PRMChannelVisible = 'Available';
        HVEMKnowledgeArticleCtrlInstance.CSPChannelVisible = 'Available';
    }

    private static void setupDataInit(){
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
            configOptions = new HVEM_Config_Options__c(name='HVEM',Default_Email_Template__c = selectedEmailTemplate.Id, Data_Category_Group_Filter__c = 'ABC , DEF', Article_Types_Filter__c = 'FAQ__kav',Languages_Selected__c='English,en_US');
            insert configOptions;
        }
        else{
            configOptions = HVEM_Config_Options__c.getInstance('HVEM');
        }

        ApexPages.currentPage().getParameters().put('Id',caseInstance.Id);
        HVEMKnowledgeArticleCtrlInstance = new HVEMKnowledgeArticleCtrl();
        System.assertEquals(caseInstance.id,HVEMKnowledgeArticleCtrlInstance.caseId);
        HVEMKnowledgeArticleCtrlInstance.getArticleTypesDevName();

        kaID = createArticle();
        caseID = createCase();
     }
    private static ID createArticle() {
        String objType;
        List<String> kavNames = new List<String>(getKavNames());
        if (kavNames.isEmpty()){
            return null;
        }
        objType = kavNames.get(0);

        SObject kavObj = Schema.getGlobalDescribe().get(objType).newSObject();
        kavObj.put('Title','Foo Foo Foo!!!');
        kavObj.put('UrlName', 'foo-foo-foo');
        kavObj.put('Summary', 'This is a summary!!! Foo. Foo. Foo.');
        kavObj.put('Language', 'en_US');
        insert kavObj;

        // requery the kavObj to get the KnowledgeArticleId on it that is created automatically
        String q = 'select id, KnowledgeArticleId from ' +objType+ ' where Id = \'' +kavObj.get('Id')+  '\' and PublishStatus = \'Draft\' and Language = \'en_US\'';
        List<SObject> kavs = Database.query(q);
        if (kavs.isempty()) {
            return null;
        }
        kavObj = kavs[0];
        KbManagement.PublishingService.publishArticle((ID)(kavObj.get('KnowledgeArticleId')),true);
        return (ID)(kavObj.get('KnowledgeArticleId'));
    }
    private static ID createCase() {

        Case c = new Case();
        c.Subject = 'foo';
        insert c;

        return c.Id;
    }

    private static Set<String> getKavNames() {
        Set<String> kavNames;
        kavNames = new Set<String>();
        Map<String,Schema.SOBjectType> gd = Schema.getGlobalDescribe();

        for (String s : gd.keySet()) {
            if (s.contains('__kav')) {
                kavNames.add(s);
            }
        }
        return kavNames;
    }

}
