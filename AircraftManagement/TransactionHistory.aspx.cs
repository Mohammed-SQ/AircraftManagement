using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration; // Required to read from Web.config

namespace AircraftManagement
{
    public partial class TransactionHistory : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("Login.aspx");
            }

            if (!IsPostBack)
            {
                LoadTransactions();
            }
        }

        private void LoadTransactions()
        {
            int userId = Convert.ToInt32(Session["UserID"]);
            string connectionString = ConfigurationManager.ConnectionStrings["AircraftDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT t.TransactionID, a.Model AS AircraftModel, t.TransactionType, t.TotalAmount, t.TransactionDate, t.Status " +
                               "FROM Transactions t INNER JOIN Aircraft a ON t.AircraftID = a.AircraftID WHERE t.UserID = @UserID";
                SqlDataAdapter adapter = new SqlDataAdapter(query, conn);
                adapter.SelectCommand.Parameters.AddWithValue("@UserID", userId);

                DataTable dt = new DataTable();
                adapter.Fill(dt);
                gvTransactions.DataSource = dt;
                gvTransactions.DataBind();
            }
        }

        protected void DdlFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            string filter = ddlFilter.SelectedValue;
            int userId = Convert.ToInt32(Session["UserID"]);
            string connectionString = ConfigurationManager.ConnectionStrings["AircraftDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT t.TransactionID, a.Model AS AircraftModel, t.TransactionType, t.TotalAmount, t.TransactionDate, t.Status " +
                               "FROM Transactions t INNER JOIN Aircraft a ON t.AircraftID = a.AircraftID WHERE t.UserID = @UserID";

                if (filter != "All")
                {
                    query += " AND t.TransactionType = @TransactionType";
                }

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@UserID", userId);

                if (filter != "All")
                {
                    cmd.Parameters.AddWithValue("@TransactionType", filter);
                }

                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);
                gvTransactions.DataSource = dt;
                gvTransactions.DataBind();
            }
        }
    }
}
