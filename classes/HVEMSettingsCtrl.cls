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

/* HVEMSettingsCtrl Class
 * This class is used to change HVEM configuration options.
 */

public with Sharing class HVEMSettingsCtrl{

	public HVEM_Config_Options__c configOptions{get;set;}
    public List<HVEM_Email_Routing_Address__c> routingConfigOptions {get; set;}
    public List<HVEM_Email_Routing_Mapping__c> routingMappingConfigOptions {get; set;}
	public EmailTemplate emailtemplate{get;set;}

    public List<folder>folderList{get;set;}
    public List<EmailTemplate>templateList{get;set;}
    public List<String> selectedArticleTypesList{get;set;}
    public List<String> selectedCategoryGroupsList{get;set;}
    public List<String> specifiedCategoryGroupsList{get;set;}
    public List<String> selectedPubliGroupsList{get;set;}
    public List<String> saveGroupList{get;set;}
    public List<String> availableRoutingAddressList {get; set;}
    public List<String> selectedRoutingAddressList {get; set;}

    private static final String NON_BREAKING_SPACE = '&nbsp;&nbsp;';
    private final String KNOWLEDGEARTICLES = Label.KNOWLEDGE_ARTICLES;
    public String articleTypes{get;set;}
    public String folders{get;set;}
    public String templates{get;set;}
    public boolean autoPopulate{get;set;}
    public boolean enableDraftEmails{get;set;}
    public boolean enableApprovalProcess{get;set;}
    public String caseStatusUnderApproval{get;set;}
    public String searchGroupText{get;set;}
    public String selectedPublicGroups{get;set;}
    public String selectedPublicGroupsExtended{get;set;}
    public List<Group> groupList{get;set;}
    public List<String> toSaveList{get;set;} 

    public String strChosenCategoryGroups{get;set;}
    public String strChosenArticleTypes{get;set;}
    public String selectedPickListCaseField{get;set;}
    public String selectedPickListCaseValue{get;set;}
    public String selectedCategoryGroups{get;set;}
    public String caseFilterMappingAPIStr{get;set;}
    public String caseFilterMappingValuesStr{get;set;}
    public String dataCategory{get;set;}
    public String baseURL{get;set;}
    public String caseMapSelected {get; set;}
    public String availableCategoryGroups {get; set;}
    public String chosenCategoryGroups {get; set;}
    public String selectedLanguages{get; set;}
    public Integer templateCount {get; set;}
    public String routingEmailInput {get; set;}
    public String selectedRoutingEmailAddress {get; set;}
    public String selectedCaseFieldReplyTo {get; set;}
    public String selectedCasePicklistReplyTo {get; set;}
    public String mappedReplyToAddress{get; set;}
    public String[] caseReplyToMapSelected {get; set;}
    public String caseRoutingAddressmappings {get; set;}
    public String toRemoveRoutingAddress{get; set;}
    public String caseMapRoutingAdd {get; set;}
    public String toRemoveRoutingMapAddress {get; set;}

    public boolean saveCS{get;set;}
    public boolean articleTypesError{get;set;}
    public boolean emailValidated{get;set;}
    public boolean categoryGroupsError{get;set;}
    public boolean caseFilterError{get;set;}
    public boolean replyToBlankError{get;set;}
    public boolean baseURLBlankError{get;set;}
    public boolean PublicGroupError{get;set;}
    public boolean enableChangeCaseStatus{get;set;}
    public boolean userLanguageError {get; set;}

   //KB article 
    public boolean IsVisibleInPKB{get;set;}
    public boolean IsVisibleInPRM{get;set;}
    public boolean IsVisibleInCSP{get;set;}
    public boolean InsertArticleContent{get;set;}
    
    public String CSPChannelVisible{get;set;}
    public String PKBChannelVisible{get;set;}
    public String PRMChannelVisible{get;set;}
    
    
    public Boolean isInvalidRoutingEmail{get; set;}
    public Boolean isroutingAddressPresent {get; set;}
    public Boolean isroutingAddressAlreadyPresent {get; set;}
    public Boolean isroutingMappingAlreadyPresent {get; set;}
    private Map<String, String> caseApiLabelMap {get;set;}
    private Map<String, Schema.SObjectField> fieldMap {get; set;}
    private Map<String, String> categoryGroupApiLabelMap{get; set;}
    private Map<String, String> dataCategoryApiLabelMap{get; set;}
    private Map<String,String> apiLabelFilterMap{get;set;}

    /**
     * Constructor                  
     */
     public HVEMSettingsCtrl(){
        caseApiLabelMap = new Map<String, String>();
        categoryGroupApiLabelMap = new Map<String, String>();
        dataCategoryApiLabelMap = new Map<String, String>();
        apiLabelFilterMap = new Map<String, String>();        
        availableRoutingAddressList = new List<String>();
        selectedRoutingAddressList= new List<String>();
             
        configOptions = HVEM_Config_Options__c.getInstance('HVEM');
        routingConfigOptions = [SELECT Email_Address__c FROM HVEM_Email_Routing_Address__c];
        routingMappingConfigOptions = [SELECT Case_API_and_Label__c,Email_Routing_Address__c,name FROM HVEM_Email_Routing_Mapping__c];
        for(HVEM_Email_Routing_Address__c routingMapinstance : routingConfigOptions){
            availableRoutingAddressList.add(routingMapinstance.Email_Address__c);
            selectedRoutingAddressList.add(routingMapinstance.Email_Address__c); 
        }
        fieldMap = Schema.SObjectType.Case.fields.getMap();
        folderList = new List<folder>();
        templateList = new List<EmailTemplate>();
        selectedArticleTypesList = new List<String>(); 
        selectedCategoryGroupsList = new List<String>();
        specifiedCategoryGroupsList = new List<String>(); 
        saveGroupList = new List<String>();  
        autoPopulate=true;
        enableDraftEmails=false;
        enableApprovalProcess = false;
        enableChangeCaseStatus = false;
        caseStatusUnderApproval='';
        strChosenCategoryGroups = '';
        routingEmailInput  = '';
        strChosenArticleTypes=null;
        caseRoutingAddressmappings = '';
        baseURL='';
        toRemoveRoutingAddress = '';
        caseMapRoutingAdd = '';
        toRemoveRoutingMapAddress = '';
        availableCategoryGroups = '';
        saveCS=false; 
        caseFilterMappingAPIStr=null;
        caseFilterMappingValuesStr=null;
        articleTypesError=false; 
        categoryGroupsError=false;
        caseFilterError=false;
        replyToBlankError = false;
        baseURLBlankError = false;
        PublicGroupError=false;
        selectedPickListCaseField=null; 
        selectedPickListCaseValue=null;
        selectedPublicGroups ='';
        selectedPublicGroupsExtended = '';
        groupList = new List<Group>();
        toSaveList = new List<String>();               
        selectedCategoryGroups = null;
        dataCategory='';
        
        IsVisibleInPKB = true;
        IsVisibleInPRM = false;
        IsVisibleInCSP = false;
        InsertArticleContent = false;
        PRMChannelVisible = Label.Channel_Available;
        PKBChannelVisible = Label.Channel_Available;
        CSPChannelVisible = Label.Channel_Available;
        isroutingMappingAlreadyPresent = false;
        isroutingAddressAlreadyPresent = false;
        List<HVEM_Config_Options__c> HVEMConfigOptionList = new List<HVEM_Config_Options__c>();

        HVEMConfigOptionList =  [SELECT name,Case_Mappin_API__c,Case_Mapping_Label__c FROM HVEM_Config_Options__c WHERE name != 'HVEM'];
        for(HVEM_Config_Options__c configInstance : HVEMConfigOptionList){
            apiLabelFilterMap.put(configInstance.Case_Mappin_API__c,configInstance.Case_Mapping_Label__c);           
        }               
        verify();
     }

     /*
      * Function to add options to the toSaveList.
      */
     public void addOption(){
         for(String optionInLeft : selectedPubliGroupsList){
             toSaveList.add(optionInLeft);
             for(Integer i=0;i<groupList.size();i++){
                 if(groupList[i].id == optionInLeft){
                     groupList.remove(i); 
                 }
             }                    
         }
     }

     /*
      * Function to remove options from the toSaveList
      */
     public void removeOption(){
         List<Group> removeList = new List<Group>();
         if(saveGroupList!=null && saveGroupList.size()>0){
             removeList = [select id,Name from Group where id IN :saveGroupList];
             groupList.addAll(removeList);
         }                       
         for(String optionInRight : saveGroupList){
             for(Integer i=0;i<toSaveList.size();i++){
                 if(toSaveList[i].subString(0,15) == optionInRight.subString(0,15)){
                     toSaveList.remove(i); 
                 }
             }            
         }
     }

     /**
      * Filter the contents on click of Find Button.
      */
     public void filterGroups(){
         String notInString = '';
         for(String singlrID : toSaveList){
             notInString += '\''+singlrID+'\',';
             notInString = notInString.substring(0,notInString.length()-1);
             notInString = '('+notInString+')';
         }     
         if(searchGroupText != null && searchGroupText.length() > 0){            
             searchGroupText = '%'+searchGroupText+'%';
             if(toSaveList != null && toSaveList.size() > 0){                
                 groupList = [Select Type, Name, Id From Group where type='regular' AND name LIKE :searchGroupText AND ID NOT IN :toSaveList];
             }
             else{
                 groupList = [Select Type, Name, Id From Group where type='regular' AND name LIKE :searchGroupText];
             }            
         }
         else{
             if(toSaveList != null && toSaveList.size() > 0){
                 groupList = [Select Type, Name, Id From Group where type='regular' AND ID NOT IN :toSaveList];
             } 
             else{
                 groupList = [Select Type, Name, Id From Group where type='regular'];
             }                                                 
         }        
     }

     /**
      *Fetch public Groups according to the filter text
      */
     public List<selectOption> getSavedOptions(){
         List<SelectOption> options = new List<SelectOption>();
         List<Group> groupOptionList = new List<Group>();
         if(toSaveList!=null && toSaveList.size()>0){
             groupOptionList = [select name from Group where id IN :toSaveList];
         }
         String singleGroupOptionString = '';
         for(String singleGroup : toSaveList){                        
             for(Group singleGroupOption : groupOptionList){
                 singleGroupOptionString = (String)singleGroupOption.id;

                 if(singleGroup.subString(0,15) == singleGroupOptionString.subString(0,15)){
                     options.add(new SelectOption(singleGroup ,singleGroupOption.name));
                 }
             }
         }       
         return options;          
     }

     /**
      *Fetch public Groups according to the filter text
      */
     public List<selectOption> getPublicGroups(){
         List<SelectOption> options = new List<SelectOption>();                            
         for(Group singleGroup : groupList){
             options.add(new SelectOption(singleGroup.id ,singleGroup.Name));
         }       
         return options;          
     }

            
     /**
      * Function to initialize the dependent picklist at load time  
      */
     public pageReference initializecategoryGroup(){
         if(strChosenCategoryGroups != null && strChosenCategoryGroups != '')
             specifiedCategoryGroupsList = strChosenCategoryGroups.split(',');  
         if((selectedCategoryGroups == null) && (specifiedCategoryGroupsList.size() > 0)){           
             selectedCategoryGroups = specifiedCategoryGroupsList[0];
         }
         return null;
     }


     /**
      * Function to add options to the CategoryGroup MultiSelectList/SingleSelect List
      */
     public List<SelectOption> getEnteredCategoryGroups()
     {
         List<String> availableCategoryGroupList = new List<String>();
         if((chosenCategoryGroups != null) && (chosenCategoryGroups != ''))
             availableCategoryGroupList  = chosenCategoryGroups.split(',');
         List<SelectOption> options = new List<SelectOption>();
         for(String singleCategoryGroup : availableCategoryGroupList){
             options.add(new SelectOption(singleCategoryGroup,singleCategoryGroup));
         }   
         if(options.size() == 0){
             options.add(new SelectOption('',''));             
         }
         return options;        
     }

     /**
      *Function to add options to the RadioButtons 
      */
      public List<SelectOption> getChannelsVisible() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption(Label.Channel_Available,Label.Channel_Available)); 
        options.add(new SelectOption(Label.Channel_Not_Available,Label.Channel_Not_Available)); 
        return options; 
    }
           
     /**
      * Function to validate before insertion
      */
     private boolean validateBeforeInsert(String inputString){

         Set <String> apiStringSet = new Set<String>();
         apiStringSet = apiLabelFilterMap.keySet();
         boolean isDuplicate = false;
         List<String> singleValueFieldCategoryList = new List<String>();
         List<String>InputStringFieldCategoryList = inputString.split('>>');
         for(String apiString : apiStringSet){
             singleValueFieldCategoryList = apiString.split('>>');            
             if(InputStringFieldCategoryList[0] == singleValueFieldCategoryList[0]){
                 isDuplicate=true;
                 break;
             }
         }
         return isDuplicate;        
     }


     public void refreshFunction(){
         System.debug('Refresh Function' + chosenCategoryGroups);
     }
     /**
      * Function to insert the options in CaseFilter Picklist to Custom Settings.
      */
     public void addMapping() {

         if(selectedCategoryGroups !=null && dataCategory != null){
             List<String> dataCategoryAPILabelList = dataCategory.split(' >> ',2);
             saveCS=false;
             boolean isDuplicate = false;
             String apiString = '' ;
             String labelString = '';
             //changes
                baseURLBlankError = false;
                userLanguageError = false;
                PublicGroupError = false;
                replyToBlankError = false;
                categoryGroupsError = false;
                articleTypesError = false;
                isroutingAddressPresent = false;
                isInvalidRoutingEmail = false;
                isroutingMappingAlreadyPresent = false;

             if(dataCategoryAPILabelList.size() == 2){
                 apiString = assembleString(selectedPickListCaseField , selectedPickListCaseValue , selectedCategoryGroups , dataCategoryAPILabelList[0]);
                 labelString = assembleString(fieldMap.get(selectedPickListCaseField).getDescribe().getLabel() , selectedPickListCaseValue ,selectedCategoryGroups, dataCategoryAPILabelList[1]);
                 isDuplicate = validateBeforeInsert(apiString);
                 if(isDuplicate == false){                  
                     apiLabelFilterMap.put(apiString,labelString);                
                     caseFilterError = false;
                    
                 }
                 else{                       
                     caseFilterError = true;
                 }
             }            
         }
     }

     /**
      * function to remove options from CaseFilter Picklist
      */
     public void removeMapping() {       
         if(apiLabelFilterMap.size() > 0){
             apiLabelFilterMap.remove(caseMapSelected);
             
         }
         saveCS=false;
         caseFilterError = false;
     }

     /**
      * Function to Add options to CaseFilter Picklist
      */
     public List<SelectOption> getCaseFilterMapEntry(){

         List<SelectOption> options = new List<SelectOption>();
         Set <String> apiStringSet = new Set<String>();
         apiStringSet = apiLabelFilterMap.keySet();
         for(String apiString : apiStringSet){
             options.add(new SelectOption(apiString,apiLabelFilterMap.get(apiString)));              
         }
         return options;
     } 

     /**
      * Function to assemble the Strings to be inserted.
      */
     public String assembleString(String casePickList, String casePickListValue, String categoryGroup, String dataCategory){

         String formattedString = casePickList+ ':'+ casePickListValue+ ' >> '+ categoryGroup+ ':'+dataCategory;
         return formattedString ;
     }

     /**
      * Function to verify wheather the custom setting exists already or not.
      */
     public void verify(){

         if(configOptions != null){
             setupHVEMSettings();
         }            
         getEmailTemplatefolders();
         initializeEmailTemplate();
         initializeCasePicListValues();
         initializecategoryGroup();
         getCasePickListFields();
     }

     /**
      * Function to retieve the list of Email templates
      */
     public pageReference initializeEmailTemplate(){

         if(folders != null){
             if(folders == 'None'){
                 Organization org  = [Select ID from Organization LIMIT 1];
                 folders = org.id;
                 templateList = [Select Subject, Name, TemplateType From EmailTemplate  where (TemplateType = 'Text' OR TemplateType = 'Custom' ) AND IsActive=true AND FolderId=:folders];
             }
             templateList = [Select Subject, Name, TemplateType From EmailTemplate  where (TemplateType = 'Text' OR TemplateType = 'Custom' )  AND IsActive=true AND FolderId=:folders];
         }
         else{
             if(folderList != null && !folderList.isEmpty()){
                 folders = folderList[0].id;
                 templateList = [Select Subject, Name, TemplateType From EmailTemplate  where (TemplateType = 'Text' OR TemplateType = 'Custom' ) AND IsActive=true AND FolderId=:folders];
             }else{
                 Organization org  = [Select ID from Organization LIMIT 1];
                 folders = org.id;
                 templateList = [Select Subject, Name, TemplateType From EmailTemplate  where (TemplateType = 'Text' OR TemplateType = 'Custom' ) AND IsActive=true AND FolderId=:folders];
             }
         }
         return null;
     }

     /**
      * Function to display the settings on the page from the custom Settings
      */
     public void setupHVEMSettings(){

         baseURL = configOptions.Article_Link_Base_URL__c;
         autoPopulate = configOptions.Auto_Populate_To_Field_From_Case_Contact__c ;
         templates = configOptions.Default_Email_Template__c; 
         folders = configOptions.Default_Email_Folder__c;       
         strChosenCategoryGroups = configOptions.Data_Category_Group_Filter__c;
         availableCategoryGroups = configOptions.Available_Data_Category_Group_Filter__c;
         strChosenArticleTypes = configOptions.Article_Types_Filter__c;        
         selectedLanguages =  configOptions.Languages_Selected__c;  
         chosenCategoryGroups = strChosenCategoryGroups;
         enableDraftEmails = configOptions.Allow_Drafts__c; 
         enableApprovalProcess = configOptions.Allow_Draft_Approval__c;
         caseStatusUnderApproval = configOptions.Under_Approval_Case_Status__c; 
         enableChangeCaseStatus = configOptions.Allow_changing_case_status__c;
         IsVisibleInPRM = configOptions.Check_PRM_Channel__c;
         IsVisibleInPKB = configOptions.Check_PKB_Channel__c;
         IsVisibleInCSP = configOptions.Check_CSP_Channel__c;
         InsertArticleContent = configOptions.Insert_KB_Article_Content__c;
         PRMChannelVisible = configOptions.PRM_Channel_Available__c;
         PKBChannelVisible  = configOptions.PKB_Channel_Available__c;
         CSPChannelVisible = configOptions.CSP_Channel_Available__c;
         
         if(configOptions.Public_Groups_With_No_Approval__c != null && configOptions.Public_Groups_With_No_Approval__c != ''){
             selectedPublicGroups = configOptions.Public_Groups_With_No_Approval__c ; 
             if(configOptions.Public_Groups_With_No_Approval_Extended__c != null && configOptions.Public_Groups_With_No_Approval_Extended__c != ''){
                 selectedPublicGroups += configOptions.Public_Groups_With_No_Approval_Extended__c ; 
             }       
         }
         if(selectedPublicGroups!=null && selectedPublicGroups.length() > 1)
             toSaveList = selectedPublicGroups.split(',');
         try{
               if(templates !=''){
                folders = configOptions.Default_Email_Folder__c;
               }
         
         }
         catch(Exception e){
             folders='None';
             templates = 'None';

         }
     }

     /**
      * Function to verify the correctness of the base URL
      */
     public boolean verifyBaseURL(){       
         boolean inCorrectURLError = false;
         String URLRegex = '^(http(?:s)?\\:\\/\\/[a-zA-Z0-9\\-]+(?:\\.[a-zA-Z0-9\\-]+)*\\.[a-zA-Z]{2,6}(?:\\/?|(?:\\/[\\w\\-]+)*)(?:\\/?|\\/\\w+\\.[a-zA-Z]{2,4}(?:\\?[\\w]+\\=[\\w\\-]+)?)?(?:\\&[\\w]+\\=[\\w\\-]+)*)$';
         Pattern MyPattern = Pattern.compile(URLRegex);        
         Matcher MyMatcher = MyPattern.matcher(baseURL);
         if (!MyMatcher.matches()){
             inCorrectURLError =true;
         }
         return inCorrectURLError ;
     }

     /**
      * Function to Save Update the value inserted on the page to the custom settings
      */
     public void saveTOCustomSettings(){
         saveCS=false;
         PublicGroupError = false;
         replyToBlankError = false;
         
         categoryGroupsError = false;
         articleTypesError = false;
         caseFilterError = false;
         replyToBlankError = false;
         baseURLBlankError = false;
         PublicGroupError = false;
         userLanguageError = FALSE;
         baseURLBlankError = false;
         isroutingAddressPresent = false;
         isInvalidRoutingEmail = false;
         isroutingAddressAlreadyPresent = false;
         isroutingMappingAlreadyPresent = false;
         selectedPublicGroups = '';
         selectedPublicGroupsExtended = '';

         List<String> categoryGroups = new List<String>();
         List<String> articleTypes= new List<String>();
         List<String> selectedLanguagesList = new List<String>();

         configOptions = HVEM_Config_Options__c.getInstance('HVEM');
         if(strChosenCategoryGroups != null && strChosenCategoryGroups != '')
             categoryGroups= strChosenCategoryGroups.split(',');

         if(strChosenArticleTypes !=null && strChosenArticleTypes != '')
             articleTypes= strChosenArticleTypes.split(',');

         if(selectedLanguages != null && selectedLanguages != '')
             selectedLanguagesList = selectedLanguages.split(',');

         if(categoryGroups.size() > 0){   
             if(categoryGroups[0] == ''){
                 categoryGroups.clear();
             }
         }else if(articleTypes.size() > 0){      
             if(articleTypes[0] == ''){
                 articleTypes.clear();
             }
         }
         Integer categoryGroupsLength = categoryGroups.size();
         Integer articleTypesLength = articleTypes.size();
         Integer userLanguagesLength = selectedLanguagesList.size();
         
         for(String singleGroup : toSaveList){
             if(selectedPublicGroups.length() < 240){
                 selectedPublicGroups += singleGroup.subString(0,15) +',';
             }
             else if(selectedPublicGroupsExtended.length() < 240){
                 selectedPublicGroupsExtended += singleGroup.subString(0,15) +',';
             }
             else{
                 PublicGroupError = true;
             }                    
         } 
             if((categoryGroupsLength == 0)||(categoryGroupsLength >= 4)){            
                 categoryGroupsError = true;            
             }
             else if((articleTypesLength == 0)||(articleTypesLength >= 5)){           
                 articleTypesError = true;            
             }else if(userLanguagesLength == 0){
                 userLanguageError = true;
             }                
             else if((baseURL == null) || (baseURL.length() == 0) || (verifyBaseURL() == true)){
                 baseURLBlankError = true;    
             }else if(selectedRoutingEmailAddress == null || selectedRoutingEmailAddress == ''){
                 isroutingAddressPresent = true;
             }
             else if(!PublicGroupError){  
                 
                 if(configOptions != null){
                     configOptions = [SELECT name,id FROM HVEM_Config_Options__c WHERE Id = : configOptions.id];
                     configOptions.Article_Types_Filter__c=strChosenArticleTypes;
                     configOptions.Data_Category_Group_Filter__c=strChosenCategoryGroups;
                     configOptions.Languages_Selected__c = selectedLanguages;
                     configOptions.Available_Data_Category_Group_Filter__c=availableCategoryGroups;
                     configOptions.Article_Link_Base_URL__c=baseURL;
                     configOptions.Auto_Populate_To_Field_From_Case_Contact__c=autoPopulate;
                     configOptions.Default_Email_Template__c=templates;
                     configOptions.Default_Email_Folder__c=folders;
                     configOptions.Allow_Drafts__c = enableDraftEmails;
                     configOptions.Allow_Draft_Approval__c = enableApprovalProcess; 
                     configOptions.Under_Approval_Case_Status__c = caseStatusUnderApproval;                              
                     configOptions.Public_Groups_With_No_Approval__c = selectedPublicGroups;
                     configOptions.Public_Groups_With_No_Approval_Extended__c = selectedPublicGroupsExtended;
                     configOptions.Allow_changing_case_status__c = enableChangeCaseStatus;
                     configOptions.Insert_KB_Article_Content__c =InsertArticleContent;
                     configOptions.PRM_Channel_Available__c = PRMChannelVisible ;
                     configOptions.PKB_Channel_Available__c = PKBChannelVisible ;
                     configOptions.CSP_Channel_Available__c = CSPChannelVisible ;
                     configOptions.Check_PKB_Channel__c = IsVisibleInPKB;
                     configOptions.Check_CSP_Channel__c = IsVisibleInCSP;
                     configOptions.Check_PRM_Channel__c = IsVisibleInPRM;
                    
                     update configOptions ;
                     caseFilterError = false;
                     isInvalidRoutingEmail = false;
                     isroutingAddressAlreadyPresent = false;
                     saveCS=true; 
                 }else{
                     configOptions =new HVEM_Config_Options__c();
                     configOptions.name='HVEM';
                     configOptions.Available_Data_Category_Group_Filter__c = availableCategoryGroups;
                     configOptions.Article_Types_Filter__c=strChosenArticleTypes;
                     configOptions.Data_Category_Group_Filter__c=strChosenCategoryGroups;
                     configOptions.Article_Link_Base_URL__c=baseURL;
                     configOptions.Languages_Selected__c = selectedLanguages;
                     configOptions.Auto_Populate_To_Field_From_Case_Contact__c=autoPopulate; 
                     configOptions.Default_Email_Template__c=templates;
                     configOptions.Default_Email_Folder__c=folders;
                     configOptions.Allow_Drafts__c = enableDraftEmails;
                     configOptions.Allow_Draft_Approval__c = enableApprovalProcess;
                     configOptions.Under_Approval_Case_Status__c = caseStatusUnderApproval;             
                     configOptions.Public_Groups_With_No_Approval__c = selectedPublicGroups;
                     configOptions.Public_Groups_With_No_Approval_Extended__c = selectedPublicGroupsExtended;                
                     configOptions.Allow_changing_case_status__c = enableChangeCaseStatus;  
                     configOptions.PRM_Channel_Available__c = PRMChannelVisible ;
                     configOptions.PKB_Channel_Available__c = PKBChannelVisible ;
                     configOptions.CSP_Channel_Available__c = CSPChannelVisible ;
                     configOptions.Check_PKB_Channel__c = IsVisibleInPKB;       
                     configOptions.Check_CSP_Channel__c = IsVisibleInCSP;
                     configOptions.Check_PRM_Channel__c = IsVisibleInPRM;
                     configOptions.Insert_KB_Article_Content__c =InsertArticleContent;
                     insert configOptions;
                     caseFilterError = false;
                     isInvalidRoutingEmail = false;
                     isroutingAddressAlreadyPresent = false;
                     saveCS=true;
                 }
                 
                 /**
                 * code to save entered email routing address in new Custom settings
                 **/
                 
                 delete [SELECT Id FROM HVEM_Email_Routing_Address__c];
                 routingConfigOptions = new List<HVEM_Email_Routing_Address__c>();
                 Integer counter = 0;
                 
                 for(String emailAddress : selectedRoutingEmailAddress.split(',',0)){
                     counter++;
                     HVEM_Email_Routing_Address__c routingConfigOptionsInstance = new HVEM_Email_Routing_Address__c();
                     routingConfigOptionsInstance.Name = counter + Label.RoutingEmail;
                     routingConfigOptionsInstance.Email_Address__c = emailAddress;
                     routingConfigOptions.add(routingConfigOptionsInstance);
                     
                 }
                 counter = 0;
                 insert routingConfigOptions;
                 
                 /**
                 * code to insert mappings in Config options
                 **/
                if(caseRoutingAddressmappings != null){
                     delete [SELECT Case_API_and_Label__c,Email_Routing_Address__c FROM HVEM_Email_Routing_Mapping__c];
                     List<HVEM_Email_Routing_Mapping__c> tempRoutingMap = new List<HVEM_Email_Routing_Mapping__c>();
                     
                     for(HVEM_Email_Routing_Mapping__c routingConfigOptionsMappingInstance : routingMappingConfigOptions){
                        HVEM_Email_Routing_Mapping__c tempRoutingMapInstance = new HVEM_Email_Routing_Mapping__c();
                        tempRoutingMapInstance.Case_API_and_Label__c = routingConfigOptionsMappingInstance.Case_API_and_Label__c;
                        tempRoutingMapInstance.Email_Routing_Address__c = routingConfigOptionsMappingInstance.Email_Routing_Address__c;
                        tempRoutingMapInstance.name = routingConfigOptionsMappingInstance.name;
                        tempRoutingMap.add(tempRoutingMapInstance);
                     }
                     insert tempRoutingMap;
                    
                 }
             }

             List<HVEM_Config_Options__c> HVEMConfigOptionList = new List<HVEM_Config_Options__c>();
             Set<String> apiStringSet = new Set<String>();            
             HVEMConfigOptionList =  [SELECT name,Case_Mappin_API__c,Case_Mapping_Label__c FROM HVEM_Config_Options__c WHERE name != 'HVEM'];
             if(HVEMConfigOptionList != null && HVEMConfigOptionList.size() > 0){
                 delete HVEMConfigOptionList;
             }            
         
             for(String apiString : apiLabelFilterMap.keySet()){
                 configOptions = new HVEM_Config_Options__c();               
                 configOptions.Name = System.now().getTime() + Label.Case_Map;
                 configOptions.Case_Mappin_API__c = apiString;
                 configOptions.Case_Mapping_Label__c = apiLabelFilterMap.get(apiString);                                
                 insert configOptions; 
         }
         
     }

     /**
      * function to retrieve the list of Template Folders
      */
     public void getEmailTemplatefolders(){

         folderList = [Select Name,Id From Folder where Type='Email' AND AccessType='Public'];
     }

     /**
      * function to add options to the Template folder Select List
      */
     public List<SelectOption> getEmailFolders() {
         List<SelectOption> options = new List<SelectOption>();
         options.add(new SelectOption('None',Label.Template_folder_option));
         options.add(new SelectOption(userInfo.getUserId(),Label.personal_email_templates));
         for(folder f : folderList){
             options.add(new SelectOption(f.Id,f.Name));
         }
         return options;
     }   

     /**
      * Function to add options to the default Template Select List
      */
     public List<SelectOption> getEmailTemplates() {
         List<SelectOption> options = new List<SelectOption>();
         options.add(new SelectOption('None',Label.Template_name));
         for(EmailTemplate t : templateList){
             options.add(new SelectOption(t.Id,t.Name));
         }
         return options;
     } 

     /**
      * Function to add options to the articleTypes MultiSelectList
      */
     public List<SelectOption> getArticleTypesDevName()
     {
         List<SelectOption> options = new List<SelectOption>();
         List<Schema.SObjectType> gd = Schema.getGlobalDescribe().Values();    

         for(Schema.SObjectType f : gd)
         {
             if (f.getDescribe().getName().endsWith('__kav')) {
                 options.add(new SelectOption(f.getDescribe().getName(),f.getDescribe().getLabel()));
             }
         }
         return options;
     } 

     /**
      * Function to initialize the dependent picklist at load time  
      */
     public pageReference initializeCasePicListValues(){
         if(selectedPickListCaseField == null || selectedCaseFieldReplyTo == null){
             Map<String, Schema.SObjectField> fieldMap = Schema.SObjectType.Case.fields.getMap();
             List<String> fields = new List<String>();
             for(Schema.SObjectField value : fieldMap.values()){
                 Schema.DescribeFieldResult fieldResult = value.getDescribe();  
                 String fieldType = String.valueOf(fieldResult.getType());
                 if(fieldType == 'PICKLIST'){
                     fields.add(String.valueOf(fieldResult.getName()));

                 }
             }
             selectedPickListCaseField = fields[0];
             selectedCaseFieldReplyTo = fields[0];
         }
         return null;
     }

     /**
      * function to add options to picklist to display the fields of cases with type picklist.
      */
     public List<SelectOption> getCasePickListFields(){
         List<SelectOption> options = new List<SelectOption>();
         for(Schema.SObjectField value : fieldMap.values()){
             Schema.DescribeFieldResult fieldResult = value.getDescribe();  
             String fieldType = String.valueOf(fieldResult.getType());
             if(fieldType == 'PICKLIST'){
                 options.add(new SelectOption(String.valueOf(fieldResult.getName()),String.valueOf(fieldResult.getLabel())));

             }
         }
         return options;
     }

     /**
      * Function to add options to picklist to display values for selected pickList.
      */
     public List<SelectOption> getCasePickListFieldsValues(){
         Map<String, Schema.SObjectField> fieldMap = Schema.SObjectType.Case.fields.getMap();
         List<SelectOption> options = new List<SelectOption>();
         String fieldName = '';
         for(Schema.SObjectField value : fieldMap.values()){
             Schema.DescribeFieldResult fieldResult = value.getDescribe();  
             fieldName= String.valueOf(fieldResult.getName());
             if(fieldName == selectedPickListCaseField){
                 List<Schema.PicklistEntry> pickListValues = fieldResult.getPicklistValues();
                 for(Schema.PicklistEntry item : pickListValues){
                     options.add(new SelectOption(item.getValue(),item.getLabel()));
                 }                
             }          
         }
         return options;
     } 

     /**
      * Function to add options to picklist to display values for selected pickList for Reply To.
      */
     public List<SelectOption> getCasePickListFieldsValuesReplyTo(){
         Map<String, Schema.SObjectField> fieldMap = Schema.SObjectType.Case.fields.getMap();
         List<SelectOption> options = new List<SelectOption>();
         String fieldName = '';
         for(Schema.SObjectField value : fieldMap.values()){
             Schema.DescribeFieldResult fieldResult = value.getDescribe();  
             fieldName= String.valueOf(fieldResult.getName());
             if(fieldName == selectedCaseFieldReplyTo ){
                 List<Schema.PicklistEntry> pickListValues = fieldResult.getPicklistValues();
                 for(Schema.PicklistEntry item : pickListValues){
                     options.add(new SelectOption(item.getValue(),item.getLabel()));
                 }                
             }          
         }
         return options;
     } 



     /**
      * Function to add options to the case's Status SelectList
      */
     public List<SelectOption> getCaseStatusFieldValues(){
         Map<String, Schema.SObjectField> fieldMap = Schema.SObjectType.Case.fields.getMap();
         List<SelectOption> options = new List<SelectOption>();
         String fieldName = '';
         for(Schema.SObjectField value : fieldMap.values()){
             Schema.DescribeFieldResult fieldResult = value.getDescribe();  
             fieldName= String.valueOf(fieldResult.getName());
             if(fieldName == 'Status'){
                 List<Schema.PicklistEntry> pickListValues = fieldResult.getPicklistValues();
                 for(Schema.PicklistEntry item : pickListValues){
                     options.add(new SelectOption(item.getValue(),item.getLabel()));
                 }                
             }          
         }
         return options;
     }
    /**
    * populate list of all language options present in org 
    **/
    public List<SelectOption> getUserLanguagesList(){
        Map<String, Schema.SObjectField> fieldMap = Schema.SObjectType.User.fields.getMap();
        List<SelectOption> options = new List<SelectOption>();
        for(Schema.SObjectField value : fieldMap.values()){
            Schema.DescribeFieldResult fieldResult = value.getDescribe();  
            String fieldName= String.valueOf(fieldResult.getName());
            if(fieldName == 'LanguageLocaleKey'){
                List<Schema.PicklistEntry> pickListValues = fieldResult.getPicklistValues();
                for(Schema.PicklistEntry item : pickListValues){
                    options.add(new SelectOption(item.getValue(),item.getLabel()));
                }                
            }          
        }
        templateCount = options.size();
        return options;
    }
    
    /**
    * populate list of Selected Routing Addresses
    **/
    public List<SelectOption> getSelectedRoutingAddress(){
        List<SelectOption> options = new List<SelectOption>();
        for(String emailInstance : selectedRoutingAddressList){
            options.add(new SelectOption(emailInstance ,emailInstance ));
        }
        return options;
    }
    
    /**
    * populate list of Selected Mapping Routing Addresses
    **/
    public List<SelectOption> getSelectedMappingRoutingAddress(){
        List<SelectOption> options = new List<SelectOption>();
        for(String emailInstance : availableRoutingAddressList){
            options.add(new SelectOption(emailInstance ,emailInstance ));
        }
        return options;
    }
    
    /**
    * populate list of Case attributes to Routing address mapping
    **/
    public List<SelectOption> getCaseReplyToFilterMapEntry(){ 
        
        List<SelectOption> options = new List<SelectOption>();
        for(HVEM_Email_Routing_Mapping__c routingConfigOptionsMappingInstance : routingMappingConfigOptions){
            list<String> apiValues;
            List<String> labelValues;
            if(routingConfigOptionsMappingInstance.Case_API_and_Label__c != null && routingConfigOptionsMappingInstance.Case_API_and_Label__c != ''){
                String[] apiAndLabel = (routingConfigOptionsMappingInstance.Case_API_and_Label__c).split(':',-2);
                apiValues = apiAndLabel[0].split('\\|\\|',-2);
                labelValues = apiAndLabel[1].split('\\|\\|',-2);
                
            }
            options.add(new SelectOption(routingConfigOptionsMappingInstance.Case_API_and_Label__c + ' >> ' +routingConfigOptionsMappingInstance.Email_Routing_Address__c,apiValues[1] + ':' + labelValues[1] + ' >> ' + routingConfigOptionsMappingInstance.Email_Routing_Address__c));
        }
        return options;
    }
    
    /**
    * Function to add Routing address 
    **/
    public void caseMapRoutingAddressAdd(){
        saveCS = false;
        // chnages
        baseURLBlankError = false;
        userLanguageError = false;
        PublicGroupError = false;
        replyToBlankError = false;
        categoryGroupsError = false;
        articleTypesError = false;
        caseFilterError = false;
        isroutingAddressPresent = false;
        isInvalidRoutingEmail = false;
        
        HVEM_Email_Routing_Mapping__c routingSettingsInstance = new HVEM_Email_Routing_Mapping__c();
        isroutingMappingAlreadyPresent = false;
        if(caseMapRoutingAdd != null && caseMapRoutingAdd != ''){
            
             for(HVEM_Email_Routing_Mapping__c routingConfigOptionsMappingInstance : routingMappingConfigOptions){
                if(routingConfigOptionsMappingInstance.Case_API_and_Label__c.trim() == caseMapRoutingAdd.split('>>',0)[0].trim()){
                    isroutingMappingAlreadyPresent = true; 
                    break;
                }
             }
             if(isroutingMappingAlreadyPresent == false){
                 routingSettingsInstance.Case_API_and_Label__c = caseMapRoutingAdd.split('>>',0)[0];
                 routingSettingsInstance.Email_Routing_Address__c = caseMapRoutingAdd.split('>>',0)[1];
                 routingSettingsInstance.name = String.valueof(system.now());
                 routingMappingConfigOptions.add(routingSettingsInstance);
             }
        }
    }
    
    /**
    * Function to remove Routing address from enterd routing address
    **/
    public void removeRoutingMapping(){
        Integer counter = 0;
        baseURLBlankError = false;
        userLanguageError = false;
        PublicGroupError = false;
        replyToBlankError = false;
        categoryGroupsError = false;
        articleTypesError = false;
        caseFilterError = false;
        isroutingAddressPresent = false;
        isInvalidRoutingEmail = false;
        isroutingMappingAlreadyPresent = false;
        
        List<String> selectedRemoveList = new List<String>();
        List<String> availableRemoveList = new List<String>();
        
        List<String> cloneSelectedRoutingAddressList = selectedRoutingAddressList.clone();
        List<String> cloneAvailableRoutingAddressList = availableRoutingAddressList.clone();
        
        for(String strRoutingAdd : toRemoveRoutingAddress.split('>',0)){
            for(String strSelectedRoutingAdd : selectedRoutingAddressList){
                if(strSelectedRoutingAdd == strRoutingAdd){
                    selectedRemoveList.add(strSelectedRoutingAdd);
                }
                counter++;
            }
            counter = 0;
            for(String strAvailableRoutingAdd : availableRoutingAddressList){
                if(strAvailableRoutingAdd == strRoutingAdd){
                    availableRemoveList.add(strAvailableRoutingAdd);
                }
                counter++;
            }
        }
        
        selectedRoutingAddressList = new List<String>();
        availableRoutingAddressList = new List<String>();
        Boolean isElementPresent = false;
        for(String str : cloneSelectedRoutingAddressList){
            for(String content : selectedRemoveList){
                if(content == str){
                    isElementPresent = true;
                }
            }
            if(!isElementPresent){
                selectedRoutingAddressList.add(str);
                availableRoutingAddressList.add(str);
            }else{
                isElementPresent = false;
            }
        }
        
    }
    
    /**
    * Function to remove Mapping Routing address 
    **/
    public void removeMappingRoutingAddress(){
        Integer counter = 0;
        if(routingMappingConfigOptions != null && routingMappingConfigOptions.size() > 0){
        for(HVEM_Email_Routing_Mapping__c routingConfigOptionsMappingInstance : routingMappingConfigOptions){
            if(routingConfigOptionsMappingInstance.Case_API_and_Label__c.trim() == toRemoveRoutingMapAddress.split('>>',0)[0].trim()){
                break;
            }else{
                counter++;
            }
        }
        routingMappingConfigOptions.remove(counter);
       }
    }
    
    /**
    * Function to validate Routing Address Input
    **/
    public pageReference validateRoutingAddressInput() {
        isroutingAddressAlreadyPresent = false;
        saveCS=false;
        baseURLBlankError = false;
        userLanguageError = false;
        PublicGroupError = false;
        replyToBlankError = false;
        categoryGroupsError = false;
        articleTypesError = false;
        caseFilterError = false;
        isroutingAddressPresent = false;
        isInvalidRoutingEmail = false;
        isroutingMappingAlreadyPresent = false;
         
        for(String selectedRoutingAddressInstance : selectedRoutingAddressList){
            if(routingEmailInput == selectedRoutingAddressInstance){
                isroutingAddressAlreadyPresent = true;
                isInvalidRoutingEmail = false;
            }
        }
        if(routingEmailInput != null && routingEmailInput != '' && isroutingAddressAlreadyPresent == false){
            isInvalidRoutingEmail = !HVEMUtil.validateEmail(new String[]{routingEmailInput});
            saveCS=false;
            if(isInvalidRoutingEmail == false){
                availableRoutingAddressList.add(routingEmailInput);
                selectedRoutingAddressList.add(routingEmailInput);
            }
            
        }
        return null;
    }

}