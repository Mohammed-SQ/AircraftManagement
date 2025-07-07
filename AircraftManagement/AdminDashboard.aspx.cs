using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;
using System.Web.UI;

namespace AircraftManagement
{
    public partial class AdminDashboard : System.Web.UI.Page
    {
        private string connectionString = ConfigurationManager.ConnectionStrings["AircraftDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsAdminAuthenticated())
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                ShowSection("users");
                InitializeAllSections();
            }
        }

        private bool IsAdminAuthenticated()
        {
            if (Session["UserID"] == null || Session["Role"] == null || Session["Role"].ToString() != "Admin")
            {
                System.Diagnostics.Debug.WriteLine("Unauthorized access attempt.");
                return false;
            }
            return true;
        }

        private void InitializeAllSections()
        {
            LoadUsers();
            LoadAircrafts();
            LoadPendingApplications();
            LoadBookings();
            LoadPayments();
            LoadPromotions();
            LoadComments();
        }

        private void ShowSection(string section)
        {
            usersSection.Attributes["class"] = "section-content" + (section == "users" ? " active" : "");
            aircraftSection.Attributes["class"] = "section-content" + (section == "aircraft" ? " active" : "");
            pendingAircraftSection.Attributes["class"] = "section-content" + (section == "pendingAircraft" ? " active" : "");
            bookingsSection.Attributes["class"] = "section-content" + (section == "bookings" ? " active" : "");
            paymentsSection.Attributes["class"] = "section-content" + (section == "payments" ? " active" : "");
            promotionsSection.Attributes["class"] = "section-content" + (section == "promotions" ? " active" : "");
            commentsSection.Attributes["class"] = "section-content" + (section == "comments" ? " active" : "");
        }

        #region Users
        private void LoadUsers()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"
                        SELECT UserID, Username, Email, Role, PhoneNumber, Address, CreatedAt
                        FROM Users";

                    string whereClause = "";
                    if (!string.IsNullOrEmpty(txtSearchUsers.Text))
                        whereClause += " WHERE (Username LIKE @Search OR Email LIKE @Search)";
                    if (!string.IsNullOrEmpty(ddlUserRoleFilter.SelectedValue))
                        whereClause += (whereClause == "" ? " WHERE " : " AND ") + "Role = @Role";
                    query += whereClause;

                    if (ViewState["Users_SortExpression"] != null)
                        query += " ORDER BY " + ViewState["Users_SortExpression"].ToString() + " " + ViewState["Users_SortDirection"].ToString();

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        if (!string.IsNullOrEmpty(txtSearchUsers.Text))
                            cmd.Parameters.AddWithValue("@Search", "%" + txtSearchUsers.Text.Trim() + "%");
                        if (!string.IsNullOrEmpty(ddlUserRoleFilter.SelectedValue))
                            cmd.Parameters.AddWithValue("@Role", ddlUserRoleFilter.SelectedValue);

                        using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            conn.Open();
                            adapter.Fill(dt);
                            conn.Close();

                            gvUsers.DataSource = dt;
                            gvUsers.DataBind();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error loading users: " + ex.Message);
            }
        }

        protected void gvUsers_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            try
            {
                int index = Convert.ToInt32(e.CommandArgument);
                if (index >= 0 && index < gvUsers.Rows.Count)
                {
                    string userId = gvUsers.DataKeys[index].Value.ToString();
                    if (e.CommandName == "EditUser")
                        Response.Redirect("EditUser.aspx?UserID=" + userId);
                    else if (e.CommandName == "DeleteUser")
                    {
                        DeleteUser(userId);
                        LoadUsers();
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error in gvUsers_RowCommand: " + ex.Message);
            }
        }

        private void DeleteUser(string userId)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "DELETE FROM Users WHERE UserID = @UserID";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                    conn.Close();
                }
            }
        }

        protected void gvUsers_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvUsers.PageIndex = e.NewPageIndex;
            LoadUsers();
        }

        protected void gvUsers_Sorting(object sender, GridViewSortEventArgs e)
        {
            string sortDirection = "ASC";
            if (ViewState["Users_SortDirection"] != null && ViewState["Users_SortDirection"].ToString() == "ASC")
                sortDirection = "DESC";
            ViewState["Users_SortExpression"] = e.SortExpression;
            ViewState["Users_SortDirection"] = sortDirection;
            LoadUsers();
        }

        protected void btnSearchUsers_Click(object sender, EventArgs e)
        {
            LoadUsers();
        }

        protected void btnClearUsersFilter_Click(object sender, EventArgs e)
        {
            txtSearchUsers.Text = "";
            ddlUserRoleFilter.SelectedValue = "";
            LoadUsers();
        }
        #endregion

        #region Aircraft
        private void LoadAircrafts()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = "SELECT AircraftID, AircraftModel, Capacity, RentalPrice, PurchasePrice, Status, " +
                                  "ImageURL, YearManufactured, CreatedAt, Status, SellerID, " +
                                  "EngineHours, FuelType, TransactionType FROM Aircraft";

                    string whereClause = "";
                    if (!string.IsNullOrEmpty(txtSearchAircraft.Text))
                        whereClause += " WHERE (AircraftModel LIKE @Search OR AircraftID LIKE @Search)";
                    if (!string.IsNullOrEmpty(ddlAircraftStatusFilter.SelectedValue))
                        whereClause += (whereClause == "" ? " WHERE " : " AND ") + "Status = @Status";
                    query += whereClause;

                    if (ViewState["Aircrafts_SortExpression"] != null)
                        query += " ORDER BY " + ViewState["Aircrafts_SortExpression"].ToString() + " " + ViewState["Aircrafts_SortDirection"].ToString();

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        if (!string.IsNullOrEmpty(txtSearchAircraft.Text))
                            cmd.Parameters.AddWithValue("@Search", "%" + txtSearchAircraft.Text.Trim() + "%");
                        if (!string.IsNullOrEmpty(ddlAircraftStatusFilter.SelectedValue))
                            cmd.Parameters.AddWithValue("@Status", ddlAircraftStatusFilter.SelectedValue);

                        using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            conn.Open();
                            adapter.Fill(dt);
                            conn.Close();

                            System.Diagnostics.Debug.WriteLine("Aircraft records retrieved: " + dt.Rows.Count.ToString());

                            gvAircrafts.DataSource = dt;
                            gvAircrafts.DataBind();

                            if (lblNoAircraft != null)
                            {
                                lblNoAircraft.Visible = dt.Rows.Count == 0;
                                if (dt.Rows.Count == 0)
                                    lblNoAircraft.Text = "No aircraft found in the database.";
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error loading aircrafts: " + ex.Message);
                Label lblError = aircraftSection.FindControl("lblAircraftError") as Label;
                if (lblError != null)
                {
                    lblError.Text = "Error loading aircraft data: " + ex.Message;
                    lblError.CssClass = "alert alert-danger d-block text-center mt-3";
                    lblError.Visible = true;
                }
            }
        }

        protected void gvAircrafts_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            try
            {
                int index = Convert.ToInt32(e.CommandArgument);
                if (index >= 0 && index < gvAircrafts.Rows.Count)
                {
                    int aircraftId = Convert.ToInt32(gvAircrafts.DataKeys[index].Value);
                    if (e.CommandName == "EditAircraft")
                        Response.Redirect("EditAircraft.aspx?AircraftID=" + aircraftId.ToString());
                    else if (e.CommandName == "DeleteAircraft")
                    {
                        DeleteAircraft(aircraftId);
                        LoadAircrafts();
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error in gvAircrafts_RowCommand: " + ex.Message);
            }
        }

        private void DeleteAircraft(int aircraftId)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "DELETE FROM Aircraft WHERE AircraftID = @AircraftID";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@AircraftID", aircraftId);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                    conn.Close();
                }
            }
        }

        protected void gvAircrafts_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvAircrafts.PageIndex = e.NewPageIndex;
            LoadAircrafts();
        }

        protected void gvAircrafts_Sorting(object sender, GridViewSortEventArgs e)
        {
            string sortDirection = "ASC";
            if (ViewState["Aircrafts_SortDirection"] != null && ViewState["Aircrafts_SortDirection"].ToString() == "ASC")
                sortDirection = "DESC";
            ViewState["Aircrafts_SortExpression"] = e.SortExpression;
            ViewState["Aircrafts_SortDirection"] = sortDirection;
            LoadAircrafts();
        }

        protected void btnFilterAircrafts_Click(object sender, EventArgs e)
        {
            LoadAircrafts();
        }

        protected void btnClearAircraftFilter_Click(object sender, EventArgs e)
        {
            txtSearchAircraft.Text = "";
            ddlAircraftStatusFilter.SelectedValue = "";
            LoadAircrafts();
        }

        protected void btnAddAircraft_Click(object sender, EventArgs e)
        {
            Response.Redirect("AddAircraft.aspx");
        }
        #endregion

        #region Pending Aircraft
        private void LoadPendingApplications()
        {
            LoadIndividualApplications();
            LoadCompanyApplications();
        }

        private void LoadIndividualApplications()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    string query = @"
                        SELECT 
                            sa.APPLICATIONID AS SellerApplicationID, 
                            sa.USERID, 
                            u.Username AS ApplicantName,
                            sa.SELLERTYPE AS SellerType,
                            sa.LICENSEPATH AS LicenseFilePath, 
                            sa.CONTACTMETHOD AS ContactMethod, 
                            sa.CONTACTINFO AS ContactInfo, 
                            sa.PAYMENTMETHOD AS PaymentMethod, 
                            sa.SELLINGEXPERIENCE AS SellingExperienceYears, 
                            sa.AIRCRAFTEXPERIENCE AS AircraftExperience, 
                            sa.STATUS AS Status
                        FROM SellerApplications sa
                        JOIN Users u ON sa.USERID = u.UserID
                        WHERE sa.SELLERTYPE = 'Individual'";

                    if (!string.IsNullOrEmpty(ddlPendingFilter.SelectedValue))
                        query += " AND sa.STATUS = @Status";

                    if (ViewState["PendingApplications_SortExpression"] != null)
                        query += " ORDER BY " + ViewState["PendingApplications_SortExpression"].ToString() + " " + ViewState["PendingApplications_SortDirection"].ToString();

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        if (!string.IsNullOrEmpty(ddlPendingFilter.SelectedValue))
                            cmd.Parameters.AddWithValue("@Status", ddlPendingFilter.SelectedValue);

                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            DataTable dt = new DataTable();
                            dt.Load(reader);
                            gvIndividualApplications.DataSource = dt;
                            gvIndividualApplications.DataBind();
                            lblNoIndividualApplications.Visible = dt.Rows.Count == 0;
                        }
                    }
                    conn.Close();
                }
            }
            catch (Exception ex)
            {
                lblFeedbackMessage.Text = "Error loading individual applications: " + ex.Message;
                lblFeedbackMessage.CssClass = "alert alert-danger";
                lblFeedbackMessage.Visible = true;
            }
        }

        private void LoadCompanyApplications()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    string query = @"
                        SELECT 
                            sa.APPLICATIONID AS SellerApplicationID, 
                            sa.USERID, 
                            u.Username AS ApplicantName,
                            sa.SELLERTYPE AS SellerType,
                            sa.COMPANYNAME AS CompanyName,
                            sa.SELLINGONBEHALF AS SellingOnBehalf,
                            sa.ISOWNER AS IsOwner,
                            sa.COMPANYAGE AS CompanyAge,
                            sa.AIRCRAFTOWNERSHIP AS AircraftOwnership,
                            sa.STATUS AS Status
                        FROM SellerApplications sa
                        JOIN Users u ON sa.USERID = u.UserID
                        WHERE sa.SELLERTYPE = 'Company'";

                    if (!string.IsNullOrEmpty(ddlPendingFilter.SelectedValue))
                        query += " AND sa.STATUS = @Status";

                    if (ViewState["PendingApplications_SortExpression"] != null)
                        query += " ORDER BY " + ViewState["PendingApplications_SortExpression"].ToString() + " " + ViewState["PendingApplications_SortDirection"].ToString();

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        if (!string.IsNullOrEmpty(ddlPendingFilter.SelectedValue))
                            cmd.Parameters.AddWithValue("@Status", ddlPendingFilter.SelectedValue);

                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            DataTable dt = new DataTable();
                            dt.Load(reader);
                            gvCompanyApplications.DataSource = dt;
                            gvCompanyApplications.DataBind();
                            lblNoCompanyApplications.Visible = dt.Rows.Count == 0;
                        }
                    }
                    conn.Close();
                }
            }
            catch (Exception ex)
            {
                lblFeedbackMessage.Text = "Error loading company applications: " + ex.Message;
                lblFeedbackMessage.CssClass = "alert alert-danger";
                lblFeedbackMessage.Visible = true;
            }
        }

        protected void gvIndividualApplications_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                // Add any specific row-bound logic if needed
            }
        }

        protected void gvCompanyApplications_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                // Add any specific row-bound logic if needed
            }
        }

        [System.Web.Services.WebMethod]
        public static string GetAircraftDetails(int sellerApplicationId)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["AircraftDB"].ConnectionString;
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    string query = @"
                        SELECT 
                            sa.APPLICATIONID AS AircraftID, 
                            COALESCE(sa.AircraftModel, 'Not Specified') AS AircraftModel, 
                            COALESCE(CAST(sa.YearManufactured AS NVARCHAR), 'Not Specified') AS YearManufactured, 
                            COALESCE(CAST(sa.EngineHours AS NVARCHAR), 'Not Specified') AS EngineHours,
                            sa.SELLERTYPE AS SellerType,
                            u.Username AS Username,
                            sa.COMPANYNAME AS CompanyName,
                            COALESCE(CAST(sa.COMPANYAGE AS NVARCHAR), 'Not Specified') AS CompanyAge,
                            COALESCE(sa.SELLINGONBEHALF, 'Not Specified') AS SellingOnBehalf,
                            COALESCE(CAST(sa.ISOWNER AS NVARCHAR), 'Not Specified') AS IsOwner,
                            COALESCE(sa.AIRCRAFTOWNERSHIP, 'Not Specified') AS AircraftOwnership,
                            COALESCE(CAST(sa.AIRCRAFTOWNERSHIPCOUNT AS NVARCHAR), 'Not Specified') AS AircraftOwnershipCount,
                            COALESCE(sa.FuelType, 'Not Specified') AS FuelType,
                            COALESCE(CAST(sa.Capacity AS NVARCHAR), 'Not Specified') AS NumberOfSeats,
                            COALESCE(sa.AircraftCondition, 'Not Specified') AS AircraftCondition,
                            COALESCE(sa.ImageURL, '') AS Photos, 
                            COALESCE(sa.DESCRIPTION, 'Not Specified') AS Description, 
                            COALESCE(CAST(CASE 
                                WHEN sa.TransactionType = 'Buy' THEN sa.PurchasePrice 
                                WHEN sa.TransactionType = 'Rent' THEN sa.RentalPrice 
                                ELSE NULL 
                            END AS NVARCHAR), 'Not Specified') AS AskingPrice,
                            sa.CONTACTMETHOD AS ContactMethod,
                            sa.CONTACTINFO AS ContactInfo,
                            sa.PAYMENTMETHOD AS PaymentMethod,
                            sa.SELLINGEXPERIENCE AS SellingExperience,
                            sa.AIRCRAFTEXPERIENCE AS AircraftExperience
                        FROM SellerApplications sa
                        JOIN Users u ON sa.USERID = u.UserID
                        WHERE sa.APPLICATIONID = @SellerApplicationID";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@SellerApplicationID", sellerApplicationId);
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                string photos = reader["Photos"] != DBNull.Value ? reader["Photos"].ToString() : string.Empty;
                                string[] photoArray = string.IsNullOrEmpty(photos) ? new string[0] : photos.Split(new char[] { ';' }, StringSplitOptions.RemoveEmptyEntries);

                                System.Web.Script.Serialization.JavaScriptSerializer serializer = new System.Web.Script.Serialization.JavaScriptSerializer();
                                return serializer.Serialize(new
                                {
                                    success = true,
                                    aircraftId = reader["AircraftID"].ToString(),
                                    model = reader["AircraftModel"].ToString(),
                                    year = reader["YearManufactured"].ToString(),
                                    engineHours = reader["EngineHours"].ToString(),
                                    sellerType = reader["SellerType"].ToString(),
                                    username = reader["Username"].ToString(),
                                    companyName = reader["CompanyName"].ToString(),
                                    companyAge = reader["CompanyAge"].ToString(),
                                    sellingOnBehalf = reader["SellingOnBehalf"].ToString(),
                                    isOwner = reader["IsOwner"].ToString(),
                                    aircraftOwnership = reader["AircraftOwnership"].ToString(),
                                    aircraftOwnershipCount = reader["AircraftOwnershipCount"].ToString(),
                                    fuelType = reader["FuelType"].ToString(),
                                    numberOfSeats = reader["NumberOfSeats"].ToString(),
                                    aircraftCondition = reader["AircraftCondition"].ToString(),
                                    description = reader["Description"].ToString(),
                                    askingPrice = reader["AskingPrice"].ToString(),
                                    photos = photoArray,
                                    contactMethod = reader["ContactMethod"].ToString(),
                                    contactInfo = reader["ContactInfo"].ToString(),
                                    paymentMethod = reader["PaymentMethod"].ToString(),
                                    sellingExperience = reader["SellingExperience"].ToString(),
                                    aircraftExperience = reader["AircraftExperience"].ToString()
                                });
                            }
                            else
                            {
                                System.Web.Script.Serialization.JavaScriptSerializer serializer = new System.Web.Script.Serialization.JavaScriptSerializer();
                                return serializer.Serialize(new { success = false, message = "No application found with ID " + sellerApplicationId + "." });
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Web.Script.Serialization.JavaScriptSerializer serializer = new System.Web.Script.Serialization.JavaScriptSerializer();
                return serializer.Serialize(new { success = false, message = "Error loading aircraft details: " + ex.Message });
            }
        }

        private void UpdateApplicationStatus(string status, int sellerApplicationId, string comments)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    // Step 1: Update SellerApplications status and comments
                    string updateQuery = @"
                        UPDATE SellerApplications 
                        SET Status = @Status, REVIEWEDAT = GETDATE(), AdminComments = @AdminComments
                        WHERE APPLICATIONID = @SellerApplicationID";
                    using (SqlCommand cmd = new SqlCommand(updateQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@Status", status);
                        cmd.Parameters.AddWithValue("@AdminComments", comments);
                        cmd.Parameters.AddWithValue("@SellerApplicationID", sellerApplicationId);
                        cmd.ExecuteNonQuery();
                    }

                    // Step 2: Fetch application details for Aircraft insertion and SellerType
                    string userQuery = @"
                        SELECT 
                            USERID, 
                            SELLERTYPE,
                            CONTACTINFO, 
                            AircraftModel, 
                            YearManufactured, 
                            EngineHours, 
                            FuelType, 
                            Capacity, 
                            AircraftCondition, 
                            ImageURL, 
                            DESCRIPTION, 
                            CASE 
                                WHEN TransactionType = 'Buy' THEN PurchasePrice 
                                WHEN TransactionType = 'Rent' THEN RentalPrice 
                                ELSE NULL 
                            END AS AskingPrice 
                        FROM SellerApplications 
                        WHERE APPLICATIONID = @SellerApplicationID";
                    string userId = string.Empty;
                    string sellerType = string.Empty;
                    string contactInfo = string.Empty;
                    string aircraftModel = string.Empty;
                    int yearManufactured = 0;
                    int engineHours = 0;
                    string fuelType = string.Empty;
                    int capacity = 0;
                    string aircraftCondition = string.Empty;
                    string photos = string.Empty;
                    string description = string.Empty;
                    decimal purchasePrice = 0;

                    using (SqlCommand cmd = new SqlCommand(userQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@SellerApplicationID", sellerApplicationId);
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                userId = reader["USERID"].ToString();
                                sellerType = reader["SELLERTYPE"].ToString();
                                contactInfo = reader["CONTACTINFO"].ToString();
                                aircraftModel = reader["AircraftModel"] != DBNull.Value ? reader["AircraftModel"].ToString() : string.Empty;
                                yearManufactured = reader["YearManufactured"] != DBNull.Value ? Convert.ToInt32(reader["YearManufactured"]) : 0;
                                engineHours = reader["EngineHours"] != DBNull.Value ? Convert.ToInt32(reader["EngineHours"]) : 0;
                                fuelType = reader["FuelType"] != DBNull.Value ? reader["FuelType"].ToString() : string.Empty;
                                capacity = reader["Capacity"] != DBNull.Value ? Convert.ToInt32(reader["Capacity"]) : 0;
                                aircraftCondition = reader["AircraftCondition"] != DBNull.Value ? reader["AircraftCondition"].ToString() : string.Empty;
                                photos = reader["ImageURL"] != DBNull.Value ? reader["ImageURL"].ToString() : string.Empty;
                                description = reader["DESCRIPTION"] != DBNull.Value ? reader["DESCRIPTION"].ToString() : string.Empty;
                                purchasePrice = reader["AskingPrice"] != DBNull.Value ? Convert.ToDecimal(reader["AskingPrice"]) : 0;
                            }
                        }
                    }

                    // Step 3: Insert into Aircraft table if approved
                    if (status == "Approved")
                    {
                        string insertAircraftQuery = @"
                            INSERT INTO Aircraft (
                                AircraftModel, 
                                YearManufactured, 
                                EngineHours, 
                                FuelType, 
                                Capacity, 
                                AircraftCondition, 
                                ImageURL, 
                                Description, 
                                PurchasePrice, 
                                SellerID, 
                                SellerType, 
                                Status, 
                                CreatedAt
                            )
                            VALUES (
                                @AircraftModel, 
                                @YearManufactured, 
                                @EngineHours, 
                                @FuelType, 
                                @Capacity, 
                                @AircraftCondition, 
                                @ImageURL, 
                                @Description, 
                                @PurchasePrice, 
                                @SellerID, 
                                @SellerType, 
                                'Available', 
                                GETDATE()
                            )";
                        using (SqlCommand cmd = new SqlCommand(insertAircraftQuery, conn))
                        {
                            cmd.Parameters.AddWithValue("@AircraftModel", aircraftModel);
                            cmd.Parameters.AddWithValue("@YearManufactured", yearManufactured);
                            cmd.Parameters.AddWithValue("@EngineHours", engineHours);
                            cmd.Parameters.AddWithValue("@FuelType", fuelType);
                            cmd.Parameters.AddWithValue("@Capacity", capacity);
                            cmd.Parameters.AddWithValue("@AircraftCondition", aircraftCondition);
                            cmd.Parameters.AddWithValue("@ImageURL", photos);
                            cmd.Parameters.AddWithValue("@Description", description);
                            cmd.Parameters.AddWithValue("@PurchasePrice", purchasePrice);
                            cmd.Parameters.AddWithValue("@SellerID", userId);
                            cmd.Parameters.AddWithValue("@SellerType", sellerType);
                            cmd.ExecuteNonQuery();
                        }

                        string roleQuery = "UPDATE Users SET SellerRole = 'ON' WHERE UserID = @UserID";
                        using (SqlCommand cmd = new SqlCommand(roleQuery, conn))
                        {
                            cmd.Parameters.AddWithValue("@UserID", userId);
                            cmd.ExecuteNonQuery();
                        }
                    }

                    // Step 4: Send notification to the user
                    string notificationQuery = @"
                        INSERT INTO Notifications (UserID, Title, Message, CreatedAt, IsRead)
                        VALUES (@UserID, @Title, @Message, GETDATE(), 0)";
                    using (SqlCommand cmd = new SqlCommand(notificationQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userId);
                        cmd.Parameters.AddWithValue("@Title", "Seller Application " + status);
                        cmd.Parameters.AddWithValue("@Message", "Your seller application has been " + status.ToLower() + " by the admin. Comments: " + comments);
                        cmd.ExecuteNonQuery();
                    }

                    lblFeedbackMessage.Text = "Application " + status + " successfully!";
                    lblFeedbackMessage.CssClass = "alert alert-success";
                    lblFeedbackMessage.Visible = true;

                    LoadPendingApplications();
                }
            }
            catch (Exception ex)
            {
                lblFeedbackMessage.Text = "Error updating application status: " + ex.Message;
                lblFeedbackMessage.CssClass = "alert alert-danger";
                lblFeedbackMessage.Visible = true;
            }
        }

        protected void btnApprove_Click(object sender, EventArgs e)
        {
            int sellerApplicationId = Convert.ToInt32(hdnApplicationId.Value);
            UpdateApplicationStatus("Approved", sellerApplicationId, txtComments.Text);
        }

        protected void btnReject_Click(object sender, EventArgs e)
        {
            int sellerApplicationId = Convert.ToInt32(hdnApplicationId.Value);
            UpdateApplicationStatus("Rejected", sellerApplicationId, txtComments.Text);
        }

        protected void ddlPendingFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadPendingApplications();
        }

        protected void btnClearPendingFilter_Click(object sender, EventArgs e)
        {
            ddlPendingFilter.SelectedValue = "";
            LoadPendingApplications();
        }
        #endregion

        #region Bookings
        private void LoadBookings()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"
                        SELECT BookingID, UserID, AircraftID, StartDate, EndDate, TotalAmount AS TotalCost, BookingStatus AS Status
                        FROM Bookings";

                    string whereClause = "";
                    if (!string.IsNullOrEmpty(txtBookingDateFilter.Text))
                        whereClause += " WHERE CAST(StartDate AS DATE) = @BookingDate";
                    if (!string.IsNullOrEmpty(ddlBookingStatusFilter.SelectedValue))
                        whereClause += (whereClause == "" ? " WHERE " : " AND ") + "BookingStatus = @Status";
                    query += whereClause;

                    if (ViewState["Bookings_SortExpression"] != null)
                        query += " ORDER BY " + ViewState["Bookings_SortExpression"].ToString() + " " + ViewState["Bookings_SortDirection"].ToString();

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        if (!string.IsNullOrEmpty(txtBookingDateFilter.Text))
                            cmd.Parameters.AddWithValue("@BookingDate", txtBookingDateFilter.Text);
                        if (!string.IsNullOrEmpty(ddlBookingStatusFilter.SelectedValue))
                            cmd.Parameters.AddWithValue("@Status", ddlBookingStatusFilter.SelectedValue);

                        using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            conn.Open();
                            adapter.Fill(dt);
                            conn.Close();

                            gvBookings.DataSource = dt;
                            gvBookings.DataBind();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error loading bookings: " + ex.Message);
            }
        }

        protected void gvBookings_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            try
            {
                int index = Convert.ToInt32(e.CommandArgument);
                if (index >= 0 && index < gvBookings.Rows.Count)
                {
                    int bookingId = Convert.ToInt32(gvBookings.DataKeys[index].Value);
                    if (e.CommandName == "CancelBooking")
                    {
                        UpdateBookingStatus(bookingId, "Cancelled");
                        LoadBookings();
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error in gvBookings_RowCommand: " + ex.Message);
            }
        }

        private void UpdateBookingStatus(int bookingId, string status)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "UPDATE Bookings SET BookingStatus = @Status WHERE BookingID = @BookingID";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Status", status);
                    cmd.Parameters.AddWithValue("@BookingID", bookingId);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                    conn.Close();
                }
            }
        }

        protected void gvBookings_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvBookings.PageIndex = e.NewPageIndex;
            LoadBookings();
        }

        protected void gvBookings_Sorting(object sender, GridViewSortEventArgs e)
        {
            string sortDirection = "ASC";
            if (ViewState["Bookings_SortDirection"] != null && ViewState["Bookings_SortDirection"].ToString() == "ASC")
                sortDirection = "DESC";
            ViewState["Bookings_SortExpression"] = e.SortExpression;
            ViewState["Bookings_SortDirection"] = sortDirection;
            LoadBookings();
        }

        protected void btnFilterBookings_Click(object sender, EventArgs e)
        {
            LoadBookings();
        }

        protected void btnClearBookingsFilter_Click(object sender, EventArgs e)
        {
            txtBookingDateFilter.Text = "";
            ddlBookingStatusFilter.SelectedValue = "";
            LoadBookings();
        }
        #endregion

        #region Payments
        private void LoadPayments()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = "SELECT PaymentID, TransactionID, PaymentMethod, Amount, PaymentDate, PaymentStatus " +
                                  "FROM Payments";

                    string whereClause = "";
                    if (!string.IsNullOrEmpty(txtPaymentDateFilter.Text))
                        whereClause += " WHERE CONVERT(date, PaymentDate) = @PaymentDate";
                    if (!string.IsNullOrEmpty(ddlPaymentStatusFilter.SelectedValue))
                        whereClause += (whereClause == "" ? " WHERE " : " AND ") + "PaymentStatus = @Status";
                    query += whereClause;

                    if (ViewState["Payments_SortExpression"] != null)
                        query += " ORDER BY " + ViewState["Payments_SortExpression"].ToString() + " " + ViewState["Payments_SortDirection"].ToString();

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        if (!string.IsNullOrEmpty(txtPaymentDateFilter.Text))
                            cmd.Parameters.AddWithValue("@PaymentDate", txtPaymentDateFilter.Text);
                        if (!string.IsNullOrEmpty(ddlPaymentStatusFilter.SelectedValue))
                            cmd.Parameters.AddWithValue("@Status", ddlPaymentStatusFilter.SelectedValue);

                        using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            conn.Open();
                            adapter.Fill(dt);
                            conn.Close();

                            System.Diagnostics.Debug.WriteLine("Payment records retrieved: " + dt.Rows.Count.ToString());

                            gvPayments.DataSource = dt;
                            gvPayments.DataBind();

                            if (lblNoPayments != null)
                            {
                                lblNoPayments.Visible = dt.Rows.Count == 0;
                                if (dt.Rows.Count == 0)
                                    lblNoPayments.Text = "No payments found in the database.";
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error loading payments: " + ex.Message);
                Label lblError = paymentsSection.FindControl("lblPaymentsError") as Label;
                if (lblError != null)
                {
                    lblError.Text = "Error loading payments data: " + ex.Message;
                    lblError.CssClass = "alert alert-danger d-block text-center mt-3";
                    lblError.Visible = true;
                }
            }
        }

        protected void btnFilterPayments_Click(object sender, EventArgs e)
        {
            LoadPayments();
        }

        protected void btnClearPaymentsFilter_Click(object sender, EventArgs e)
        {
            txtPaymentDateFilter.Text = "";
            ddlPaymentStatusFilter.SelectedValue = "";
            LoadPayments();
        }

        protected void gvPayments_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvPayments.PageIndex = e.NewPageIndex;
            LoadPayments();
        }

        protected void gvPayments_Sorting(object sender, GridViewSortEventArgs e)
        {
            string sortDirection = "ASC";
            if (ViewState["Payments_SortDirection"] != null && ViewState["Payments_SortDirection"].ToString() == "ASC")
                sortDirection = "DESC";
            ViewState["Payments_SortExpression"] = e.SortExpression;
            ViewState["Payments_SortDirection"] = sortDirection;
            LoadPayments();
        }

        protected void gvPayments_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            try
            {
                int index = Convert.ToInt32(e.CommandArgument);
                if (index >= 0 && index < gvPayments.Rows.Count)
                {
                    int paymentId = Convert.ToInt32(gvPayments.DataKeys[index].Value);
                    if (e.CommandName == "RefundPayment")
                    {
                        RefundPayment(paymentId);
                        LoadPayments();
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error in gvPayments_RowCommand: " + ex.Message);
            }
        }

        private void RefundPayment(int paymentId)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "UPDATE Payments SET PaymentStatus = 'Refunded' WHERE PaymentID = @PaymentID";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@PaymentID", paymentId);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                    conn.Close();
                }
            }
        }
        #endregion

        #region Promotions
        private void LoadPromotions()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"
SELECT PromotionID, Title, Discount, ExpiryDate,
CASE
WHEN ExpiryDate < GETDATE() THEN 'Expired'
WHEN IsActive = 1 THEN 'Active'
ELSE 'Inactive'
END AS IsActive
FROM Promotions";

                    if (!string.IsNullOrEmpty(ddlPromotionStatusFilter.SelectedValue))
                        query += " WHERE (CASE WHEN ExpiryDate < GETDATE() THEN 2 WHEN IsActive = 1 THEN 1 ELSE 0 END) = @Status";

                    if (ViewState["Promotions_SortExpression"] != null)
                        query += " ORDER BY " + ViewState["Promotions_SortExpression"].ToString() + " " + ViewState["Promotions_SortDirection"].ToString();

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        if (!string.IsNullOrEmpty(ddlPromotionStatusFilter.SelectedValue))
                            cmd.Parameters.AddWithValue("@Status", ddlPromotionStatusFilter.SelectedValue);

                        using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            conn.Open();
                            adapter.Fill(dt);
                            conn.Close();

                            gvPromotions.DataSource = dt;
                            gvPromotions.DataBind();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error loading promotions: " + ex.Message);
            }
        }

        protected void gvPromotions_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            try
            {
                int index = Convert.ToInt32(e.CommandArgument);
                if (index >= 0 && index < gvPromotions.Rows.Count)
                {
                    int promotionId = Convert.ToInt32(gvPromotions.DataKeys[index].Value);
                    if (e.CommandName == "EditPromotion")
                        Response.Redirect("EditPromotion.aspx?PromotionID=" + promotionId.ToString());
                    else if (e.CommandName == "DeletePromotion")
                    {
                        DeletePromotion(promotionId);
                        LoadPromotions();
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error in gvPromotions_RowCommand: " + ex.Message);
            }
        }

        private void DeletePromotion(int promotionId)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "DELETE FROM Promotions WHERE PromotionID = @PromotionID";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@PromotionID", promotionId);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                    conn.Close();
                }
            }
        }

        protected void gvPromotions_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvPromotions.PageIndex = e.NewPageIndex;
            LoadPromotions();
        }

        protected void gvPromotions_Sorting(object sender, GridViewSortEventArgs e)
        {
            string sortDirection = "ASC";
            if (ViewState["Promotions_SortDirection"] != null && ViewState["Promotions_SortDirection"].ToString() == "ASC")
                sortDirection = "DESC";
            ViewState["Promotions_SortExpression"] = e.SortExpression;
            ViewState["Promotions_SortDirection"] = sortDirection;
            LoadPromotions();
        }

        protected void btnFilterPromotions_Click(object sender, EventArgs e)
        {
            LoadPromotions();
        }

        protected void btnClearPromotionsFilter_Click(object sender, EventArgs e)
        {
            ddlPromotionStatusFilter.SelectedValue = "";
            LoadPromotions();
        }

        protected void btnAddPromotion_Click(object sender, EventArgs e)
        {
            Response.Redirect("AddPromotion.aspx");
        }
        #endregion

        #region Comments
        private void LoadComments()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"
SELECT CommentID, AdminID, CommentText, CreatedDate, Status
FROM AdminComments";

                    if (!string.IsNullOrEmpty(ddlCommentStatusFilter.SelectedValue))
                        query += " WHERE Status = @Status";

                    if (ViewState["Comments_SortExpression"] != null)
                        query += " ORDER BY " + ViewState["Comments_SortExpression"].ToString() + " " + ViewState["Comments_SortDirection"].ToString();

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        if (!string.IsNullOrEmpty(ddlCommentStatusFilter.SelectedValue))
                            cmd.Parameters.AddWithValue("@Status", ddlCommentStatusFilter.SelectedValue);

                        using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            conn.Open();
                            adapter.Fill(dt);
                            conn.Close();

                            gvComments.DataSource = dt;
                            gvComments.DataBind();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error loading comments: " + ex.Message);
            }
        }

        protected void gvComments_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            try
            {
                int index = Convert.ToInt32(e.CommandArgument);
                if (index >= 0 && index < gvComments.Rows.Count)
                {
                    int commentId = Convert.ToInt32(gvComments.DataKeys[index].Value);
                    if (e.CommandName == "MarkCorrect")
                        UpdateCommentStatus(commentId, "Correct");
                    else if (e.CommandName == "MarkUncorrect")
                        UpdateCommentStatus(commentId, "Uncorrect");
                    LoadComments();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error in gvComments_RowCommand: " + ex.Message);
            }
        }

        protected void gvComments_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                LinkButton lnkMarkCorrect = (LinkButton)e.Row.FindControl("lnkMarkCorrect");
                LinkButton lnkMarkUncorrect = (LinkButton)e.Row.FindControl("lnkMarkUncorrect");
                string status = DataBinder.Eval(e.Row.DataItem, "Status").ToString();

                if (status == "Correct")
                {
                    lnkMarkCorrect.Visible = false;
                    lnkMarkUncorrect.Visible = true;
                }
                else if (status == "Uncorrect")
                {
                    lnkMarkCorrect.Visible = true;
                    lnkMarkUncorrect.Visible = false;
                }
                else
                {
                    lnkMarkCorrect.Visible = true;
                    lnkMarkUncorrect.Visible = true;
                }
            }
        }

        private void UpdateCommentStatus(int commentId, string status)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "UPDATE AdminComments SET Status = @Status WHERE CommentID = @CommentID";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Status", status);
                    cmd.Parameters.AddWithValue("@CommentID", commentId);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                    conn.Close();
                }
            }
        }

        protected void gvComments_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvComments.PageIndex = e.NewPageIndex;
            LoadComments();
        }

        protected void gvComments_Sorting(object sender, GridViewSortEventArgs e)
        {
            string sortDirection = "ASC";
            if (ViewState["Comments_SortDirection"] != null && ViewState["Comments_SortDirection"].ToString() == "ASC")
                sortDirection = "DESC";
            ViewState["Comments_SortExpression"] = e.SortExpression;
            ViewState["Comments_SortDirection"] = sortDirection;
            LoadComments();
        }

        protected void btnFilterComments_Click(object sender, EventArgs e)
        {
            LoadComments();
        }

        protected void btnClearCommentsFilter_Click(object sender, EventArgs e)
        {
            ddlCommentStatusFilter.SelectedValue = "";
            LoadComments();
        }

        protected void btnAddComment_Click(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(txtNewComment.Text))
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"
INSERT INTO AdminComments (AdminID, CommentText, CreatedDate, Status)
VALUES (@AdminID, @CommentText, GETDATE(), 'Pending')";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@AdminID", Session["UserID"].ToString());
                        cmd.Parameters.AddWithValue("@CommentText", txtNewComment.Text.Trim());
                        conn.Open();
                        cmd.ExecuteNonQuery();
                        conn.Close();
                    }
                }
                txtNewComment.Text = "";
                LoadComments();
            }
        }
        #endregion

        #region Navigation
        protected void lnkUsers_Click(object sender, EventArgs e)
        {
            ShowSection("users");
        }

        protected void lnkAircrafts_Click(object sender, EventArgs e)
        {
            ShowSection("aircraft");
        }

        protected void lnkPendingAircraft_Click(object sender, EventArgs e)
        {
            ShowSection("pendingAircraft");
        }

        protected void lnkBookings_Click(object sender, EventArgs e)
        {
            ShowSection("bookings");
        }

        protected void lnkPayments_Click(object sender, EventArgs e)
        {
            ShowSection("payments");
        }

        protected void lnkPromotions_Click(object sender, EventArgs e)
        {
            ShowSection("promotions");
        }

        protected void lnkComments_Click(object sender, EventArgs e)
        {
            ShowSection("comments");
        }
        #endregion
    }
}