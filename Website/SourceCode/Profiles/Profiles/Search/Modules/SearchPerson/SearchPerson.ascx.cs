/*  
 
    Copyright (c) 2008-2012 by the President and Fellows of Harvard College. All rights reserved.  
    Profiles Research Networking Software was developed under the supervision of Griffin M Weber, MD, PhD.,
    and Harvard Catalyst: The Harvard Clinical and Translational Science Center, with support from the 
    National Center for Research Resources and Harvard University.


    Code licensed under a BSD License. 
    For details, see: LICENSE.txt 
  
*/
using System;
using System.IO;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using System.Configuration;
using System.Text;


using Profiles.Framework.Utilities;
using Profiles.Search.Utilities;



namespace Profiles.Search.Modules.SearchPerson
{
    public partial class SearchPerson : BaseModule
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Request.Form[this.hdnSearch.UniqueID].IsNullOrEmpty())
            {
                this.Search();
            }
        }


        public SearchPerson() { }
        public SearchPerson(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
        {
            txtSearchFor.Attributes.Add("onkeypress", "JavaScript:runScript(event);");
            txtFname.Attributes.Add("onkeypress", "JavaScript:runScript(event);");
            txtLname.Attributes.Add("onkeypress", "JavaScript:runScript(event);");
            


            if (Request.QueryString["action"] == "modify")
            {
                
                this.ModifySearch();
            }
            else
            {
                //Profiles.Search.Utilities.DataIO dropdowns = new Profiles.Search.Utilities.DataIO();
                if (Convert.ToBoolean(ConfigurationSettings.AppSettings["ShowInstitutions"]) == true)
                {
                    litInstitution.Text = SearcDropDowns.BuildDropdown("institution", "249", "");
                }
                else
                {
                    trInstitution.Visible = false;
                }

                if (Convert.ToBoolean(ConfigurationSettings.AppSettings["ShowDepartments"]) == true)
                {
                    litDepartment.Text = SearcDropDowns.BuildDropdown("department", "249", "");
                }
                else
                {
                    trDepartment.Visible = false;
                }

                if (Convert.ToBoolean(ConfigurationSettings.AppSettings["ShowDivisions"]) == true)
                {
                    litDivision.Text = SearcDropDowns.BuildDropdown("division", "249", "");
                }
                else
                {
                    trDivision.Visible = false;
                }


            }

            
            BuildFilters();
        }

        private void ModifySearch()
        {
            Search.Utilities.DataIO data = new Profiles.Search.Utilities.DataIO();

            bool institutiondropdown = false;
            bool departmentdropdown = false;
            bool divisiondropdown = false;
            string searchrequest = string.Empty;


            if (base.MasterPage !=null)
            {
                if(base.MasterPage.SearchRequest.IsNullOrEmpty() ==false)
                searchrequest = base.MasterPage.SearchRequest;
            }
            else if (Request.QueryString["searchrequest"].IsNullOrEmpty() == false)
            {
                searchrequest = Request.QueryString["searchrequest"];
            }

            SearchRequest = new XmlDocument();

            SearchRequest.LoadXml(data.DecryptRequest(searchrequest));

            


            if (SearchRequest.SelectSingleNode("SearchOptions/MatchOptions/SearchString") != null)
            {
                txtSearchFor.Text = SearchRequest.SelectSingleNode("SearchOptions/MatchOptions/SearchString").InnerText;
            }

            if (SearchRequest.SelectSingleNode("SearchOptions/MatchOptions/SearchString/@ExactMatch") != null)
            {
                switch (SearchRequest.SelectSingleNode("SearchOptions/MatchOptions/SearchString/@ExactMatch").Value)
                {
                    case "true":
                        chkExactphrase.Checked = true;
                        break;
                    case "false":
                        chkExactphrase.Checked = false;
                        break;
                }
            }

            if (SearchRequest.SelectSingleNode("SearchOptions/MatchOptions/SearchFiltersList") != null)
            {

                foreach (XmlNode x in SearchRequest.SelectNodes("SearchOptions/MatchOptions/SearchFiltersList/SearchFilter"))
                {
                    if (x.SelectSingleNode("@Property").Value == "http://profiles.catalyst.harvard.edu/ontology/prns#personInPrimaryPosition" && x.SelectSingleNode("@Property2").Value == "http://vivoweb.org/ontology/core#positionInOrganization")
                    {


                        litInstitution.Text = SearcDropDowns.BuildDropdown("institution", "249", x.InnerText);
                        institutiondropdown = true;

                        if (x.SelectSingleNode("@IsExclude").Value == "1")
                            institutionallexcept.Checked = true;
                        else
                            institutionallexcept.Checked = false;
                    }

                    if (x.SelectSingleNode("@Property").Value == "http://profiles.catalyst.harvard.edu/ontology/prns#personInPrimaryPosition" && x.SelectSingleNode("@Property2").Value == "http://profiles.catalyst.harvard.edu/ontology/prns#positionInDepartment")
                    {
                        litDepartment.Text = SearcDropDowns.BuildDropdown("department", "249", x.InnerText);
                        departmentdropdown = true;

                        if (x.SelectSingleNode("@IsExclude").Value == "1")
                            departmentallexcept.Checked = true;
                        else
                            departmentallexcept.Checked = false;
                    }


                    if (x.SelectSingleNode("@Property").Value == "http://profiles.catalyst.harvard.edu/ontology/prns#personInPrimaryPosition" && x.SelectSingleNode("@Property2").Value == "http://profiles.catalyst.harvard.edu/ontology/prns#positionInDivision")
                    {
                        litDivision.Text = SearcDropDowns.BuildDropdown("division", "249", x.InnerText);
                        divisiondropdown = true;

                        if (x.SelectSingleNode("@IsExclude").Value == "1")
                            divisionallexcept.Checked = true;
                        else
                            divisionallexcept.Checked = false;
                    }

                    if (x.SelectSingleNode("@Property").Value == "http://profiles.catalyst.harvard.edu/ontology/prns#hasPersonFilter")
                    {





                    }

                    if (x.SelectSingleNode("@Property").Value == "http://xmlns.com/foaf/0.1/firstName")
                    {
                        txtFname.Text = x.InnerText;
                    }

                    if (x.SelectSingleNode("@Property").Value == "http://xmlns.com/foaf/0.1/lastName")
                    {
                        txtLname.Text = x.InnerText;
                    }
                }
            }

            if (!institutiondropdown)
                litInstitution.Text = SearcDropDowns.BuildDropdown("institution", "249", "");

            if (!departmentdropdown)
                litDepartment.Text = SearcDropDowns.BuildDropdown("department", "249", "");

            if (!divisiondropdown)
                litDivision.Text = SearcDropDowns.BuildDropdown("division", "249", "");





        }

        public string GetURLDomain()
        {
            return Root.Domain;
        }

               
        private void BuildFilters()
        {

            Utilities.DataIO data = new Profiles.Search.Utilities.DataIO();

            System.Data.DataSet ds = data.GetPersonTypes();

        }

        private void Search()
        {
            string lname = Request.Form[this.txtLname.UniqueID];
            string fname = Request.Form[this.txtFname.UniqueID];
            string searchfor = Request.Form[this.txtSearchFor.UniqueID];
            string exactphrase = Request.Form[this.chkExactphrase.UniqueID];
            //string facrank = Request.Form[this.hidList.UniqueID];

            if (exactphrase == "on")
                exactphrase = "true";
            else
                exactphrase = "false";

            string institution = "";
            string institutionallexcept = "";

            string department = "";
            string departmentallexcept = "";

            string division = "";
            string divisionallexcept = "";


            if (Request.Form["institution"] != null)
            {
                institution = Request.Form["institution"];
                institutionallexcept = Request.Form[this.institutionallexcept.UniqueID];//Request.Form["institutionallexcept"];
            }

            if (!Request.Form["department"].IsNullOrEmpty())
            {
                department = Request.Form["department"];
                departmentallexcept = Request.Form[this.departmentallexcept.UniqueID];
            }


            if (!Request.Form["division"].IsNullOrEmpty())
            {
                division = Request.Form["division"];
                divisionallexcept = Request.Form[this.divisionallexcept.UniqueID];
            }

            string otherfilters = Request.Form["hdnSelectedText"];

            string classuri = "http://xmlns.com/foaf/0.1/Person";

            string searchrequest = string.Empty;

            Utilities.DataIO data = new Profiles.Search.Utilities.DataIO();



            data.SearchRequest(searchfor, exactphrase, fname, lname, institution, institutionallexcept,
                department, departmentallexcept, division, divisionallexcept, classuri, "15", "0", "", "", otherfilters, "", ref searchrequest);

            Response.Redirect(Root.Domain + "/search/default.aspx?showcolumns=1&searchtype=people&otherfilters=" + otherfilters + "&searchrequest=" + searchrequest, true);



        }

        private XmlDocument SearchRequest { get; set; }
    }
}
