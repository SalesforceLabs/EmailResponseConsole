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

/* HVEMUtil Class
 * This Class is used to create reusable methods.
 */
public Class HVEMUtil {
	public Static String DraftEmailActiveStatus = 'Draft,Approval,Rejected,Approved';

	/** 
	 * Function to handle 
	 **/
	public Static Boolean validateEmail(List<String> emailAddressList){
		Boolean isValid = true;
		Pattern emailPattern= Pattern.compile('((.)+[@][a-zA-Z0-9]+[.](.)+)');
		Matcher emailMatcher;
		// Then instantiate a new Matcher object "MyMatcher"
		if(emailAddressList != null && emailAddressList.size() > 0){
			for(String emailString : emailAddressList){
				if(emailString.split('@',-1).size() > 2){
					return false;
				}
				emailMatcher = emailPattern.matcher(emailString);
				if(!emailMatcher.matches()){
					isValid = false; 
				}else{
					isValid = true; 
				}
			}
			return isValid;
		}else{
			return true;
		}

	}

}