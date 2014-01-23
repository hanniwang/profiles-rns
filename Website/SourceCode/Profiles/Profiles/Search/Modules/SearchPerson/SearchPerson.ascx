<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SearchPerson.ascx.cs"
    Inherits="Profiles.Search.Modules.SearchPerson.SearchPerson" EnableViewState="true" %>
<%@ Register Src="ComboTreeCheck.ascx" TagName="ComboTreeCheck" TagPrefix="uc1" %>

<script type="text/javascript">

    function runScript(e) {
        if (e.keyCode == 13) {
            search();
        }
        return false;
    }

    function search() {

        document.getElementById("<%=hdnSearch.ClientID%>").value = "true"
        document.forms[0].submit();
    }

    function showdiv() {
        $('[id*=divChkList]').css("display", "block");

        $('[id*=divChkList]').focus();
    }

    function showdivonClick() {
        var objDLL = $('[id*=divChkList]');
        if (objDLL.css("display") == "block")
            objDLL.css("display", "none");
        else
            objDLL.css("display", "block");
    }

    function getSelectedItem(lstValue, lstNo, lstID, ctrlType) {
        var noItemChecked = 0;
        var ddlChkList = document.querySelectorAll('[id*=ddlChkList]'); //browser support for http://caniuse.com/queryselector (IE 8+ and all modern browsers; Should be good)
        var selectedItems = "";
        var selectedValues = "";
        var arr = document.querySelectorAll('[id*=_chkLstItem_]');
        var arrlbl = document.querySelectorAll('[id*=_chkLstItem]')[0].querySelectorAll('tr > td > label');
        var objLstId = document.querySelectorAll('[id*=hidList]');
        

        for (i = 0; i < arr.length; i++) {
            checkbox = arr[i];
            if (i == lstNo) {
                if (ctrlType == 'anchor') {
                    if (!checkbox.checked) {
                        checkbox.checked = true;
                    }
                    else {
                        checkbox.checked = false;
                    }
                }
            }

            if (checkbox.checked) {

                var buffer;
                if (arrlbl[i].innerText == undefined)
                    buffer = arrlbl[i].textContent;
                else
                    buffer = arrlbl[i].innerText;

                if (selectedItems == "") {

                    selectedItems = buffer;
                }
                else {
                    selectedItems = selectedItems + "," + buffer;
                }
                noItemChecked = noItemChecked + 1;
            }
        }

        ddlChkList.title = selectedItems;

        
        if (noItemChecked != "0")
            ddlChkList.item(0).item(0).innerHTML = selectedItems;
        else
            ddlChkList.item(0).item(0).innerHTML = "";
        
            

        $('[id*=hidList]').attr("value", ddlChkList.item(0).item(0).innerText);




    }

    document.onclick = check;
    function check(e) {
        var target = (e && e.target) || (event && event.srcElement);
        var obj = document.querySelectorAll('[id*=divChkList]');
        var obj1 = document.querySelectorAll('[id*=ddlChkList]');
        if (target.id != "alst" && !target.id.match("chkLstItem")) {
            if (!(target == obj || target == obj1)) {
                //obj.style.display = 'none'
            }
            else if (target == obj || target == obj1) {
                if (obj.style.display == 'block') {
                    obj.style.display = 'block';
                }
                else {
                    obj.style.display = 'none';
                    document.querySelectorAll('[id*=ddlChkList]').blur();
                }
            }
        }
    }
</script>

<asp:HiddenField ID="hdnSearch" runat="server" Value="hdnSearch"></asp:HiddenField>
<div class="content_container">
    <div class="tabContainer" style="margin-top: 0px;">
        <div class="searchForm">
            <table onkeypress="JavaScript:runScript(event);" width="100%">
                <tbody align="left">
                    <tr>
                        <td colspan='3'>
                            <div style="font-size: 18px; color: #b23f45; font-weight: bold; margin-bottom: 3px;">
                                Find people by keyword</div>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="3">
                            <div class="searchSection" id="divSearchSection">
                                <table width="100%" class='searchForm'>
                                    <tr>
                                        <th>
                                            Keywords
                                        </th>
                                        <td colspan="2" class="fieldOptions">
                                            <asp:TextBox runat="server" ID="txtSearchFor" CssClass="inputText"></asp:TextBox>
                                            <asp:CheckBox runat="server" ID="chkExactphrase" />
                                            Search for exact phrase
                                        </td>
                                    </tr>
                                    <tr>
                                        <tr>
                                            <th>
                                            </th>
                                            <td style="text-decoration: none" colspan="2">
                                                <div style="float: left; display: inline">
                                                    <a href="JavaScript:search();">
                                                        <img src="<%=GetURLDomain()%>/Search/Images/search.jpg" style="border: 0;" alt="Search" />
                                                    </a>
                                                </div>
                                            </td>
                                        </tr>
                                    </tr>
                                </table>
                            </div>
                        </td>
                    </tr>
            </table>
            <table width="100%">
                <tr>
                    <td colspan='3'>
                        <div style="font-size: 18px; color: #b23f45; font-weight: bold; margin-bottom: 3px;">
                            Find people by name/organization</div>
                    </td>
                </tr>
                <tr>
                    <td colspan='3'>
                        <div class="searchSection" id="div1">
                            <table width="100%" class='searchForm'>
                                <tr>
                                    <th>
                                        Last Name
                                    </th>
                                    <td colspan="2">
                                        <asp:TextBox runat="server" ID="txtLname" CssClass="inputText"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        First Name
                                    </th>
                                    <td colspan="2">
                                        <asp:TextBox runat="server" ID="txtFname" CssClass="inputText"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr runat="server" id="trInstitution">
                                    <th>
                                        Institution
                                    </th>
                                    <td colspan="2">
                                        <asp:Literal runat="server" ID="litInstitution"></asp:Literal>
                                        <asp:CheckBox runat="server" ID="institutionallexcept" />
                                        All <b>except</b> the one selected
                                    </td>
                                </tr>
                                <tr runat="server" id="trDepartment">
                                    <th>
                                        Department
                                    </th>
                                    <td colspan="2">
                                        <asp:Literal runat="server" ID="litDepartment"></asp:Literal>
                                        <asp:CheckBox runat="server" ID="departmentallexcept" />
                                        All <b>except</b> the one selected
                                    </td>
                                </tr>
                                <tr runat="server" id="trDivision">
                                    <th>
                                        Division
                                    </th>
                                    <td colspan="2">
                                        <asp:Literal runat="server" ID="litDivision"></asp:Literal>
                                        <asp:CheckBox runat="server" id="divisionallexcept" />
                                        All <b>except</b> the one selected
                                    </td>
                                </tr>
                               
                                <tr>
                                    <th>
                                    </th>
                                    <td colspan="2">
                                        <div style="float: left; display: inline">
                                            <a href="JavaScript:search();">
                                                <img src="<%=GetURLDomain()%>/Search/Images/search.jpg" style="border: 0;" alt="Search" />
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                            <asp:Literal runat="server" ID="litFacRankScript"></asp:Literal>
                            
                        </div>
                    </td>
                </tr>
            </table>
        </div>
    </div>
</div>