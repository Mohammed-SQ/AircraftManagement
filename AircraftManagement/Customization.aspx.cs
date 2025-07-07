using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;

namespace AircraftManagement
{
    public partial class Customization : System.Web.UI.Page
    {
        private string connectionString = ConfigurationManager.ConnectionStrings["AircraftDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("Login.aspx");
            }

            if (!IsPostBack)
            {
                LoadAircrafts();
            }
        }

        private void LoadAircrafts()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    string query = @"
                        SELECT a.AircraftID, a.Model 
                        FROM Aircraft a
                        INNER JOIN Transactions t ON a.AircraftID = t.AircraftID
                        WHERE t.UserID = @UserID 
                        AND t.PaymentStatus = 'Completed'";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", Session["UserID"].ToString());
                        using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            adapter.Fill(dt);
                            ddlAircrafts.DataSource = dt;
                            ddlAircrafts.DataTextField = "Model";
                            ddlAircrafts.DataValueField = "AircraftID";
                            ddlAircrafts.DataBind();
                            ddlAircrafts.Items.Insert(0, new ListItem("Select an Aircraft", ""));
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                lblFeedbackMessage.Text = "Error loading aircrafts: " + ex.Message;
                lblFeedbackMessage.CssClass = "alert alert-danger text-center";
                lblFeedbackMessage.Visible = true;
            }
        }

        protected void btnSaveCustomization_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(ddlAircrafts.SelectedValue))
            {
                lblFeedbackMessage.Text = "Please select an aircraft to customize.";
                lblFeedbackMessage.CssClass = "alert alert-warning text-center";
                lblFeedbackMessage.Visible = true;
                return;
            }

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"
                        INSERT INTO Customizations (
                            UserID, 
                            AircraftID, 
                            BodyColor, 
                            WingColor, 
                            Decal, 
                            WingType, 
                            WingSize, 
                            TailStyle, 
                            EngineUpgrade, 
                            GearType, 
                            GearSize, 
                            AircraftSize, 
                            InteriorTheme, 
                            SeatMaterial, 
                            SeatColor, 
                            InteriorLighting, 
                            ExteriorLighting, 
                            CreatedAt
                        )
                        VALUES (
                            @UserID, 
                            @AircraftID, 
                            @BodyColor, 
                            @WingColor, 
                            @Decal, 
                            @WingType, 
                            @WingSize, 
                            @TailStyle, 
                            @EngineUpgrade, 
                            @GearType, 
                            @GearSize, 
                            @AircraftSize, 
                            @InteriorTheme, 
                            @SeatMaterial, 
                            @SeatColor, 
                            @InteriorLighting, 
                            @ExteriorLighting, 
                            GETDATE()
                        )";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        // Validate color inputs
                        string bodyColor = hdnCurrentBodyColor.Value;
                        if (string.IsNullOrEmpty(bodyColor) || !bodyColor.StartsWith("#") || bodyColor.Length != 7)
                        {
                            bodyColor = "#FFFFFF";
                        }

                        string wingColor = hdnCurrentWingColor.Value;
                        if (string.IsNullOrEmpty(wingColor) || !wingColor.StartsWith("#") || wingColor.Length != 7)
                        {
                            wingColor = "#FFFFFF";
                        }

                        string seatColor = hdnCurrentSeatColor.Value;
                        if (string.IsNullOrEmpty(seatColor) || !seatColor.StartsWith("#") || seatColor.Length != 7)
                        {
                            seatColor = "#FFFFFF";
                        }

                        cmd.Parameters.AddWithValue("@UserID", Session["UserID"].ToString());
                        cmd.Parameters.AddWithValue("@AircraftID", ddlAircrafts.SelectedValue);
                        cmd.Parameters.AddWithValue("@BodyColor", bodyColor);
                        cmd.Parameters.AddWithValue("@WingColor", wingColor);
                        cmd.Parameters.AddWithValue("@Decal", hdnCurrentDecal.Value ?? "none");
                        cmd.Parameters.AddWithValue("@WingType", hdnCurrentWingType.Value ?? "straight");
                        cmd.Parameters.AddWithValue("@WingSize", Convert.ToDecimal(hdnCurrentWingSize.Value ?? "1"));
                        cmd.Parameters.AddWithValue("@TailStyle", hdnCurrentTailStyle.Value ?? "conventional");
                        cmd.Parameters.AddWithValue("@EngineUpgrade", hdnCurrentEngine.Value ?? "standard");
                        cmd.Parameters.AddWithValue("@GearType", hdnCurrentGearType.Value ?? "fixed");
                        cmd.Parameters.AddWithValue("@GearSize", Convert.ToDecimal(hdnCurrentGearSize.Value ?? "1"));
                        cmd.Parameters.AddWithValue("@AircraftSize", Convert.ToDecimal(hdnCurrentAircraftSize.Value ?? "5"));
                        cmd.Parameters.AddWithValue("@InteriorTheme", hdnCurrentInteriorTheme.Value ?? "luxury");
                        cmd.Parameters.AddWithValue("@SeatMaterial", hdnCurrentSeatMaterial.Value ?? "leather");
                        cmd.Parameters.AddWithValue("@SeatColor", seatColor);
                        cmd.Parameters.AddWithValue("@InteriorLighting", hdnCurrentInteriorLighting.Value ?? "standard");
                        cmd.Parameters.AddWithValue("@ExteriorLighting", hdnCurrentExteriorLighting.Value ?? "standard");

                        conn.Open();
                        cmd.ExecuteNonQuery();
                        conn.Close();
                    }
                }

                lblFeedbackMessage.Text = "Customization saved successfully for " + ddlAircrafts.SelectedItem.Text + "!";
                lblFeedbackMessage.CssClass = "alert alert-success text-center";
                lblFeedbackMessage.Visible = true;
            }
            catch (Exception ex)
            {
                lblFeedbackMessage.Text = "Error saving customization: " + ex.Message;
                lblFeedbackMessage.CssClass = "alert alert-danger text-center";
                lblFeedbackMessage.Visible = true;
            }
        }
    }
}