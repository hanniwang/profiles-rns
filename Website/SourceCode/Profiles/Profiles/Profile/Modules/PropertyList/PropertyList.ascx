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
<asp:Literal ID="litPropertyList" runat="server"></asp:Literal>



<!-- UI elements here for grants -->
<h3>Grant Information</h3>


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

<table>
    <tr>
        <td valign="middle">
            <asp:Image runat="server" ID="imgAdd" OnClick="lnkAddGrant_OnClick" />&nbsp;
        </td>
        <td style="padding-bottom: 4px" valign="middle">                    
            <asp:Literal runat="server" ID='lnkAddGrantTmp' Text = "Add A Grant"></asp:Literal>
        </td>
    </tr>
</table>


