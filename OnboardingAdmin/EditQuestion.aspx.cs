using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Onboarding_EditQuestion : System.Web.UI.Page
{
    int ID;
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
        ID = Int32.Parse(Request.Params["Id"]);

        if (IsPostBack)
            return;
        BindData();
    }

    protected void btnDeleteOption_Click(object sender, EventArgs e)
    {
        Onboarding.DeleteOption(Int32.Parse((sender as LinkButton).CommandArgument));
        BindData();
    }

    protected void btnUpOption_Click(object sender, EventArgs e)
    {
        Onboarding.UpOption(Int32.Parse((sender as LinkButton).CommandArgument));
        BindData();
    }

    protected void btnDownOption_Click(object sender, EventArgs e)
    {
        Onboarding.DownOption(Int32.Parse((sender as LinkButton).CommandArgument));
        BindData();
    }
    protected void btnAddOption_Click(object sender, EventArgs e)
    {
        Onboarding.AddOption(ID);
        BindData();
    }

    protected void BindData()
    {
        int ID = int.Parse(Request.Params["ID"]);

        Onboarding.Question q = Onboarding.GetQuestion(ID);
        this.txtName.Text = q.Name;
        this.txtShow.Text = q.Visible;
        this.txtHide.Text = q.Hidden;
        this.ClientID = q.ClientId;

        this.gvOptions.DataSource = Onboarding.GetOptions(ID);
        this.gvOptions.DataBind();
    }

    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        Onboarding.Question o = new Onboarding.Question();
        o.Id = ID;
        o.Name = this.txtName.Text;
        o.Visible = this.txtShow.Text;
        o.Hidden = this.txtHide.Text;

        Onboarding.SetQuestion(o);

        Response.Redirect(String.Format("Client.aspx?Id={0}", this.ClientID));
    }
}