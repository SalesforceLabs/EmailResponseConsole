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

/* HVEMEmailEditorCompCtrl Class
* This Class is used to populate default values and perform all functionalities related to Deatil Email Editor Component
*/
public with Sharing class HVEMEmailEditorCompCtrl {
    public Id caseId{get; set;}
    public EmailMessage finalEmail {get; set;}
    public Folder folderInstance{get;set;}
    public Organization orgIns{get;set;}
    public Case caseInstance{get; set;}
    public Case caseFromQueue{get; set;}
    public Task taskInstance {get; set;}
    public EmailMessage emailMessageInstance{get;set;}
    public HVEM_Config_Options__c configOptions{get;set;}
    public EmailTemplate emailtemplate{get; set;}
    //Case Instance for temporary usage.
    public Case temporaryCase{get;set;}

    public List<Case> caseList{get;set;}
    public List<EmailMessage>emailMessageList{get;set;}
    public List<GroupMember> loggedInUserQueueList {get; set;}
    public List<Case> casesInQueueList{get; set;}
    public List<boolean> incomingMail{get;set;}
    public List<folder> folderList{get;set;}
    public List<EmailTemplate> templateList{get;set;}
    public List<DraftEmailMessage__c> currentDraft {get; set;}
    public List<String> articleContentList{get;set;}


    public boolean isValidated {get; set;}
    public boolean isNoCustomError {get; set;}
    public boolean includeThread{get;set;}
    public boolean bodyBlankError{get;set;}
    public boolean subjectblankError{get;set;}
    public boolean toEmailBlankError{get;set;}
    public boolean changeCaseOwnerError {get; set;}
    public Boolean isBccAddressValid{get; set;}
    public Boolean isAdditionalToAddressValid{get; set;}
    public Boolean isCcAddressValid{get; set;}
    public boolean noCaseInQueueError{get;set;}
    public boolean emailBodyLengthExceededError{get;set;}
    public Boolean noQueueAssigned {get; set;}
    public boolean enableDraftEmails{get;set;}
    public boolean enableChangeCaseStatus{get;set;}

    public Integer emailCount{get;set;}
    public String thread{get;set;}
    public String emailSubject {get; set;}
    public String additionalTo {get; set;}
    public String addCc {get; set;}
    public String addBcc {get; set;}
    public String selectedTemplate {get; set;}
    public String caseStatus{get;set;}
    public String emailBody{get;set;}
    public String userName{get;set;}
    public String userEmailAddress {get;set;}
    public String htmlBody{get; set;}
    public EmailTemplate selectedEmailTemplate {get; set;}
    public String editorHtmlValue {get; set;}
    public String finalQueueId{get; set;}
    public Id loggedUser {get; set;}
    public String bodyValue {get; set;}
    public User activeUser{get; set;}
    public String ccAddress {get; set;}
    public String bccAddress {get; set;}
    public String additionalToAddress {get; set;}
    private HVEMDBhelper dbHelper {get; set;}
    public boolean superUserApprovalRendered{get;set;}
    public Boolean superUserApproval {get; set;}
    public boolean isSuperUser{get;set;}
    public boolean statusChanged{get;set;}
    public String folders{get;set;}
    public String selectedKnowledgeArticleId{get; set;}
    public String articleTypeOfSelectedArticle{get;set;}
    public String selectedKnowledgeArticleFrameSourceId{get;set;}
    public String articleTitle{get;set;}
    public String articleSummary{get;set;}
    public String templateType {get; set;}



    /** Phase II Variable declaration -- START */

    public Boolean isActiveStatus {get; set;}
    public Boolean draftSaved {get; set;}
    public DraftEmailMessage__c draftInstance {get; set;}
    public Boolean isUnderApproval {get;set;}
    public boolean isRejected{get;set;}
    public String HTMLValue {get; set;}
    public String rejectionComment{get;set;}
    public DraftEmailMessage__c lDraftEmailMessageInstance{get;set;}
    public boolean isTemplateDeleted{get;set;}
    public boolean isServiceCloud{get;set;}
    public String type{get;set;}

    /**
    * Constructor
    */
    public List<EmailTemplate> emailTemplateList {get; set;}
    public HVEMEmailEditorCompCtrl(){
        loggedUser  = Userinfo.getuserId();
        loggedInUserQueueList = new List<GroupMember>();
        articleContentList = new List<String>();
        casesInQueueList = new List<Case>();
        folderList = new List<folder>();
        selectedEmailTemplate = new EmailTemplate();
        dbHelper = new HVEMDBhelper();
        caseId = ApexPages.currentPage().getParameters().get('Id');
        String isDtpParam= ApexPages.currentPage().getParameters().get('isdtp');
        isServiceCloud = false;
        orgIns  = new Organization();
        orgIns = [Select Id From Organization LIMIT 1];
        folderInstance = new folder();
        caseInstance = new Case();
        finalEmail = new EmailMessage();
        taskInstance = new Task();
        configOptions = new HVEM_Config_Options__c();
        thread='';
        rejectionComment = '';
        selectedKnowledgeArticleId = '';
        articleTypeOfSelectedArticle = '';
        articleTitle = '';
        templateType = '';
        articleSummary = '';
        selectedKnowledgeArticleFrameSourceId = '';
        isUnderApproval = false;
        isRejected = false;
        isTemplateDeleted = false;
        superUserApprovalRendered = false;
        enableDraftEmails=false;
        enableChangeCaseStatus = false;
        // Get full user instance
        userName = UserInfo.getUserName();
        Id userId = UserInfo.getUserId();
        activeUser = [Select Email,TimeZoneSidKey,HVEM_User__c From User where Id = : userId limit 1];
        userEmailAddress = activeUser.Email;
        configOptions = HVEM_Config_Options__c.getInstance('HVEM');
        if(isDtpParam != null && activeUser.HVEM_User__c == true){
            isServiceCloud = true;
        }
        caseFromQueue = new Case();
        if(configOptions != null){
            selectedTemplate = configOptions.Default_Email_Template__c;
            enableDraftEmails = configOptions.Allow_Drafts__c;
            enableChangeCaseStatus = configOptions.Allow_changing_case_status__c;
        }
        else{
            selectedTemplate = 'none';
        }
        folderList = [Select Name,Id From Folder where Type='Email' AND AccessType='Public'];
            try{
                    folders = configOptions.Default_Email_Folder__c;

            }
            catch(Exception e){
                selectedTemplate = 'None';
                }

        emailTemplateList = new List<EmailTemplate>();
        emailMessageList= new List<EmailMessage>();
        emailMessageList = [Select ParentId,CcAddress,CreatedDate,FromAddress,FromName, HTMLbody, ToAddress,TextBody, Subject, MessageDate, inComing From EmailMessage where ParentId=:caseId order By CreatedDate desc];
        emailCount = emailMessageList.size();
        incomingMail = new List<boolean>();
        for(EmailMessage singleEmail : emailMessageList){
            incomingMail.add(singleEmail.incoming);
        }

        // Get full case Instance
        //caseInstance = [Select Type, PotentialLiability__c ,SLAViolation__c,SystemModstamp, SuppliedPhone, SuppliedName, SuppliedEmail, SuppliedCompany, Subject, Status, Reason, Priority, ParentId, OwnerId, Origin, LastModifiedDate, LastModifiedById, IsEscalated, IsDeleted, IsClosed, Id,  Description, CreatedDate, CreatedById, ContactId, ClosedDate, CaseNumber, AssetId, AccountId From Case where Id=:caseId];
        List<Case> caseListLocal  = new List<Case>();
        HVEMConditionBuilder lCondition = new HVEMConditionBuilder();
        lCondition.setCondition('Id=\'' + caseId + '\'');
        List<String> fields = new List<String>();
        caseListLocal = dbHelper.getQueryResults(new Case(), fields, lCondition);
        if(caseListLocal != null && caseListLocal.size() > 0){
            caseInstance = caseListLocal[0];
        }else{
            caseInstance = new Case();
        }
        if(configOptions == null){
            caseInstance.contactId = null;
        }
       emailSubject = 'Re: ' + caseInstance.Subject;
       caseStatus = caseInstance.Status;
       if(configOptions != null){
           if(configOptions.Auto_Populate_To_Field_From_Case_Contact__c == false){
               caseInstance.contactId = null;
           }
       }
       editorHtmlValue = '';

       // Phase II Implementation -- START
        draftInstance = new DraftEmailMessage__c();
        List<String> activeStatus = String.valueOf(HVEMUtil.DraftEmailActiveStatus).split(',',-1);
        currentDraft = [SELECT id,BccAddress__c,Include_Thread__c,Case__c,CcAddress__c,FromAddress__c,FromName__c,FutureCaseStatus__c,HtmlBody__c,OldCaseStatus__c,Status__c,Subject__c,TemplateId__c,TextBody__c,ToAddress__c,FolderId__c FROM DraftEmailMessage__c WHERE Case__r.id =: caseId AND (Status__c IN : activeStatus )];
        if(currentDraft.size() == 1 && currentDraft[0].status__c != 'Approved'){
            isActiveStatus = true;
            draftInstance = currentDraft[0];

            //Approval Implementaion
            if(configOptions != null){
                if(configOptions.Allow_Draft_Approval__c == true ){
                    if(draftInstance.Status__c == 'Approval'){
                        isUnderApproval = true;
                    }
                    else if(draftInstance.Status__c == 'Rejected'){
                        List<ProcessInstance> processInstanceList = new List<ProcessInstance>();
                        ProcessInstance processInstanceIns = new ProcessInstance();
                        processInstanceList = [Select TargetObjectId, Status, IsDeleted, Id From ProcessInstance where Status='Rejected' AND TargetObjectId =:draftInstance.id ORDER BY SystemModstamp DESC];
                        if(processInstanceList != null && processInstanceList.size() > 0){
                            processInstanceIns = processInstanceList[0];
                        }
                        ProcessInstanceStep processInstanceStepIns = new ProcessInstanceStep();
                        processInstanceStepIns = [Select Id, Comments From ProcessInstanceStep where ProcessInstanceId = :processInstanceIns.id AND StepStatus = 'Rejected'];
                        isRejected = true;
                        rejectionComment = processInstanceStepIns.Comments;
                    }
                }
            }
            //End of Approval implementation

            emailSubject = draftInstance.Subject__c;
            addCc =  draftInstance.CcAddress__c;
            addBcc = draftInstance.BccAddress__c;
            List<String> additionalToList = new List<String>();
            if(draftInstance.ToAddress__c != null){
                additionalToList = draftInstance.ToAddress__c.split(';',2);
            }
            if(additionalToList.size() == 0){
                additionalTo = '';
                caseInstance.contactId = null;
            }else{
                Contact contactInstance = [SELECT id FROM Contact WHERE Email =:additionalToList[0] LIMIT 1];
                if(additionalToList[0] != null && additionalToList[0] != ''){
                    caseInstance.contactId = contactInstance.Id;
                }else{
                    caseInstance.contactId = null;
                }
                if(additionalToList.size() > 1){
                    if(additionalToList[1] != null && additionalToList[1] != ''){
                        additionalTo = additionalToList[1];
                    }else{
                        additionalTo = '';
                    }
                }
            }
            caseStatus = draftInstance.FutureCaseStatus__c;
            includeThread = draftInstance.Include_Thread__c;
            folders = draftInstance.FolderId__c;
            //Approval Implementaion
            if(draftInstance.Status__c == 'Approval'){
                isUnderApproval = true;
                if(configOptions != null){
                    if(configOptions.Allow_Draft_Approval__c == true && (configOptions.Under_Approval_Case_Status__c != null && configOptions.Under_Approval_Case_Status__c != '')){
                        caseStatus = configOptions.Under_Approval_Case_Status__c;
                    }
                }
            }
        }
        lDraftEmailMessageInstance = new DraftEmailMessage__c();
        isSuperUser = verifyUser();
        if(isSuperUser){
            superUserApprovalRendered = true;
        }

         // Phase II Implementation -- END

        try{
            if(selectedTemplate != 'none'){
                selectedEmailTemplate = [Select e.HtmlValue,e.Id,e.FolderId,e.templateType,e.body  From EmailTemplate e WHERE e.Id = : selectedTemplate AND isActive = true];
                type = selectedEmailTemplate.templateType;
                 folders = configOptions.Default_Email_Folder__c;
                if(selectedEmailTemplate.Body != null && selectedEmailTemplate.Body != ''){
                    if(selectedEmailTemplate.templateType == 'text'){
                        bodyValue =  String.valueOf(selectedEmailTemplate.body).replaceAll('\n','<br/>');
                    }
                }
            }

            // Extract merge field values

            PageReference emailEditorPageRef;
            if(configOptions != null){
                if(configOptions.Default_Email_Template__c != '' && configOptions.Default_Email_Template__c != 'None'){
                 emailEditorPageRef = new PageReference(URL.getSalesforceBaseUrl().getProtocol() + '://' + URL.getSalesforceBaseUrl().getHost() + '/email/author/emailauthor.jsp?retURL=/' + caseId + '&p3_lkid=' + caseId + '&rtype=003&p2_lkid=' + caseInstance.ContactId + '&template_id=' + configOptions.Default_Email_Template__c);
                 String fullHtml  =  emailEditorPageRef.getContent().toString();
                   String finalContent = extractContent(selectedEmailTemplate.templateType , fullHtml);
                   bodyValue = finalContent;
                }
            }
        }
        catch(Exception e){
            selectedTemplate = 'none';
            bodyValue ='';
        }
        Finally{
            try{
                 // Phase II Implementation -- START
                 if(currentDraft.size() == 1 && currentDraft[0].status__c != 'Approved'){
                    selectedTemplate = draftInstance.TemplateId__c;
                    if(selectedTemplate !='None'){
                      folders = draftInstance.FolderId__c;
                    }
                    else{
                        folders='None';
                    }

                    //Body load
                     if(selectedTemplate != 'none'){
                        selectedEmailTemplate = [Select e.HtmlValue,e.Id,e.FolderId,e.templateType,e.body  From EmailTemplate e WHERE e.Id = : selectedTemplate];
                        type = selectedEmailTemplate.templateType;
                            if(selectedEmailTemplate.templateType == 'text'){
                                if(draftInstance.TextBody__c != null && draftInstance.TextBody__c!= ''){
                                    bodyValue =  String.valueOf(draftInstance.TextBody__c).replaceAll('\n','<br/>');
                                }else{
                                    bodyValue = '';
                                }
                            }else if(selectedEmailTemplate.templateType == 'custom'){
                                if(draftInstance.HtmlBody__c != null && draftInstance.HtmlBody__c!= ''){
                                    bodyValue = String.valueOf(draftInstance.HtmlBody__c);
                                }else{
                                    bodyValue = '';
                                }
                            }
                     }else{
                         folders = draftInstance.FolderId__c;
                        if(draftInstance.TextBody__c != null && draftInstance.TextBody__c!= ''){
                                type = 'text';
                                bodyValue =  String.valueOf(draftInstance.TextBody__c).replaceAll('\n','<br/>');
                        }else if(draftInstance.HtmlBody__c != null && draftInstance.HtmlBody__c!= ''){
                                type = 'custom';
                                bodyValue = String.valueOf(draftInstance.HtmlBody__c);
                           }

                     }
                 }
            }
            catch(Exception e){
                selectedTemplate = 'none';
                if(draftInstance.TextBody__c != null && draftInstance.TextBody__c!= ''){
                    type = 'text';
                    bodyValue =  String.valueOf(draftInstance.TextBody__c).replaceAll('\n','<br/>');
                }else if(draftInstance.HtmlBody__c != null && draftInstance.HtmlBody__c!= ''){
                    type = 'custom';
                    bodyValue = String.valueOf(draftInstance.HtmlBody__c);
                }
            }

             // Phase II Implementation -- END
        }

        //temporary usage
        temporaryCase = new Case();

    }

    /**
    * Function to extract content with merge fields
    */
    public String extractContent(String templateType, String fullHtml){
        String finalContent = '';
        String valueString = '';
        if(templateType == 'text'){
            String var = '<input type="hidden" ' + ' id=\"text_body_hidden\" ' + 'name=\"text_body_hidden\"';
            List<String> contentList = fullHtml.split(var);
            if(contentList.size() > 0 ){
                valueString = contentList[1];
            }

            List<String> valueList = valueString.split('"');
            if(valueList.size() > 0 ){
                finalContent =  valueList[1];
            }
            return finalContent;
        }else if(templateType == 'custom'){
            String var = '<input type="hidden" ' + ' id=\"html_body_hidden\" ' + 'name=\"html_body_hidden\"';
            List<String> contentList = fullHtml.split(var);
            if(contentList.size() > 0 ){
                valueString = contentList[1];
            }
            List<String> valueList = valueString.split('"');
            if(valueList.size() > 0 ){
                finalContent =  valueList[1];
            }
            return finalContent;
        }
        return finalContent;
    }
    /**
    * Function to verify user whether current user is Super user or not
    */
    public boolean verifyUser(){
        boolean isSuperUser = false;
        Set<Id> superUserSet = new Set<Id>();
        if(configOptions != null){
            if(configOptions.Allow_Draft_Approval__c == true && (configOptions.Public_Groups_With_No_Approval__c != null && configOptions.Public_Groups_With_No_Approval__c != '')){
                List<String> superGroupList = new List<String>();
                superGroupList = configOptions.Public_Groups_With_No_Approval__c.split(',');
                Set<Id> userInSingleGroupSet = new Set<Id>();
                for(String supergroupIdString : superGroupList){
                    Id supergroupId = (ID)supergroupIdString;
                    userInSingleGroupSet = GetUserIdsFromGroup(supergroupId);
                    superUserSet.addAll(userInSingleGroupSet);
                }
                if(superUserSet.contains(loggedUser)){
                    isSuperUser = true;
                }
            }
        }
        return isSuperUser;
    }

    /**
    * Function to get the set of Super users under the specified group.
    */
    private Set<Id> GetUserIdsFromGroup(String groupId){
        // store the results in a set so we don't get duplicates
        Set<ID> result=new Set<ID>();
        String userType = Schema.SObjectType.User.getKeyPrefix();
        String groupType = Schema.SObjectType.Group.getKeyPrefix();

        // Loop through all group members in a group
        for (GroupMember m : [Select Id, UserOrGroupId From GroupMember Where GroupId = :groupId]){
            // If the user or group id is a user
            if (((String)m.UserOrGroupId).startsWith(userType)){
                result.add(m.UserOrGroupId);
            }
            // If the user or group id is a group
            else if (((String)m.UserOrGroupId).startsWith(groupType)){
                // Call this function again but pass in the group found within this group
                result.addAll(GetUserIdsFromGroup(m.UserOrGroupId));
            }
        }

        return result;
    }
    /**
    * Function to perform actions if Next Case Present in Queue
    */
    public void checkNextCasePresent(){
       /*
                 * retrieve cookie stored for queue id
                 */
                 noQueueAssigned = false;
                 noCaseInQueueError  = false;
                 List<QueueSobject> queueSobjectList = [SELECT Queue.Id FROM QueueSobject WHERE SobjectType = 'Case'];
                 List<Id> queueSobjIdList = new List<Id>();
                 for(QueueSobject queueInstance : queueSobjectList){
                     queueSobjIdList.add(queueInstance.Queue.Id);
                 }

                 loggedInUserQueueList = [SELECT Group.Name, Group.Id FROM GroupMember WHERE UserOrGroupId = : loggedUser AND Group.Type = 'Queue' AND Group.Id IN:queueSobjIdList];
                 Cookie queuePageCookie = ApexPages.currentPage().getCookies().get('queueId');
                 if(queuePageCookie  != null){
                    finalQueueId = queuePageCookie.getValue();
                 }else{
                    if(loggedInUserQueueList !=null && loggedInUserQueueList.size() > 0){
                        finalQueueId =  loggedInUserQueueList[0].Group.Id;
                    }else{
                        noQueueAssigned = true;
                    }
                 }

                 if(finalQueueId != null && finalQueueId != ''){
                     if(finalQueueId.contains('idSelectedQueue_')){
                        finalQueueId = finalQueueId.replace('idSelectedQueue_', '');
                     }
                 }
                 /**
                 * code to check if queue saved in cookie still present
                 **/
                 Boolean isQueuePresent = false;
                 if(loggedInUserQueueList.size() != null && loggedInUserQueueList.size() > 0){
                     for(GroupMember loggedInUserQueueInstance : loggedInUserQueueList){
                         if(loggedInUserQueueInstance.Group.Id == finalQueueId){
                             isQueuePresent = true;
                         }
                     }
                 }else{
                     noQueueAssigned = true;
                 }
                 /*
                 * get selected queue count list
                 */
                // Common code to be used in both If and Else

                if(isQueuePresent){
                    if(finalQueueId != null && finalQueueId != ''){
                        HVEMConditionBuilder lCondition = new HVEMConditionBuilder();
                        lCondition.setCondition('OwnerId = \'' + finalQueueId + '\' AND Status != \'Closed\' ORDER BY LastModifiedDate ASC');
                        List<String> fields = new List<String>();
                        fields.add('caseNumber');
                        fields.add('IsEscalated');
                        fields.add('Owner.Name');
                        fields.add('Subject');
                        fields.add('Status');
                        fields.add('Contact.Name');
                        casesInQueueList = dbHelper.getQueryResults(new Case(), fields, lCondition);
                        if(casesInQueueList.size() > 0){
                            casesInQueueList[0].OwnerId = loggedUser;
                            update casesInQueueList[0];
                            caseFromQueue = [SELECT id,caseNumber,IsEscalated,Owner.Name,Subject,Status,Contact.Name FROM Case WHERE id=: casesInQueueList[0].Id];
                        }else{
                            noCaseInQueueError = true;
                        }
                    }
                    else{
                        noCaseInQueueError = true;
                    }
                }else{
                    if(loggedInUserQueueList !=null && loggedInUserQueueList.size() > 0){
                        finalQueueId =  loggedInUserQueueList[0].Group.Id;
                        HVEMConditionBuilder lCondition = new HVEMConditionBuilder();
                        lCondition.setCondition('OwnerId = \'' + finalQueueId + '\' AND Status != \'Closed\' ORDER BY LastModifiedDate ASC');
                        List<String> fields = new List<String>();
                        fields.add('caseNumber');
                        fields.add('IsEscalated');
                        fields.add('Owner.Name');
                        fields.add('Subject');
                        fields.add('Status');
                        fields.add('Contact.Name');
                        casesInQueueList = dbHelper.getQueryResults(new Case(), fields, lCondition);

                        if(casesInQueueList.size() > 0){
                            casesInQueueList[0].OwnerId = loggedUser;
                            update casesInQueueList[0];
                            caseFromQueue = [SELECT id,caseNumber,IsEscalated,Owner.Name,Subject,Status,Contact.Name FROM Case WHERE id=: casesInQueueList[0].Id];
                        }else{
                            noCaseInQueueError = true;
                        }
                    }else{
                        noQueueAssigned = true;
                    }
                }
                finalQueueId = 'idSelectedQueue_' + finalQueueId ;
                Cookie queuePageCookieNew = ApexPages.currentPage().getCookies().get('queueId');
                queuePageCookieNew = new Cookie('queueId',finalQueueId ,null,-1,false);
                ApexPages.currentPage().setCookies(new Cookie[]{queuePageCookieNew});
    }


    /**
    * Function to perform actions on click os 'Save n New' Button.
    */
    public void sendAndNextAction(){
        isSuperUser = false;
        isRejected = false;
        isSuperUser = verifyUser();

        try{
            Datetime myDT = Datetime.now();
            String myDate = myDT.format('yyyy.MM.dd HH:mm:ss:sss z');
            List<String> values=  myDate.split(' ');
            String timeZone = values.get(values.size() - 1);
             if(selectedEmailTemplate.TemplateType == 'text' || selectedEmailTemplate.TemplateType == ''){
                emailBody = emailBody.replaceAll('\n','<br/>');
             }
            if(includeThread == true){
                if(emailMessageList.size() != 0){
                    thread = emailBody;
                        for(EmailMessage emailTemplateInstance : emailMessageList){
                            if(emailTemplateInstance.HtmlBody != null && emailTemplateInstance.HtmlBody != ''){
                                thread = thread + '<br/><br/>_____________________________________________________________________<br/><br/><b>From:</b> ' +  emailTemplateInstance.FromName  + '<br/><b>Reply-To:</b> ' +  emailTemplateInstance.FromName  +  '<br/><b>Sent</b>: ' +  emailTemplateInstance.CreatedDate + ' ' + timeZone +  '<br/><b>To</b>: ' + emailTemplateInstance.ToAddress + '<br/><b>Subject</b>: ' +  emailTemplateInstance.Subject+'<br/><br/>' + emailTemplateInstance.HtmlBody + '<br/><br/>'  ;
                            }else{
                                thread = thread + '<br/><br/>_____________________________________________________________________<br/><br/><b>From:</b> ' +  emailTemplateInstance.FromName  + '<br/><b>Reply-To:</b> ' +  emailTemplateInstance.FromName  +  '<br/><b>Sent</b>: ' +  emailTemplateInstance.CreatedDate + ' ' + timeZone + '<br/><b>To</b>: ' + emailTemplateInstance.ToAddress + '<br/><b>Subject</b>: ' +  emailTemplateInstance.Subject+'<br/><br/>' + String.valueOf(emailTemplateInstance.TextBody).replaceAll('\n','<br/>') + '<br/><br/>'  ;
                            }

                        }
                }else{
                    thread = emailBody;
                }
            }
            else{
                thread = emailBody;
            }
             String contactId = caseInstance.contactId;
             /*
             * querying current case instance to be used check 1. current case owner 2.change status
             */
             Case lCaseInstance = [SELECT Id, Status, OwnerId FROM Case WHERE Id=: caseId];
             emailBodyLengthExceededError = false;
             changeCaseOwnerError = false;
             bodyBlankError = false;
             subjectblankError = false;
             toEmailBlankError  = false;
             draftSaved = false;
             isAdditionalToAddressValid = false;
             isCcAddressValid = false;
             isBccAddressValid = false;
             statusChanged = false;
             draftSaved = false;
             /**
             ** Boolean list is local list which will have 0th postition for additional to,1st for cc and 2nd for bcc
             **/
             List<Boolean> emailAddressList = new List<Boolean>();
             for(Integer i=0;i<3;i++){
                 Boolean boolFalse = true;
                 emailAddressList.add(boolFalse);
             }
              List<String> additionalToAddressList = additionalToAddress.split(';');
             if(additionalToAddress != null && additionalToAddress != ''){

                 emailAddressList[0] = HVEMUtil.validateEmail(additionalToAddressList);
             }

             if(emailAddressList[0]){
                 List<String> ccAddressList = ccAddress.split(';');
                 if(ccAddress != null && ccAddress != ''){
                     emailAddressList[1] = HVEMUtil.validateEmail(ccAddressList);
                 }
             }
             if(emailAddressList[1]){
                 List<String> bccAddressList = bccAddress.split(';');
                 if(bccAddress != null && bccAddress != ''){
                     emailAddressList[2] = HVEMUtil.validateEmail(bccAddressList);
                 }
             }
            //if-else to send email or raise error if body is blank
             if(emailBody.length() > 32000){
                emailBodyLengthExceededError = true;
             }else if(lCaseInstance.OwnerId != loggedUser){
                changeCaseOwnerError = true;
             }else if(emailSubject.length() == 0){
                 subjectblankError = true;
             }else if( contactId== null  || contactId == ''){
                 toEmailBlankError  = true;
             }else if(!emailAddressList[0]){
                 isAdditionalToAddressValid = true;
             }else if(!emailAddressList[1]){
                 isCcAddressValid = true;
             }else if(!emailAddressList[2]){
                 isBccAddressValid = true;
             }else if(emailBody.length() == 0){
                 bodyBlankError = true;
             }else{
                 if(configOptions.Allow_Draft_Approval__c == false || (configOptions.Allow_Draft_Approval__c == true && isSuperUser == true && superUserApproval == false)){
                     /*
                     * send email to recipient
                     * different function to reuse the send mail functionality
                     */
                    sendEmail();
                    saveDraft();
                    draftSaved = false;
                    //function to send Email
                      //update Status of the case if changed.
                    if(caseInstance.Status != caseStatus){
                        lCaseInstance.Status = caseStatus;
                        update lCaseInstance;
                    }

               //insert the new Email message into Email Messge object
                    emailMessageInstance = new EmailMessage();

                    Contact contactInstance = new Contact();
                    contactInstance = [Select Email from Contact where Id =:contactId ];
                    String contactEmailAddress = contactInstance.Email;
                    emailMessageInstance.ToAddress = contactEmailAddress;
                    if(selectedEmailTemplate.TemplateType == 'custom'){
                        emailBody = emailBody.replaceAll('<br/>','\n');
                        emailMessageInstance.HtmlBody = emailBody;
                    }else  if(selectedEmailTemplate.TemplateType == 'text'){
                        emailBody = emailBody.replaceAll('<br/>','\n');
                        emailMessageInstance.TextBody = emailBody;
                    }else{
                        emailBody = emailBody.replaceAll('<br/>','\n');
                        emailMessageInstance.TextBody = emailBody;
                    }
                    emailMessageInstance.Subject = emailSubject;
                    emailMessageInstance.ParentId = caseId;
                    emailMessageInstance.FromName = userName;
                    emailMessageInstance.FromAddress = userEmailAddress;
                    emailMessageInstance.CcAddress = ccAddress;
                    emailMessageInstance.BccAddress = bccAddress;
                    insert emailMessageInstance;

                //insert the required fields to Task object
                    taskInstance.WhatId = caseId;
                    taskInstance.WhoId = contactId ;
                    taskInstance.subject= emailSubject;
                    taskInstance.status = 'Completed';
                    taskInstance.Description = 'Additional To:'+additionalTo;
                    taskInstance.ActivityDate = date.today();
                    upsert taskInstance;

                //Change status of DEM record if saved and Sent
                    List<DraftEmailMessage__c> DEMList = new List<DraftEmailMessage__c>();
                    DEMList = [Select id,status__c from DraftEmailMessage__c where case__c=:caseId ];
                    for(DraftEmailMessage__c DEMInstance : DEMList){
                        if(DEMList != null && DEMInstance.status__c == 'Draft'){
                            DEMInstance.status__c = 'Sent';
                            update DEMInstance;
                        }
                    }
               }
                else{
                    isUnderApproval = true;
                    saveDraft();
                    Approval.ProcessSubmitRequest submitRequest = new Approval.ProcessSubmitRequest();
                    submitRequest.setComments(Label.Email_draft_approval);
                    submitRequest.setObjectId(lDraftEmailMessageInstance.id);
                    Approval.ProcessResult result = Approval.process(submitRequest);
                    Case caseInstance = [SELECT Id, Status, OwnerId FROM Case WHERE Id=: caseId];
                }
                //Function call to perform actions if Next Case Present in Queue
                checkNextCasePresent();
                     }
            isValidated = true;
            if(!isBccAddressValid  && !isAdditionalToAddressValid  && !bodyBlankError && !subjectblankError && !toEmailBlankError && !emailBodyLengthExceededError && !isCcAddressValid ){
                isNoCustomError = true;
            }
        }
        catch(EmailException e){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.Invalid_email);
            ApexPages.addMessage(myMsg);
        }
        catch(DmlException e){
            ApexPages.addMessages(e);
            isUnderApproval = false;
            lDraftEmailMessageInstance.status__c = 'Draft';
            update lDraftEmailMessageInstance;
        }
        catch(Exception e){
            ApexPages.addMessages(e);
        }
    }

    /*
    * Functio to populate Email Editor
    */
    public void populateEditor(){
         if(selectedTemplate != 'none' && selectedTemplate != ''){
        /**
        * Extract merge field values
        */
        selectedEmailTemplate = [Select e.HtmlValue,e.Id,e.FolderId,e.templateType,e.body  From EmailTemplate e WHERE e.Id = : selectedTemplate];
        type = selectedEmailTemplate.templateType;
        PageReference emailEditorPageRef = new PageReference(URL.getSalesforceBaseUrl().getProtocol() + '://' + URL.getSalesforceBaseUrl().getHost() + '/email/author/emailauthor.jsp?retURL=/' + caseId + '&p3_lkid=' + caseId + '&rtype=003&p2_lkid=' + caseInstance.ContactId + '&template_id=' + selectedTemplate);
        String fullHtml  =  emailEditorPageRef.getContent().toString();
        String finalContent = extractContent(selectedEmailTemplate.templateType , fullHtml);
        bodyValue = finalContent;

        if(selectedEmailTemplate.templateType == 'text'){
            bodyValue =  String.valueOf(bodyValue).replaceAll('\n','<br/>');
        }else if(selectedEmailTemplate.templateType == 'Custom'){
            bodyValue =  String.valueOf(bodyValue);
        }
      }else{
        selectedEmailTemplate = new EmailTemplate();
        bodyValue = '';
        type='text';
      }


    }

    /**
    * Function to Send Email.
    */
    public void sendEmail(){
        List<String> activeStatus = String.valueOf(HVEMUtil.DraftEmailActiveStatus).split(',',-1);
        List<DraftEmailMessage__c> previousSentDraft = [SELECT id,BccAddress__c,Reply_To_Address__c,Include_Thread__c,Case__c,CcAddress__c,FromAddress__c,FromName__c,FutureCaseStatus__c,HtmlBody__c,OldCaseStatus__c,Status__c,Subject__c,TemplateId__c,TextBody__c,ToAddress__c,FolderId__c FROM DraftEmailMessage__c WHERE Case__r.id =: caseId AND (Status__c = 'Approved' OR Status__c = 'Sent') ORDER BY SystemModstamp DESC LIMIT 1];
        List<String> additionalToList = new List<String>();
        if(additionalToAddress.contains(';')){
            additionalToList = additionalToAddress.split(';');
        }else{
            if(additionalToAddress.length() > 0){
                additionalToList.add(additionalToAddress);
            }
        }
        List<String> ccList = new  List<String>();
        if(ccAddress.contains(';')){
            ccList = ccAddress.split(';');
        }else{
            if(ccAddress.length() > 0){
                ccList.add(ccAddress);
            }
        }
        List<String> bccList = new  List<String>();
        if(bccAddress.contains(';')){
            bccList = bccAddress.split(';');
        }else{
            if(bccAddress.length() > 0){
                bccList.add(bccAddress);
            }
        }
        Messaging.reserveSingleEmailCapacity(2);
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String contactId = caseInstance.contactId;
        Contact contactInstance = new Contact();
        contactInstance = [Select Email from Contact where Id =:contactId ];
        String emailAddress = contactInstance.Email;
        if(additionalToList.size() > 0){
            String tempEmail = additionalToList[0];
            additionalToList[0] = emailAddress;
            additionalToList.add(tempEmail);
        }else{
            additionalToList.add(emailAddress);
        }
        mail.setBccSender(true);
        mail.setToAddresses(additionalToList);
        if(configOptions != null){
                String replyTo = '';
                if(previousSentDraft != null && previousSentDraft.size() > 0){
                    replyTo = previousSentDraft[0].Reply_To_Address__c;
                }else{
                    replyTo = replyToAddressToUse();

                }
                mail.setReplyTo(replyTo);
        }
        if(ccList.size() > 0){
            mail.setCcAddresses(ccList);
        }
        if(bccList.size() > 0){
            mail.setBccAddresses(bccList);
        }
        mail.setSenderDisplayName(userName);

        mail.setUseSignature(false);
        /*
        * Populate ref field in email subject
        */
        String finalRef = '';

        finalRef = ' [ref:'   + String.valueOf(orgins.Id).substring(0, 4) + String.valueOf(orgins.Id).substring(String.valueOf(orgins.Id).length() - 7,String.valueOf(orgins.Id).length() - 3) + '.';
        finalRef = finalRef + String.valueOf(caseId).substring(0, 4) + String.valueOf(caseId).substring(String.valueOf(caseId).length() - 8,String.valueOf(caseId).length() - 3) + ':ref]';
        mail.setSubject(emailSubject + finalRef );
       mail.setHtmlBody(thread);

        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

    }

    /**
    * Function to add email Templates to the SelectList
    * according to their respective folders.
    */
    public List<SelectOption> getEmailTemplates(){
         List<SelectOption> options = new List<SelectOption>();
         emailTemplateList = [Select Id, Name, TemplateType, Folder.Name From EmailTemplate where (TemplateType = 'Text' OR TemplateType = 'Custom' ) AND IsActive=true order by folderId];
         String folderName;
         ID folderId;
         //if for null check on the emailTemplateList List
         options.add(new SelectOption('None' ,'None'));
         if(emailTemplateList != null && !emailTemplateList.isEmpty()){
             folderId = emailTemplateList[0].folderId;
             //if else to add The first folder Name to the selectList
             if(emailTemplateList[0].folderId != orgIns.Id){
                 if(emailTemplateList[0].folderId != UserInfo.getUserId()){
                     folderInstance = [select Id,Name from folder where Id=:emailTemplateList[0].folderId];
                     folderName = folderInstance.Name;
                     options.add(new SelectOption(emailTemplateList[0].folderId ,folderName+':',true));
                 }
             }
             else{
                 folderName = Label.Unfiled_Public_Email_Templates;
                 options.add(new SelectOption(emailTemplateList[0].folderId ,folderName+':',true));
             }

             //for to add email templates and their respective folders to the SelectList
             for(EmailTemplate emailInstance : emailTemplateList ){
                 if(emailInstance.folderId != orgIns.Id){
                     if(emailInstance.folderId != UserInfo.getUserId()){
                         folderInstance = [select Id,Name from folder where Id=:emailInstance.folderId];
                         folderName = folderInstance.Name;
                     }
                 }
                 else{
                     folderName =  Label.Unfiled_Public_Email_Templates;                 }
                 //if loop to add remaining folder names to the SelectList
                 if((folderId != emailInstance.FolderId) && (emailInstance.folderId != UserInfo.getUserId())){
                     options.add(new SelectOption(emailInstance.FolderId ,folderName+':',true));
                     folderId = emailInstance.FolderId;
                 }
                 //if to add email templated NOT belonging to the Personel Email Folders.
                 if(emailInstance.folderId != UserInfo.getUserId()){
                     options.add(new SelectOption(emailInstance.Id ,'- '+emailInstance.Name));
                 }
             }//end of for
         }//end of if
         return options;
    }

    /**
    * Function to add options to the case's Status SelectList
    */
    public List<SelectOption> getCaseStatusFieldValues(){
        Map<String, Schema.SObjectField> fieldMap = Schema.SObjectType.Case.fields.getMap();
        List<SelectOption> options = new List<SelectOption>();
        for(Schema.SObjectField value : fieldMap.values()){
            Schema.DescribeFieldResult fieldResult = value.getDescribe();
            String fieldName= String.valueOf(fieldResult.getName());
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
    * PHASE - II
    */
    /**
    * function called on click of Save draft functionality
    **/
    public void saveDraft(){
        isRejected = false;
        isAdditionalToAddressValid = false;
        isCcAddressValid = false;
        isBccAddressValid = false;
        emailBodyLengthExceededError = false;
        changeCaseOwnerError = false;
        bodyBlankError = false;
        subjectblankError = false;
        toEmailBlankError  = false;
        Case lCaseInstance = [SELECT Id, Status, OwnerId FROM Case WHERE Id=: caseId];
        emailBodyLengthExceededError = false;
        changeCaseOwnerError = false;
        statusChanged = false;
        draftSaved = false;
        List<DraftEmailMessage__c> previousSentDraft = [SELECT id,BccAddress__c,Reply_To_Address__c,Include_Thread__c,Case__c,CcAddress__c,FromAddress__c,FromName__c,FutureCaseStatus__c,HtmlBody__c,OldCaseStatus__c,Status__c,Subject__c,TemplateId__c,TextBody__c,ToAddress__c,FolderId__c FROM DraftEmailMessage__c WHERE Case__r.id =: caseId AND (Status__c = 'Approved' OR Status__c = 'Sent') ORDER BY SystemModstamp DESC LIMIT 1];
        if(emailBody.length() > 32000){
           emailBodyLengthExceededError = true;
        }else if(lCaseInstance.OwnerId != loggedUser){
           changeCaseOwnerError = true;
        }else{
            Contact contactInstance = new Contact();
            List<String> activeStatus = String.valueOf(HVEMUtil.DraftEmailActiveStatus).split(',',-1);
            currentDraft = [SELECT id,CcAddress__c FROM DraftEmailMessage__c WHERE Case__r.id =: caseId AND (Status__c IN : activeStatus )];
            if(currentDraft.size() == 1){
                lDraftEmailMessageInstance = currentDraft[0];
            }else{
                lDraftEmailMessageInstance = new DraftEmailMessage__c();
            }

            if(caseInstance.contactId != null){
                contactInstance = [Select Email from Contact where Id =:caseInstance.contactId];
                if(additionalTo == ''){
                    lDraftEmailMessageInstance.ToAddress__c = contactInstance.Email;
                }else{
                    lDraftEmailMessageInstance.ToAddress__c = contactInstance.Email + ';' + additionalTo;
                }
            }else{
                if(additionalTo == ''){
                    lDraftEmailMessageInstance.ToAddress__c = '';
                }else{
                    lDraftEmailMessageInstance.ToAddress__c = ';' + additionalTo;
                }
            }
            emailBody = emailBody.replaceAll('<br/>','\n');

            if(type == 'custom'){
                lDraftEmailMessageInstance.HtmlBody__c = emailBody;
                lDraftEmailMessageInstance.EmailTemplate_Type__c = 'custom';
                lDraftEmailMessageInstance.TextBody__c = '';
            }else if(type == 'text'){
                lDraftEmailMessageInstance.TextBody__c = emailBody;
                lDraftEmailMessageInstance.EmailTemplate_Type__c = 'text';
                lDraftEmailMessageInstance.HtmlBody__c = '';
            }else{
                lDraftEmailMessageInstance.TextBody__c = emailBody;
                lDraftEmailMessageInstance.EmailTemplate_Type__c = 'text';
                lDraftEmailMessageInstance.HtmlBody__c = '';
            }

            lDraftEmailMessageInstance.Subject__c = emailSubject;
            lDraftEmailMessageInstance.Case__c = caseId;
            lDraftEmailMessageInstance.FromName__c = userName;
            lDraftEmailMessageInstance.FromAddress__c = userEmailAddress;
            lDraftEmailMessageInstance.CcAddress__c = ccAddress;
            lDraftEmailMessageInstance.BccAddress__c = bccAddress;
            lDraftEmailMessageInstance.OldCaseStatus__c  = caseInstance.Status;
            lDraftEmailMessageInstance.FutureCaseStatus__c  = caseStatus;
            lDraftEmailMessageInstance.Include_Thread__c  = includeThread;

            if(previousSentDraft != null && previousSentDraft.size() > 0){
                lDraftEmailMessageInstance.Reply_To_Address__c = previousSentDraft[0].Reply_To_Address__c;
            }else{
                lDraftEmailMessageInstance.Reply_To_Address__c = replyToAddressToUse();
            }

            if(isUnderApproval == true){
                lDraftEmailMessageInstance.Status__c = 'approval';
            }
            else{
                lDraftEmailMessageInstance.Status__c = 'Draft';
            }

            if(enableDraftEmails == true){
              if(selectedTemplate != ''){
                       lDraftEmailMessageInstance.TemplateId__c = selectedTemplate;
                       lDraftEmailMessageInstance.FolderId__c = folders;
                }
            }
            upsert lDraftEmailMessageInstance;

            if(isUnderApproval == true){
                 draftSaved = false;
            }
            else{
                draftSaved = true;
            }

        }
    }

    /**
    * function called on click of Discard changes functionality
    **/
    public void discardDraft(){
        isAdditionalToAddressValid = false;
        isCcAddressValid = false;
        isBccAddressValid = false;
        statusChanged = false;
        bodyBlankError = false;
        emailBodyLengthExceededError = false;
        changeCaseOwnerError = false;
        bodyBlankError = false;
        subjectblankError = false;
        toEmailBlankError  = false;

        List<String> activeStatus = String.valueOf(HVEMUtil.DraftEmailActiveStatus).split(',',-1);
        List<DraftEmailMessage__c> currentDraft = [SELECT id,CcAddress__c FROM DraftEmailMessage__c WHERE Case__r.id =: caseId AND (Status__c IN : activeStatus )];
        if(currentDraft.size() == 1){
            currentDraft[0].Status__c = 'Deleted';
            update currentDraft[0];
            draftSaved = false;
            isUnderApproval = false;
            isRejected = false;
        }
        additionalTo = '';
        addCc = '';
        addBcc = '';
        if(configOptions == null){
            caseInstance.contactId = null;
        }
        caseInstance = [Select Type, SystemModstamp, SuppliedPhone, SuppliedName, SuppliedEmail, SuppliedCompany, Subject, Status, Reason, Priority, ParentId, OwnerId, Origin, LastModifiedDate, LastModifiedById, IsEscalated, IsDeleted, IsClosed, Id,  Description, CreatedDate, CreatedById, ContactId, ClosedDate, CaseNumber, AssetId, AccountId From Case where Id=:caseId];
        emailSubject = 'Re: ' + caseInstance.Subject;
        caseStatus = caseInstance.Status;
        try{
            if(configOptions != null){
                if(configOptions.Auto_Populate_To_Field_From_Case_Contact__c == false){
                   caseInstance.contactId = null;
                }
                selectedTemplate = configOptions.Default_Email_Template__c;
                selectedEmailTemplate = [Select e.HtmlValue,e.Id,e.FolderId,e.templateType,e.body  From EmailTemplate e WHERE e.Id = : selectedTemplate AND isActive = true];
                type = selectedEmailTemplate.templateType;
                folders = configOptions.Default_Email_Folder__c;
                if(selectedEmailTemplate.templateType == 'text'){
                    bodyValue =  String.valueOf(selectedEmailTemplate.body).replaceAll('\n','<br/>');
                }
                PageReference emailEditorPageRef;

                if(configOptions.Default_Email_Template__c != '' && configOptions.Default_Email_Template__c != 'None'){
                 emailEditorPageRef = new PageReference(URL.getSalesforceBaseUrl().getProtocol() + '://' + URL.getSalesforceBaseUrl().getHost() + '/email/author/emailauthor.jsp?retURL=/' + caseId + '&p3_lkid=' + caseId + '&rtype=003&p2_lkid=' + caseInstance.ContactId + '&template_id=' + configOptions.Default_Email_Template__c);
                 String fullHtml  =  emailEditorPageRef.getContent().toString();
                   String finalContent = extractContent(selectedEmailTemplate.templateType , fullHtml);
                   bodyValue = finalContent;
                    folders = configOptions.Default_Email_Folder__c;
                   if(selectedEmailTemplate.templateType == 'text'){
                        bodyValue =  String.valueOf(bodyValue).replaceAll('\n','<br/>');
                        type = 'text';
                    }else if(selectedEmailTemplate.templateType == 'Custom'){
                        bodyValue =  String.valueOf(bodyValue);
                        type = 'custom';
                    }
                }

            }
            else{
                selectedTemplate = 'none';
                bodyValue = '';
                type = 'text';
            }
        }
        catch(Exception e){
            selectedTemplate = 'none';
            bodyValue = '';
            isTemplateDeleted = true;
            folders = configOptions.Default_Email_Folder__c;

        }

    }
    /**
    * Function called for Initialiazing templates depending on folder
    */
    public pageReference initializeEmailTemplate(){

        if(folders != null){
            if(folders == 'None'){
                Organization org  = [Select ID from Organization LIMIT 1];
                folders = org.id;
                templateList = [Select Subject, Name, TemplateType From EmailTemplate  where (TemplateType = 'Text' OR TemplateType = 'Custom' ) AND IsActive=true AND FolderId=:folders];
                bodyValue = '';

            }
            templateList = [Select Subject, Name, TemplateType From EmailTemplate  where (TemplateType = 'Text' OR TemplateType = 'Custom' )  AND IsActive=true AND FolderId=:folders];
        }else{
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
    * Function to get Email Template Folder
    */
    public void getEmailTemplatefolders(){

        folderList = [Select Name,Id From Folder where Type='Email' AND AccessType='Public'];
    }

    /**
    * Function to get Email Template Folder
    */
     public List<SelectOption> getEmailFolders() {
        List<SelectOption> options = new List<SelectOption>();
       Organization org  = [Select ID from Organization LIMIT 1];
        options.add(new SelectOption(org.Id,Label.Template_folder_option));
        options.add(new SelectOption(userInfo.getUserId(),Label.personal_email_templates));
             for(folder f : folderList){
                options.add(new SelectOption(f.Id,f.Name));
            }

        return options;
    }

    /**
    * Function to get Email Templates
    */
    public List<SelectOption> getEmailTemplatesList() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('None',Label.Template_name));
        if(folders=='None')
        {
        Organization org  = [Select ID from Organization LIMIT 1];
        folders = org.Id;
        templateList = [Select Subject, Name, TemplateType From EmailTemplate  where (TemplateType = 'Text' OR TemplateType = 'Custom' ) AND IsActive=true AND FolderId=:folders];
        }
        else
        {
        templateList = [Select Subject, Name, TemplateType From EmailTemplate  where (TemplateType = 'Text' OR TemplateType = 'Custom' ) AND IsActive=true AND FolderId=:folders];
        }
        for(EmailTemplate t : templateList){
            options.add(new SelectOption(t.Id,t.Name));
        }

        return options;
    }

    /**
    * Function to Change the case status without sending an email
    */
     public void changeCaseStatus(){
        emailBodyLengthExceededError = false;
        bodyBlankError = false;
        subjectblankError = false;
        toEmailBlankError  = false;
        draftSaved = false;
        isAdditionalToAddressValid = false;
        isCcAddressValid = false;
        isBccAddressValid = false;
        statusChanged = false;
        draftSaved = false;
        changeCaseOwnerError = false;
        isUnderApproval = false;
        try{
         if(configOptions != null){
            if(enableChangeCaseStatus == true){
                caseInstance.status = caseStatus;
                update caseInstance;
                statusChanged = true;
                    isNoCustomError = true;
            }
            }
                //Function call to perform actions if Next Case Present in Queue
        checkNextCasePresent();
        }catch(Exception e){
            ApexPages.addMessages(e);
       }
    }

    /**
    * Function to verify reply to address corresponding to ERC Setting mapping
    **/
    public String replyToAddressToUse(){

        String replyToAddress = '';
        List<HVEM_Email_Routing_Address__c> routingAddressList = new List<HVEM_Email_Routing_Address__c>();
        List<HVEM_Email_Routing_Mapping__c> routingAddressMappingList = new List<HVEM_Email_Routing_Mapping__c>();

        routingAddressList = [SELECT Name,Email_Address__c FROM HVEM_Email_Routing_Address__c];
        routingAddressMappingList = [SELECT Name,Case_API_and_Label__c,Email_Routing_Address__c FROM HVEM_Email_Routing_Mapping__c];
        String defaultReplyTo = '';
        for(HVEM_Email_Routing_Address__c routinginstance : routingAddressList){
            if(routinginstance.Name.replace('RoutingEmail','') == '1'){
                defaultReplyTo = routinginstance.Email_Address__c;
                break;
            }
        }
        replyToAddress = defaultReplyTo;
        if(routingAddressMappingList != null && routingAddressMappingList.size() > 0){
            for(HVEM_Email_Routing_Mapping__c routinginstance : routingAddressMappingList){
                List<String> caseFilterMapList = routinginstance.Case_API_and_Label__c.split('\\|\\|');

                if(caseInstance.get(caseFilterMapList[0]) == caseFilterMapList[2]){
                    replyToAddress = routinginstance.Email_Routing_Address__c;
                    break;
                }
            }
        }
        return replyToAddress;
    }

    /**
    * Function to insert article content
    **/
    public void insertArticleContent() {
        bodyValue = '';
        articleContentList = new List<String>();
        List<CaseArticle> ca = [select ID from CaseArticle where CaseId =: caseId and KnowledgeArticleId =: selectedKnowledgeArticleId];
        if (ca.isEmpty()) {
            CaseArticle caseArticleInstance = new CaseArticle();
            caseArticleInstance.CaseId = caseId;
            caseArticleInstance.KnowledgeArticleId = selectedKnowledgeArticleId;
            insert caseArticleInstance;
        }
        try{
            String ConditionForArticleObject = 'SELECT Id, title, Summary from '+articleTypeOfSelectedArticle+' WHERE Id=\''+selectedKnowledgeArticleId+'\'';
            if((String.valueOf(selectedKnowledgeArticleFrameSourceId) != null) && (String.valueOf(selectedKnowledgeArticleFrameSourceId) != '')){
                List<sObject> articleTypeIns = DataBase.query(ConditionForArticleObject);
                HVEMConditionBuilder lConditionForArticleObject = new HVEMConditionBuilder();
                lConditionForArticleObject.setCondition('Id=\''+selectedKnowledgeArticleFrameSourceId+'\'');
                List<sObject> articleTypeList = dbHelper.getQueryResults(articleTypeIns.getSObjectType().newSObject(),null,lConditionForArticleObject);

                Map<String, Schema.SObjectField> fieldMap = articleTypeIns.getSObjectType().getDescribe().fields.getMap();
                if(templateType == 'custom'){
                    articleContentList.add('<b>Title</b><br/>');
                    articleContentList.add('<b>' + articleTitle + '</b>');
                    articleContentList.add('<br/><br/>');
                }else{
                articleContentList.add('Title<br/>');
                articleContentList.add(articleTitle);
                articleContentList.add('<br/><br/>');
                }
                if(articleSummary != null && articleSummary != ''){
                    articleContentList.add('Summary<br/>');
                    if(articleSummary.contains('\r\n')){
                        articleContentList.add(articleSummary.replaceAll('\r\n','<br/>'));
                    }else{
                        articleContentList.add(articleSummary + '<br/><br/>');
                    }
                    articleContentList.add('<br/>');
                }
                for(String key : fieldMap.keySet()){
                    if(key.endsWith('__c')){
                        Schema.SObjectField valueCustom = fieldMap.get(key);
                        Schema.DescribeFieldResult fieldResultCustom = valueCustom.getDescribe();
                        String fieldCustomLabel = String.valueOf(fieldResultCustom.getLabel());
                        String fieldCustomValue = String.valueOf(articleTypeList[0].get(key));
                        if((fieldCustomValue!= null) && (fieldCustomValue!= ' ')){
                           if(!(fieldResultCustom.isHtmlFormatted() == true && templateType != 'Custom') && fieldCustomValue != ''){
                               articleContentList.add(fieldCustomLabel+ '<br/>');
                               if(fieldCustomValue.contains('\r\n')){
                                   articleContentList.add(fieldCustomValue.replaceAll('\r\n','<br/>'));
                               }else{
                                   articleContentList.add(fieldCustomValue + '<br/>');
                               }
                               articleContentList.add('<br/>');
                            }
                        }
                     }
                 }
             }

             for(String articleFieldValue : articleContentList){
                 // update img src value to point to the external url
                 String pkbUrl = configOptions.Article_Link_Base_URL__c;
                 String replace = '<img src=\"' + pkbUrl + '/servlet';
                 // Compile regular expression
                 //  note: alt attribute is lost but this is OK
                 pattern myPattern = pattern.compile('<img*[^\\>]*/servlet');
                 // Replace all occurrences of pattern in input
                 matcher myMatcher = mypattern.matcher(articleFieldValue);
                 String output = myMatcher.replaceAll(replace);

                bodyValue = bodyValue + output;
             }
        }
        catch(Exception e){
            ApexPages.addMessages(e);
        }
    }

}