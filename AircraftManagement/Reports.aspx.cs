using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace AircraftManagement
{
    public partial class Reports : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Role"] == null || Session["Role"].ToString() != "Admin")
            {
                Response.Redirect("Login.aspx");
            }

            if (!IsPostBack)
            {
                LoadTransactionData();
            }
        }

        private void LoadTransactionData()
        {
            string connectionString = "Data Source=(LocalDB)\\MSSQLLocalDB;AttachDbFilename=C:\\Users\\abcdq\\source\\repos\\AircraftManagement\\AircraftManagement\\App_Data\\AircraftDB.mdf;Integrated Security=True"; // Replace with your actual connection string

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT TransactionType, COUNT(*) AS Count FROM Transactions GROUP BY TransactionType";
                SqlDataAdapter adapter = new SqlDataAdapter(query, conn);

                DataTable dt = new DataTable();
                adapter.Fill(dt);

            }
        }
    }
}