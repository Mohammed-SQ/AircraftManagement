using System;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace AircraftManagement
{
    public partial class PurchaseRental : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadAircrafts();
                txtStartDate.Text = DateTime.Now.ToShortDateString();
            }
        }

        private void LoadAircrafts()
        {
            string connectionString = "Server=(localdb)\\MSSQLLocalDB;Integrated Security=True;AttachDbFilename=C:\\Users\\abcdq\\source\\repos\\AircraftManagement\\AircraftManagement\\App_Data\\AircraftDB.mdf;";

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT AircraftID, Model, RentalPrice, PurchasePrice, ImageURL FROM Aircraft";
                SqlCommand cmd = new SqlCommand(query, conn);

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    string model = reader["Model"].ToString();
                    string aircraftId = reader["AircraftID"].ToString();
                    ddlAircrafts.Items.Add(new ListItem(model, aircraftId));

                    if (Request.QueryString["AircraftID"] == aircraftId)
                    {
                        ddlAircrafts.SelectedValue = aircraftId;
                        txtTotalAmount.Text = reader["RentalPrice"].ToString();
                        imgAircraft.ImageUrl = reader["ImageURL"].ToString();
                    }
                }
            }
        }

        protected void DdlAircrafts_SelectedIndexChanged(object sender, EventArgs e)
        {
            string connectionString = "Server=(localdb)\\MSSQLLocalDB;Integrated Security=True;AttachDbFilename=C:\\Users\\abcdq\\source\\repos\\AircraftManagement\\AircraftManagement\\App_Data\\AircraftDB.mdf;";

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT RentalPrice, PurchasePrice, ImageURL FROM Aircraft WHERE AircraftID=@AircraftID";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@AircraftID", ddlAircrafts.SelectedValue);

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    imgAircraft.ImageUrl = reader["ImageURL"].ToString();
                    txtTotalAmount.Text = reader["RentalPrice"].ToString();
                }
            }
        }

        protected void DdlTransactionType_SelectedIndexChanged(object sender, EventArgs e)
        {
            pnlRentalOptions.Visible = (ddlTransactionType.SelectedValue == "Rent");

            if (ddlTransactionType.SelectedValue == "Purchase")
            {
                string connectionString = "Server=(localdb)\\MSSQLLocalDB;Integrated Security=True;AttachDbFilename=C:\\Users\\abcdq\\source\\repos\\AircraftManagement\\AircraftManagement\\App_Data\\AircraftDB.mdf;";

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = "SELECT PurchasePrice FROM Aircraft WHERE AircraftID=@AircraftID";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@AircraftID", ddlAircrafts.SelectedValue);

                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();
                    if (reader.Read())
                    {
                        txtTotalAmount.Text = reader["PurchasePrice"].ToString();
                    }
                }
            }
        }

        protected void DdlRentalPeriod_SelectedIndexChanged(object sender, EventArgs e)
        {
            DateTime startDate = DateTime.Now;
            txtEndDate.Text = startDate.AddDays(Convert.ToInt32(ddlRentalPeriod.SelectedValue)).ToShortDateString();
        }

        protected void BtnConfirmTransaction_Click(object sender, EventArgs e)
        {
            Response.Write("<script>alert('Transaction Successful!');</script>");
        }
    }
}
