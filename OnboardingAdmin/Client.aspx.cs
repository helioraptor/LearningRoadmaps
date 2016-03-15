using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Onboarding_Client : System.Web.UI.Page
{
    int ClientID;
    protected void Page_Load(object sender, EventArgs e)
    {
        ClientID = int.Parse(Request.Params["ID"]);
        if (IsPostBack)
            return;

        BindData();
    }


    /***************************************************************************************************************************/
    protected void btnAddQuestion_Click(object sender, EventArgs e)
    {
        Onboarding.AddQuestion(ClientID);
        BindData();
    }

    protected void btnDeleteQuestion_Click(object sender, EventArgs e)
    {
        Onboarding.DeleteQuestion(Int32.Parse((sender as LinkButton).CommandArgument));
        BindData();
    }

    protected void btnUpQuestion_Click(object sender, EventArgs e)
    {
        Onboarding.UpQuestion(Int32.Parse((sender as LinkButton).CommandArgument));
        BindData();
    }

    protected void btnDownQuestion_Click(object sender, EventArgs e)
    {
        Onboarding.DownQuestion(Int32.Parse((sender as LinkButton).CommandArgument));
        BindData();
    }

    /***************************************************************************************************************************/
    protected void btnAddLandingPage_Click(object sender, EventArgs e)
    {
        Onboarding.AddLandingPage(ClientID);
        BindData();
    }

    protected void btnUpLandingPage_Click(object sender, EventArgs e)
    {
        Onboarding.UpLandingPage(Int32.Parse((sender as LinkButton).CommandArgument));
        BindData();
    }

    protected void btnDownLandingPage_Click(object sender, EventArgs e)
    {
        Onboarding.DownLandingPage(Int32.Parse((sender as LinkButton).CommandArgument));
        BindData();
    }

    protected void btnDeleteLandingPage_Click(object sender, EventArgs e)
    {
        Onboarding.DeleteLandingPage(Int32.Parse((sender as LinkButton).CommandArgument));
        BindData();
    }

    /***************************************************************************************************************************/
    protected void btnAddActivity_Click(object sender, EventArgs e)
    {
        //Onboarding.AddActivity(ClientID);
        //BindData();
        Response.Redirect("Activities.aspx?Id="+Request.Params["Id"]);
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


    protected void BindData() {
        ClientID = int.Parse(Request.Params["ID"]);

        Onboarding.Client o = Onboarding.GetClient(ClientID);

        this.txtName.Text = o.Name;
        this.txtEmail.Text = o.Email;
        this.txtNext.Text = o.allowNext;

        this.gvLandingPages.DataSource = Onboarding.GetLandingPages(ClientID);
        this.gvLandingPages.DataBind();

        this.gvQuestions.DataSource = Onboarding.GetQuestions(ClientID);
        this.gvQuestions.DataBind();

    }

    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        Onboarding.Client o = new Onboarding.Client();
        o.Id = ClientID;
        o.Name = this.txtName.Text;
        o.Email = this.txtEmail.Text;
        o.allowNext = this.txtNext.Text;

        Onboarding.SetClient(o);

        Response.Redirect(String.Format("Default.aspx?Id={0}", this.ClientID));
    }
}