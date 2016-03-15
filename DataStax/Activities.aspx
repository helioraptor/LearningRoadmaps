<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Activities.aspx.cs" Inherits="Onboarding_Client_Activities" EnableEventValidation = "false"  %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link type="text/css" rel="Stylesheet" href="Style.css" />
</head>
<body>
    <form id="form1" runat="server">

    <center>
	<a href="Default.aspx"><asp:Image ImageUrl="img/Logo.png" border="none" width="600px" runat="server" ID="imgLogo" /></a>

		<br/><br/>
		<button style="width:150px;" onclick="window.print();" runat="server" id="btnPrint"><img src="img/print.png" style="vertical-align:middle;"> Print</button>
		<button style="width:150px;" onserverclick="ExcelClick" runat="server" id="btnExcel"><img src="img/excel.png" style="vertical-align:middle;"> Export to Excel</button>
		<button style="width:150px;" onserverclick="PdfClick" runat="server" id="btnPdf"><img src="img/pdf.png" style="vertical-align:middle;"> Export to PDF</button>

        <asp:LinkButton ID="l1" runat="server"></asp:LinkButton>

    <table cellpadding="0" cellspacing="0" border="0" width="100%" style="margin-right:50px" >
        <tr>
            <td style="width:50%">
                &nbsp;
            </td>
            <td style="width:50%">
        <table width="100%">
    	<tr>
			<td style="text-align:right; font-weight:bold; font-size:12px; border:hidden;">Name:</td>
			<td colspan="2" style="border-top:none; border-left:none; border:hidden; text-align:left; font-weight:bold; font-size:12px;"><asp:Label ID="lblName" runat="server" name="lblName"/></td>
			<td  style="border-top:none; border-left:none; border:hidden;"></td>
			<td  style="text-align:right; font-weight:bold; font-size:12px; border-top:none; border-left:none; border:hidden;">Plan Date:</td>
			<td style="border-top:none; border-left:none; border:hidden; font-weight:bold; font-size:12px;"><asp:Label runat="server" id="lblPlanDate" name="lblPlanDate"/></td>
		</tr>
		<tr>
			<td style="text-align:right; font-weight:bold; font-size:12px; border-top:hidden; border-left:hidden;">Role:</td>
			<td style="border-top:none; border-left:none; border-top:hidden; border-left:hidden;  text-align:left; font-weight:bold; font-size:12px;" colspan="2"><asp:Label ID="lblEmail" runat="server" name="lblEmail"/></td>
			<td style="border-top:0; border-left:none; border-top:hidden; border-left:hidden;"></td>
			<td style="text-align:right; font-weight:bold; font-size:12px; border-top:hidden; border-left:hidden;">Duration:</td>
			<td style="border-top:none; border-left:none; border-top:hidden; border-left:hidden; border-right:hidden; font-weight:bold; font-size:12px;"><asp:Label ID="lblDuration" runat="server" name="lblDuration" Text="12 weeks"/></td>
		</tr>
    </table>
            </td>
        </tr>
    </table>
    

    <asp:GridView ID="gvActivites"  runat="server" AutoGenerateColumns="false" CssClass="TableActivities" HeaderStyle-CssClass="TableActivitiesHeader" GridLines="None">
        <Columns>
                        <asp:TemplateField HeaderText="Learning Activity Detail" ControlStyle-Width="500px">
                        <ItemTemplate>
                            <asp:Label runat="server" Text='<%# Eval("Content") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Topic Category" ControlStyle-Width="100px">
                        <ItemTemplate>
                            <asp:Label  runat="server" Text='<%# Eval("Topic") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Onboarding Week">
                        <ItemTemplate>
                            <asp:Label  runat="server" Text='<%# Eval("Week") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>

                   <asp:TemplateField HeaderText="Est. Time for Activity">
                        <ItemTemplate>
                            <asp:Label ID="Label1"  runat="server" Text='<%# Eval("Time") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Complete?">
                        <ItemTemplate>
                            &nbsp;
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Notes">
                        <ItemTemplate>
                            &nbsp;
                        </ItemTemplate>
                    </asp:TemplateField>
         </Columns>
    </asp:GridView>
    </center>

    </form>
</body>
</html>
