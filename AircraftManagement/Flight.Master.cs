using System;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace AircraftManagement
{
    public partial class Flight : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Logic for AdminLink visibility
            if (Session["Role"] != null && Session["Role"].ToString() == "Admin")
            {
                var adminLink = LoginView1.FindControl("AdminLink") as HyperLink;
                if (adminLink != null)
                {
                    adminLink.Visible = true;
                }
            }
            else
            {
                var adminLink = LoginView1.FindControl("AdminLink") as HyperLink;
                if (adminLink != null)
                {
                    adminLink.Visible = false;
                }
            }
        }
    }
}
