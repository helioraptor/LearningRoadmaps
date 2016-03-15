﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;

using System.IO;

using iTextSharp;
using iTextSharp.text;
using iTextSharp.text.xml;
using iTextSharp.text.html.simpleparser;
using iTextSharp.text.pdf;
using iTextSharp.tool.xml;

public partial class Onboarding_Client_Activities : System.Web.UI.Page
{
    int ClientID
    {
        get
        {
            return Int32.Parse(ConfigurationManager.AppSettings["ClientID"]);
        }
    }

    protected List<Onboarding.Selection> Selections
    {
        get
        {
            if (null == Session["Selections"]) 
            {
                Response.Redirect("Default.aspx");
                return null;
            }
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

        this.lblName.Text = Session["Name"].ToString();
        this.lblEmail.Text = Session["Email"].ToString();
        this.lblPlanDate.Text = DateTime.Now.ToShortDateString();
    }

    protected void ExportToPDF(object sender, EventArgs e) 
    { 
    }

    public void PdfClick(object sender, EventArgs e)
    {
        this.imgLogo.Visible = false;
        this.btnPrint.Visible = false;
        this.btnPdf.Visible = false;
        this.btnExcel.Visible = false;

        Response.ContentType = "application/pdf";
        Response.AddHeader("content-disposition", "attachment;filename=MyLearningRoadmap.pdf");
        Response.Cache.SetCacheability(HttpCacheability.NoCache);
        StringWriter sw = new StringWriter();
        HtmlTextWriter hw = new HtmlTextWriter(sw);
        this.Page.RenderControl(hw);
        StringReader sr = new StringReader(sw.ToString());
        using (Document pdfDoc = new Document(PageSize.LETTER, 10f, 10f, 100f, 0f))
        {
            PdfWriter writer = PdfWriter.GetInstance(pdfDoc, Response.OutputStream);
            pdfDoc.Open();

            XMLWorkerHelper.GetInstance().ParseXHtml(writer, pdfDoc, sr);
            //XMLWorkerHelper htmlparser = new HTMLWorker(pdfDoc);
            Response.Write(pdfDoc);
        }
        Response.End();
    }

    public void ExcelClick(object sender, EventArgs e)
    {
        throw new Exception("ExcelClick");
    }

}