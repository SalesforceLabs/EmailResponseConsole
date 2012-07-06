public class HVEMCaseFeedEmailPublisherCntrl{
   public boolean isCaseFeedEmailPublisherEnabled{get; set;}
   public Id caseId{get; set;} 
   public HVEM_Config_Options__c configOptions{get;set;}
   
    
   public HVEMCaseFeedEmailPublisherCntrl(ApexPages.StandardController controller) {
          
         configOptions = HVEM_Config_Options__c.getInstance('HVEM');
         if(configOptions.IsCustomEmailPublisher__c){
         	isCaseFeedEmailPublisherEnabled = false;
         }else{
         	isCaseFeedEmailPublisherEnabled = true;
         }
    }

}