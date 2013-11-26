
namespace Profiles.Proxy.Modules.AddProfile
{
    public class Profile 
    {
        public Profile(string firstName, string middleName, string lastName, string gender, string addressLineOne, string addressLineTwo, string city, string state, string zip, string phoneNumber, string emailAddress, string title, string institutionName, string institutionAbbreviation, string departmentName)
        {
            this.firstName = firstName;
            this.middleName = middleName;
            this.lastName = lastName;
            this.gender = gender;
            this.addressLineOne = addressLineOne;
            this.addressLineTwo = addressLineTwo;
            this.city = city;
            this.state = state;
            this.zip = zip;
            this.phoneNumber = phoneNumber;
            this.emailAddress = emailAddress;
            this.title = title;
            this.institutionName = institutionName;
            this.institutionAbbreviation = institutionAbbreviation;
            this.departmentName = departmentName;
        }

        public string firstName { get; set; }
        public string middleName { get; set; }
        public string lastName { get; set; }
        public string gender { get; set; }
        public string addressLineOne { get; set; }
        public string addressLineTwo { get; set; }
        public string city { get; set; }
        public string state { get; set; }
        public string zip { get; set; }
        public string phoneNumber { get; set; }
        public string emailAddress { get; set; }
        public string title { get; set; }
        public string institutionName { get; set; }
        public string institutionAbbreviation { get; set; }
        public string departmentName { get; set; }

    }
}