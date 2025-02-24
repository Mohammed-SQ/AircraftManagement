using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;

namespace AircraftManagement
{
    public partial class Aircrafts : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadAircrafts();
            }
        }

        private void LoadAircrafts(string searchQuery = "", string sortOption = "")
        {
            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["AircraftDB"].ConnectionString;

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    string query = "SELECT AircraftID, Model, Capacity, RentalPrice, Manufacturer, ImageUrl, Description FROM Aircraft WHERE 1=1";

                    if (!string.IsNullOrEmpty(searchQuery))
                    {
                        query += " AND (Model LIKE @SearchText OR Manufacturer LIKE @SearchText OR Description LIKE @SearchText)";
                    }

                    switch (sortOption)
                    {
                        case "PriceAsc":
                            query += " ORDER BY RentalPrice ASC";
                            break;
                        case "PriceDesc":
                            query += " ORDER BY RentalPrice DESC";
                            break;
                        case "CapacityDesc":
                            query += " ORDER BY Capacity DESC";
                            break;
                        default:
                            query += " ORDER BY Model ASC";
                            break;
                    }

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        if (!string.IsNullOrEmpty(searchQuery))
                        {
                            cmd.Parameters.AddWithValue("@SearchText", "%" + searchQuery + "%");
                        }

                        using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            sda.Fill(dt);

                            if (dt.Rows.Count > 0)
                            {
                                rptAircrafts.DataSource = dt;
                                rptAircrafts.DataBind();
                            }
                            else
                            {
                                rptAircrafts.DataSource = null;
                                rptAircrafts.DataBind();
                                lblError.Text = "No aircraft found matching your criteria.";
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                lblError.Text = "Error loading aircrafts: " + ex.Message;
            }
        }

        protected void btnFilter_Click(object sender, EventArgs e) // Ensure this method exists
        {
            string searchQuery = txtSearch.Text.Trim();
            string sortOption = ddlSort.SelectedValue;
            LoadAircrafts(searchQuery, sortOption);
        }
    }
}