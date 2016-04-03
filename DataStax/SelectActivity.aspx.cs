using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class DataStax_SelectActivity : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string Id = Request.Params["id"];
        string Checked = Request.Params["checked"];
        string Email = Session["Email"].ToString();

        Onboarding.SelectActivityForEmail(Id, Checked, Email);

        Response.Clear();
        Response.Write("OK");
        Response.End();
    }
}