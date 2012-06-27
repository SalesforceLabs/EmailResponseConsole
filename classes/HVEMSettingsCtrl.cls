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
	public EmailTemplate emailtemplate{get;set;}

    public List<folder>folderList{get;set;}
    public List<EmailTemplate>templateList{get;set;}
    public List<String> selectedArticleTypesList{get;set;}
    public List<String> selectedCategoryGroupsList{get;set;}
    public List<String> specifiedCategoryGroupsList{get;set;}
    public List<String> selectedPubliGroupsList{get;set;}
    public List<String> saveGroupList{get;set;}

    private static final String NON_BREAKING_SPACE = '&nbsp;&nbsp;';
    private final String KNOWLEDGEARTICLES = 'KnowledgeArticleVersion';
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
    public String replyToAddress {get; set;}
    public String availableCategoryGroups {get; set;}
    public String chosenCategoryGroups {get; set;}

    public boolean saveCS{get;set;}
    public boolean articleTypesError{get;set;}
    public boolean emailValidated{get;set;}
    public boolean categoryGroupsError{get;set;}
    public boolean caseFilterError{get;set;}
    public boolean replyToBlankError{get;set;}
    public boolean baseURLBlankError{get;set;}
    public boolean PublicGroupError{get;set;}

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
        configOptions = HVEM_Config_Options__c.getInstance('HVEM');
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
        caseStatusUnderApproval='';
        strChosenCategoryGroups = '';
        strChosenArticleTypes=null;
        baseURL='';
        replyToAddress = '';
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
         //String groupQuery = 'Select Type, Name, Id From Group where type=\'regular\' AND name LIKE \'%'+searchGroupText+'%\'';
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

             if(dataCategoryAPILabelList.size() == 2){
                 apiString = assembleString(selectedPickListCaseField , selectedPickListCaseValue , selectedCategoryGroups , dataCategoryAPILabelList[0]);
                 labelString = assembleString(fieldMap.get(selectedPickListCaseField).getDescribe().getLabel() , selectedPickListCaseValue ,selectedCategoryGroups, dataCategoryAPILabelList[1]);
                 isDuplicate = validateBeforeInsert(apiString);
                 if(isDuplicate == false){                  
                     apiLabelFilterMap.put(apiString,labelString);                
                     caseFilterError = false;
                     //getCaseFilterMapEntry();
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
             //getCaseFilterMapEntry();
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
         replyToAddress = configOptions.Reply_To_Mail__c;
         autoPopulate = configOptions.Auto_Populate_To_Field_From_Case_Contact__c ;
         templates = configOptions.Default_Email_Template__c; 
         folders = configOptions.Default_Email_Folder__c;       
         strChosenCategoryGroups = configOptions.Data_Category_Group_Filter__c;
         availableCategoryGroups = configOptions.Available_Data_Category_Group_Filter__c;
         strChosenArticleTypes = configOptions.Article_Types_Filter__c;        
         chosenCategoryGroups = strChosenCategoryGroups;
         enableDraftEmails = configOptions.Allow_Drafts__c; 
         enableApprovalProcess = configOptions.Allow_Draft_Approval__c;
         caseStatusUnderApproval = configOptions.Under_Approval_Case_Status__c; 
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
         
             /*if(templates !='None'){
                 //emailtemplate = [select FolderId from EmailTemplate where id=:templates];
                 //folders = emailtemplate.FolderId;
                 folders = configOptions.Default_Email_Folder__c;
             }
            else{
               //  folders='None';
               folders = configOptions.Default_Email_Folder__c;
             } */ 
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
         articleTypesError = false;
         categoryGroupsError = false;
         caseFilterError = false;
         replyToBlankError = false;
         baseURLBlankError = false;
         PublicGroupError = false;
         selectedPublicGroups = '';
         selectedPublicGroupsExtended = '';

         List<String> categoryGroups = new List<String>();
         List<String> articleTypes= new List<String>();

         configOptions = HVEM_Config_Options__c.getInstance('HVEM');
         if(strChosenCategoryGroups != null && strChosenCategoryGroups != '')
             categoryGroups= strChosenCategoryGroups.split(',');

         if(strChosenArticleTypes !=null && strChosenArticleTypes != '')
             articleTypes= strChosenArticleTypes.split(',');


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
         if((replyToAddress == null) || (replyToAddress.length() == 0)){
             replyToBlankError = true;    
         }else{
             if(replyToAddress.split('@',-1).size() > 2){
                 replyToBlankError = true;
             }else{
                 Boolean isValid = HVEMUtil.validateEmail(new String[]{replyToAddress});
                 if(!isValid){
                     replyToBlankError = true; 
                 }
             }
         }
         if(!replyToBlankError){
             if((categoryGroupsLength == 0)||(categoryGroupsLength >= 4)){            
                 categoryGroupsError = true;            
             }
             else if((articleTypesLength == 0)||(articleTypesLength >= 5)){           
                 articleTypesError = true;            
             }                
             else if((baseURL == null) || (baseURL.length() == 0) || (verifyBaseURL() == true)){
                 baseURLBlankError = true;    
             }
             else if(!PublicGroupError){  
                 
                 if(configOptions != null){
                     configOptions = [SELECT name,id FROM HVEM_Config_Options__c WHERE Id = : configOptions.id];
                     configOptions.Article_Types_Filter__c=strChosenArticleTypes;
                     configOptions.Data_Category_Group_Filter__c=strChosenCategoryGroups;
                     configOptions.Available_Data_Category_Group_Filter__c=availableCategoryGroups;
                     configOptions.Article_Link_Base_URL__c=baseURL;
                     configOptions.Reply_To_Mail__c=replyToAddress;
                     configOptions.Auto_Populate_To_Field_From_Case_Contact__c=autoPopulate;
                     configOptions.Default_Email_Template__c=templates;
                     configOptions.Default_Email_Folder__c=folders;
                     configOptions.Allow_Drafts__c = enableDraftEmails;
                     configOptions.Allow_Draft_Approval__c = enableApprovalProcess; 
                     configOptions.Under_Approval_Case_Status__c = caseStatusUnderApproval;                              
                     configOptions.Public_Groups_With_No_Approval__c = selectedPublicGroups;
                     configOptions.Public_Groups_With_No_Approval_Extended__c = selectedPublicGroupsExtended;
                     update configOptions ;
                     caseFilterError = false;
                     saveCS=true; 
                 }
                 else{
                     configOptions =new HVEM_Config_Options__c();
                     configOptions.name='HVEM';
                     configOptions.Available_Data_Category_Group_Filter__c = availableCategoryGroups;
                     configOptions.Article_Types_Filter__c=strChosenArticleTypes;
                     configOptions.Data_Category_Group_Filter__c=strChosenCategoryGroups;
                     configOptions.Article_Link_Base_URL__c=baseURL;
                     configOptions.Auto_Populate_To_Field_From_Case_Contact__c=autoPopulate; 
                     configOptions.Reply_To_Mail__c = replyToAddress; 
                     configOptions.Default_Email_Template__c=templates;
                     configOptions.Default_Email_Folder__c=folders;
                     configOptions.Allow_Drafts__c = enableDraftEmails;
                     configOptions.Allow_Draft_Approval__c = enableApprovalProcess;
                     configOptions.Under_Approval_Case_Status__c = caseStatusUnderApproval;             
                     configOptions.Public_Groups_With_No_Approval__c = selectedPublicGroups;
                     configOptions.Public_Groups_With_No_Approval_Extended__c = selectedPublicGroupsExtended;                
                     insert configOptions;
                     caseFilterError = false;
                     saveCS=true;
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
                 configOptions.Name = System.now().getTime() + 'CaseMap';
                 configOptions.Case_Mappin_API__c = apiString;
                 configOptions.Case_Mapping_Label__c = apiLabelFilterMap.get(apiString);                                
                 //if(!apiStringSet.contains(apiString)){
                 insert configOptions; 
                 //}                                                   
             }  
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
         options.add(new SelectOption('None','Please select a template folder'));
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
         options.add(new SelectOption('None','Please select a template'));
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
         if(selectedPickListCaseField == null){
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
         }
         return null;
     }

     /**
      * function to add options to picklist to display the fields of cases with type picklist.
      */
     public List<SelectOption> getCasePickListFields(){
         //Map<String, Schema.SObjectField> fieldMap = Schema.SObjectType.Case.fields.getMap();
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

}