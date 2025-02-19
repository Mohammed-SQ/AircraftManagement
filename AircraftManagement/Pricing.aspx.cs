using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration; // Required to read from Web.config

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
            string connectionString = ConfigurationManager.ConnectionStrings["AircraftDB"].ConnectionString;

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
