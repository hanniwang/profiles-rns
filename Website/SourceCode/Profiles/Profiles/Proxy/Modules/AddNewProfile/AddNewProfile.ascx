<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AddNewProfile.ascx.cs"
    Inherits="Profiles.Proxy.Modules.AddProfile.AddNewProfile" %>
 
 
<div id="divStatus" style="position: fixed; text-align: center; height: 100%; width: 100%; top: 0;
    right: 0; left: 0; z-index: 9999999; opacity: 0.7;display:none">
    <span style="border-width: 0px; position: fixed; padding: 50px; background-color: #FFFFFF;
        font-size: 36px; left: 40%; top: 40%;"><img alt="Loading..." src="<%=GetURLDomain()%>/Edit/Images/loader.gif" /></span>
</div>
<div class="pageTitle">
    <asp:Literal runat="server" ID="litBackLink"></asp:Literal>
</div>

<br />
<!-- TODO: Add explanatory text --><p>Squid kogi butcher, pariatur sed velit bitters Shoreditch irony. Sed wolf duis delectus Tumblr, Etsy dreamcatcher voluptate Helvetica DIY mollit kitsch deep v 3 wolf moon. 3 wolf moon culpa swag American Apparel wayfarers nisi. Banjo keffiyeh flannel locavore, deep v assumenda DIY Marfa occupy swag cred VHS. Bushwick pickled McSweeney's, keytar fashion axe whatever authentic culpa bitters ennui consequat you probably haven't heard of them Etsy accusamus messenger bag. Ennui synth swag chillwave, shabby chic ethnic American Apparel roof party. Exercitation consequat stumptown consectetur fixie bicycle rights, pickled in Truffaut ad Shoreditch.</p>
<br />
<br />

<div style="margin-top: 10px;">
    <asp:Panel ID="addProfilePanel" runat="server">
        <div class="content_container">
            <div class="tabContainer" style="margin-top: 0px;">
                <div class="searchForm">
                    <div class="searchSection">
                        <table border="0" cellspacing="0" cellpadding="0" class="searchForm">
                            <tr>
                                <th>First Name</th>
                                <td>                                    
                                    <asp:TextBox ID="txtFirstName" runat="server" Width="250px" />
                                </td>
                            </tr>
                            <tr>
                                <th>Middle Name</th>
                                <td>
                                    <asp:TextBox ID="txtMiddleName" runat="server" Width="250px" />
                                </td>
                            </tr>
                            <tr>
                                <th>Last Name</th>
                                <td>
                                    <asp:TextBox ID="txtLastName" runat="server" Width="250px" />
                                </td>
                            </tr>
                            <tr>
                                <th>Gender</th> <!-- TODO: make drop down-->
                                <td>
                                    <asp:TextBox ID="txtGender" runat="server" Width="250px" />
                                </td>
                            </tr>
                            <tr>
                                <th>Address Line 1</th>
                                <td>
                                    <asp:TextBox ID="txtAddressLineOne" runat="server" Width="250px" />
                                </td>
                            </tr>
                            <tr>
                                <th>Address Line 2</th>
                                <td>
                                    <asp:TextBox ID="txtAddressLineTwo" runat="server" Width="250px" />
                                </td>
                            </tr>
                            <tr>
                                <th>City</th>
                                <td>
                                    <asp:TextBox ID="txtCity" runat="server" Width="250px" />
                                </td>
                            </tr>
                            <tr>
                                <th>State</th> <!-- TODO: dropdown box of all of the state abbreviations in the US -->
                                <td>
                                    <asp:TextBox ID="txtState" runat="server" Width="250px" />
                                </td>
                            </tr>
                            <tr>
                                <th>Zip</th>
                                <td>
                                    <asp:TextBox ID="txtZip" runat="server" Width="250px" />
                                </td>
                            </tr>
                            <tr>
                                <th>Phone Number</th>
                                <td>
                                    <asp:TextBox ID="txtPhoneNumber" runat="server" Width="250px" />
                                </td>
                            </tr>
                            <tr>
                                <th>Email Address</th>
                                <td>
                                    <asp:TextBox ID="txtEmail" runat="server" Width="250px" />
                                </td>
                            </tr>
                            <tr>
                                <th>Work Title</th>
                                <td>
                                    <asp:TextBox ID="txtTitle" runat="server" Width="250px" />
                                </td>
                            </tr>
                            <tr>
                                <th>Institution Name</th>
                                <td>
                                    <asp:TextBox ID="txtInstitutionName" runat="server" Width="250px" />
                                </td>
                            </tr>
                            <tr>
                                <th>Institution Abbreviation</th>
                                <td>
                                    <asp:TextBox ID="txtInstitutionAbbreviation" runat="server" Width="250px" />
                                </td>
                            </tr>
                            <tr>
                                <th>Department Name</th>
                                <td>
                                    <asp:TextBox ID="txtDepartmentName" runat="server" Width="250px" />
                                </td>
                            </tr>
                                    
                            <tr>
                                <th>
                                </th>
                                <td>
                                    <div style="padding: 12px 0px;">
                                        <asp:Button ID="btnAddProfile" runat="server" Text="Add Profile" OnClick="btnAddProfile_Click" />
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



