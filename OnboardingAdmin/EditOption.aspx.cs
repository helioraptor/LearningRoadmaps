using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Onboarding_EditOption : System.Web.UI.Page
{
    int ID;
    int QuestionID {
        get {
            return Int32.Parse(ViewState["QuestionID"] as String);
        }
        set {
            ViewState["QuestionID"] = value.ToString();
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

        Onboarding.Option o = Onboarding.GetOption(ID);

        this.txtName.Text = o.Name;
        this.txtTag.Text = o.Tag;
        this.txtShow.Text = o.Visible;
        this.txtHide.Text = o.Hidden;

        this.QuestionID = o.QuestionId;
    }

    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        Onboarding.Option option = new Onboarding.Option();
        option.Id = ID;
        option.Name = this.txtName.Text;
        option.Tag = this.txtTag.Text;
        option.Visible = this.txtShow.Text;
        option.Hidden = this.txtHide.Text;

        Onboarding.SetOption(option);

        Response.Redirect(String.Format("EditQuestion.aspx?Id={0}",this.QuestionID));
    }
}