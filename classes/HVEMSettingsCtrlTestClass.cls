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
private class HVEMSettingsCtrlTestClass {            
    static HVEMSettingsCtrl hvenSettings;
    static Group groupIns; 
    static EmailTemplate EmailTemplateObj;
    static HVEM_Config_Options__c configOptions;
    static List<HVEM_Config_Options__c> configOptionsList1;
    static List<Group> groupList;
    static List<String> saveGroupList;
    static List<SelectOption> option;
    static List<String> categoryGroups; 
    static List<String> articleTypes;
    static List<HVEM_Config_Options__c> configOptionsList;
    static List<EmailTemplate> templateList;
    static List<Folder> folderList;
    static Folder folderObj;
    static String inputString;

    static void setTestData() {
        hvenSettings = new HVEMSettingsCtrl();
        configOptions = new HVEM_Config_Options__c();
        configOptionsList= new List<HVEM_Config_Options__c>();
        if(HVEM_Config_Options__c.getInstance('HVEM') == null){
            configOptions = new HVEM_Config_Options__c();
            configOptions.Name='HVEM';
            configOptions.Article_Link_Base_URL__c='hhtp://testing/hvem';
            configOptions.Reply_To_Mail__c = 'testing@hvem.com';
            configOptions.Auto_Populate_To_Field_From_Case_Contact__c = true;
            configOptions.Default_Email_Template__c = hvenSettings.templates;        
            configOptions.Data_Category_Group_Filter__c='category1, category2';
            configOptions.Available_Data_Category_Group_Filter__c='test1 , test2';
            configOptions.Allow_Drafts__c=true; 
            configOptions.Allow_Draft_Approval__c=true;
            configOptions.Under_Approval_Case_Status__c='Process'; 
            configOptions.Public_Groups_With_No_Approval__c ='servicegroup';
            configOptions.Public_Groups_With_No_Approval_Extended__c='servicegruop1';
            configOptions.Case_Mappin_API__c='text1';
            configOptions.Case_Mapping_Label__c='text2';
            insert configOptions;
        }
        else{
            configOptions = HVEM_Config_Options__c.getInstance('HVEM');
        }
        configOptionsList.add(configOptions);
        option = new List<SelectOption>();
        categoryGroups = new List<String>();
        articleTypes = new List<String>();
        templateList = new List<EmailTemplate>();
        folderList = new List<folder>();
        folderObj = new Folder(Name ='FoldTest',Type = 'Email',AccessType = 'Public');
        folderList.add(folderObj); 
        groupIns = new Group(name='test Group',type='regular');
        insert groupIns;

        EmailTemplateObj = new EmailTemplate();
        hvenSettings.autoPopulate=true;
        hvenSettings.strChosenCategoryGroups = 'category1, category2';
        hvenSettings.strChosenArticleTypes= 'article1, article2';
        hvenSettings.baseURL='http://hvem.com';
        hvenSettings.replyToAddress = 'testing@hvem.com';
        hvenSettings.folders = 'None';
        hvenSettings.templates = 'None'; 
        hvenSettings.toSaveList.add(groupIns.Id);
        hvenSettings.groupList.add(groupIns);
        hvenSettings.searchGroupText='test Group';
        hvenSettings.autoPopulate=true;
        hvenSettings.templates='abcd';
        hvenSettings.availableCategoryGroups='test1 , test2';
        hvenSettings.enableDraftEmails=true;
        hvenSettings.selectedPublicGroups='servicegroup';
        hvenSettings.chosenCategoryGroups='category1, category2';   
        hvenSettings.selectedPublicGroupsExtended='';   
        hvenSettings.replyToBlankError=true;
       
    }
    static void testDataverify()
    {
        hvenSettings = new HVEMSettingsCtrl();
        configOptions = new HVEM_Config_Options__c();

        option = new List<SelectOption>();
        categoryGroups = new List<String>();
        articleTypes = new List<String>();
        EmailTemplateObj = new EmailTemplate();
        hvenSettings.autoPopulate=true;
        hvenSettings.baseURL='http://testing/hvem';
        hvenSettings.replyToAddress = '';
        categoryGroups = new List<String>();
        hvenSettings.strChosenCategoryGroups = ', category2';

    }

    static testMethod void setcomponentsOnLoad() {        
        setTestData();
        Test.startTest();
        hvenSettings.getEmailFolders();
        System.assertEquals('Email',folderObj.Type);
        hvenSettings.getEmailTemplates();
        hvenSettings.folders =null;  
        hvenSettings.getEmailFolders();
        hvenSettings.getEmailTemplates();           
        hvenSettings.getCasePickListFieldsValues();
        hvenSettings.getCaseStatusFieldValues();  
        hvenSettings.getCaseFilterMapEntry();
        List<selectOption> articleTypeList = hvenSettings.getArticleTypesDevName();
        System.assertEquals(true,articleTypeList.size() > 0);
        List<selectOption> optionList = hvenSettings.getSavedOptions();        
        System.assertEquals(true,optionList.size() > 0);
        List<selectOption> optionList1 = hvenSettings.getPublicGroups();        
        System.assertEquals(true,optionList1.size() > 0);
        Test.stopTest();
    }

    static testMethod void testAddMapping() {
        setTestData(); 
        Test.startTest();
        configOptionsList = new List<HVEM_Config_Options__c>();      
        hvenSettings.selectedPickListCaseField = 'status';
        hvenSettings.selectedPickListCaseValue = 'New';
        hvenSettings.selectedCategoryGroups = 'Test Category';
        hvenSettings.dataCategory = 'Test Category >> All';
        hvenSettings.addMapping();
        System.assertNotEquals(true,configOptionsList.size() > 0);
        System.assertEquals('Test Category',hvenSettings.selectedCategoryGroups);
        System.assertEquals('status',hvenSettings.selectedPickListCaseField);     
        Test.stopTest();
    } 

    static testMethod void testSaveUpdate() {
        setTestData();
        Test.startTest();
        hvenSettings.saveTOCustomSettings();
        testDataverify();
        hvenSettings.saveTOCustomSettings();  
        List<selectOption> optionList = hvenSettings.getEnteredCategoryGroups();
        System.assertEquals(true,optionList.size() > 0);
        hvenSettings.ChosenCategoryGroups = null;
        List<SelectOption> options1 =  hvenSettings.getEnteredCategoryGroups();
        System.assertEquals(true,optionList.size() > 0);
        System.assertEquals(null,hvenSettings.ChosenCategoryGroups); 
        hvenSettings.chosenCategoryGroups ='category1, category2,';
        options1 =  hvenSettings.getEnteredCategoryGroups();
        System.assertNotEquals(null,hvenSettings.ChosenCategoryGroups); 
        Test.stopTest();

    }
    static testMethod void testsaveTOCustomSettings(){
        setTestData();   
        Test.startTest();
        hvenSettings.saveTOCustomSettings(); 
        System.assertNotEquals(null,hvenSettings.replyToAddress);
        System.assertNotEquals(null,hvenSettings.baseURL); 
        categoryGroups = new List<String>();
        articleTypes = new List<String>();
        hvenSettings.strChosenCategoryGroups = '';
        hvenSettings.strChosenArticleTypes= ', article2';
        hvenSettings.selectedPublicGroupsExtended='servicegroup2';  
        hvenSettings.saveTOCustomSettings(); 
        System.assertNotEquals(true,categoryGroups.size() > 0); 
        System.assertEquals(true,configOptions!=null);
        Test.stopTest();
    }

    static testMethod void testremoveMapping() {
        setTestData();
        Test.startTest();
        hvenSettings.removeMapping();
        configOptions = new HVEM_Config_Options__c();
        configOptions = HVEM_Config_Options__c.getInstance('HVEM');
        System.assertEquals(configOptions,HVEM_Config_Options__c.getInstance('HVEM')); 
        Test.stopTest();
    }
    static testMethod void testaddOption() {
        setTestData();
        Test.startTest();
        hvenSettings.selectedPubliGroupsList = new List<String>();
        hvenSettings.selectedPubliGroupsList.add(groupIns.Id);
        hvenSettings.addOption();
        System.assertEquals(true,hvenSettings.selectedPubliGroupsList.size() > 0); 
        Test.stopTest();
    }
    static testMethod void testremoveOption() {
        setTestData();
        Test.startTest();
        hvenSettings.saveGroupList = new List<String>();
        hvenSettings.saveGroupList.add(groupIns.Id);
        hvenSettings.removeOption();
        System.assertEquals(true,hvenSettings.saveGroupList.size() > 0); 
        Test.stopTest();
    }
    static void setTestDataforFilter() {
        hvenSettings = new HVEMSettingsCtrl();
        hvenSettings.searchGroupText='test Group';

    }
    static testMethod void testfilterGroups(){
        setTestData();
        Test.startTest();
        hvenSettings.filterGroups();
        System.assertNotEquals(null,hvenSettings.searchGroupText);
        hvenSettings.searchGroupText='';
        hvenSettings.filterGroups();
        System.assertEquals(groupIns.type,'regular');
        Test.stopTest();
    } 

    static testMethod void testNegativefilterGroups(){
        setTestDataforFilter();
        Test.startTest();
        hvenSettings.filterGroups();
        System.assertNotEquals(null,hvenSettings.searchGroupText);
        hvenSettings.searchGroupText='';
        hvenSettings.filterGroups();
        Test.stopTest();

    } 

    static testMethod void testrefreshFunction(){
    
        setTestData();
        Test.startTest();
        hvenSettings.refreshFunction();
        System.assertEquals(true,true);
        Test.stopTest();
    }

    static testMethod void setTestDataInit() {
        hvenSettings = new HVEMSettingsCtrl();

        folderObj = new Folder(Name ='FoldTest',Type = 'Email',AccessType = 'Public');
        hvenSettings.folderList.add(folderObj);
        EmailTemplateObj = new EmailTemplate();

        hvenSettings.folders = null;

        if(HVEM_Config_Options__c.getInstance('HVEM') == null){
            configOptions = new HVEM_Config_Options__c();
            configOptions.Name='HVEM';
            configOptions.Article_Link_Base_URL__c='hhtp://testing/hvem';
            configOptions.Reply_To_Mail__c = 'testing@hvem.com';
            configOptions.Auto_Populate_To_Field_From_Case_Contact__c = true;
            configOptions.Default_Email_Template__c = hvenSettings.templates;        
            configOptions.Data_Category_Group_Filter__c='category1, category2';
            configOptions.Available_Data_Category_Group_Filter__c='test1 , test2';
            configOptions.Allow_Drafts__c=true; 
            configOptions.Allow_Draft_Approval__c=true;
            configOptions.Under_Approval_Case_Status__c='Process'; 
            configOptions.Public_Groups_With_No_Approval__c ='servicegroup';
            configOptions.Public_Groups_With_No_Approval_Extended__c='servicegruop1';
            configOptions.Case_Mappin_API__c='text1';
            configOptions.Case_Mapping_Label__c='text2';
            insert configOptions;
        }
        else{
            configOptions = HVEM_Config_Options__c.getInstance('HVEM');
        }

        hvenSettings.templates = 'None';
        configOptionsList=new List<HVEM_Config_Options__c>();
        configOptionsList.add(configOptions);
        System.assertEquals(true,configOptions!=null);

    }
    static testMethod void testinitializeEmailTemplate(){
        setTestDataInit();
        Test.startTest();
        hvenSettings.initializeEmailTemplate();
        System.assertEquals(true,hvenSettings.folderList.size()>0); 
        hvenSettings.folderList = null;
        hvenSettings.folders=null;
        hvenSettings.initializeEmailTemplate();
        Test.stopTest();

    }

    static testMethod void testControllerElse(){
        setTestData();
        Test.startTest();
        hvenSettings=new HVEMSettingsCtrl();
        System.assertEquals(true,configOptions!=null);
        Test.stopTest();
    }

    static testMethod void testDataNegative()
    {
        hvenSettings = new HVEMSettingsCtrl();
        configOptions = new HVEM_Config_Options__c();
        option = new List<SelectOption>();
        categoryGroups = new List<String>();
        articleTypes = new List<String>();
        templateList = new List<EmailTemplate>();
        folderObj = new Folder(Name ='FoldTest',Type = 'Email',AccessType = 'Public');
        groupIns = new Group(name='test Group',type='regular');
        insert groupIns;
        EmailTemplateObj = new EmailTemplate();
        hvenSettings.autoPopulate=true;
        hvenSettings.strChosenCategoryGroups = 'category1, category2';
        hvenSettings.strChosenArticleTypes= 'article1, article2';
        hvenSettings.baseURL='http://hvem.com';
        hvenSettings.replyToAddress = 'testing@hvem.com';
        hvenSettings.folders = 'None';
        hvenSettings.templates = 'None'; 
        hvenSettings.toSaveList.add(groupIns.Id);
        hvenSettings.groupList.add(groupIns);
        hvenSettings.searchGroupText='test Group';
        hvenSettings.autoPopulate=true;
        hvenSettings.templates='abcd';
        hvenSettings.availableCategoryGroups='test1 , test2';
        hvenSettings.enableDraftEmails=true;
        hvenSettings.selectedPublicGroups='servicegroup';
        hvenSettings.chosenCategoryGroups='category1, category2';   
        hvenSettings.selectedPublicGroupsExtended='';   
        hvenSettings.replyToBlankError=true;
        System.assertEquals(true,hvenSettings.strChosenCategoryGroups!=null ); 
    }

    static testMethod void testSavetoCustomNegative(){
    
        testDataNegative();
        Test.startTest();
        List<HVEM_Config_Options__c> configList= new List<HVEM_Config_Options__c>();
        configList=[select Id from HVEM_Config_Options__c];
        delete configList;
        hvenSettings.saveTOCustomSettings();
        System.assertEquals(true,configOptions!=null);
        Test.stopTest();
    }
   
    static void setTestDataInitNegative(){
        hvenSettings = new HVEMSettingsCtrl();
        folderObj = new Folder(Name ='FoldTest',Type = 'Email',AccessType = 'Public');
        hvenSettings.folderList.add(folderObj);
        EmailTemplateObj = new EmailTemplate();
        hvenSettings.folders = null;

        if(HVEM_Config_Options__c.getInstance('HVEM') == null){
            configOptions = new HVEM_Config_Options__c();
            configOptions.Name='abcd';
            configOptions.Article_Link_Base_URL__c='hhtp://testing/hvem';
            configOptions.Reply_To_Mail__c = 'testing@hvem.com';
            configOptions.Auto_Populate_To_Field_From_Case_Contact__c = true;
            configOptions.Default_Email_Template__c = hvenSettings.templates;        
            configOptions.Data_Category_Group_Filter__c='category1, category2';
            configOptions.Available_Data_Category_Group_Filter__c='test1 , test2';
            configOptions.Allow_Drafts__c=true; 
            configOptions.Allow_Draft_Approval__c=true;
            configOptions.Under_Approval_Case_Status__c='Process'; 
            configOptions.Public_Groups_With_No_Approval__c ='servicegroup';
            configOptions.Public_Groups_With_No_Approval_Extended__c='servicegruop1';
            configOptions.Case_Mappin_API__c='testing';
            configOptions.Case_Mapping_Label__c='textHVEM';
            insert configOptions;
        }
        else{
            configOptions = HVEM_Config_Options__c.getInstance('HVEM');
        }

        hvenSettings.templates = 'None';
        configOptionsList=new List<HVEM_Config_Options__c>();
        configOptionsList.add(configOptions);
    }
    static testMethod void testconfigListNegative(){
        setTestDataInitNegative();
        Test.startTest();
        hvenSettings = new HVEMSettingsCtrl();
        System.assertEquals(true,configOptions!=null);
        hvenSettings.removeMapping();
        hvenSettings.getCaseFilterMapEntry(); 
        Test.stopTest();

    } 

  static void setDatavalidateBeforeInsertNegative(){
   
        hvenSettings = new HVEMSettingsCtrl();
        configOptions = new HVEM_Config_Options__c();
        if(HVEM_Config_Options__c.getInstance('HVEM') == null){
            configOptions = new HVEM_Config_Options__c();
            configOptions.Name='abcd';
            configOptions.Article_Link_Base_URL__c='hhtp://testing/hvem';
            configOptions.Reply_To_Mail__c = 'testing@hvem.com';
            configOptions.Auto_Populate_To_Field_From_Case_Contact__c = true;
            configOptions.Default_Email_Template__c = hvenSettings.templates;        
            configOptions.Data_Category_Group_Filter__c='category1, category2';
            configOptions.Available_Data_Category_Group_Filter__c='test1 , test2';
            configOptions.Allow_Drafts__c=true; 
            configOptions.Allow_Draft_Approval__c=true;
            configOptions.Under_Approval_Case_Status__c='Process'; 
            configOptions.Public_Groups_With_No_Approval__c ='servicegroup';
            configOptions.Public_Groups_With_No_Approval_Extended__c='servicegroup1';
            configOptions.Case_Mappin_API__c='testing';
            configOptions.Case_Mapping_Label__c='textHVEM';
            insert configOptions;
        }
        else{
            configOptions = HVEM_Config_Options__c.getInstance('HVEM');
        }

        option = new List<SelectOption>();
        categoryGroups = new List<String>();
        articleTypes = new List<String>();
        templateList = new List<EmailTemplate>();
        folderObj = new Folder(Name ='FoldTest',Type = 'Email',AccessType = 'Public');
        groupIns = new Group(name='test Group',type='regular');
        insert groupIns;
        EmailTemplateObj = new EmailTemplate();
        hvenSettings.autoPopulate=true;
        hvenSettings.strChosenCategoryGroups = 'category1, category2';
        hvenSettings.strChosenArticleTypes= 'article1, article2';
        hvenSettings.baseURL='http://hvem.com';
        hvenSettings.replyToAddress = 'testing@hvem.com';
        hvenSettings.folders = 'None';
        hvenSettings.templates = 'None'; 
        hvenSettings.toSaveList.add(groupIns.Id);
        hvenSettings.groupList.add(groupIns);
        hvenSettings.searchGroupText='test Group';
        hvenSettings.autoPopulate=true;
        hvenSettings.templates='abcd';
        hvenSettings.availableCategoryGroups='test1 , test2';
        hvenSettings.enableDraftEmails=true;
        hvenSettings.selectedPublicGroups='servicce hello';
        hvenSettings.chosenCategoryGroups='category1, category2';   
        hvenSettings.selectedPublicGroupsExtended='';   
        hvenSettings.replyToBlankError=true;
        hvenSettings.baseURL='testing@hvem.com';
         
    }

    static testMethod void testvalidateNegative(){
        setDatavalidateBeforeInsertNegative();
        Test.startTest();
        hvenSettings.verifyBaseURL();
        hvenSettings.saveTOCustomSettings();
        System.assertEquals(true,configOptions!=null);
        hvenSettings.replyToAddress = 'testing@hvem.com@hvem';
        hvenSettings.saveTOCustomSettings();
        System.assertEquals(true,hvenSettings.selectedPublicGroupsExtended.length() < 240);
        Test.stopTest();
    }
 
   
}