using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;

public partial class Onboarding_Client_Default : System.Web.UI.Page
{

    protected List<Onboarding.Selection> Selections
    {
        get {
            return this.ViewState["Selections"] as List<Onboarding.Selection>;
        }
        set {
            this.ViewState["Selections"] = value;
        }
    }

    protected bool SelectionContains(string str) 
    {
        if (String.IsNullOrEmpty(str)) 
            return true;

        foreach (Onboarding.Selection s in this.Selections) 
        {
            if ((","+str+",").Contains(s.Tag))
                return true;
        }
        return false;
    }

    protected Dictionary<Onboarding.Question, List<Onboarding.Option>> Questions
    {
        get
        {
            return this.ViewState["Questions"] as Dictionary<Onboarding.Question, List<Onboarding.Option>>;
        }
        set
        {
            this.ViewState["Questions"] = value;
        }
    }

    protected int ClientID {
        get {
            return Int32.Parse(ConfigurationManager.AppSettings["ClientID"]);
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack)
                return;

        this.Selections = new List<Onboarding.Selection>();
        this.Questions = new Dictionary<Onboarding.Question, List<Onboarding.Option>>();

        Session["Selections"] = null;

        LoadDataFromDB();

        BindData();

        //this.gvQuestions.DataSource = Onboarding.GetQuestions(1);
        //this.gvQuestions.DataBind();
    }

    protected void LoadDataFromDB()
    {
        this.Questions.Clear();
        List<Onboarding.Question> questions = Onboarding.GetQuestions(ClientID);
        foreach (Onboarding.Question q in questions)
        {
            List<Onboarding.Option> options = Onboarding.GetOptions(q.Id);
            this.Questions.Add(q, options);
        }
    }

    protected void BindData() {
        List<Onboarding.Question> qs = this.Questions.Keys.Where(x => SelectionContains(x.Visible)).ToList();

        this.gvQuestions.DataSource = qs;
        this.gvQuestions.DataBind();

        Onboarding.Client client = Onboarding.GetClient(ClientID);
        btnNext.Visible  = SelectionContains(client.allowNext);
    }

    protected void gvQuestions_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType != DataControlRowType.DataRow)
            return;

        DropDownList ddlOptions = (e.Row.FindControl("ddlOptions") as DropDownList);
        HiddenField hiddenQuestionID = (e.Row.FindControl("hiddenQuestionId") as HiddenField);
        Onboarding.Question question = (e.Row.DataItem as Onboarding.Question);

        ddlOptions.DataSource = Questions[question];
        hiddenQuestionID.Value = question.Id.ToString();

        //ddlOptions.DataSource = Onboarding.GetOptions(question.Id);
        ddlOptions.DataBind();
        foreach (Onboarding.Selection s in this.Selections)
        {
            if (s.QuestionID == question.Id)
            {
                ddlOptions.SelectedIndex = ddlOptions.Items.IndexOf(ddlOptions.Items.FindByValue(s.Tag));
            }
        }
        ddlOptions.Items.Insert(0, new ListItem("--select--",""));
    }

    protected void ddlOptionSelectedIndexChanged(object sender, EventArgs e) {
        string NewTag = (sender as DropDownList).SelectedItem.Value;
        string QuestionID = "";
        foreach (GridViewRow row in gvQuestions.Rows) { 
            if((row.FindControl("ddlOptions").Equals(sender as DropDownList)))
            {
                 QuestionID = (row.FindControl("hiddenQuestionId") as HiddenField).Value;
            }
        }
        Console.Write(e.GetType());
        Console.Write(QuestionID);
        Console.Write(NewTag);

        Onboarding.Selection s1 = new Onboarding.Selection(Int32.Parse(QuestionID), NewTag);
        List<Onboarding.Selection> newSelections = new List<Onboarding.Selection>();
        foreach (Onboarding.Selection s2 in Selections)
        {
            if (s2.QuestionID == s1.QuestionID) 
            {
                break;
            }
            else{
                newSelections.Add(s2);
            }
        }
        newSelections.Add(s1);

        this.Selections = newSelections;

        BindData();
    }

    protected void btnNext_Click(object sender, EventArgs e)
    {
        Session["Selections"] = this.Selections;
        Session["Name"] = this.txtName.Text;
        Session["Email"] = this.txtEmail.Text;
        //Response.Redirect(String.Format("Welcome.aspx?ID={0}", ClientID));
        Response.Redirect("Welcome.aspx");
    }

}