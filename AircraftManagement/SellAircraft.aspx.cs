using System;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI.WebControls;

public partial class SellAircraft : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // **Restrict access based on role**
        if (Session["Role"] == null || (!Session["Role"].ToString().Equals("Seller") &&
            !Session["Role"].ToString().Equals("Customer") &&
            !Session["Role"].ToString().Equals("Admin")))
        {
            // **Redirect to Unauthorized Page**
            Response.Redirect("Unauthorized.aspx");
        }
    }

    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        try
        {
            string model = txtModel.Text.Trim();
            int capacity = Convert.ToInt32(Request.Form["customCapacity"]);
            decimal rentalPrice = txtRentalPrice.Visible ? Convert.ToDecimal(txtRentalPrice.Text.Trim()) : 0;
            decimal purchasePrice = txtPurchasePrice.Visible ? Convert.ToDecimal(txtPurchasePrice.Text.Trim()) : 0;
            string imagePath = "";
            // **Handle Image Upload**
            if (fileUpload.HasFile)
            {
                string filename = Path.GetFileName(fileUpload.FileName);
                string path = "~/uploads/aircrafts/" + filename;
                fileUpload.SaveAs(Server.MapPath(path));
                imagePath = path;
            }
            // **Insert Data into Aircraft Table**
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["AircraftDB"].ConnectionString))
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
            // **Update Session Role to "Seller" if they are Customer**
            if (Session["Role"].ToString() == "Customer")
            {
                Session["Role"] = "Seller";
            }
            // **Redirect to success page with confirmation message**
            Response.Redirect("Aircrafts.aspx?msg=Your aircraft has been listed successfully!");
        }
        catch (Exception)
        {
            // **Redirect Unauthorized Users Instead of Error**
            Response.Redirect("Unauthorized.aspx");
        }
    }
}