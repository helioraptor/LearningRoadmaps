using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Onboarding_EditActivity : System.Web.UI.Page
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

    protected void BindData()
    {
        ID = int.Parse(Request.Params["ID"]);

        Onboarding.Activity o = Onboarding.GetActivity(ID);

        this.txtContent.Text = o.Content;
        this.txtTopic.Text = o.Topic;
        this.txtWeek.Text = o.Week;
        this.txtDay.Text = o.Day;
        this.txtTime.Text = o.Time;

        this.ClientID = o.ClientId;

        this.gvConditions.DataSource = Onboarding.GetConditions(ID);
        this.gvConditions.DataBind();
    }

    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        Onboarding.Activity o = new Onboarding.Activity();
        o.Id = ID;
        o.Content = this.txtContent.Text;
        o.Topic = this.txtTopic.Text;
        o.Week = this.txtWeek.Text;
        o.Day = this.txtDay.Text;
        o.Time = this.txtTime.Text;

        Onboarding.SetActivity(o);

        Response.Redirect(String.Format("Activities.aspx?Id={0}", this.ClientID));
    }

    protected void btnEditCondition_Click(object sender, EventArgs e)
    {
        //Response.Redirect(String.Format("EditCondition.aspx?Id={0}", Int32.Parse((sender as LinkButton).CommandArgument)));
    }

    protected void btnUpCondition_Click(object sender, EventArgs e)
    {
        //Response.Redirect(String.Format("EditAActivity.aspx?Id={0}", Int32.Parse((sender as LinkButton).CommandArgument)));
    }

    protected void btnDownCondition_Click(object sender, EventArgs e)
    {
        //Response.Redirect(String.Format("EditAActivity.aspx?Id={0}", Int32.Parse((sender as LinkButton).CommandArgument)));
    }
    
    protected void btnDeleteCondition_Click(object sender, EventArgs e)
    {
        Onboarding.DeleteCondition(Int32.Parse((sender as LinkButton).CommandArgument));

        BindData();
    }

    protected void btnAddCondition_Click(object sender, EventArgs e)
    {
        Onboarding.AddCondition(ID);
        BindData();
    }
}