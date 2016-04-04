using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Text;
using System.Xml.Serialization;
using System.IO;

public partial class Onboarding_Client_Return : System.Web.UI.Page
{

    
    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack)
                return;
    }

    
    protected void btnNext_Click(object sender, EventArgs e)
    {
        string Selections = Onboarding.GetSavedSession(this.txtEmail.Text);
        if (String.IsNullOrEmpty(Selections))
        {
            errEmail.Text = "email not found";
            errEmail.Visible = true;
            return;
        }
        else
        {
            StringBuilder output = new StringBuilder();
            var writer = new StringWriter(output);

            XmlSerializer serializer = new XmlSerializer(typeof(List<Onboarding.Selection>));

            Session["Selections"] = serializer.Deserialize(new StringReader(Selections)) as List<Onboarding.Selection>;
            Session["Name"] = Onboarding.GetSavedSessionName(this.txtEmail.Text);
            Session["Role"] = Onboarding.GetSavedSessionRole(this.txtEmail.Text);
            Session["Email"] = this.txtEmail.Text;
            //Response.Redirect(String.Format("Welcome.aspx?ID={0}", ClientID));
            Response.Redirect("Activities.aspx");
        }
    }

}