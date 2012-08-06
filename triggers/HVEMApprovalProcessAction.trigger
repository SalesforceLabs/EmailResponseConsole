trigger HVEMApprovalProcessAction on DraftEmailMessage__c (after update){
    HVEM_Config_Options__c configOptions = new HVEM_Config_Options__c();
    List<EmailMessage> emailMessageList = new List<EmailMessage>();
    String userName = UserInfo.getUserName();
    Case caseInstance = new Case();

    for(DraftEmailMessage__c demInstance : Trigger.New){
        caseInstance = [SELECT Id,Status FROM Case WHERE Id = :demInstance.Case__c];
        if(demInstance.Status__c == 'Approved'){

            // Select current date time to be included in mail
            Datetime myDT = Datetime.now();
            String myDate = myDT.format('yyyy.MM.dd HH:mm:ss:sss z');
            List<String> values=  myDate.split(' ');
            String timeZone = values.get(values.size() - 1);


            configOptions = HVEM_Config_Options__c.getInstance('HVEM');
            // Insert task instance
            Task taskInstance = new task();
            taskInstance.WhatId = demInstance.Case__c;
            Contact contactInstance = [SELECT id FROM Contact WHERE Email =:demInstance.ToAddress__c.split(';')[0] LIMIT 1];
            taskInstance.WhoId = contactInstance.Id;
            taskInstance.subject= demInstance.Subject__c;
            taskInstance.status = 'Completed';
            taskInstance.Description = 'Additional To:'+demInstance.ToAddress__c;
            taskInstance.ActivityDate = date.today();
            upsert taskInstance;

            caseInstance.Status = demInstance.FutureCaseStatus__c;
            update caseInstance;

            EmailMessage emailMessageInstance = new EmailMessage();
           /* Contact contactInstance = new Contact();
            contactInstance = [Select Email from Contact where Id =:contactId ];
            String contactEmailAddress = contactInstance.Email; */
            String emailBody = '';
            if(demInstance.TextBody__c != null && demInstance.TextBody__c != ''){
                emailBody = demInstance.TextBody__c;
                emailBody = emailBody.replaceAll('\n','<br/>');
            }
            if(demInstance.HtmlBody__c != null && demInstance.HtmlBody__c != ''){
                emailBody = demInstance.HtmlBody__c;
            }
            if(demInstance.ToAddress__c.split(';')[0] != null){
                emailMessageInstance.ToAddress = demInstance.ToAddress__c.split(';')[0];
            }
            emailMessageList = [Select ParentId,CcAddress,CreatedDate,FromAddress,FromName, HTMLbody, ToAddress,TextBody, Subject, MessageDate, inComing From EmailMessage where ParentId=:caseInstance.Id order By CreatedDate desc];
            if(demInstance.Include_Thread__c == true){
                if(emailMessageList.size() != 0){
                    for(EmailMessage emailTemplateInstance : emailMessageList){
                        if(emailTemplateInstance.HtmlBody != null && emailTemplateInstance.HtmlBody != ''){
                            emailBody = emailBody + '<br/><br/>_____________________________________________________________________<br/><br/><b>From:</b> ' +  emailTemplateInstance.FromName  + '<br/><b>Reply-To:</b> ' +  emailTemplateInstance.FromName  +  '<br/><b>Sent</b>: ' +  emailTemplateInstance.CreatedDate + ' ' + timeZone +  '<br/><b>To</b>: ' + emailTemplateInstance.ToAddress + '<br/><b>Subject</b>: ' +  emailTemplateInstance.Subject+'<br/><br/>' + emailTemplateInstance.HtmlBody + '<br/><br/>'  ;
                        }else{
                            emailBody = emailBody + '<br/><br/>_____________________________________________________________________<br/><br/><b>From:</b> ' +  emailTemplateInstance.FromName  + '<br/><b>Reply-To:</b> ' +  emailTemplateInstance.FromName  +  '<br/><b>Sent</b>: ' +  emailTemplateInstance.CreatedDate + ' ' + timeZone + '<br/><b>To</b>: ' + emailTemplateInstance.ToAddress + '<br/><b>Subject</b>: ' +  emailTemplateInstance.Subject+'<br/><br/>' + String.valueOf(emailTemplateInstance.TextBody).replaceAll('\n','<br/>') + '<br/><br/>'  ;
                        }

                    }
                }else{
                    emailBody = emailBody;
                }
            }else{
                emailBody = emailBody;
            }

            //EmailTemplate selectedEmailTemplate = [Select e.HtmlValue,e.Id,e.FolderId,e.templateType,e.body  From EmailTemplate e WHERE e.Id = : demInstance.TemplateId__c];
            //emailBody = emailBody.replaceAll('<br/>','\n');
            String thread = emailBody;

            if(demInstance.EmailTemplate_Type__c == 'custom'){
                emailMessageInstance.HtmlBody = demInstance.HtmlBody__c;
            }else if(demInstance.EmailTemplate_Type__c == 'text'){
                emailMessageInstance.TextBody = demInstance.TextBody__c;
            }else{
                emailMessageInstance.TextBody = demInstance.TextBody__c;
            }
            emailMessageInstance.Subject = demInstance.Subject__c;
            emailMessageInstance.ParentId = demInstance.Case__c;
            emailMessageInstance.FromName = userName;
            emailMessageInstance.FromAddress = demInstance.FromAddress__c;
            emailMessageInstance.CcAddress = demInstance.CcAddress__c;
            emailMessageInstance.BccAddress = demInstance.BccAddress__c;
            insert emailMessageInstance;
            sendEmail(demInstance,emailBody);

            //demInstance.Status__c = 'Sent';
            //update demInstance;

        }else if(demInstance.Status__c == 'Rejected'){
            caseInstance.Status = demInstance.OldCaseStatus__c;
            update caseInstance;
        }

    }
    private void sendEmail(DraftEmailMessage__c demInstance,String emailBody){
        Organization orgIns  = new Organization();
        orgIns = [Select Id From Organization LIMIT 1];
        List<String> additionalToList = new List<String>();
        if(demInstance.ToAddress__c != null){
            if(demInstance.ToAddress__c.contains(';')){
                additionalToList = demInstance.ToAddress__c.split(';');
            }else{
                if(demInstance.ToAddress__c.length() > 0){
                    additionalToList.add(demInstance.ToAddress__c);
                }
            }
        }
        List<String> ccList = new  List<String>();
        if(demInstance.CcAddress__c != null){
            if(demInstance.CcAddress__c.contains(';')){
                ccList = demInstance.CcAddress__c.split(';');
            }else{
                if(demInstance.CcAddress__c.length() > 0){
                    ccList.add(demInstance.CcAddress__c);
                }
            }
        }
        List<String> bccList = new List<String>();
        if(demInstance.BccAddress__c != null){
            if(demInstance.BccAddress__c.contains(';')){
                bccList = demInstance.BccAddress__c.split(';');
            }else{
                if(demInstance.BccAddress__c.length() > 0){
                    bccList.add(demInstance.BccAddress__c);
                }
            }
        }
        Messaging.reserveSingleEmailCapacity(2);
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        /*String contactId = caseInstance.contactId;
        Contact contactInstance = new Contact();
        contactInstance = [Select Email from Contact where Id =:contactId ];
        String emailAddress = contactInstance.Email;
        if(additionalToList.size() > 0){
            String tempEmail = additionalToList[0];
            additionalToList[0] = emailAddress;
            additionalToList.add(tempEmail);
        }else{
            additionalToList.add(emailAddress);
        }*/
        mail.setBccSender(true);
        mail.setToAddresses(additionalToList);
        if(configOptions != null){
            //if(configOptions.Reply_To_Mail__c != ''){
                String replyTo = '';
                if(demInstance.Reply_To_Address__c != null && demInstance.Reply_To_Address__c != ''){
                    replyTo = demInstance.Reply_To_Address__c;
                }else{
                    replyTo = replyToAddressToUse();
            }
                mail.setReplyTo(replyTo);
            //    mail.setReplyTo(configOptions.Reply_To_Mail__c);
            //}
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
        finalRef = ' [ref:' + String.valueOf(orgins.Id).substring(0, 4) + String.valueOf(orgins.Id).substring(String.valueOf(orgins.Id).length() - 7,String.valueOf(orgins.Id).length() - 3) + '.';
        finalRef = finalRef + String.valueOf(demInstance.Case__c).substring(0, 4) + String.valueOf(demInstance.Case__c).substring(String.valueOf(demInstance.Case__c).length() - 8,String.valueOf(demInstance.Case__c).length() - 3) + ':ref]';
        mail.setSubject(demInstance.Subject__c + finalRef );
        //mail.setPlainTextBody(thread);
        String thread = '';
      /*  if(demInstance.HtmlBody__c != null && demInstance.HtmlBody__c != ''){
            thread = emailBody;
        }else if(demInstance.TextBody__c != null && demInstance.TextBody__c != ''){
            thread = emailBody.replaceAll('\n','<br/>');
        }*/
        /*if(emailBody.length() > 32000){
            emailBody = emailBody.subString(0,31999);
        }*/
        mail.setHtmlBody(emailBody);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
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
                /*String fieldAPI = caseFilterMapList[0].split('||',2)[0];
                String fieldValue = caseFilterMapList[1].split('||',2)[0];*/
                if(caseInstance.get(caseFilterMapList[0]) == caseFilterMapList[2]){
                    replyToAddress = routinginstance.Email_Routing_Address__c;
                    break;
                }
            }
        }

        return replyToAddress;
    }
}