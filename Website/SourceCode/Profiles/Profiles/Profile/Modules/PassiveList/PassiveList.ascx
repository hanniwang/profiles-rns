<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="PassiveList.ascx.cs" Inherits="Profiles.Profile.Modules.PassiveList.PassiveList" %>
 <%--
    Copyright (c) 2008-2012 by the President and Fellows of Harvard College. All rights reserved.  
    Profiles Research Networking Software was developed under the supervision of Griffin M Weber, MD, PhD.,
    and Harvard Catalyst: The Harvard Clinical and Translational Science Center, with support from the 
    National Center for Research Resources and Harvard University.


    Code licensed under a BSD License. 
    For details, see: LICENSE.txt 
 --%> 
 
<asp:Literal ID="litPassiveNetworkList" runat="server"></asp:Literal>


<script type="text/javascript">
    //Hack to sort the research roles by Start-date asc
/*    researchRoles =
        $('div[id="http://vivoweb.org/ontology/core#hasResearcherRole"]',
            'div[id="http://profiles.catalyst.harvard.edu/ontology/prns#PropertyGroupResearch"]'
         ).children();
    piRoles =
        $('div[id="http://vivoweb.org/ontology/core#hasPrincipalInvestigatorRole"]',
            'div[id="http://profiles.catalyst.harvard.edu/ontology/prns#PropertyGroupResearch"]'
         ).children();

    function dateSort (a, b) {
        var aText = $(a).text();
        var bText = $(b).text();

        var startDateRegEx = /End Date:\s*(\d{4}-\d{2}-\d{2})/g; //Niki: changed from "Start Date" to "End Date"
        var matches = [];
        var dates = [];

        while (matches = startDateRegEx.exec(aText + bText)) {
            dates.push(matches[1]);
        }
        
        var aDate_splits = dates[0].split("-");
        var aDate = new Date(aDate_splits[0], aDate_splits[1], aDate_splits[2]);
        //var aDate = new Date(dates[0]);
        var bDate = new Date(dates[1]);

        if (aDate < bDate)
            return 1; //Niki: changed from -1 to 1 for desc order
        if (aDate > bDate)
            return -1; //Niki: changed from 1 to -1 for desc order
        return 0;
    }
    
    researchRoles.sort(dateSort);
    piRoles.sort(dateSort);
    researchRoles.parent().append(researchRoles);
    piRoles.parent().append(piRoles);
    */
</script>