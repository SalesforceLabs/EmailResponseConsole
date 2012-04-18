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
/* DBhelper Class
* This Class is a generic class defined to perform SOQL queries.
*/

public with Sharing class HVEMDBhelper{
    
    /* getQueryResults method
    *  This method takes following Parameters : Sobject, Field list to retrieve, Instance of ConditionBuilder
    *  if field value specified as null then retrive full data
    */
    
    public List<SObject> getQueryResults(SObject sobj, List<String> fieldsList,HVEMConditionBuilder condition){
        List<SObject> lQueryReultList  = new List<SObject>();
        String lExtractedFields = '';
        String lQuery;
        Integer lCount = 0;
        
        
        if(fieldsList != null && fieldsList.size() > 0){
            for(String fieldValue : fieldsList){
                if((lCount + 1) == fieldsList.size()){
                    lExtractedFields += fieldValue;
                }else{
                    lExtractedFields += fieldValue + ',';
                }
                lCount++;
            }   
        }else{
            Map<String, Schema.SObjectField> sObjectFieldMap = new Map<String, Schema.SObjectField>();
            sObjectFieldMap  = sobj.getSObjectType().getDescribe().fields.getMap();
            for(String fieldName : sObjectFieldMap.keySet()){
                if((lCount + 1) == sObjectFieldMap.size()){
                    lExtractedFields += fieldName;
                }else{
                    lExtractedFields += fieldName + ',';
                }
                lCount++;
            }
        }
        if(condition != null && condition.getCondition() != null && condition.getCondition().trim().length() > 0 && condition.getCondition().trim().toLowerCase().startsWith('order by')){
            lQuery = 'SELECT ' +  lExtractedFields + ' FROM ' + sobj.getSObjectType() + ' ' + condition.getCondition();
        }else if(condition != null && condition.getCondition() != null && condition.getCondition().trim().length() > 0 && (!condition.getCondition().trim().toLowerCase().startsWith('order by'))){
            lQuery = 'SELECT ' +  lExtractedFields + ' FROM ' + sobj.getSObjectType() + ' WHERE ' + condition.getCondition();   
        }else{
            lQuery = 'SELECT ' +  lExtractedFields + ' FROM ' + sobj.getSObjectType();
        }
        lQueryReultList = Database.query(lQuery);
                
        return lQueryReultList;
    }

}