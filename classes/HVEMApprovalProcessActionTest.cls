@ istest
public class HVEMApprovalProcessActionTest
{
    public static DraftEmailMessage__c demInstance;
    public static Case caseInstance;
    public static Contact contactInstance;
    public static Task taskInstance; 
    public static HVEM_Config_Options__c configOptions;
    public static  EmailTemplate selectedEmailTemplate ;
     static testMethod void setUpData()
     {
        configOptions = new HVEM_Config_Options__c();
         
       
          caseInstance = new Case(Status='New');
            insert caseInstance;
           Organization orgObj = [select Id From Organization];
           
          selectedEmailTemplate = new  EmailTemplate();
           selectedEmailTemplate.folderId = orgObj.Id;
           selectedEmailTemplate.TemplateStyle = 'Products';
           selectedEmailTemplate.TemplateType = 'custom';
           selectedEmailTemplate.DeveloperName = 'zyzw';
           selectedEmailTemplate.Name = 'abcd';
           User u1 = [SELECT Id FROM User Limit 1];
           System.RunAs(u1){
           insert selectedEmailTemplate;
            }
        if(HVEM_Config_Options__c.getInstance('HVEM') == null){
            configOptions = new HVEM_Config_Options__c(name='HVEM',Default_Email_Template__c = selectedEmailTemplate.Id,Allow_Draft_Approval__c = true);
            insert configOptions  ;
        }
        else{
            configOptions = HVEM_Config_Options__c.getInstance('HVEM');
           }
           
               demInstance= new DraftEmailMessage__c();
               demInstance.Status__c='Approved';
               demInstance.Case__c = caseInstance.Id;
               demInstance.CcAddress__c = 'abc@xyz.com;sql@de.com';
               demInstance.BccAddress__c = 'abc1@xyz.com;se@pt.com';
               demInstance.ToAddress__c ='xyz@pzy.com;xyz@avcf.com;';
               demInstance.FromAddress__c='abcd@xyz.com';
               demInstance.Subject__c = 'Testing';
               demInstance.TextBody__c='test';
               demInstance.HtmlBody__c='<div >';
               demInstance.TextBody__c='TestAbc';
               demInstance.TemplateId__c=selectedEmailTemplate.Id;
               insert demInstance;
                   
               contactInstance = new Contact(Email='abcd@xwz.com',LastName='ABCDF');
                insert contactInstance ;
                contactInstance.Email = demInstance.ToAddress__c.split(';')[0];
                upsert contactInstance;
              taskInstance = new task();
              taskInstance.WhoId = contactInstance.Id;
              taskInstance.subject= demInstance.Subject__c;
              taskInstance.status = 'Completed';
              taskInstance.Description = 'Additional To:'+demInstance.ToAddress__c;
              taskInstance.ActivityDate = date.today();
              upsert taskInstance;
              }
          static testMethod void testTrigger()
            {
               setUpData();
               demInstance.HtmlBody__c='';
               Test.startTest();
               demInstance.Status__c='Approved';
               demInstance.Case__c = caseInstance.Id;
               demInstance.CcAddress__c = 'abc@xyz.com;sql@de.com';
               demInstance.BccAddress__c = 'abc1@xyz.com;se@pt.com';
               demInstance.ToAddress__c ='xyz@pzy.com;xyz@avcf.com;';
               demInstance.FromAddress__c='abcd@xyz.com';
               demInstance.Subject__c = 'Testind2';
               demInstance.TextBody__c='test';
               demInstance.HtmlBody__c='<div >';
               update demInstance;
               System.assertEquals(true,demInstance.BccAddress__c.contains(';'));
                System.assertEquals(true,demInstance.ToAddress__c.contains(';'));
                
               demInstance.Status__c='Approved';
               demInstance.Case__c = caseInstance.Id;
               demInstance.CcAddress__c = 'abc@xyz.com';
               demInstance.BccAddress__c = 'abc1@xyz.com';
               demInstance.ToAddress__c ='xyz@pzy.com;xyz@avcf.com;';
               demInstance.FromAddress__c='abcd@xyz.com';
               demInstance.Subject__c = 'Testind2';
               demInstance.TextBody__c='test';
               demInstance.HtmlBody__c='';
               System.assertEquals(false,demInstance.BccAddress__c.contains(';'));
               update demInstance;
               
             //  selectedEmailTemplate.TemplateType = 'text';
               demInstance.Status__c='Rejected';
               demInstance.Case__c = caseInstance.Id;
               demInstance.CcAddress__c = 'abc@xyz.com;sql';
               demInstance.BccAddress__c = 'abc1@xyz.com;se';
               demInstance.ToAddress__c ='xyz@pzy.com;xyz@avcf.com;';
               demInstance.FromAddress__c='abcd@xyz.com';
               demInstance.Subject__c = 'Testing';
               demInstance.TextBody__c='test';
               demInstance.HtmlBody__c='';
               demInstance.TextBody__c='TestAbc';
               demInstance.TemplateId__c=selectedEmailTemplate.Id;
               update demInstance;
                Test.stopTest();    
           }
    
           

}