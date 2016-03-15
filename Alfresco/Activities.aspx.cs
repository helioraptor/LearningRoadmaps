using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Onboarding_Client_Activities : System.Web.UI.Page
{
    int ClientID
    {
        get
        {
            return Int32.Parse(Request.Params["ID"]);
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
        List<Onboarding.Activity> activities = new List<Onboarding.Activity>();
        foreach (Onboarding.Activity a in Onboarding.GetActivities(ClientID)) 
        {
            bool notfound = false;
            foreach (Onboarding.Condition c in Onboarding.GetConditions(a.Id)) 
            {
                if (!SelectionContains(c.Tags))
                {
                    notfound = true;
                    break;
                }
            }
            if (!notfound) 
            {
                activities.Add(a);
            }
        }
        this.gvActivites.DataSource = activities;
        this.gvActivites.DataBind();
    }

}