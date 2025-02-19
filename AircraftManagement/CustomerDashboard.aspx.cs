using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.Util;

namespace AircraftManagement
{
    public partial class CustomerDashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Role"] == null || Session["Role"].ToString() != "Customer")
            {
                Response.Redirect("Login.aspx");
            }

            if (!IsPostBack)
            {
                LoadBookings();
                LoadTransactions();
                LoadWishlist();
            }
        }

        private void LoadBookings()
        {
            int userId = Convert.ToInt32(Session["UserID"]);
            string connectionString = "Data Source=(LocalDB)\\MSSQLLocalDB;AttachDbFilename=C:\\Users\\abcdq\\source\\repos\\AircraftManagement\\AircraftManagement\\App_Data\\AircraftDB.mdf;Integrated Security=True";

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT BookingType, StartDate, EndDate, TotalAmount, Status FROM Bookings WHERE UserID = @UserID";
                SqlDataAdapter adapter = new SqlDataAdapter(query, conn);
                adapter.SelectCommand.Parameters.AddWithValue("@UserID", userId);

                DataTable dt = new DataTable();
                adapter.Fill(dt);
                gvBookings.DataSource = dt;
                gvBookings.DataBind();
            }
        }

        private void LoadTransactions()
        {
            int userId = Convert.ToInt32(Session["UserID"]);
            string connectionString = "Data Source=(LocalDB)\\MSSQLLocalDB;AttachDbFilename=C:\\Users\\abcdq\\source\\repos\\AircraftManagement\\AircraftManagement\\App_Data\\AircraftDB.mdf;Integrated Security=True";

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT TransactionType, StartDate, EndDate, TotalAmount, Status FROM Transactions WHERE UserID = @UserID";
                SqlDataAdapter adapter = new SqlDataAdapter(query, conn);
                adapter.SelectCommand.Parameters.AddWithValue("@UserID", userId);

                DataTable dt = new DataTable();
                adapter.Fill(dt);
                gvTransactions.DataSource = dt;
                gvTransactions.DataBind();
            }
        }

        private void LoadWishlist()
        {
            int userId = Convert.ToInt32(Session["UserID"]);
            string connectionString = "Data Source=(LocalDB)\\MSSQLLocalDB;AttachDbFilename=C:\\Users\\abcdq\\source\\repos\\AircraftManagement\\AircraftManagement\\App_Data\\AircraftDB.mdf;Integrated Security=True";

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT a.Model, w.AddedAt FROM Wishlist w INNER JOIN Aircraft a ON w.AircraftID = a.AircraftID WHERE w.UserID = @UserID";
                SqlDataAdapter adapter = new SqlDataAdapter(query, conn);
                adapter.SelectCommand.Parameters.AddWithValue("@UserID", userId);

                DataTable dt = new DataTable();
                adapter.Fill(dt);
                gvWishlist.DataSource = dt;
                gvWishlist.DataBind();
            }
        }
    }
}