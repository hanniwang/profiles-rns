using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Data.Common;
using System.Globalization;
using System.Text;
using System.Xml;
using System.Xml.Xsl;
using System.Web.UI.HtmlControls;


using Profiles.Framework.Utilities;
using Profiles.Profile.Utilities;

namespace Profiles.Proxy.Modules.AddProfile
{
    public partial class AddNewProfile : BaseModule
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            LoadAssets();
        }

        public AddNewProfile() { }
        public AddNewProfile(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
        {

        }
        
        private void LoadAssets()
        {
            HtmlLink Searchcss = new HtmlLink();
            Searchcss.Href = Root.Domain + "/Search/CSS/search.css";
            Searchcss.Attributes["rel"] = "stylesheet";
            Searchcss.Attributes["type"] = "text/css";
            Searchcss.Attributes["media"] = "all";
            Page.Header.Controls.Add(Searchcss);
        }

        protected void btnAddProfile_Click(object sender, EventArgs e)
        {
            Utilities.DataIO data = new Profiles.Proxy.Utilities.DataIO();

            string firstName = txtFirstName.Text.ToString();
            string middleName = txtMiddleName.Text.ToString();
            string lastName = txtLastName.Text.ToString();
            string gender = txtGender.Text.ToString(); // TODO : make a drop down
            string addressLineOne = txtAddressLineOne.Text.ToString();
            string addressLineTwo = txtAddressLineTwo.Text.ToString();
            string city = txtCity.Text.ToString();
            string state = txtState.Text.ToString(); //TODO: make a drop down
            string zip = txtZip.Text.ToString();
            string phoneNumber = txtPhoneNumber.Text.ToString();
            string emailAddress = txtEmail.Text.ToString();
            string title = txtTitle.Text.ToString();
            string institutionName = txtInstitutionName.Text.ToString();
            string institutionAbbreviation= txtInstitutionAbbreviation.Text.ToString();
            string departmentName = txtDepartmentName.Text.ToString();
            

            // Check that all of the inputs are valid
            
            if (firstName == string.Empty)
            {
                printErrorMessage("First Name is required", txtFirstName);
                return;
            }

            if (firstName.Length > 50)
            {
                printErrorMessage("First Name must be less than 50 characters", txtFirstName);
                return;
            }

            if (middleName == string.Empty)
            {
                printErrorMessage("Middle Name is required", txtMiddleName);
                return;
            }

            if (middleName.Length > 50)
            {
                printErrorMessage("Middle Name must be less than 50 characters.", txtMiddleName);
                return;
            }
            
            if (lastName == string.Empty)
            {
                printErrorMessage("Last Name is required.", txtLastName);
                return;
            }

            if (lastName.Length > 50)
            {
                printErrorMessage("You cannot input a Last Name with more than 50 characters.", txtLastName);
                return;
            } 
            
            if (gender == string.Empty)
            {
                printErrorMessage("Gender is required", txtGender);
                return;
            }

            if (gender.Length > 50)
            {
                printErrorMessage("Gender must be less than 50 characters", txtGender);
                return;
            }
            
            if (addressLineOne == string.Empty)
            {
                printErrorMessage("Address Line One is required", txtAddressLineOne);
                return;
            }

            if (addressLineOne.Length > 55)
            {
                printErrorMessage("Address Line One must be less than 55 characters", txtAddressLineOne);
                return;
            }
            
            if (addressLineTwo == string.Empty)
            {
                printErrorMessage("Address Line Two is required", txtAddressLineTwo);
                return;
            }

            if (addressLineTwo.Length > 55)
            {
                printErrorMessage("Address Line Two must be less than 55 characters", txtAddressLineTwo);
                return;
            }
            
            if (city == string.Empty)
            {
                printErrorMessage("City is required", txtCity);
                return;
            }

            if (city.Length > 100)
            {
                printErrorMessage("City must be less than 100 characters", txtCity);
                return;
            }
            
            if (state == string.Empty)
            {
                printErrorMessage("State is required", txtState);
                return;
            }

            if (state.Length != 2)
            {
                printErrorMessage("State must be 2 characters", txtState);
                return;
            } 
            
            if (zip == string.Empty)
            {
                printErrorMessage("Zip is required", txtZip);
                return;
            }

            if (zip.Length > 50)
            {
                printErrorMessage("Zip must be less than 10 characters", txtZip);
                return;
            } 
            
            if (phoneNumber == string.Empty)
            {
                printErrorMessage("Phone Number is required", txtPhoneNumber);
                return;
            }

            // TODO: Are there any other restrictions on phone number? Should I put some simple regex checks here?

            if (phoneNumber.Length > 35)
            {
                printErrorMessage("Phone Number must be less than 35 characters", txtPhoneNumber);
                return;
            } 
            
            if (emailAddress == string.Empty)
            {
                printErrorMessage("Email is required", txtEmail);
                return;
            }

            // TODO: Are there any other restrictions on email address? Should I put some simple regex checks here?

            if (emailAddress.Length > 255)
            {
                printErrorMessage("Email must be less than 255 characters", txtEmail);
                return;
            } 
            
            if (title == string.Empty)
            {
                printErrorMessage("Title is required", txtTitle);
                return;
            }

            if (title.Length > 500)
            {
                printErrorMessage("Title must be less than 500", txtTitle);
                return;
            } 
            
            if (institutionName == string.Empty)
            {
                printErrorMessage("Institution Name is required", txtInstitutionName);
                return;
            }

            if (institutionName.Length > 500)
            {
                printErrorMessage("Institution Name must be less than 500 characters", txtInstitutionName);
                return;
            }

            if (institutionAbbreviation == string.Empty)
            {
                printErrorMessage("Institution Name is required", txtInstitutionAbbreviation);
                return;
            }

            if (institutionAbbreviation.Length > 50)
            {
                printErrorMessage("Institution Name must be less than 500 characters", txtInstitutionAbbreviation);
                return;
            }

            if (departmentName == string.Empty)
            {
                printErrorMessage("Department Name is required", txtDepartmentName);
                return;
            }

            if (departmentName.Length > 500)
            {
                printErrorMessage("Institution Name must be less than 500 characters", txtDepartmentName);
                return;
            }

            // Check that the profile we are trying to add doesn't already exist in the system
            if (data.emailExists(emailAddress.ToLower()))
            {
                printErrorMessage("A profile with this email already exists in the system.", txtEmail);
                return;
            }
            
            // Add a row into Profile.Import.Person and Profile.Import.PersonAffiliation tables
            data.loadNewProfileIntoStagingTables(new Profile(firstName, middleName, lastName, gender, addressLineOne, addressLineTwo, city, state, zip, phoneNumber, emailAddress, title, institutionName, institutionAbbreviation, departmentName));

            // TODO: Should I call Profiles.Import.ValidateProfileImportblahblah.StoredProcedure.sql here?? --> I looked at it brielfy
            //    --> we might be able to use it here to validate user inputs (I have to read through it all first to ensure it doesnt have unintended side effects)
            // data.validateProfileImport();

            // call the Profile.Import.LoadProfilesData stored procedure
            data.loadProfilesData();

            // call RDF.Stage.ProcessDataMap stored procedure
            data.processDataMap();

            // At this point the new profile should be in the system. 
            
            // I need to update cache now. So it is searchable            
            // call Search.Cache.Public.UpdateCache stored proc
            data.updatePublicCache();

        }

        // TODO: Place this function in Utils so that all of the classes can access this
        private void printErrorMessage(String message, WebControl errorer) 
        {
            string strScript = " window.alert('" + message + "');";
            if (!Page.ClientScript.IsStartupScriptRegistered("myscript"))
                Page.ClientScript.RegisterStartupScript(this.GetType(), "myscript", strScript, true);
            errorer.Style.Add("background", "#FFAAAA");
        }

        public string GetURLDomain()
        {
            return Root.Domain;
        }

        public DataSet MyDataSet
        {
            get
            {
                if (ViewState["MyDataSet"] == null)
                    ViewState["MyDataSet"] = new DataSet();
                return (DataSet)ViewState["MyDataSet"];
            }
            set { ViewState["MyDataSet"] = value; }
        }

    }

   
}