using System;
using System.Data.SqlClient;
using System.Configuration;

namespace AircraftManagement
{
    public partial class Contact : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["Role"] != null && (Session["Role"].ToString() == "Customer" || Session["Role"].ToString() == "Seller" || Session["Role"].ToString() == "Admin"))
                {
                    txtName.Text = Session["FullName"] != null ? Session["FullName"].ToString() : "";
                    txtEmail.Text = Session["Email"] != null ? Session["Email"].ToString() : "";
                    txtName.ReadOnly = true;
                    txtEmail.ReadOnly = true;
                }

                // Bind the button click event to prevent the compilation error
                BtnSubmit.Click += new EventHandler(btnSubmit_Click);
            }
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            string name = txtName.Text.Trim();
            string email = txtEmail.Text.Trim();
            string subject = txtSubject.Text.Trim();
            string message = txtMessage.Text.Trim();

            if (string.IsNullOrEmpty(name) || string.IsNullOrEmpty(email) || string.IsNullOrEmpty(subject) || string.IsNullOrEmpty(message))
            {
                lblMessage.Text = "❌ Please fill in all fields.";
                return;
            }

            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["AircraftDB"].ConnectionString;

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = "INSERT INTO ContactUs (FullName, Email, Subject, Message, CreatedAt) VALUES (@Name, @Email, @Subject, @Message, GETDATE())";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@Name", name);
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@Subject", subject);
                    cmd.Parameters.AddWithValue("@Message", message);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                lblMessage.ForeColor = System.Drawing.Color.Green;
                lblMessage.Text = "✅ Thank you for contacting us! We will get back to you soon.";
                txtSubject.Text = txtMessage.Text = "";
            }
            catch (Exception ex)
            {
                lblMessage.Text = "❌ Error: " + ex.Message;
            }
        }
    }
}