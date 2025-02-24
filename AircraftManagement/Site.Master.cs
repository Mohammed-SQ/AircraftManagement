using System;

namespace AircraftManagement
{
    public partial class Site : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                UpdateUserSession();
            }
        }

        private void UpdateUserSession()
        {
            if (Session["Users"] == null)
            {
                Session["FullName"] = null;
                Session["Role"] = null;
                Session["Email"] = null;
            }
        }
    }
}