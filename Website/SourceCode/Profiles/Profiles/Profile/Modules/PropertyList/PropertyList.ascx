<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="PropertyList.ascx.cs"
    Inherits="Profiles.Profile.Modules.PropertyList.PropertyList" %>
<%--
    Copyright (c) 2008-2012 by the President and Fellows of Harvard College. All rights reserved.  
    Profiles Research Networking Software was developed under the supervision of Griffin M Weber, MD, PhD.,
    and Harvard Catalyst: The Harvard Clinical and Translational Science Center, with support from the 
    National Center for Research Resources and Harvard University.


    Code licensed under a BSD License. 
    For details, see: LICENSE.txt 
 --%>
<br />
<asp:Panel ID="narrativePanel" runat="server">    
     <asp:Literal ID="narrativeDiv" runat="server"></asp:Literal>
     <asp:Literal ID="narrativeCollapseLink" runat="server"></asp:Literal>
     <asp:Literal ID="narrativeimgon" runat="server"></asp:Literal>
     <asp:Literal ID="narrativeimgoff" runat="server"></asp:Literal>
     <asp:Literal ID="narrativeDivClose" runat="server"></asp:Literal>

     <asp:Literal ID="narrativeContentOpen" runat="server"></asp:Literal>
        <asp:TextBox ID="narrativeBox"  runat="server" style="width:100%" TextMode="MultiLine" Rows="10" />
        <asp:Button ID="narrativeBoxButton" runat="server" Text="Save Narrative" OnClick="narrativeBoxButton_click" />
        <br /><br />
     <asp:Literal ID="narrativeContentClose" runat="server"></asp:Literal>
</asp:Panel>

<asp:Literal ID="litPropertyList" runat="server"></asp:Literal>
<br />

<asp:Literal ID="grantDiv" runat="server"></asp:Literal>
<asp:Literal ID="grantCollapseLink" runat="server"></asp:Literal>
<asp:Literal ID="grantimgon" runat="server"></asp:Literal>
<asp:Literal ID="grantimgoff" runat="server"></asp:Literal>
<asp:Literal ID="grantDivClose" runat="server"></asp:Literal>


<asp:Literal ID="grantContentOpen" runat="server"></asp:Literal>
<!-- UI elements here for grants -->
<h4>Principal Investigator On:</h4>

<asp:GridView Width="100%" ID="piGrants" EmptyDataText="None" AutoGenerateColumns="false"
            GridLines="Both" CellSpacing="-1" runat="server" OnRowDataBound="piGrants_OnRowDataBound">
            <HeaderStyle CssClass="topRow" BorderStyle="None" />
            <RowStyle BorderColor="#ccc" Width="1px" VerticalAlign="Middle" />
            <AlternatingRowStyle CssClass="evenRow" />
             <Columns>
                <asp:BoundField HeaderStyle-HorizontalAlign="Center" DataField="Title" HeaderText="Title" ReadOnly="true" />
                <asp:BoundField HeaderStyle-HorizontalAlign="Center"  DataField="Amount" HeaderText="Amount" ReadOnly="true" />
                <asp:BoundField HeaderStyle-HorizontalAlign="Center"  DataField="StartDate" HeaderText="StartDate" ReadOnly="true" />
                <asp:BoundField HeaderStyle-HorizontalAlign="Center"  DataField="EndDate" HeaderText="EndDate" ReadOnly="true" />
            </Columns>
        </asp:GridView>


<h4>Researcher On:</h4>


<asp:GridView Width="100%" ID="Grants" EmptyDataText="None" AutoGenerateColumns="false"
            GridLines="Both" CellSpacing="-1" runat="server" OnRowDataBound="Grants_OnRowDataBound">
            <HeaderStyle CssClass="topRow" BorderStyle="None" />
            <RowStyle BorderColor="#ccc" Width="1px" VerticalAlign="Middle" />
            <AlternatingRowStyle CssClass="evenRow" />            
             <Columns>
                <asp:BoundField HeaderStyle-HorizontalAlign="Center" DataField="Title" HeaderText="Title" ReadOnly="true" />
                <asp:BoundField HeaderStyle-HorizontalAlign="Center"  DataField="Amount" HeaderText="Amount" ReadOnly="true" />
                <asp:BoundField HeaderStyle-HorizontalAlign="Center"  DataField="StartDate" HeaderText="StartDate" ReadOnly="true" />
                <asp:BoundField HeaderStyle-HorizontalAlign="Center"  DataField="EndDate" HeaderText="EndDate" ReadOnly="true" />
            </Columns>
        </asp:GridView>
<br />
<br />


<div style="margin-top: 10px;">
    <asp:Panel ID="addGrantProfile" runat="server">
        <h3>Add a Grant:</h3>
        <div class="content_container">
            <div class="tabContainer" style="margin-top: 0px;">
                <div class="searchForm">
                    <div class="searchSection">
                        <table border="0" cellspacing="0" cellpadding="0" class="searchForm">
                            <tr>
                                <th>Grant Title</th>
                                <td>                                    
                                    <asp:TextBox ID="txtGrantTitle" runat="server" Width="250px" />
                                </td>
                            </tr>
                            <tr>
                                <th>Start Date</th>
                                <td>
                                    <asp:TextBox ID="txtStartDate" value="Enter date in format:dd/mm/yyyy " runat="server" Width="250px" />
                                </td>
                            </tr>
                            <tr>
                                <th>End Date</th>
                                <td>
                                    <asp:TextBox ID="txtEndDate"  value="Enter date in format:dd/mm/yyyy "  runat="server" Width="250px" />                                    
                                </td>
                            </tr>
                            <tr>
                                <th>Grant Amount</th>
                                <td>
                                    <asp:TextBox ID="txtGrantAmount" runat="server" Width="250px" />
                                </td>
                            </tr>
                            <tr>
                                <th>Is Principal Investigator</th>
                                <td>
                                      <asp:DropDownList id="PIList"
                                        AutoPostBack="False"
                                        OnSelectedIndexChanged="PIList_selectionChanged"
                                        runat="server">
                                      <asp:ListItem Selected="True" Value="0"> No </asp:ListItem>
                                      <asp:ListItem Value="1"> Yes </asp:ListItem>
                                      </asp:DropDownList>
                                </td>
                            </tr>                     
                                    
                            <tr>
                                <th>
                                </th>
                                <td>
                                    <div style="padding: 12px 0px;">
                                        <asp:Button ID="btnAddGrant" runat="server" Text="Add Grant" OnClick="btnAddGrant_Click" />
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </asp:Panel>
</div>


<asp:Literal ID="grantContentClose" runat="server"></asp:Literal>
