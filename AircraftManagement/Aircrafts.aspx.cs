using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.Services;

namespace AircraftManagement
{
    public partial class Aircrafts : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Initial load is handled by JavaScript
            }
        }

        [WebMethod]
        public static object LoadAircrafts()
        {
            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["AircraftDB"].ConnectionString;
                if (string.IsNullOrEmpty(connectionString))
                {
                    return new { success = false, message = "Connection string 'AircraftDB' not found in Web.config." };
                }

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    string query = @"
                        SELECT 
                            AircraftID, 
                            AircraftModel, 
                            Capacity, 
                            Manufacturer, 
                            ImageURL, 
                            Description, 
                            YearManufactured, 
                            EngineHours, 
                            COALESCE(FuelType, 'Not Specified') AS FuelType, 
                            COALESCE(AircraftCondition, 'Not Specified') AS AircraftCondition, 
                            SellerType 
                        FROM Aircraft 
                        WHERE Status IN ('Available', 'ON')";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            sda.Fill(dt);

                            if (dt.Rows.Count > 0)
                            {
                                // Convert DataTable to a list of objects
                                var aircrafts = new System.Collections.Generic.List<object>();
                                foreach (DataRow row in dt.Rows)
                                {
                                    aircrafts.Add(new
                                    {
                                        AircraftID = Convert.ToInt32(row["AircraftID"]),
                                        AircraftModel = row["AircraftModel"].ToString(),
                                        Capacity = Convert.ToInt32(row["Capacity"]),
                                        Manufacturer = row["Manufacturer"].ToString(),
                                        ImageURL = row["ImageURL"] != DBNull.Value ? row["ImageURL"].ToString() : null,
                                        Description = row["Description"].ToString(),
                                        YearManufactured = Convert.ToInt32(row["YearManufactured"]),
                                        EngineHours = Convert.ToInt32(row["EngineHours"]),
                                        FuelType = row["FuelType"].ToString(),
                                        AircraftCondition = row["AircraftCondition"].ToString(),
                                        SellerType = row["SellerType"].ToString()
                                    });
                                }

                                return new { success = true, aircrafts };
                            }
                            else
                            {
                                return new { success = false, message = "No aircraft found." };
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                return new { success = false, message = "Error loading aircrafts: " + ex.Message };
            }
        }
    }
}