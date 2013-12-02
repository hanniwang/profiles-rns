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
using System.Data;
using System.Data.SqlClient;
using System.Xml;
using System.Configuration;

using Profiles.Framework.Utilities;

namespace Profiles.Proxy.Utilities
{
    public class DataIO : Profiles.Framework.Utilities.DataIO
    {
        public Boolean emailExists(string email)
        {
            SqlDataReader dbreader = null;

            try
            {
                string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;
                SqlConnection dbconnection = new SqlConnection(connstr);

                dbconnection.Open();

                SqlCommand dbcommand = new SqlCommand();
                dbcommand.CommandType = CommandType.StoredProcedure;

                dbcommand.CommandText = "[User.Account].[GetUserByEmail]";
                dbcommand.CommandTimeout = base.GetCommandTimeout();

                dbcommand.Parameters.Add(new SqlParameter("@Email", email));
                dbcommand.Connection = dbconnection;
                dbreader = dbcommand.ExecuteReader(CommandBehavior.CloseConnection);

                dbreader.Read();
                string userID = dbreader["UserID"].ToString();
                dbreader.Close();

                if (userID != String.Empty)
                    return true;
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }

            return false;
        }


        public void updatePublicCache()
        {
            try
            {
                string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;
                SqlConnection dbconnection = new SqlConnection(connstr);

                dbconnection.Open();

                SqlCommand dbcommand = new SqlCommand();
                dbcommand.CommandType = CommandType.StoredProcedure;

                dbcommand.CommandText = "[Search.Cache].[Public.UpdateCache]";
                //dbcommand.CommandTimeout = base.GetCommandTimeout();
                dbcommand.CommandTimeout = 0;

                dbcommand.Connection = dbconnection;
                dbcommand.ExecuteNonQuery();
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        public void validateProfileImport()
        {
            try
            {
                string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;
                SqlConnection dbconnection = new SqlConnection(connstr);

                dbconnection.Open();

                SqlCommand dbcommand = new SqlCommand();
                dbcommand.CommandType = CommandType.StoredProcedure;

                dbcommand.CommandText = "[Profile.Import].[ValidateProfilesImportTables]";
                dbcommand.CommandTimeout = base.GetCommandTimeout();

                dbcommand.Connection = dbconnection;
                dbcommand.ExecuteNonQuery();
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        public void processDataMap()
        {
            try
            {
                string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;
                SqlConnection dbconnection = new SqlConnection(connstr);

                dbconnection.Open();

                SqlCommand dbcommand = new SqlCommand();
                dbcommand.CommandType = CommandType.StoredProcedure;

                dbcommand.CommandText = "[RDF.Stage].[ProcessDataMap]";
                //dbcommand.CommandTimeout = base.GetCommandTimeout();
                dbcommand.CommandTimeout = 0;

                dbcommand.Connection = dbconnection;
                dbcommand.ExecuteNonQuery();
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        public void loadProfilesData()
        {
            try
            {
                string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;
                SqlConnection dbconnection = new SqlConnection(connstr);

                dbconnection.Open();

                SqlCommand dbcommand = new SqlCommand();
                dbcommand.CommandType = CommandType.StoredProcedure;

                dbcommand.CommandText = "[Profile.Import].[LoadProfilesData]";
                //dbcommand.CommandTimeout = base.GetCommandTimeout();
                dbcommand.CommandTimeout = 0;

                //dbcommand.Parameters.Add(new SqlParameter("@use_internalusername_as_pkey", 1));

                dbcommand.Connection = dbconnection;
                dbcommand.ExecuteNonQuery();
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        public void loadNewProfileIntoStagingTables(Profiles.Proxy.Modules.AddProfile.Profile profile)
        {
            // Create a row in [Profile.Import].[Person]
            try
            {
                string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;
                SqlConnection dbconnection = new SqlConnection(connstr);

                dbconnection.Open();

                SqlCommand dbcommand = new SqlCommand();
                dbcommand.CommandType = CommandType.StoredProcedure;

                dbcommand.CommandText = "[Profile.Import].[InsertPersonData]";
                dbcommand.CommandTimeout = base.GetCommandTimeout();
                
                dbcommand.Parameters.Add(new SqlParameter("@FirstName", profile.firstName));
                dbcommand.Parameters.Add(new SqlParameter("@MiddleName", profile.middleName));
                dbcommand.Parameters.Add(new SqlParameter("@LastName", profile.lastName));
                dbcommand.Parameters.Add(new SqlParameter("@Gender", profile.gender));
                dbcommand.Parameters.Add(new SqlParameter("@AddressLineOne", profile.addressLineOne));
                dbcommand.Parameters.Add(new SqlParameter("@AddressLineTwo", profile.addressLineTwo));
                dbcommand.Parameters.Add(new SqlParameter("@City", profile.city));
                dbcommand.Parameters.Add(new SqlParameter("@State", profile.state));
                dbcommand.Parameters.Add(new SqlParameter("@Zip", profile.zip));
                dbcommand.Parameters.Add(new SqlParameter("@PhoneNumber", profile.phoneNumber));
                dbcommand.Parameters.Add(new SqlParameter("@Email", profile.emailAddress));
                
                dbcommand.Connection = dbconnection;
                dbcommand.ExecuteNonQuery();
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }

            // Create a row in [Profile.Import].[PersonAffiliation]
            try
            {
                string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;
                SqlConnection dbconnection = new SqlConnection(connstr);

                dbconnection.Open();

                SqlCommand dbcommand = new SqlCommand();
                dbcommand.CommandType = CommandType.StoredProcedure;

                dbcommand.CommandText = "[Profile.Import].[InsertPersonAffiliationData]";
                dbcommand.CommandTimeout = base.GetCommandTimeout();


                dbcommand.Parameters.Add(new SqlParameter("@Email", profile.emailAddress));
                dbcommand.Parameters.Add(new SqlParameter("@Title", profile.title));
                dbcommand.Parameters.Add(new SqlParameter("@InstitutionName", profile.institutionName));
                dbcommand.Parameters.Add(new SqlParameter("@InstitutionAbbreviation", profile.institutionAbbreviation));
                dbcommand.Parameters.Add(new SqlParameter("@DepartmentName", profile.departmentName));

                dbcommand.Connection = dbconnection;
                dbcommand.ExecuteNonQuery();
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }


        public Boolean doesCurrentUserHavePermissionsOverInputtedPermissions(string institutionPermission, string departmentPermission)
        {
            SqlDataReader reader;

            string userSessionUserID;

            // Get currently logged in user's user id
            reader = GetUserIDBySessionID();
            reader.Read();
            userSessionUserID = reader["UserID"].ToString();
            reader.Close();

            // Get currently logged in user's permission level
            string userInstPermission;
            string userDeptPermission;

            reader = GetUserPermissionsByUserID(userSessionUserID);
            reader.Read();
            userInstPermission = reader["Institution"].ToString();
            userDeptPermission = reader["Department"].ToString();
            reader.Close();

            return permissionCheck(userInstPermission, userDeptPermission, institutionPermission, departmentPermission);
        }


        // The below function only works when an inputted UserID already has permissions in the DefaultProxy table
        // Use doesCurrentUserHavePermissionsOverInputtedPermissions( ) if the super proxy does not exist in the system yet
        public Boolean doesCurrentUserHavePermissionsOverInputtedUserID(string otherUserID)
        {
            SqlDataReader reader;

            string userSessionUserID;

            // Get currently logged in user's user id
            reader = GetUserIDBySessionID();
            reader.Read();
            userSessionUserID = reader["UserID"].ToString();
            reader.Close();

            // Get currently logged in user's permission level
            string userInstPermission;
            string userDeptPermission;

            reader = GetUserPermissionsByUserID(userSessionUserID);
            reader.Read();
            userInstPermission = reader["Institution"].ToString();
            userDeptPermission = reader["Department"].ToString();
            reader.Close();

            string otherInstPermission;
            string otherDeptPermission;

            // Get other user's permissions
            reader = GetUserPermissionsByUserID(otherUserID);
            reader.Read();
            otherInstPermission = reader["Institution"].ToString();
            otherDeptPermission = reader["Department"].ToString();
            reader.Close();

            return permissionCheck(userInstPermission, userDeptPermission, otherInstPermission, otherDeptPermission); 
        }

        private Boolean permissionCheck(string userInstPermission, string userDeptPermission, string otherInstPermission, string otherDeptPermission)
        {
            // If current user has "All" permissions on Institution then they have global permissions
            if (userInstPermission != "All")
            {
                // if current user does not have permission over the other user user's institution
                if (userInstPermission != otherInstPermission)
                {
                    return false;
                }

                // if the current user does have permission over other user's insitution
                // but the current user does not have permission over other user's department
                if (userDeptPermission != "All")
                {
                    if (userDeptPermission != otherDeptPermission)
                    {
                        return false;
                    }
                }
            }

            return true;
        }

        public SqlDataReader GetUserPermissionsByUserID(string userID)
        {
            SqlDataReader dbreader = null;

            try
            {

                string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;
                SqlConnection dbconnection = new SqlConnection(connstr);

                dbconnection.Open();

                SqlCommand dbcommand = new SqlCommand();
                dbcommand.CommandType = CommandType.StoredProcedure;

                dbcommand.CommandText = "[User.Account].[Proxy.GetDefaultProxyPermissionsByUserID]";
                dbcommand.CommandTimeout = base.GetCommandTimeout();

                dbcommand.Parameters.Add(new SqlParameter("@UserID", userID));
                dbcommand.Connection = dbconnection;
                dbreader = dbcommand.ExecuteReader(CommandBehavior.CloseConnection);

            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }

            return dbreader;
        }

        public SqlDataReader GetUserIDBySessionID()
        {
            SqlDataReader dbreader = null;
            SessionManagement sm = new SessionManagement();

            try
            {

                string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;
                SqlConnection dbconnection = new SqlConnection(connstr);

                dbconnection.Open();

                SqlCommand dbcommand = new SqlCommand();
                dbcommand.CommandType = CommandType.StoredProcedure;

                dbcommand.CommandText = "[User.Account].[Proxy.GetUserIDBySessionID]";
                dbcommand.CommandTimeout = base.GetCommandTimeout();

                dbcommand.Parameters.Add(new SqlParameter("@SessionID", sm.Session().SessionID));
                dbcommand.Connection = dbconnection;
                dbreader = dbcommand.ExecuteReader(CommandBehavior.CloseConnection);

            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }

            return dbreader;
        }

        public void DeleteSuperProxy(string userid)
        {
            SessionManagement sm = new SessionManagement();

            try
            {
                string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;
                SqlConnection dbconnection = new SqlConnection(connstr);

                dbconnection.Open();

                SqlCommand dbcommand = new SqlCommand();
                dbcommand.CommandType = CommandType.StoredProcedure;

                dbcommand.CommandText = "[User.Account].[Proxy.DeleteDefaultProxy]";
                dbcommand.CommandTimeout = base.GetCommandTimeout();
                dbcommand.Parameters.Add(new SqlParameter("@UserID", userid));
                dbcommand.Connection = dbconnection;
                dbcommand.ExecuteNonQuery();
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        public void DeleteProxy(string userid)
        {
            SessionManagement sm = new SessionManagement();

            try
            {

                string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;
                SqlConnection dbconnection = new SqlConnection(connstr);

                dbconnection.Open();

                SqlCommand dbcommand = new SqlCommand();
                dbcommand.CommandType = CommandType.StoredProcedure;

                dbcommand.CommandText = "[User.Account].[Proxy.DeleteDesignatedProxy]";
                dbcommand.CommandTimeout = base.GetCommandTimeout();

                dbcommand.Parameters.Add(new SqlParameter("@SessionID", sm.Session().SessionID));
                dbcommand.Parameters.Add(new SqlParameter("@UserID", userid));
                dbcommand.Connection = dbconnection;
                dbcommand.ExecuteNonQuery();

            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }


        }

        public void InsertDefaultProxy(string userid, string proxyForInstitution, string proxyForDepartment, bool isVisible)
        {
            SessionManagement sm = new SessionManagement();

            try
            {
                string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;
                SqlConnection dbconnection = new SqlConnection(connstr);

                dbconnection.Open();

                SqlCommand dbcommand = new SqlCommand();
                dbcommand.CommandType = CommandType.StoredProcedure;

                dbcommand.CommandText = "[User.Account].[Proxy.AddDefaultProxy]";
                dbcommand.CommandTimeout = base.GetCommandTimeout();

                dbcommand.Parameters.Add(new SqlParameter("@UserID", userid));
                dbcommand.Parameters.Add(new SqlParameter("@ProxyForInstitution", proxyForInstitution));
                dbcommand.Parameters.Add(new SqlParameter("@ProxyForDepartment", proxyForDepartment));
                dbcommand.Parameters.Add(new SqlParameter("@IsVisible", isVisible));
                dbcommand.Connection = dbconnection;
                dbcommand.ExecuteNonQuery();  
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }


        public void InsertProxy(string userid)
        {
            SessionManagement sm = new SessionManagement();

            try
            {

                string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;
                SqlConnection dbconnection = new SqlConnection(connstr);

                dbconnection.Open();

                SqlCommand dbcommand = new SqlCommand();
                dbcommand.CommandType = CommandType.StoredProcedure;

                dbcommand.CommandText = "[User.Account].[Proxy.AddDesignatedProxy]";
                dbcommand.CommandTimeout = base.GetCommandTimeout();

                dbcommand.Parameters.Add(new SqlParameter("@SessionID", sm.Session().SessionID));
                dbcommand.Parameters.Add(new SqlParameter("@UserID", userid));
                dbcommand.Connection = dbconnection;
                dbcommand.ExecuteNonQuery();

            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }


        }

        public SqlDataReader ManageProxies(string operation)
        {
            SqlDataReader dbreader = null;
            SessionManagement sm = new SessionManagement();

            try
            {

                string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;
                SqlConnection dbconnection = new SqlConnection(connstr);

                dbconnection.Open();

                SqlCommand dbcommand = new SqlCommand();
                dbcommand.CommandType = CommandType.StoredProcedure;
                
                dbcommand.CommandText = "[User.Account].[Proxy.GetProxies]";
                dbcommand.CommandTimeout = base.GetCommandTimeout();
                
                dbcommand.Parameters.Add(new SqlParameter("@SessionID", sm.Session().SessionID));
                dbcommand.Parameters.Add(new SqlParameter("@Operation", operation));
                dbcommand.Connection = dbconnection;
                dbreader = dbcommand.ExecuteReader(CommandBehavior.CloseConnection);

            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }

            return dbreader;
        }
        public DataSet SearchProxies(string lastname, string firstname,
            string institution,string department,int offset,int limit)
        {
            DataSet ds = new DataSet();
            SqlDataAdapter da;

            try
            {
                string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;
                SqlConnection dbconnection = new SqlConnection(connstr);

                dbconnection.Open();

                SqlCommand dbcommand = new SqlCommand();
                dbcommand.CommandType = CommandType.StoredProcedure;

                dbcommand.CommandText = "[user.account].[proxy.search]";
                dbcommand.CommandTimeout = base.GetCommandTimeout();

                dbcommand.Parameters.Add(new SqlParameter("@LastName",lastname));
                dbcommand.Parameters.Add(new SqlParameter("@FirstName", firstname));
                dbcommand.Parameters.Add(new SqlParameter("@Institution", institution));
                dbcommand.Parameters.Add(new SqlParameter("@Department", department));                

                dbcommand.Parameters.Add(new SqlParameter("@offset", offset));
                dbcommand.Parameters.Add(new SqlParameter("@limit", limit));
                dbcommand.Connection = dbconnection;
                da = new SqlDataAdapter(dbcommand);
                da.Fill(ds, "Table");

            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }

            return ds;
        }

        public List<GenericListItem> GetInstitutions()
        {
            
              SqlDataReader dbreader = null;
            SessionManagement sm = new SessionManagement();
            List<GenericListItem> institutions = new List<GenericListItem>();

            try
            {

                string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;
                SqlConnection dbconnection = new SqlConnection(connstr);

                dbconnection.Open();

                SqlCommand dbcommand = new SqlCommand();
                dbcommand.CommandType = CommandType.Text;

                dbcommand.CommandText = "select distinct institution,count(institution) as count from [User.Account].[User] where isnull(institution,'')<>'' and CanBeProxy = 1 group by institution order by institution";
                dbcommand.CommandTimeout = base.GetCommandTimeout();                
          
                dbcommand.Connection = dbconnection;
                dbreader = dbcommand.ExecuteReader(CommandBehavior.CloseConnection);

                while (dbreader.Read())
                    institutions.Add(new GenericListItem(dbreader["institution"].ToString() + " (" + dbreader["count"].ToString() + ")",dbreader["institution"].ToString()));

                //Always close your readers
                if (!dbreader.IsClosed)
                    dbreader.Close();
                

            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }

            return institutions;
        }

        public List<GenericListItem> GetDepartments()
        {

             
              SqlDataReader dbreader = null;
            SessionManagement sm = new SessionManagement();
            List<GenericListItem> departments = new List<GenericListItem>();



            try
            {

                string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;
                SqlConnection dbconnection = new SqlConnection(connstr);

                dbconnection.Open();

                SqlCommand dbcommand = new SqlCommand();
                dbcommand.CommandType = CommandType.Text;

                dbcommand.CommandText = "select distinct department from [User.Account].[User] where isnull(department,'')<>'' and CanBeProxy = 1 order by department";
                dbcommand.CommandTimeout = base.GetCommandTimeout();                
          
                dbcommand.Connection = dbconnection;
                dbreader = dbcommand.ExecuteReader(CommandBehavior.CloseConnection);

                while (dbreader.Read())
                    departments.Add(new GenericListItem(dbreader["department"].ToString(), dbreader["department"].ToString()));

                //Always close your readers
                if (!dbreader.IsClosed)
                    dbreader.Close();
                
                
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }


            return departments;
 


        }



    }



}
