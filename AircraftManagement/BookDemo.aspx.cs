using System;
using System.Data;
using System.Data.SqlClient;

namespace AircraftManagement
{
    public partial class BookDemo : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadAircrafts();
            }
        }

        private void LoadAircrafts()
        {
            string connectionString = "Data Source=(LocalDB)\\MSSQLLocalDB;AttachDbFilename=C:\\Users\\abcdq\\source\\repos\\AircraftManagement\\AircraftManagement\\App_Data\\AircraftDB.mdf;Integrated Security=True";

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT AircraftID, Model FROM Aircraft WHERE Status = 'Available'";
                SqlDataAdapter adapter = new SqlDataAdapter(query, conn);

                DataTable dt = new DataTable();
                adapter.Fill(dt);

                ddlAircraft.DataSource = dt;
                ddlAircraft.DataTextField = "Model";
                ddlAircraft.DataValueField = "AircraftID";
                ddlAircraft.DataBind();

                ddlAircraft.Items.Insert(0, new System.Web.UI.WebControls.ListItem("-- Select Aircraft --", "0"));
            }
        }

        protected void BtnBookDemo_Click(object sender, EventArgs e)
        {
            string fullName = txtFullName.Text.Trim();
            string email = txtEmail.Text.Trim();
            string phoneNumber = txtPhoneNumber.Text.Trim();
            int aircraftId = Convert.ToInt32(ddlAircraft.SelectedValue);

            if (string.IsNullOrEmpty(fullName) || string.IsNullOrEmpty(email) || string.IsNullOrEmpty(phoneNumber) || aircraftId == 0)
            {
                lblError.Text = "All fields are required.";
                return;
            }

            if (!DateTime.TryParse(txtStartDate.Text, out DateTime startDate) || !DateTime.TryParse(txtEndDate.Text, out DateTime endDate))
            {
                lblError.Text = "Please enter valid start and end dates.";
                return;
            }

            if (startDate >= endDate)
            {
                lblError.Text = "End date must be after start date.";
                return;
            }

            if (Session["UserID"] == null)
            {
                lblError.Text = "You must be logged in to book a demo.";
                return;
            }

            try
            {
                string connectionString = "Data Source=(LocalDB)\\MSSQLLocalDB;AttachDbFilename=C:\\Users\\abcdq\\source\\repos\\AircraftManagement\\AircraftManagement\\App_Data\\AircraftDB.mdf;Integrated Security=True";

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = "INSERT INTO Bookings (UserID, FullName, Email, PhoneNumber, AircraftID, BookingType, StartDate, EndDate, BookingStatus) " +
                                   "VALUES (@UserID, @FullName, @Email, @PhoneNumber, @AircraftID, 'Demo', @StartDate, @EndDate, 'Confirmed')";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);
                    cmd.Parameters.AddWithValue("@FullName", fullName);
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@PhoneNumber", phoneNumber);
                    cmd.Parameters.AddWithValue("@AircraftID", aircraftId);
                    cmd.Parameters.AddWithValue("@StartDate", startDate);
                    cmd.Parameters.AddWithValue("@EndDate", endDate);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                Response.Redirect("CustomerDashboard.aspx");
            }
            catch (Exception ex)
            {
                lblError.Text = "An error occurred: " + ex.Message;
            }
        }
    }
}
