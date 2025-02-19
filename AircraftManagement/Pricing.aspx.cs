using System;
using System.Data;
using System.Data.SqlClient;

namespace AircraftManagement
{
    public partial class Pricing : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadPricing();
            }
        }

        private void LoadPricing()
        {
            string connectionString = "Data Source=(LocalDB)\\MSSQLLocalDB;AttachDbFilename=C:\\Users\\abcdq\\source\\repos\\AircraftManagement\\AircraftManagement\\App_Data\\AircraftDB.mdf;Integrated Security=True";

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT Model, Capacity, RentalPrice, PurchasePrice FROM Aircraft";
                SqlDataAdapter adapter = new SqlDataAdapter(query, conn);

                DataTable dt = new DataTable();
                adapter.Fill(dt);
                gvPricing.DataSource = dt;
                gvPricing.DataBind();
            }
        }
    }
}