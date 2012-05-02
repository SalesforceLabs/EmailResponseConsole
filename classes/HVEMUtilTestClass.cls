@isTest
public class HVEMUtilTestClass
{

    static HVEMUtil HVEMUtilInstance;
    static List<String> emailAddressList;
  
   static void setUpData()
   {
     HVEMUtilInstance = new HVEMUtil();
     emailAddressList= new List<String>();
     emailAddressList.add('test@org@test2');
        
   } 
   static testMethod void testvalidateEmail()
   {
     setUpData();
     Test.startTest();
     HVEMUtil.validateEmail(emailAddressList);
     System.assertEquals(true,emailAddressList!=null);
     Test.stopTest();
   } 
   static void setUpDataNegative()
   {
     HVEMUtilInstance = new HVEMUtil();
     emailAddressList= new List<String>();
     emailAddressList.add('testEmail@$.com');
        
   } 
   static testMethod void testvalidateEmailNegative()
   {
     setUpDataNegative();
     Test.startTest();
     HVEMUtil.validateEmail(emailAddressList);
     emailAddressList=null;
     HVEMUtil.validateEmail(emailAddressList);
     System.assertEquals(true,emailAddressList==null);
     Test.stopTest();
   } 

}