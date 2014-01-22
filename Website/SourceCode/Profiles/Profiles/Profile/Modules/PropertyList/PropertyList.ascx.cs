/*  
 
    Copyright (c) 2008-2012 by the President and Fellows of Harvard College. All rights reserved.  
    Profiles Research Networking Software was developed under the supervision of Griffin M Weber, MD, PhD.,
    and Harvard Catalyst: The Harvard Clinical and Translational Science Center, with support from the 
    National Center for Research Resources and Harvard University.


    Code licensed under a BSD License. 
    For details, see: LICENSE.txt 
  
*/
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using System.Xml.Xsl;
using Profiles.Framework.Utilities;
using Profiles.Profile.Utilities;
using Profiles.ORNG.Utilities;
using System.Data;
using System.Data.SqlClient;


namespace Profiles.Profile.Modules.PropertyList
{
    public partial class PropertyList : BaseModule
    {
        private ModulesProcessing mp;  
        private string personid;

        protected void Page_Load(object sender, EventArgs e)
        {
            DrawProfilesModule();
            DrawGrantInformation();
        }

        public PropertyList() { }
        public PropertyList(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
            : base(pagedata, moduleparams, pagenamespaces)
        {

            
            XmlDocument presentationxml = base.PresentationXML;
            SessionManagement sm = new SessionManagement();

            Profiles.Profile.Utilities.DataIO data = new Profiles.Profile.Utilities.DataIO();
            

            this.PropertyListXML = data.GetPropertyList(pagedata, presentationxml,"",false,false,true);

            mp = new ModulesProcessing();

        }

        protected void piGrants_OnRowDataBound(object sender, GridViewRowEventArgs e)
        {
        }

        protected void Grants_OnRowDataBound(object sender, GridViewRowEventArgs e)
        {
        }
        protected void btnAddGrant_Click(object sender, EventArgs e)
        {
            Profiles.Profile.Utilities.DataIO data = new Profiles.Profile.Utilities.DataIO();
            
            personid = data.getPersonIDByProfileID((string)Request.QueryString["subject"]);
            
            // Call Add Grant Stored Procedure
            // TODO: put some checks testing the ingerity of the data inputs
            //Profiles.Profile.Utilities.DataIO data = new Profiles.Profile.Utilities.DataIO();
            string newGrantID = data.insertNewGrantAndRetrieveNewGrantID(txtGrantTitle.Text.ToString(), txtStartDate.Text.ToString(), txtEndDate.Text.ToString(), txtGrantAmount.Text.ToString());

            if (personid != null)
            {
                data.insertPersonAffiliationByGrantID(newGrantID, PIList.SelectedValue, personid);

                // Call stored proc to generate triples for this personID
                data.generateGrantTriplesByPersonID(personid);

                // Refresh to the page
                Response.Redirect(Root.Domain + "/display/"+ (string)Request.QueryString["subject"]);
            }
        }

        protected void PIList_selectionChanged(object sender, EventArgs e)
        {           
        }

        


        private void DrawGrantInformation() {            
            string path = HttpContext.Current.Request.Url.AbsolutePath; //profiles/display/**(maybe more in the future)**/{id} (should be at least)

            string[] partsOfPath = path.Split('/');
            string profileID = partsOfPath[partsOfPath.Length-1];

            //Get the personID from the ProfileID
            Profiles.Profile.Utilities.DataIO data = new Profiles.Profile.Utilities.DataIO();
            personid = data.getPersonIDByProfileID(profileID);

            ViewState["personid"] = personid;

            if (personid != null)
            {
                // Get all of the grants this profile is a PI on
                SqlDataReader reader;
                List<Grant> PIgrants = new List<Grant>();

                reader = data.getGrantsByPersonID(personid, true);

                while (reader.Read())
                {
                    PIgrants.Add(new Grant(reader["ID"].ToString(), reader["Title"].ToString(), reader["Amount"].ToString(), reader["StartDate"].ToString(), reader["EndDate"].ToString()));
                }
                reader.Close();

                // Get all of the grants this profile is not a PI on
                reader = null;
                List<Grant> nonPIGrants = new List<Grant>();

                reader = data.getGrantsByPersonID(personid, false);

                while (reader.Read())
                {
                    nonPIGrants.Add(new Grant(reader["ID"].ToString(), reader["Title"].ToString(), reader["Amount"].ToString(), reader["StartDate"].ToString(), reader["EndDate"].ToString()));
                }
                reader.Close();

                if (PIgrants != null)
                {
                    // Throw the data in the grid table
                    piGrants.DataSource = PIgrants;
                    piGrants.DataBind();
                    piGrants.CellPadding = 2;
                }


                if (nonPIGrants != null)
                {
                    // Throw the data in the grid table
                    Grants.DataSource = nonPIGrants;
                    Grants.DataBind();
                    Grants.CellPadding = 2;
                }

                // Check if current user is not a super proxy then do not show the grant add button
                SessionManagement sm = new SessionManagement();
                string subject = sm.Session().SessionID.ToString();
                addGrantProfile.Visible = false;


                if (sm.Session().UserID != 0)
                {
                    // TODO: check if currently logged in user is a super proxy
                    Profiles.Proxy.Utilities.DataIO pData = new Profiles.Proxy.Utilities.DataIO();

                    if (pData.ManageProxies("GetDefaultUsersWhoseNodesICanEdit").Read()) // TODO: this might break on non super proxies (check)
                    {
                        // Currently logged in user has super proxy permissions over at least one user

                        // Check if the currently logged in user has permissions over the currently viewed profile
                        if (pData.doesCurrentUserHavePermissionsOverInputtedUserID(data.getUserIDByPersonID(personid)))
                        {
                            addGrantProfile.Visible = true;
                        }                                                                       
                    }
                }
            }

        }

        public class Grant {
            public Grant(string id, string title, string amount, string startdate, string enddate)
            {
                this.id = id;
                this.title = title;
                this.amount = amount;
                this.startdate = startdate;
                this.enddate = enddate;
            }
            public string id { get; set; }
            public string title { get; set; }
            public string amount { get; set; }
            public string startdate { get; set; }
            public string enddate { get; set; }
        }

        private void DrawProfilesModule()
        {
            //Remove Physical Neighbors
            string removePhysicalNeighbor = "$('.panelPassive:contains(\"Neighbors\") > .passiveSectionBody').filter(\":last\").remove();  ";
            removePhysicalNeighbor += " $('.passiveSectionHead:contains(\"Neighbors\")').remove(); ";
            removePhysicalNeighbor += " $('.passiveSectionLine').filter(\":last\").remove(); ";

            Page.ClientScript.RegisterStartupScript(this.GetType(), "removeNeighbor", removePhysicalNeighbor, true);
            //END Remove Physical Neighbors 

            string label = string.Empty;
            System.Text.StringBuilder html = new System.Text.StringBuilder();
            System.Text.StringBuilder itembuffer = new System.Text.StringBuilder();
            
            bool hasitems = false;

            // UCSF OpenSocial items
            string uri = null;
            // code to convert from numeric node ID to URI
            if (base.Namespaces.HasNamespace("rdf"))
            {
                XmlNode node = this.BaseData.SelectSingleNode("rdf:RDF/rdf:Description/@rdf:about", base.Namespaces);
                uri = node != null ? node.Value : null;
            }
            new Responder(uri, Page);
            bool gadgetsShown = false;

            foreach (XmlNode propertygroup in this.PropertyListXML.SelectNodes("PropertyList/PropertyGroup"))
            {                

                if (base.GetModuleParamXml("PropertyGroupURI") == null || base.GetModuleParamString("PropertyGroupURI") != string.Empty)
                {

                    if ((propertygroup.SelectNodes("Property/Network/Connection").Count > 0 && propertygroup.SelectNodes("Property[@CustomDisplay='false']").Count > 0) || propertygroup.SelectNodes("Property/CustomModule").Count > 0)
                    {
                        // START Hacks to remove auto generated GrantUI
                        if (propertygroup.SelectSingleNode("@URI").Value == "http://profiles.catalyst.harvard.edu/ontology/prns#PropertyGroupResearch")
                        {
                            continue;
                        }

                        if (propertygroup.SelectSingleNode("@URI").Value == "http://vivoweb.org/ontology/core#hasResearcherRole")
                        {
                            continue;
                        }

                        if (propertygroup.SelectSingleNode("@URI").Value == "http://vivoweb.org/ontology/core#hasPrincipalInvestigatorRole")
                        {
                            continue;
                        }
                        // END Hacks to remove auto generated GrantUI


                        // ORNG 
                        if (propertygroup.SelectSingleNode("@URI").Value == "http://profiles.catalyst.harvard.edu/ontology/prns#PropertyGroupBibliographic")
                        {
                            html.Append("<div id='gadgets-view' class='gadgets-gadget-parent'></div>");
                            gadgetsShown = true;
                        }
              
                        html.Append("<div class='PropertyGroup' style='cursor:pointer;' onclick=\"javascript:toggleBlock('propertygroup','" + propertygroup.SelectSingleNode("@URI").Value + "');\"><br>");
                        html.Append("<a style='text-decoration:none' href=\"javascript:toggleBlock('propertygroup','" + propertygroup.SelectSingleNode("@URI").Value + "\"> <img id=\"propertygroup" + propertygroup.SelectSingleNode("@URI").Value + "\" src='" + Root.Domain + "/Profile/Modules/PropertyList/images/minusSign.gif' style='border: none; text-decoration: none !important' border='0' /></a>&nbsp;"); //add image and onclick here.
                        html.Append("<input  type='hidden' id=\"imgon" + propertygroup.SelectSingleNode("@URI").Value + "\" value='" + Root.Domain + "/Profile/Modules/PropertyList/images/minusSign.gif' />");
                        html.Append("<input type='hidden' id=\"imgoff" + propertygroup.SelectSingleNode("@URI").Value + "\" value='" + Root.Domain + "/Profile/Modules/PropertyList/images/plusSign.gif'/>");
                        
                        html.Append(propertygroup.SelectSingleNode("@Label").Value);
                        html.Append("&nbsp;<br></div>");
                        html.Append("<div class='PropertyGroupItem'  id='" + propertygroup.SelectSingleNode("@URI").Value + "'>");

                        foreach (XmlNode propertyitem in propertygroup.SelectNodes("Property"))
                        {
                            if (base.GetModuleParamXml("PropertyURI") == null || base.GetModuleParamString("PropertyURI") != string.Empty)
                            {
                                itembuffer = new System.Text.StringBuilder();
                                if (propertyitem.SelectSingleNode("@CustomDisplay").Value == "false")
                                {
                                    hasitems = false;

                                    itembuffer.Append("<input type='hidden' id=\"imgon" + propertyitem.SelectSingleNode("@URI").Value + "\" value='" + Root.Domain + "/Profile/Modules/PropertyList/images/minusSign.gif' />");
                                    itembuffer.Append("<input type='hidden' id=\"imgoff" + propertyitem.SelectSingleNode("@URI").Value + "\" value='" + Root.Domain + "/Profile/Modules/PropertyList/images/plusSign.gif'/>");
                                    itembuffer.Append("<div>");
                                    itembuffer.Append("<div class='PropertyItemHeader' style='cursor:pointer;'  onclick=\"javascript:toggleBlock('propertyitem','" + propertyitem.SelectSingleNode("@URI").Value + "');\">");
                                    itembuffer.Append("<a  style='border: none; text-decoration: none !important' href=\"javascript:toggleBlock('propertyitem','" + propertyitem.SelectSingleNode("@URI").Value + "\"> <img id=\"propertyitem" + propertyitem.SelectSingleNode("@URI").Value + "\" src='" + Root.Domain + "/Profile/Modules/PropertyList/images/minusSign.gif' border='0'  /></a>&nbsp;"); //add image and onclick here.
                                    itembuffer.Append(propertyitem.SelectSingleNode("@Label").Value);
                                    itembuffer.Append("</div>");
                                    itembuffer.Append("<div class='PropertyGroupData'>");
                                    itembuffer.Append("<div style='padding-top:6px;padding-right:6px;padding-left:6px' id='" + propertyitem.SelectSingleNode("@URI").Value + "'>");

                                    foreach (XmlNode connection in propertyitem.SelectNodes("Network/Connection"))
                                    {
                                        
                                        if (connection.SelectSingleNode("@ResourceURI") != null)
                                        {
                                            itembuffer.Append("<a href='");
                                            itembuffer.Append(connection.SelectSingleNode("@ResourceURI").Value);
                                            itembuffer.Append("'>");
                                            itembuffer.Append(connection.InnerText.Replace("\n", "<br/>") + "<br><br>");
                                            itembuffer.Append("</a>");
                                            hasitems = true;

                                        }
                                        else
                                        {
                                            itembuffer.Append(connection.InnerText.Replace("\n","<br/>") + "<br><br>");
                                            hasitems = true;

                                        }
                                    }

                                    itembuffer.Append("</div></div></div>");

                                }
                                else if (propertyitem.SelectSingleNode("@CustomDisplay").Value == "true" && propertyitem.SelectNodes("CustomModule").Count > 0)
                                {
                                    itembuffer.Append("<input type='hidden' id=\"imgon" + propertyitem.SelectSingleNode("@URI").Value + "\" value='" + Root.Domain + "/Profile/Modules/PropertyList/images/minusSign.gif' />");
                                    itembuffer.Append("<input type='hidden' id=\"imgoff" + propertyitem.SelectSingleNode("@URI").Value + "\" value='" + Root.Domain + "/Profile/Modules/PropertyList/images/plusSign.gif'/>");
                                    itembuffer.Append("<div>");
                                    itembuffer.Append("<div class='PropertyItemHeader' style='cursor:pointer;' onclick=\"javascript:toggleBlock('propertyitem','" + propertyitem.SelectSingleNode("@URI").Value + "');\">");
                                    itembuffer.Append("<a href=\"javascript:toggleBlock('propertyitem','" + propertyitem.SelectSingleNode("@URI").Value + "\"> <img id=\"propertyitem" + propertyitem.SelectSingleNode("@URI").Value + "\" src='" + Root.Domain + "/Profile/Modules/PropertyList/images/minusSign.gif' style='border: none; text-decoration: none !important' border='0' /></a>&nbsp;"); //add image and onclick here.
                                    itembuffer.Append(propertyitem.SelectSingleNode("@Label").Value);
                                    itembuffer.Append("</div>");
                                    itembuffer.Append("<div class='PropertyGroupData'>");
                                    itembuffer.Append("<div id='" + propertyitem.SelectSingleNode("@URI").Value + "'>");
                                    
                                    foreach(XmlNode node in propertyitem.SelectNodes("CustomModule")){
                                        hasitems = true;
                                        itembuffer.Append(base.RenderCustomControl(node.OuterXml,base.BaseData));
                                    }

                                    itembuffer.Append("</div></div></div>");

                                }



                                if (hasitems)
                                {
                                    html.Append(itembuffer.ToString());

                                }

                            }

                        } //End of property item loop

                        // ORNG hack
                        if (propertygroup.SelectSingleNode("@URI").Value == "http://profiles.catalyst.harvard.edu/ontology/prns#PropertyGroupBibliographic")
                        {
                            html.Append("<div id='gadgets-view-bottom' class='gadgets-gadget-parent'></div>");
                        }


                        html.Append("</div>");

                    }
                }


            }//End of property group loop

            // ORNG gadget 
            if (!gadgetsShown)
            {
                html.Append("<div id='gadgets-view' class='gadgets-gadget-parent'></div>");
                html.Append("<div id='gadgets-view-bottom' class='gadgets-gadget-parent'></div>");
                gadgetsShown = true;
            }

            litPropertyList.Text = html.ToString();

        }

       
        private List<Module> Modules { get; set; }
        private XmlDocument PropertyListXML { get; set; }

        public class Responder : ORNGCallbackResponder
        {
            string uri;

            public Responder(string uri, Page page) : base(uri, page, false, ORNGCallbackResponder.JSON_PERSONID_REQ)
            {
                this.uri = uri;
            }

            public override string getCallbackResponse()
            {
                return BuildJSONPersonIds(uri, "one person");
            }
        }
    }

}