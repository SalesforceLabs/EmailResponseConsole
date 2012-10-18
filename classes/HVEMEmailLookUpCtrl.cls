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

/* HVEMEmailLookUpCtrl Class
 * This Class is used to populate look up page for Additional to , cc and bcc look up.
 */
public with Sharing class HVEMEmailLookUpCtrl{
    public  List<User> userList {get; set;}
    private List<Contact> contactList {get; set;}

    public List<String> selectedUserContactList {get; set;}

    public String selectedOption {get; set;}
    public List<SelectOption> userContactOptions {get; set;}
    public String selectedContact {get; set;}
    public String caseId{get;set;}
    public Case caseInstance {get; set;}
    /** Constructor */

    public HVEMEmailLookUpCtrl(){
        userList = new List<User>();
        contactList = new List<Contact>();
        UserContactOptions = getUserContactOptions('Users');
        selectedUserContactList = new List<String>();

        caseId = ApexPages.currentPage().getParameters().get('Id');
        caseInstance = new Case();
        if(caseId != null && caseId != ''){
            caseInstance = [SELECT  AccountId,Account.Name FROM Case WHERE id=: caseId];
        }
    }

    public void changeSelection(){
        UserContactOptions = getUserContactOptions(selectedOption);

    }
    /**
    * populate default choice for look up
    */
    public List<SelectOption> getInitialOptions(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Users','All Co-Workers in Company'));
        if(caseInstance.AccountId != null ){
            options.add(new SelectOption('Contacts','Contacts: ' + caseInstance.Account.Name));
        }
        return options;
    }
    /**
    * populate data based on initial option selected
    */
    public List<SelectOption> getUserContactOptions(String selectedOption){
        List<SelectOption> options = new List<SelectOption>();
        If(selectedOption == 'Users'){
            userList  = [Select Name, Id,Email From User WHERE IsActive = true];
            for(User userInstance : userList){
                options.add(new SelectOption(userInstance.Email,userInstance.Name));
            }
        }else if(selectedOption == 'Contacts'){
            contactList = [SELECT id,Name,Email FROM Contact WHERE AccountId =: caseInstance.AccountId and Email != null];
            for(Contact contactInstance: contactList){
                options.add(new SelectOption(contactInstance.Email + ' ',contactInstance.Name));
            }
        }
        return options;
    }
}