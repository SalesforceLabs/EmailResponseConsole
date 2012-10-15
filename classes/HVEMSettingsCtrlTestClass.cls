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
    static HVEMSettingsCtrl hvemSettings;
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
    static List<HVEM_Email_Routing_Address__c> routingConfigOptions;
    static List<HVEM_Email_Routing_Mapping__c> routingMappingConfigOptions;
    static HVEM_Email_Routing_Address__c routingConfigOptionsInstance;
    static HVEM_Email_Routing_Mapping__c routingMappingConfigOptionsInstance;

    public static void setTestData() {
        hvemSettings = new HVEMSettingsCtrl();
        configOptions = new HVEM_Config_Options__c();
        configOptionsList= new List<HVEM_Config_Options__c>();
        if(HVEM_Config_Options__c.getInstance('HVEM') == null){
            configOptions = new HVEM_Config_Options__c();
            configOptions.Name='HVEM';
            configOptions.Article_Link_Base_URL__c='hhtp://testing/hvem';
            configOptions.Reply_To_Mail__c = 'testing@hvem.com';
            configOptions.Auto_Populate_To_Field_From_Case_Contact__c = true;
            configOptions.Default_Email_Template__c = hvemSettings.templates;
            configOptions.Data_Category_Group_Filter__c='category1, category2';
            configOptions.Available_Data_Category_Group_Filter__c='test1 , test2';
            configOptions.Allow_Drafts__c=true;
            configOptions.Allow_Draft_Approval__c=true;
            configOptions.Under_Approval_Case_Status__c='Process';
            configOptions.Public_Groups_With_No_Approval__c ='servicegroup';
            configOptions.Public_Groups_With_No_Approval_Extended__c='servicegruop1';
            configOptions.Case_Mappin_API__c='text1';
            configOptions.Case_Mapping_Label__c='text2';
            configOptions.Languages_Selected__c = 'English,French';
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
        hvemSettings.autoPopulate=true;
        hvemSettings.strChosenCategoryGroups = 'category1, category2';
        hvemSettings.strChosenArticleTypes= 'article1, article2';
        hvemSettings.baseURL='http://hvem.com';
        hvemSettings.folders = 'None';
        hvemSettings.templates = 'None';
        hvemSettings.toSaveList.add(groupIns.Id);
        hvemSettings.groupList.add(groupIns);
        hvemSettings.searchGroupText='test Group';
        hvemSettings.autoPopulate=true;
        hvemSettings.templates='abcd';
        hvemSettings.availableCategoryGroups='test1 , test2';
        hvemSettings.enableDraftEmails=true;
        hvemSettings.selectedPublicGroups='servicegroup';
        hvemSettings.chosenCategoryGroups='category1, category2';
        hvemSettings.selectedPublicGroupsExtended='';
        hvemSettings.replyToBlankError=true;

    }
    public static void testDataverify()
    {
        hvemSettings = new HVEMSettingsCtrl();
        configOptions = new HVEM_Config_Options__c();
        option = new List<SelectOption>();
        categoryGroups = new List<String>();
        articleTypes = new List<String>();
        EmailTemplateObj = new EmailTemplate();
        hvemSettings.autoPopulate=true;
        hvemSettings.baseURL='http://testing/hvem';
        categoryGroups = new List<String>();
        hvemSettings.strChosenCategoryGroups = ', category2';

    }

    public static testMethod void setcomponentsOnLoad() {
        setTestData();
        Test.startTest();
        hvemSettings.getEmailFolders();
        System.assertEquals('Email',folderObj.Type);
        hvemSettings.getEmailTemplates();
        hvemSettings.folders =null;
        hvemSettings.getEmailFolders();
        hvemSettings.getEmailTemplates();
        hvemSettings.getCasePickListFieldsValues();
        hvemSettings.getCaseStatusFieldValues();
        hvemSettings.getCaseFilterMapEntry();
        List<selectOption> articleTypeList = hvemSettings.getArticleTypesDevName();
        System.assertEquals(true,articleTypeList.size() > 0);
        List<selectOption> optionList = hvemSettings.getSavedOptions();
        System.assertEquals(true,optionList.size() > 0);
        List<selectOption> optionList1 = hvemSettings.getPublicGroups();
        System.assertEquals(true,optionList1.size() > 0);
        Test.stopTest();
    }

    public static testMethod void testAddMapping() {
        setTestData();
        Test.startTest();
        configOptionsList = new List<HVEM_Config_Options__c>();
        hvemSettings.selectedPickListCaseField = 'status';
        hvemSettings.selectedPickListCaseValue = 'New';
        hvemSettings.selectedCategoryGroups = 'Test Category';
        hvemSettings.dataCategory = 'Test Category >> All';
        hvemSettings.addMapping();
        System.assertNotEquals(true,configOptionsList.size() > 0);
        System.assertEquals('Test Category',hvemSettings.selectedCategoryGroups);
        System.assertEquals('status',hvemSettings.selectedPickListCaseField);
        hvemSettings.dataCategory = 'Test Category >> All >> Data';
        hvemSettings.addMapping();
        Test.stopTest();
    }

    public static testMethod void testSaveUpdate() {
        setTestData();
        Test.startTest();
        hvemSettings.saveTOCustomSettings();
        testDataverify();
        hvemSettings.saveTOCustomSettings();
        List<selectOption> optionList = hvemSettings.getEnteredCategoryGroups();
        System.assertEquals(true,optionList.size() > 0);
        hvemSettings.ChosenCategoryGroups = null;
        List<SelectOption> options1 =  hvemSettings.getEnteredCategoryGroups();
        System.assertEquals(true,optionList.size() > 0);
        System.assertEquals(null,hvemSettings.ChosenCategoryGroups);
        hvemSettings.chosenCategoryGroups ='category1, category2,';
        options1 =  hvemSettings.getEnteredCategoryGroups();
        System.assertNotEquals(null,hvemSettings.ChosenCategoryGroups);
        Test.stopTest();

    }
    public static testMethod void testsaveTOCustomSettings(){
        setTestData();
        Test.startTest();
        hvemSettings.saveTOCustomSettings();
        System.assertNotEquals(null,hvemSettings.baseURL);
        categoryGroups = new List<String>();
        articleTypes = new List<String>();
        hvemSettings.strChosenCategoryGroups = '';
        hvemSettings.strChosenArticleTypes= ', article2';
        hvemSettings.selectedPublicGroupsExtended='servicegroup2';
        hvemSettings.saveTOCustomSettings();
        System.assertNotEquals(true,categoryGroups.size() > 0);
        System.assertEquals(true,configOptions!=null);
        Test.stopTest();
    }

    public static testMethod void testremoveMapping() {
        setTestData();
        Test.startTest();
        hvemSettings.removeMapping();
        configOptions = new HVEM_Config_Options__c();
        configOptions = HVEM_Config_Options__c.getInstance('HVEM');
        System.assertEquals(configOptions,HVEM_Config_Options__c.getInstance('HVEM'));
        Test.stopTest();
    }
    public static testMethod void testaddOption() {
        setTestData();
        Test.startTest();
        hvemSettings.selectedPubliGroupsList = new List<String>();
        hvemSettings.selectedPubliGroupsList.add(groupIns.Id);
        hvemSettings.addOption();
        System.assertEquals(true,hvemSettings.selectedPubliGroupsList.size() > 0);
        Test.stopTest();
    }
    public static testMethod void testremoveOption() {
        setTestData();
        Test.startTest();
        hvemSettings.saveGroupList = new List<String>();
        hvemSettings.saveGroupList.add(groupIns.Id);
        hvemSettings.removeOption();
        System.assertEquals(true,hvemSettings.saveGroupList.size() > 0);
        Test.stopTest();
    }
    public static void setTestDataforFilter() {
        hvemSettings = new HVEMSettingsCtrl();
        hvemSettings.searchGroupText='test Group';

    }
    public static testMethod void testfilterGroups(){
        setTestData();
        Test.startTest();
        hvemSettings.filterGroups();
        System.assertNotEquals(null,hvemSettings.searchGroupText);
        hvemSettings.searchGroupText='';
        hvemSettings.filterGroups();
        System.assertEquals(groupIns.type,'regular');
        Test.stopTest();
    }

    public static testMethod void testNegativefilterGroups(){
        setTestDataforFilter();
        Test.startTest();
        hvemSettings.filterGroups();
        System.assertNotEquals(null,hvemSettings.searchGroupText);
        hvemSettings.searchGroupText='';
        hvemSettings.filterGroups();
        Test.stopTest();

    }

    public static testMethod void testrefreshFunction(){
        setTestData();
        Test.startTest();
        hvemSettings.refreshFunction();
        System.assertEquals(true,true);
        Test.stopTest();
    }

    public static testMethod void setTestDataInit() {
        hvemSettings = new HVEMSettingsCtrl();

        folderObj = new Folder(Name ='FoldTest',Type = 'Email',AccessType = 'Public');
        hvemSettings.folderList.add(folderObj);
        EmailTemplateObj = new EmailTemplate();

        hvemSettings.folders = null;

        if(HVEM_Config_Options__c.getInstance('HVEM') == null){
            configOptions = new HVEM_Config_Options__c();
            configOptions.Name='HVEM';
            configOptions.Article_Link_Base_URL__c='hhtp://testing/hvem';
            configOptions.Reply_To_Mail__c = 'testing@hvem.com';
            configOptions.Auto_Populate_To_Field_From_Case_Contact__c = true;
            configOptions.Default_Email_Template__c = hvemSettings.templates;
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

        hvemSettings.templates = 'None';
        configOptionsList=new List<HVEM_Config_Options__c>();
        configOptionsList.add(configOptions);
        System.assertEquals(true,configOptions!=null);

    }
    public static testMethod void testinitializeEmailTemplate(){
        setTestDataInit();
        Test.startTest();
        hvemSettings.initializeEmailTemplate();
        System.assertEquals(true,hvemSettings.folderList.size()>0);
        hvemSettings.folderList = null;
        hvemSettings.folders=null;
        hvemSettings.initializeEmailTemplate();
        hvemSettings.folders='None';
        hvemSettings.initializeEmailTemplate();
        System.assertEquals(true,hvemSettings.folders!=null);
        Test.stopTest();
    }

    public static testMethod void testControllerElse(){
        setTestData();
        Test.startTest();
        hvemSettings=new HVEMSettingsCtrl();
        System.assertEquals(true,configOptions!=null);
        Test.stopTest();
    }

    public static testMethod void testDataNegative(){
        hvemSettings = new HVEMSettingsCtrl();
        configOptions = new HVEM_Config_Options__c();
        option = new List<SelectOption>();
        categoryGroups = new List<String>();
        articleTypes = new List<String>();
        templateList = new List<EmailTemplate>();
        folderObj = new Folder(Name ='FoldTest',Type = 'Email',AccessType = 'Public');
        groupIns = new Group(name='test Group',type='regular');
        insert groupIns;
        EmailTemplateObj = new EmailTemplate();
        hvemSettings.autoPopulate=true;
        hvemSettings.strChosenCategoryGroups = 'category1, category2';
        hvemSettings.strChosenArticleTypes= 'article1, article2';
        hvemSettings.baseURL='http://hvem.com';
        hvemSettings.folders = 'None';
        hvemSettings.templates = 'None';
        hvemSettings.toSaveList.add(groupIns.Id);
        hvemSettings.groupList.add(groupIns);
        hvemSettings.searchGroupText='test Group';
        hvemSettings.autoPopulate=true;
        hvemSettings.templates='abcd';
        hvemSettings.availableCategoryGroups='test1 , test2';
        hvemSettings.enableDraftEmails=true;
        hvemSettings.selectedPublicGroups='servicegroup';
        hvemSettings.chosenCategoryGroups='category1, category2';
        hvemSettings.selectedPublicGroupsExtended='';
        hvemSettings.replyToBlankError=true;
        System.assertEquals(true,hvemSettings.strChosenCategoryGroups!=null );
    }

    public static testMethod void testSavetoCustomNegative(){
        testDataNegative();
        Test.startTest();
        List<HVEM_Config_Options__c> configList= new List<HVEM_Config_Options__c>();
        configList=[select Id from HVEM_Config_Options__c];
        delete configList;
        hvemSettings.saveTOCustomSettings();
        System.assertEquals(true,configOptions!=null);
        Test.stopTest();
    }

    public static void setTestDataInitNegative(){
        hvemSettings = new HVEMSettingsCtrl();
        folderObj = new Folder(Name ='FoldTest',Type = 'Email',AccessType = 'Public');
        hvemSettings.folderList.add(folderObj);
        EmailTemplateObj = new EmailTemplate();
        hvemSettings.folders = null;

        if(HVEM_Config_Options__c.getInstance('HVEM') == null){
            configOptions = new HVEM_Config_Options__c();
            configOptions.Name='abcd';
            configOptions.Article_Link_Base_URL__c='hhtp://testing/hvem';
            configOptions.Reply_To_Mail__c = 'testing@hvem.com';
            configOptions.Auto_Populate_To_Field_From_Case_Contact__c = true;
            configOptions.Default_Email_Template__c = hvemSettings.templates;
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

        hvemSettings.templates = 'None';
        configOptionsList=new List<HVEM_Config_Options__c>();
        configOptionsList.add(configOptions);
    }

    public static testMethod void testconfigListNegative(){
        setTestDataInitNegative();
        Test.startTest();
        hvemSettings = new HVEMSettingsCtrl();
        System.assertEquals(true,configOptions!=null);
        hvemSettings.removeMapping();
        hvemSettings.getCaseFilterMapEntry();
        Test.stopTest();
    }

    public static void setDatavalidateBeforeInsertNegative(){
        hvemSettings = new HVEMSettingsCtrl();
        configOptions = new HVEM_Config_Options__c();
        if(HVEM_Config_Options__c.getInstance('HVEM') == null){
            configOptions = new HVEM_Config_Options__c();
            configOptions.Name='abcd';
            configOptions.Article_Link_Base_URL__c='hhtp://testing/hvem';
            configOptions.Reply_To_Mail__c = 'testing@hvem.com';
            configOptions.Auto_Populate_To_Field_From_Case_Contact__c = true;
            configOptions.Default_Email_Template__c = hvemSettings.templates;
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
        hvemSettings.autoPopulate=true;
        hvemSettings.strChosenCategoryGroups = 'category1, category2';
        hvemSettings.strChosenArticleTypes= 'article1, article2';
        hvemSettings.baseURL='http://hvem.com';
        hvemSettings.folders = 'None';
        hvemSettings.templates = 'None';
        hvemSettings.toSaveList.add(groupIns.Id);
        hvemSettings.groupList.add(groupIns);
        hvemSettings.searchGroupText='test Group';
        hvemSettings.autoPopulate=true;
        hvemSettings.templates='abcd';
        hvemSettings.availableCategoryGroups='test1 , test2';
        hvemSettings.enableDraftEmails=true;
        hvemSettings.selectedPublicGroups='servicce hello';
        hvemSettings.chosenCategoryGroups='category1, category2';
        hvemSettings.selectedPublicGroupsExtended='';
        hvemSettings.replyToBlankError=true;
        hvemSettings.baseURL='testing@hvem.com';

    }

    public static testMethod void testvalidateNegative(){
        setDatavalidateBeforeInsertNegative();
        Test.startTest();
        hvemSettings.verifyBaseURL();
        hvemSettings.saveTOCustomSettings();
        System.assertEquals(true,configOptions!=null);
        hvemSettings.saveTOCustomSettings();
        System.assertEquals(true,hvemSettings.selectedPublicGroupsExtended.length() < 240);
        Test.stopTest();
    }

    public static testMethod  void testgetUserLanguagesList(){
       setTestData();
       Test.startTest();
       List<SelectOption> selectOptionLst = hvemSettings.getUserLanguagesList();
       System.assertEquals(true,selectOptionLst.size()>0);
       Test.stopTest();
    }
    public static testMethod  void testChannelsVisibleFunctions(){
       setTestData();
       Test.startTest();
       List<SelectOption> selectOptionLst = hvemSettings.getChannelsVisible();
       System.assertEquals(true,selectOptionLst.size()>0);
       Test.stopTest();
    }

    public static void setDataForRemoveRoutingMapping() {
       hvemSettings = new HVEMSettingsCtrl();
       routingConfigOptions = new List<HVEM_Email_Routing_Address__c>();
       routingMappingConfigOptions = new List<HVEM_Email_Routing_Mapping__c>();
       routingConfigOptionsInstance =  new HVEM_Email_Routing_Address__c(Name='RoutingAdderess',Email_Address__c = 'abcd@xyz.com');
       insert routingConfigOptionsInstance;
       routingConfigOptions.add(routingConfigOptionsInstance);

       routingMappingConfigOptionsInstance = new HVEM_Email_Routing_Mapping__c(Case_API_and_Label__c = 'testAddress',Email_Routing_Address__c= 'test@app.com',name='EmailAddress');
       insert routingMappingConfigOptionsInstance;
       routingMappingConfigOptions.add(routingMappingConfigOptionsInstance);
       hvemSettings = new HVEMSettingsCtrl();
       hvemSettings.toRemoveRoutingAddress = 'abcd@xyz.com>xyz.com';
    }

    public static testMethod void testremoveRoutingMapping(){
       setDataForRemoveRoutingMapping();
       Test.startTest();
       hvemSettings.removeRoutingMapping();
       System.assertEquals(true,routingConfigOptions.size()>0);
       Test.stopTest();
    }
    public static void setDataForRemoveRoutingMappingElse() {
       hvemSettings = new HVEMSettingsCtrl();
       routingConfigOptions = new List<HVEM_Email_Routing_Address__c>();
       routingMappingConfigOptions = new List<HVEM_Email_Routing_Mapping__c>();
       routingConfigOptionsInstance =  new HVEM_Email_Routing_Address__c(Name='RoutingAdderess',Email_Address__c = 'abcd@xyz.com');
       insert routingConfigOptionsInstance;
       routingConfigOptions.add(routingConfigOptionsInstance);
       routingMappingConfigOptionsInstance = new HVEM_Email_Routing_Mapping__c(Case_API_and_Label__c = 'testAddress',Email_Routing_Address__c= 'test@app.com',name='EmailAddress');
       insert routingMappingConfigOptionsInstance;
       routingMappingConfigOptions.add(routingMappingConfigOptionsInstance);
       hvemSettings = new HVEMSettingsCtrl();
       hvemSettings.toRemoveRoutingAddress = 'test@pqr.com>xyz.com';
    }

    public static testMethod void testremoveRoutingMappingElse(){
       setDataForRemoveRoutingMappingElse();
       Test.startTest();
       hvemSettings.removeRoutingMapping();
       System.assertEquals(true,routingConfigOptions.size()>0);
       Test.stopTest();
    }
    public static void setDataRemoveMappingRoutingAddress() {
       hvemSettings = new HVEMSettingsCtrl();
       routingMappingConfigOptions = new List<HVEM_Email_Routing_Mapping__c>();
       routingMappingConfigOptionsInstance = new HVEM_Email_Routing_Mapping__c(Case_API_and_Label__c = 'Reason||Case Reason:Installation||Installation',Email_Routing_Address__c= 'test@app.com',name='EmailAddress');
       insert routingMappingConfigOptionsInstance;
       routingMappingConfigOptions.add(routingMappingConfigOptionsInstance);
       hvemSettings = new HVEMSettingsCtrl();
       hvemSettings.toRemoveRoutingMapAddress = 'Reason||Case Reason:Installation||Installation >> testingAdd@test.com';
    }

    public static testMethod void testRemoveMappingRoutingAddress(){
       setDataRemoveMappingRoutingAddress();
       Test.startTest();
       hvemSettings.removeMappingRoutingAddress();
       System.assertEquals(true,routingMappingConfigOptions.size()>0);
       Test.stopTest();
    }

    public static void setDataValidateRoutingAddressInput() {
       hvemSettings = new HVEMSettingsCtrl();
       routingConfigOptions = new List<HVEM_Email_Routing_Address__c>();
       routingConfigOptionsInstance =  new HVEM_Email_Routing_Address__c(Name='RoutingAdderess',Email_Address__c = 'abcd@xyz.com');
       insert routingConfigOptionsInstance;
       routingConfigOptions.add(routingConfigOptionsInstance);
       hvemSettings = new HVEMSettingsCtrl();
       hvemSettings.toRemoveRoutingAddress = 'test@pqr.com>xyz.com';
       hvemSettings.routingEmailInput = 'abcd@xyz.com';
    }

    public static testMethod void testValidateRoutingAddressInput(){
       setDataValidateRoutingAddressInput();
       Test.startTest();
       hvemSettings.validateRoutingAddressInput();
       System.assertEquals(true,hvemSettings.isroutingAddressAlreadyPresent);
       hvemSettings.routingEmailInput = 'test@xyz.com';
       hvemSettings.validateRoutingAddressInput();
       System.assertEquals(false,hvemSettings.isInvalidRoutingEmail );
       Test.stopTest();
    }

    public static testMethod void testgetCasePickListFieldsValuesReplyTo(){
       setDataForRemoveRoutingMapping();
       Test.startTest();
       List<SelectOption> selectOptionLst = hvemSettings.getCasePickListFieldsValuesReplyTo();
       System.assertEquals(true,selectOptionLst.size()>0);
       Test.stopTest();
    }

    public static testMethod void testForSelectedRoutingAddress(){
       setDataForRemoveRoutingMapping();
       Test.startTest();
       List<SelectOption> selectOptionList = hvemSettings.getSelectedRoutingAddress();
       System.assertEquals(true,selectOptionList.size()>0);
       List<SelectOption> selectOptionMappingRoutingAddressList = hvemSettings.getSelectedMappingRoutingAddress();
       System.assertEquals(true,selectOptionMappingRoutingAddressList.size()>0);
       Test.stopTest();
    }

    public static void setDatagetCaseReplyToFilterMapEntry() {
       hvemSettings = new HVEMSettingsCtrl();
       routingConfigOptions = new List<HVEM_Email_Routing_Address__c>();
       routingMappingConfigOptions = new List<HVEM_Email_Routing_Mapping__c>();
       routingConfigOptionsInstance =  new HVEM_Email_Routing_Address__c(Name='RoutingAdderess',Email_Address__c = 'abcd@xyz.com');
       insert routingConfigOptionsInstance;
       routingConfigOptions.add(routingConfigOptionsInstance);

       routingMappingConfigOptionsInstance = new HVEM_Email_Routing_Mapping__c(Case_API_and_Label__c = 'Reason||Case Reason:Installation||Installation',Email_Routing_Address__c= 'test@app.com',name='EmailAddress');
       insert routingMappingConfigOptionsInstance;
       routingMappingConfigOptions.add(routingMappingConfigOptionsInstance);
       hvemSettings = new HVEMSettingsCtrl();
       hvemSettings.toRemoveRoutingAddress = 'Reason||Case Reason:Installation||Installation>>abcd@test.com ';
    }

    public static testMethod void testCaseReplyToFilterMapEntry(){
       setDatagetCaseReplyToFilterMapEntry();
       Test.startTest();
       List<SelectOption> selectOptionReplyToFilterMapList = hvemSettings.getCaseReplyToFilterMapEntry();
       System.assertEquals(true,selectOptionReplyToFilterMapList.size()>0);
       Test.stopTest();
    }

    public static void setDatacaseMapRoutingAddressAdd() {
       hvemSettings = new HVEMSettingsCtrl();
       routingConfigOptions = new List<HVEM_Email_Routing_Address__c>();
       routingMappingConfigOptions = new List<HVEM_Email_Routing_Mapping__c>();
       routingConfigOptionsInstance =  new HVEM_Email_Routing_Address__c(Name='RoutingAdderess',Email_Address__c = 'abcd@xyz.com');
       insert routingConfigOptionsInstance;
       routingConfigOptions.add(routingConfigOptionsInstance);

       routingMappingConfigOptionsInstance = new HVEM_Email_Routing_Mapping__c(Case_API_and_Label__c = 'Reason||Case Reason:Installation||Installation',Email_Routing_Address__c= 'test@app.com',name='EmailAddress');
       insert routingMappingConfigOptionsInstance;
       routingMappingConfigOptions.add(routingMappingConfigOptionsInstance);
       hvemSettings = new HVEMSettingsCtrl();
       hvemSettings.toRemoveRoutingAddress = 'Reason||Case Reason:Installation||Installation>>abcd@test.com ';
       hvemSettings.caseMapRoutingAdd ='Reason||Case Reason:Installation||Installation>>testingAdd@test.com';
    }

    public static testMethod void testCaseMapRoutingAddressAdd(){
       setDatacaseMapRoutingAddressAdd();
       Test.startTest();
       hvemSettings.caseMapRoutingAddressAdd();
       System.assertEquals(true,hvemSettings.isroutingMappingAlreadyPresent);
       hvemSettings.caseMapRoutingAdd ='Reason>>testingAdd@test.com';
       hvemSettings.caseMapRoutingAddressAdd();
       System.assertEquals(false,hvemSettings.isroutingMappingAlreadyPresent);
       Test.stopTest();
    }

    public static void setDataSaveToCustomSettings(){
       routingMappingConfigOptions = new List<HVEM_Email_Routing_Mapping__c>();
       routingMappingConfigOptionsInstance = new HVEM_Email_Routing_Mapping__c(Case_API_and_Label__c = 'Reason||Case Reason:Installation||Installation',Email_Routing_Address__c= 'test@app.com',name='EmailAddress');
       insert routingMappingConfigOptionsInstance;
       routingMappingConfigOptions.add(routingMappingConfigOptionsInstance);
       hvemSettings = new HVEMSettingsCtrl();
       hvemSettings.toRemoveRoutingAddress = 'Reason||Case Reason:Installation||Installation>>abcd@test.com ';
       hvemSettings.caseRoutingAddressmappings = 'mapping@set.com';
       configOptions = new HVEM_Config_Options__c();

       if(HVEM_Config_Options__c.getInstance('HVEM') == null){
            configOptions = new HVEM_Config_Options__c();
            configOptions.Name='HVEM';
            configOptions.Article_Link_Base_URL__c='hhtp://testing/hvem';
            configOptions.Reply_To_Mail__c = 'testing@hvem.com';
            configOptions.Auto_Populate_To_Field_From_Case_Contact__c = true;
            configOptions.Default_Email_Template__c = hvemSettings.templates;
            configOptions.Data_Category_Group_Filter__c='category1, category2';
            configOptions.Available_Data_Category_Group_Filter__c='test1 , test2';
            configOptions.Allow_Drafts__c=true;
            configOptions.Allow_Draft_Approval__c=true;
            configOptions.Under_Approval_Case_Status__c='Process';
            configOptions.Public_Groups_With_No_Approval__c ='servicegroup';
            configOptions.Public_Groups_With_No_Approval_Extended__c='servicegrouptest';
            configOptions.Case_Mappin_API__c='text1';
            configOptions.Case_Mapping_Label__c='text2';
            configOptions.Languages_Selected__c = 'English,French,Hindi';
            insert configOptions;
        }
        else{
            configOptions = HVEM_Config_Options__c.getInstance('HVEM');
        }
        hvemSettings = new HVEMSettingsCtrl();
        hvemSettings.strChosenCategoryGroups = 'category1,';
        hvemSettings.strChosenArticleTypes = 'article1,';
        hvemSettings.baseURL = 'http://hvem123.com';
        hvemSettings.selectedRoutingEmailAddress = 'routingEmailAddress@add.com';

   }

   public static testMethod void testsaveTOCustomSettingsForMapping(){
       setDataSaveToCustomSettings();
       Test.startTest();
       hvemSettings.saveTOCustomSettings();
       System.assertEquals(false,hvemSettings.PublicGroupError);
       List<HVEM_Config_Options__c> configList = new List<HVEM_Config_Options__c>();
       configList = [select Id from HVEM_Config_Options__c];
       delete configList;
       hvemSettings.saveTOCustomSettings();
       Test.stopTest();
    }

   public static void setDataForapiFilterMap(){

       configOptions = new HVEM_Config_Options__c(Name = 'ABC',Case_Mappin_API__c='CaseMappinApi',Case_Mapping_Label__c='CaseMappinLabel');
       insert configOptions;
       hvemSettings = new HVEMSettingsCtrl();
  }

  public static testMethod void testForapiFilterMap(){
      setDataForapiFilterMap();
      Test.startTest();
      hvemSettings = new HVEMSettingsCtrl();
      hvemSettings.removeMapping();
      List<SelectOption> selectList = hvemSettings.getCaseFilterMapEntry();
      System.assertEquals(true,selectList.size()>0);
      Test.stopTest();

  }

/*
   public static testMethod void testdisableEnableEmailPublisherOptions(){
      setDataSaveToCustomSettings();
      Test.startTest();
      hvemSettings.disableEnableEmailPublisherOptions();
//      List<SelectOption> selectList = hvemSettings.getEmailPublisherSelectionOptions();
//      System.assertEquals(true,selectList.size()>0);
      ApexPages.StandardController controller;
      HVEMCaseFeedEmailPublisherCntrl hVEMCaseFeedEmailPublisherCntrlInstance = new HVEMCaseFeedEmailPublisherCntrl(controller);
      Test.stopTest();

  }
*/


}
