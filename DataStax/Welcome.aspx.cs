using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;

public partial class Onboarding_Client_Welcome : System.Web.UI.Page
{
    int ClientID {
        get {
            return Int32.Parse(ConfigurationManager.AppSettings["ClientID"]);
        }
    }

    protected List<Onboarding.Selection> Selections
    {
        get
        {
            return Session["Selections"] as List<Onboarding.Selection>;
        }
    }

    protected bool SelectionContains(string str)
    {
        if (String.IsNullOrEmpty(str))
            return true;

        foreach (Onboarding.Selection s in this.Selections)
        {
            if (("," + str + ",").Contains(s.Tag))
                return true;
        }
        return false;
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack)
            return;

        BindData();
    }

    protected void BindData()
    {
        foreach (Onboarding.LandingPage page in Onboarding.GetLandingPages(ClientID))
        {
            if (SelectionContains(page.Visible)) {
                this.lblLanding.Text = page.Name;
                this.lblContent.Text = page.Content;
                break;
            }
        }
    }

    protected void btnNext_Click(object sender, EventArgs e)
    {
        //Response.Redirect(String.Format("Activities.aspx?Id={0}", ClientID));
        Response.Redirect("Activities.aspx");
    }
}