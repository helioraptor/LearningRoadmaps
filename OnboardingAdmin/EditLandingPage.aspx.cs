using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Onboarding_EditLandingPage : System.Web.UI.Page
{
    int ID;
    int ClientID {
        get {
            return Int32.Parse(ViewState["ClientID"] as String);
        }
        set {
            ViewState["ClientID"] = value.ToString();
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        ID = Int32.Parse(Request.Params["Id"]);

        if (IsPostBack)
            return;
        BindData();
    }

    protected void BindData()
    {
        ID = int.Parse(Request.Params["ID"]);

        Onboarding.LandingPage o = Onboarding.GetLandingPage(ID);

        this.txtName.Text = o.Name;
        this.txtShow.Text = o.Visible;
        this.txtContent.Text = o.Content;

        this.ClientID = o.ClientId;
    }

    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        Onboarding.LandingPage o = new Onboarding.LandingPage();
        o.Id = ID;
        o.Name = this.txtName.Text;
        o.Visible = this.txtShow.Text;
        o.Content = this.txtContent.Text;

        Onboarding.SetLandingPage(o);

        Response.Redirect(String.Format("Client.aspx?Id={0}",this.ClientID));
    }
}