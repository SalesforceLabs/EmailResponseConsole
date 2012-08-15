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

/* HVEMCaseListDetailsCtrl Class
 * This Class is used to populate the left sidebar component with queue and case details of logged in user
 */

public with Sharing class HVEMCaseListDetailsCtrl {
    public Map<Id,GroupMember> loggedInUserQueueMap {get; set;}
    public List<Case> loggedInUserCaseList {get; set;}
    public List<Case> casesInQueueList{get; set;}
    public List<AssignedCaseList> loggedUserCaseInnerList {get; set;}
    public List<AggregateResult> caseCountQueue {get; set;}
    public Id selectedQueue {get; set;}
    public List<QueueCount> queueCountList {get; set;}
    public List<DraftEmailMessage__c> draftsEmailList {get; set;}
    public List<Case> cloneLoggedInCaseList{get; set;}
    public List<Case> idList{get; set;}
    public Id queueId {get; set;}
    public Id caseId {get; set;}
    public String caseListErrorMessage{get; set;}
    public String queueListErrorMessage{get; set;}
    public String previousCaseErrorMessage{get; set;}
    public Boolean isPreviousCasePresent {get; set;}
    public Case selectedCase{get; set;}
    public Case initialSelectedCase {get; set;}
    public Case previousCase {get; set;}
    public String refreshListParam {get; set;}
    public List<CaseHistory> caseHistoryList {get; set;}
    public String queuePageId{get; set;}
    public String finalQueueId {get; set;}
    private HVEMDBhelper dbHelper {get; set;}
    private Id loggedUser {get; set;}
    public User loggedUserInstance {get; set;}
    public DraftEmailMessage__c demObj {get; set;}
    public Boolean isFound {get;set;}
    public Boolean isDrafts {get; set;}
    public Boolean isDraftsAllowed {get; set;}
    public HVEM_Config_Options__c configOptions {get;set;}


    public HVEMCaseListDetailsCtrl(){
        // Get logged in user and assigning neccessary references
        HVEMConditionBuilder lCondition = new HVEMConditionBuilder();
        List<String> fields = new List<String>();
        loggedUserInstance = new User();
        loggedUser  = Userinfo.getuserId();
        dbHelper = new HVEMDBhelper();
        loggedInUserCaseList = new List<Case>();
        casesInQueueList = new List<Case>();
        loggedInUserQueueMap = new Map<Id,GroupMember>();
        caseCountQueue = new List<AggregateResult>();
        queueCountList = new List<QueueCount>();
         draftsEmailList = new List<DraftEmailMessage__c>();
        cloneLoggedInCaseList = new  List<Case>();
        loggedUserCaseInnerList = new List<AssignedCaseList>();
        caseListErrorMessage = '';
        queueListErrorMessage = '';
        previousCaseErrorMessage= '';
        refreshListParam = '';
        selectedCase = new Case();
        caseId = ApexPages.currentPage().getParameters().get('Id');
        isPreviousCasePresent = true;
        if(caseId != null){
            initialSelectedCase = new Case();
            initialSelectedCase = [SELECT Id, CaseNumber, Owner.Name FROM Case WHERE Id=: caseId ];
        }
        configOptions = new HVEM_Config_Options__c();
        configOptions = HVEM_Config_Options__c.getInstance('HVEM');
        if(configOptions != null) {
            isDraftsAllowed = configOptions.Allow_Drafts__c;
        }

        refreshCaseQueueList();
    }

    /*
     * store selected queue id in cookie variable
     */
    public void  storeSelectedQueuePageId(){
        Cookie queuePageCookie = ApexPages.currentPage().getCookies().get('queueId');
        queuePageCookie = new Cookie('queueId',queuePageId,null,-1,false);
        ApexPages.currentPage().setCookies(new Cookie[]{queuePageCookie});
    }

    public void assignCaseFromQueue(){
        // Get logged in user Case Count
        HVEMConditionBuilder lCondition = new HVEMConditionBuilder();
        lCondition.setCondition('OwnerId = \'' + queueId + '\' AND Status != \'Closed\'');
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
            refreshCaseQueueList();
        }else{
            queueListErrorMessage = Label.No_Case_In_Queue_Error_Message;
            refreshListParam = 'fromQueue';
            refreshCaseQueueList();
        }
    }

    /*
     * select case to open case details in new Primary tab
     */
    public void openCaseDetailsPrimaryTab(){
        selectedCase = [SELECT Id,CaseNumber,Owner.Name,Subject FROM Case WHERE Id=:caseId];
        caseId = selectedCase.Id;
    }

    /*
     * function to repopulate parameters populated in constructor
     */
    public void refreshCaseQueueList(){
        //boolean varibles to control draft
        isfound = false;
        queueCountList = new List<QueueCount>();
        caseListErrorMessage = '';
        if(refreshListParam == 'fromRefresh'){
            queueListErrorMessage = '';
        }

        // Get all queues associated with logged in user
        HVEMConditionBuilder lCondition = new HVEMConditionBuilder();
        List<String> fields = new List<String>();
        List<QueueSobject> queueSobjectList = [SELECT Queue.Id FROM QueueSobject WHERE SobjectType = 'Case'];
        List<Id> queueSobjIdList = new List<Id>();
        for(QueueSobject queueInstance : queueSobjectList){
            queueSobjIdList.add(queueInstance.Queue.Id);
        }
        loggedInUserQueueMap = new Map<Id,GroupMember>([SELECT Group.Name, Group.Id FROM GroupMember WHERE UserOrGroupId = : loggedUser AND Group.Type = 'Queue' AND Group.Id IN:queueSobjIdList ]);
        loggedUserInstance = [SELECT Id,Name,HVEM_User__c FROM User WHERE Id = : loggedUser];
        if(loggedInUserQueueMap !=null && !loggedInUserQueueMap.isEmpty()){
            // generate List in comma seperated format to be used for "IN" clause in DBHelper instance
            Map<Id,GroupMember> queueIdMap = new Map<Id,GroupMember>();
            String queueIds = '';
            Integer i = 0;
            for(GroupMember groupMemberInstance : loggedInUserQueueMap.Values()){
                if((i+1) == loggedInUserQueueMap.size()){
                    queueIds = queueIds + '\'' + groupMemberInstance.Group.id + '\'';
                }else{
                    queueIds = queueIds + '\'' + groupMemberInstance.Group.id + '\',';
                }
                queueIdMap.put(groupMemberInstance.Group.Id,groupMemberInstance);
                i++;
            }
            if(queueIds != ''){
                queueIds = '(' + queueIds + ')';
                // Query to retrieve Case Count associated with each queue
                lCondition = new HVEMConditionBuilder();
                lCondition.setCondition('OwnerId IN ' + queueIds + ' AND Status != \'closed\' GROUP BY Owner.Id');
                fields = new List<String>();
                fields.add('Owner.Id OwnerId,COUNT(Id) QueueId');
                caseCountQueue = dbHelper.getQueryResults(new Case(), fields, lCondition);
            }

            // Populate Wrapper with queue and count related details
            for(Id queueId : queueIdMap.keySet()){
                Boolean flag = false;
                for(AggregateResult aggInstance : caseCountQueue){
                    if((Id)aggInstance.get('OwnerId') == queueId){
                        flag = true;
                        QueueCount queueCountInstance = new QueueCount();
                        queueCountInstance.queueInstance = queueIdMap.get((Id)aggInstance.get('OwnerId'));
                        queueCountInstance.caseCount = (Integer)aggInstance.get('QueueId');
                        queueCountList.add(queueCountInstance);
                    }
                }
                if(!flag){
                    QueueCount queueCountInstance = new QueueCount();
                    queueCountInstance.queueInstance = queueIdMap.get(queueId);
                    queueCountInstance.caseCount = 0;
                    queueCountList.add(queueCountInstance);
                }
            }
        }
        // set cookies for the selected Queue Id
        Cookie queuePageCookie = ApexPages.currentPage().getCookies().get('queueId');
        if(queuePageCookie  != null){
            finalQueueId = queuePageCookie.getValue();
        }else{
            if(queueCountList !=null && queueCountList.size() > 0){
                finalQueueId = 'idSelectedQueue_' + queueCountList[0].queueInstance.Group.Id;
            }
        }

        if(isDrafts == true){
            draftsCaseListFunc();
        }else{
            // Get logged in user Case List
            Map<Id,Case> loggedUserCaseMap = new Map<Id,Case>([SELECT caseNumber,IsEscalated,Owner.Name,Subject,Status,Contact.Name FROM Case WHERE OwnerId =:loggedUser AND Status != 'Closed' ORDER BY LastModifiedDate DESC]);
            lCondition = new HVEMConditionBuilder();
            lCondition.setCondition('OwnerId = \'' + loggedUser + '\' AND Status != \'Closed\' ORDER BY LastModifiedDate DESC');
            fields = new List<String>();
            fields.add('caseNumber');
            fields.add('IsEscalated');
            fields.add('Owner.Name');
            fields.add('Subject');
            fields.add('Status');
            fields.add('Contact.Name');
            loggedInUserCaseList = dbHelper.getQueryResults(new Case(), fields, lCondition);
            draftsEmailList = [SELECT id,Case__c,Status__c FROM DraftEmailMessage__c WHERE (Status__c = 'Rejected' OR Status__c = 'Draft') AND Case__c IN :loggedInUserCaseList];
            Map<Id,Boolean> draftRejected = new Map<Id,Boolean>();
            Map<Id,Boolean> inDraft = new Map<Id,Boolean>();
            loggedUserCaseInnerList = new List<AssignedCaseList>();
            for(Case caseInstance : loggedInUserCaseList ){
                loggedUserCaseInnerList.add(new AssignedCaseList(caseInstance , false, false));
            }
            for(DraftEmailMessage__c draftInstance : draftsEmailList ){
                if(draftInstance.Status__c == 'Rejected'){
                    draftRejected.put(draftInstance.Case__c,true);
                }else if(draftInstance.Status__c == 'Draft'){
                    inDraft.put(draftInstance.Case__c,true);
                }
            }
            for(AssignedCaseList assignedCaseInstance : loggedUserCaseInnerList){
                if(draftRejected.containsKey(assignedCaseInstance.loggedUserCase.Id)){
                    assignedCaseInstance.isRejected = true;
                    assignedCaseInstance.isDraft = false;
                }else if(inDraft.containsKey(assignedCaseInstance.loggedUserCase.Id)){
                    assignedCaseInstance.isRejected = false;
                    assignedCaseInstance.isDraft = true;
                }
            }
        }

        if(loggedInUserCaseList.size() > 0){
            // Populate the recently visited case
            selectedCase = loggedInUserCaseList[0];
        }else{
            if(isDrafts == false){
                caseListErrorMessage = Label.No_Case_Assigned_Error_Message;
            }
        }
        //  Populate previous case logic for refresh link click
        List<EmailMessage> latestEmailSentList =  new List<EmailMessage>();
        List<DraftEmailMessage__c> latestDraftApprovalList = new List<DraftEmailMessage__c>();
        latestEmailSentList = [SELECT Subject,SystemModstamp,parent.Status,parent.Owner.Name, parent.caseNumber, parent.Contact.Name,parent.IsEscalated, parent.Subject FROM EmailMessage WHERE parent.OwnerId =: loggedUserInstance.Id AND Incoming = false ORDER BY SystemModstamp DESC NULLS LAST LIMIT 1];
        latestDraftApprovalList = [SELECT case__r.caseNumber,SystemModstamp from DraftEmailMessage__c where status__c = 'Approval' ORDER BY SystemModstamp DESC NULLS LAST LIMIT 1];
        if(configOptions != null && configOptions.Allow_Draft_Approval__c == true ){
            if(latestDraftApprovalList.size() > 0){
                DraftEmailMessage__c DEMInstance = new DraftEmailMessage__c();
                DEMInstance = latestDraftApprovalList[0];
                if(latestEmailSentList != null && latestEmailSentList.size() > 0){
                    EmailMessage latestEmailSent = latestEmailSentList.get(0);
                    if(latestEmailSent.SystemModstamp < DEMInstance.SystemModstamp){
                        previousCase = [select Status,caseNumber,Owner.Name,Contact.Name,IsEscalated, Subject from Case where id=:DEMInstance.case__c];
                        previousCaseErrorMessage = Label.Error_emailMessage  + ' ' + DEMInstance.case__r.caseNumber + ' ' + Label.Email_underApproval ;
                        isPreviousCasePresent = true;
                    }else{
                        previousCase = (Case)latestEmailSent.parent;
                        previousCaseErrorMessage = Label.Error_emailMessage + ' ' + previousCase.CaseNumber + ' ' +  Label.Error_email;
                        isPreviousCasePresent = true;
                    }
                }else{
                    previousCase = [select Status,caseNumber,Owner.Name,Contact.Name,IsEscalated, Subject from Case where id=:DEMInstance.case__c];
                    previousCaseErrorMessage = Label.Error_emailMessage + ' ' + DEMInstance.case__r.caseNumber + ' ' + Label.Email_underApproval ;
                    isPreviousCasePresent = true;
                }
            }else{
                if(latestEmailSentList.size() > 0 && latestEmailSentList != null){
                    EmailMessage latestEmailSent = latestEmailSentList.get(0);
                    previousCase = (Case)latestEmailSent.parent;
                    previousCaseErrorMessage = Label.Error_emailMessage + ' ' + previousCase.CaseNumber + ' ' +  Label.Error_email;
                    isPreviousCasePresent = true;
                }else{
                    previousCaseErrorMessage = 'Hello, ' + loggedUserInstance.Name;
                    isPreviousCasePresent = false;
                }
            }
        }else{
            if(latestEmailSentList.size() > 0 && latestEmailSentList != null){
                EmailMessage latestEmailSent = latestEmailSentList.get(0);
                previousCase = (Case)latestEmailSent.parent;
                if(System.now() > latestEmailSent.SystemModstamp.addMinutes(1)){
                }else{
                    previousCaseErrorMessage = Label.Error_emailMessage + ' ' + previousCase.CaseNumber + ' ' + Label.Error_email;
                    isPreviousCasePresent = true;
                }
            }else{
                previousCaseErrorMessage = 'Hello, ' + loggedUserInstance.Name;
                isPreviousCasePresent = false;
            }
        }
    }

    /*
     * Inner class data structure to to populate queue and count for queues.
     */
    public class QueueCount{
        public GroupMember queueInstance{get; set;}
        public Integer caseCount {get; set;}
        QueueCount(){
            queueInstance = new GroupMember();
            caseCount = 0;
        }
    }

    public class AssignedCaseList{
        public Case loggedUserCase{get;set;}
        public Boolean isRejected {get; set;}
        public Boolean isDraft {get; set;}
        AssignedCaseList(Case caseInstance,Boolean rejectionValue, Boolean draftValue){
            loggedUserCase = caseInstance;
            isRejected = rejectionValue;
            isDraft = draftValue;
        }
    }


    /*
     * Function to populate cases saved as a draft.
     */
    public void draftsCaseListFunc(){
        if(isDrafts == false){
            refreshCaseQueueList();
        }else{
            HVEMConditionBuilder lCondition = new HVEMConditionBuilder();
            lCondition.setCondition('OwnerId = \'' + loggedUser + '\' AND Status != \'Closed\' ORDER BY LastModifiedDate DESC');
            List<String> fields = new List<String>();
            fields.add('caseNumber');
            fields.add('IsEscalated');
            fields.add('Owner.Name');
            fields.add('Subject');
            fields.add('Status');
            fields.add('Contact.Name');
            loggedInUserCaseList = dbHelper.getQueryResults(new Case(), fields, lCondition);
            cloneLoggedInCaseList = loggedInUserCaseList.clone();
            idList = new List<Case>();
            demObj = new DraftEmailMessage__c();
            isFound = false;
            loggedUserCaseInnerList = new List<AssignedCaseList>();
            draftsEmailList = [SELECT id,Case__c,Status__c FROM DraftEmailMessage__c WHERE (Status__c = 'Draft' OR Status__c='Rejected') AND Case__c IN :loggedInUserCaseList];

            List<Case> removeList = new List<Case>();
            for(Integer j=0;j<draftsEmailList.size();j++) {
                for(Integer i=0;i<loggedInUserCaseList.size();i++) {
                    if(draftsEmailList[j].Case__c == loggedInUserCaseList[i].id) {
                        if(draftsEmailList[j].Status__c == 'Rejected'){
                           loggedUserCaseInnerList.add(new AssignedCaseList(loggedInUserCaseList[i],true,false));
                        }else if(draftsEmailList[j].Status__c == 'Draft'){
                           loggedUserCaseInnerList.add(new AssignedCaseList(loggedInUserCaseList[i],false,true));
                        }else{
                           loggedUserCaseInnerList.add(new AssignedCaseList(loggedInUserCaseList[i],false,false));
                        }
                        removeList.add(loggedInUserCaseList[i]);
                    }
                }
            }
            loggedInUserCaseList = removeList;
        }
        if(loggedInUserCaseList.size() == 0){
            isFound=true;
        }
    }
}