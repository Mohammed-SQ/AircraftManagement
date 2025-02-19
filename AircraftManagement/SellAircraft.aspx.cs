using System;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI.WebControls;
using System.Configuration; // Required to read from Web.config

public partial class SellAircraft : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["Role"] == null || (!Session["Role"].ToString().Equals("Seller") &&
                                        !Session["Role"].ToString().Equals("Customer") &&
                                        !Session["Role"].ToString().Equals("Admin")))
        {
            Response.Redirect("Unauthorized.aspx");
        }
    }

    protected void BtnSubmit_Click(object sender, EventArgs e)
    {
        try
        {
            string model = txtModel.Text.Trim();
            int capacity = Convert.ToInt32(Request.Form["customCapacity"]);
            decimal rentalPrice = txtRentalPrice.Visible ? Convert.ToDecimal(txtRentalPrice.Text.Trim()) : 0;
            decimal purchasePrice = txtPurchasePrice.Visible ? Convert.ToDecimal(txtPurchasePrice.Text.Trim()) : 0;
            string imagePath = "";

            if (fileUpload.HasFile)
            {
                string filename = Path.GetFileName(fileUpload.FileName);
                string path = "~/uploads/aircrafts/" + filename;
                fileUpload.SaveAs(Server.MapPath(path));
                imagePath = path;
            }

            string connectionString = ConfigurationManager.ConnectionStrings["AircraftDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "INSERT INTO Aircraft (Model, Capacity, RentalPrice, PurchasePrice, ImageURL) VALUES (@Model, @Capacity, @RentalPrice, @PurchasePrice, @ImageURL)";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@Model", model);
                cmd.Parameters.AddWithValue("@Capacity", capacity);
                cmd.Parameters.AddWithValue("@RentalPrice", rentalPrice);
                cmd.Parameters.AddWithValue("@PurchasePrice", purchasePrice);
                cmd.Parameters.AddWithValue("@ImageURL", imagePath);

                conn.Open();
                cmd.ExecuteNonQuery();
            }

            if (Session["Role"].ToString() == "Customer")
            {
                Session["Role"] = "Seller";
            }

            Response.Redirect("Aircrafts.aspx?msg=Your aircraft has been listed successfully!");
        }
        catch (Exception)
        {
            Response.Redirect("Unauthorized.aspx");
        }
    }
}
