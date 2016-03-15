using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Onboarding_Activities : System.Web.UI.Page
{
    int ClientID
    {
        get
        {
            return Int32.Parse(ViewState["ClientID"] as String);
        }
        set
        {
            ViewState["ClientID"] = value.ToString();
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        ClientID = Int32.Parse(Request.Params["Id"]);

        if (IsPostBack)
            return;
        BindData();
    }

    protected void btnDeleteActivity_Click(object sender, EventArgs e)
    {
        Onboarding.DeleteActivity(Int32.Parse((sender as LinkButton).CommandArgument));
        BindData();
    }

    protected void btnUpActivity_Click(object sender, EventArgs e)
    {
        Onboarding.UpActivity(Int32.Parse((sender as LinkButton).CommandArgument));
        BindData();
    }

    protected void btnDownActivity_Click(object sender, EventArgs e)
    {
        Onboarding.DownActivity(Int32.Parse((sender as LinkButton).CommandArgument));
        BindData();
    }

    protected void BindData()
    {
        this.gvActivities.DataSource = Onboarding.GetActivities(ClientID);
        this.gvActivities.DataBind();
    }

    protected void btnAddActivity_Click(object sender, EventArgs e)
    {
        Onboarding.AddActivity(ClientID);
        BindData();
    }
    protected void btnEditActivity_Click(object sender, EventArgs e)
    {
        Response.Redirect(String.Format("EditActivity.aspx?Id={0}", Int32.Parse((sender as LinkButton).CommandArgument)));
    }
}