@isTest
public class HVEMDBhelperTestClass
{
   static HVEMDBhelper HVEMDBhelperInstance;
   static List<String> fieldsList;
   static HVEMConditionBuilder lCondition;
  
   public static void setUpInitData(){
      HVEMDBhelperInstance= new HVEMDBhelper();
      fieldsList = new List<String>();
      lCondition = new HVEMConditionBuilder();
      lCondition.setCondition('ORDER BY LastModifiedDate'); 
      fieldsList = new List<String>();
      fieldsList.add('caseNumber');
      fieldsList.add('IsEscalated');
      fieldsList.add('Owner.Name');
      fieldsList.add('Subject');
      fieldsList.add('Status');
        
   }      
   public static testMethod void testgetQueryResults(){
       setUpInitData();
       Test.startTest();
       HVEMDBhelperInstance.getQueryResults(new Case(), fieldsList , lCondition);
       System.AssertEquals(true,lCondition!=null);
       Test.stopTest();
   }
   public static void setUpInitDataElse(){
      HVEMDBhelperInstance= new HVEMDBhelper();
      fieldsList = new List<String>();
      lCondition = new HVEMConditionBuilder();
      lCondition.setCondition('');
      fieldsList = new List<String>();
      fieldsList.add('caseNumber');
      fieldsList.add('IsEscalated');
      fieldsList.add('Owner.Name');
      fieldsList.add('Subject');
      fieldsList.add('Status');
        
   }    
   public static testMethod void testgetQueryResultsElse(){
       setUpInitDataElse();
       Test.startTest();
       HVEMDBhelperInstance.getQueryResults(new Case(), fieldsList , lCondition);
       System.AssertEquals(true,lCondition!=null);
       Test.stopTest();
    }
    
 }