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
private class HVEMEmailLookUpCtrlTestClass {
    static HVEMEmailLookUpCtrl emailLookup;
    static Case caseIns;
    static testMethod void setupDataInit() {
        Account accountIns = new Account(name='test');
        insert accountIns;
        Contact contactIns = new Contact(LastName='test',email='test@hvem.com',Accountid=accountIns.id);
        insert contactIns;
        caseIns = new Case(status='New',AccountId=accountIns.id,Origin='Phone');
        insert caseIns;
        System.assertNotEquals(null,caseIns);
        ApexPages.currentPage().getParameters().put('Id',caseIns.Id);
        emailLookup = new HVEMEmailLookUpCtrl();
    }
    static testmethod void testChangeSelectionwithUser(){
        setupDataInit();
        emailLookup.selectedOption = 'Users';
        test.startTest();
        emailLookup.changeSelection();
        test.stopTest();
        System.assertEquals(true,emailLookup.UserContactOptions.size() > 0);
    }
    static testmethod void testChangeSelectionwithContact(){
        setupDataInit();
        //setup data for testChangeSelectionwithContact
        emailLookup.selectedOption = 'Contacts';
        test.startTest();
        emailLookup.changeSelection();
        test.stopTest();
        System.assertEquals(true,emailLookup.UserContactOptions.size() > 0);
    }
    static testmethod void testHVEMEmailLookUpCtrlInit(){
        setupDataInit();
        //setup data for
        test.startTest();
        List<selectOption> options = emailLookup.getInitialOptions();
        test.stopTest();
        System.assertEquals(true,options.size() > 0);
    }

}