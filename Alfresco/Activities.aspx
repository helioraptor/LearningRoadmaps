<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Activities.aspx.cs" Inherits="Onboarding_Client_Activities" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link type="text/css" rel="Stylesheet" href="Style.css" />
</head>
<body>
    <form id="form1" runat="server">

    <center>
	<a href="index.html"><img src="img/Logo.png" border="none" width="600px" /></a>

		<br/><br/>
		<button style="width:150px;" onclick="window.print();"><img src="img/print.png" style="vertical-align:middle;"> Print</button>
		<button style="width:150px;"><img src="img/excel.png" style="vertical-align:middle;"> Export to Excel</button>
		<button style="width:150px;"><img src="img/pdf.png" style="vertical-align:middle;"> Export to PDF</button>
	

    <table cellpadding="0" cellspacing="0" border="0" width="100%" style="margin-right:50px" >
        <tr>
            <td style="width:50%">
                &nbsp;
            </td>
            <td style="width:50%">
        <table width="100%">
    	<tr>
			<td style="text-align:right; font-weight:bold; font-size:12px; border:hidden;">Name:</td>
			<td colspan="2" style="border-top:none; border-left:none; border:hidden; text-align:left; font-weight:bold; font-size:12px;"><span id="Span1"/></td>
			<td  style="border-top:none; border-left:none; border:hidden;"></td>
			<td  style="text-align:right; font-weight:bold; font-size:12px; border-top:none; border-left:none; border:hidden;">Plan Date:</td>
			<td style="border-top:none; border-left:none; border:hidden; font-weight:bold; font-size:12px;"><span id="Span2">09/10/2015</span></td>
		</tr>
		<tr>
			<td style="text-align:right; font-weight:bold; font-size:12px; border-top:hidden; border-left:hidden;">Role:</td>
			<td style="border-top:none; border-left:none; border-top:hidden; border-left:hidden;  text-align:left; font-weight:bold; font-size:12px;" colspan="2"><span id="Span3"/></td>
			<td style="border-top:0; border-left:none; border-top:hidden; border-left:hidden;"></td>
			<td style="text-align:right; font-weight:bold; font-size:12px; border-top:hidden; border-left:hidden;">Duration:</td>
			<td style="border-top:none; border-left:none; border-top:hidden; border-left:hidden; border-right:hidden; font-weight:bold; font-size:12px;"><span id="Span4">12 weeks</span></td>
		</tr>
    </table>
            </td>
        </tr>
    </table>
    </center>

    <asp:GridView ID="gvActivites"  runat="server" AutoGenerateColumns="false" CssClass="TableActivities" HeaderStyle-CssClass="TableActivitiesHeader" GridLines="None">
        <Columns>
                        <asp:TemplateField HeaderText="Learning Activity Detail">
                        <ItemTemplate>
                            <asp:Label runat="server" Text='<%# Eval("Content") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Topic Category">
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

                    <asp:TemplateField HeaderText="Onboarding Day">
                        <ItemTemplate>
                            <asp:Label  runat="server" Text='<%# Eval("Day") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Complete?">
                        <ItemTemplate>
                            &nbsp;
                        </ItemTemplate>
                    </asp:TemplateField>
         </Columns>
    </asp:GridView>

    </form>
</body>
</html>
