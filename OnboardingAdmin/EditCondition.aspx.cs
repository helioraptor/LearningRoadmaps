using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Onboarding_EditCondition : System.Web.UI.Page
{
    int ID;
    int ActivityID {
        get {
            return Int32.Parse(ViewState["ActivityID"] as String);
        }
        set {
            ViewState["ActivityID"] = value.ToString();
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        ID = Int32.Parse(Request.Params["Id"]);

        if (IsPostBack)
            return;

        int ClientID = Onboarding.GetClientIDForCondition(ID);

        cbQuestions.DataSource = Onboarding.GetQuestions(ClientID);//TODO 
        cbQuestions.DataBind();

        BindData();
    }

    protected string Tags
    {
        set {
            ViewState["Tags"] = value;
        }
        get {
            return ViewState["Tags"].ToString();
        }
    }

    protected void BindData()
    {
        ID = int.Parse(Request.Params["ID"]);

        Onboarding.Condition o = Onboarding.GetCondition(ID);

        this.cbQuestions.SelectedValue = String.Format("{0}",o.idQuestion);
        this.Tags = o.Tags;

        this.gvOptions.DataSource = Onboarding.GetOptions(o.idQuestion);
        this.gvOptions.DataBind();

        this.ActivityID = o.idActivity;
    }

    protected void cbOptions_DataBinding(object sender, EventArgs e)
    {
        Console.WriteLine(sender.ToString());
    }
    protected void cbOptions_DataBound(object sender, EventArgs e)
    {
        Console.WriteLine(sender.ToString());
    }

    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        string txtTags = "";
        foreach (GridViewRow r in gvOptions.Rows) {
            if (r.RowType != DataControlRowType.DataRow)
                return;

            CheckBox cb1 = (r.FindControl("cb1") as CheckBox);

            if (cb1.Checked) {
                txtTags += ",";
                txtTags += cb1.InputAttributes["value"];
            }
        }

        Onboarding.Condition o = new Onboarding.Condition();
        o.Id = ID;
        o.idQuestion = Int32.Parse(this.cbQuestions.SelectedValue);
        o.Tags = txtTags;
        
        Onboarding.SetCondition(o);

        Response.Redirect(String.Format("EditActivity.aspx?Id={0}",this.ActivityID));
    }

    protected void gvOptions_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType != DataControlRowType.DataRow)
            return;

        CheckBox cb1 = (e.Row.FindControl("cb1") as CheckBox);
        Onboarding.Option option = (e.Row.DataItem as Onboarding.Option);

        cb1.InputAttributes.Add("value", option.Tag);
        if (this.Tags.Contains(option.Tag)) {
            cb1.Checked = true;
        }
    }
}