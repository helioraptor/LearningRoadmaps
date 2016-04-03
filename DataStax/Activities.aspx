<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Activities.aspx.cs" Inherits="Onboarding_Client_Activities" EnableEventValidation = "false"  %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link type="text/css" rel="Stylesheet" href="Style.css" />
    <style>
        body {
		font-family: Helvetica Neue,Helvetica,Arial,sans-serif ;
		font-size:13px; 
		}

		td.caption{
		color: rgb(0,178,90);
		font-weight:bold;
		text-align:right;
		padding:10px;
		}

		td.control{
		text-align:left;
		font-weight:bold;
		width:400px;
		}

		td.control input,select{
		width:300px;
		}

		td.header {
		color: rgb(0,178,90);
		font-weight:bold;
		font-size:20pt;
		}

		td.subheader {
		color: rgb(0,178,90);
		font-size:18pt;
		}

		H3 {
			font-size:12px;
		}
		
div.Content	
{
    text-align:left;
    font-size:12px;
}	

    td.activity{
		border: solid 1px grey;
		padding:5px;
	}

	tr td.activity:first-child {
		text-align:left;
	}

.TableActivities
{
   font-size:12px; 
   border:solid 1px grey; 
   margin-left:20px; 
   margin-right:20px; 
   padding:0px; 
   border-collapse:collapse;
}

.TableActivitiesHeader
{
    background-color:#007DC3;
    font-weight:bold;
    color:white; 
    font-size:12px; 
    text-align:center;
}

tr.TableActivitiesHeader th
{
    padding:10px;
}

table.TableActivities tr td
{
    border:solid 1px grey;
    padding:3px;
}

    </style>

<script
			  src="https://code.jquery.com/jquery-2.2.2.min.js"
			  integrity="sha256-36cp2Co+/62rEAAYHLmRCPIych47CvdM+uTBJwSzWjI="
			  crossorigin="anonymous"></script>

<script type="text/javascript">
    function CheckBoxCheck(checkBox, id) {
        //alert(checkBox.checked);
        //alert(id);
        $.get("SelectActivity.aspx?id=" + id + "&checked=" + checkBox.checked);
    }
</script>
</head>
<body style="width:100%">
    <form id="form1" runat="server" style="width:100%;">
    <div style="margin:auto; width:60%; text-align:center;">

   
    <img src="http://learningroadmaps.com/DataStax/img/Logo.png" alt="LOGO" width="600" style="border:none;cursor:pointer;" align="middle" onclick="window.location='Default.aspx';" />
   
		<br/><br/>
		<button style="width:150px;" onclick="window.print();" runat="server" id="btnPrint"><img src="img/print.png" style="vertical-align:middle;"> Print</button>

        <!--
		<button style="width:150px;" onserverclick="ExcelClick" runat="server" id="btnExcel"><img src="img/excel.png" style="vertical-align:middle;"> Export to Excel</button>
		-->
        
        <button style="width:150px;" onserverclick="PdfClick" runat="server" id="btnPdf"><img src="img/pdf.png" style="vertical-align:middle;"> Export to PDF</button>
 
        <asp:LinkButton ID="l1" runat="server"></asp:LinkButton>


        <table border="0">
        <tr>
        <td style="width:50%">&nbsp;</td>
        <td>

        <table width="400px" border="0" style="margin-right:0px; font-weight:bold;">
    	<tr>
			<td style="text-align:right">Name:</td>
            <td style="text-align:left" width="100"><asp:Label ID="lblName" runat="server" name="lblName"/></td>

			<td style="text-align:right">Plan Date:</td>
            <td style="text-align:left" width="100"><asp:Label runat="server" id="lblPlanDate" name="lblPlanDate"/></td>

		</tr>
		<tr>
			<td style="text-align:right">Role:</td>
            <td style="text-align:left"><asp:Label ID="lblEmail" runat="server" name="lblEmail"/></td>

			<td style="text-align:right">Duration:</td>
            <td style="text-align:left"><asp:Label ID="lblDuration" runat="server" name="lblDuration" Text="12 weeks"/></td>
		</tr>
        </table>
      
        </td>
        </tr>
        </table>
      

    <asp:GridView ID="gvActivites"  runat="server" AutoGenerateColumns="false" CssClass="TableActivities" HeaderStyle-CssClass="TableActivitiesHeader" GridLines="None">
        <Columns>
                        <asp:TemplateField HeaderText="Learning Activity Detail" ItemStyle-HorizontalAlign="left" ItemStyle-Width="50%">
                        <ItemTemplate>
                        <div style="text-align:left">
                            <%# Eval("Content") %>
</div>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Category">
                        <ItemTemplate>
                            <%# Eval("Topic") %>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Week">
                        <ItemTemplate>
                            <%# Eval("Week") %>
                        </ItemTemplate>
                    </asp:TemplateField>

                   <asp:TemplateField HeaderText="Duration">
                        <ItemTemplate>
                            <%# Eval("Time") %>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Complete?">
                        <ItemTemplate>
                            <asp:CheckBox ID="cb1" runat="server" onclick='<%# Eval("Id","CheckBoxCheck(this,{0})") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Notes" ItemStyle-Width="20%">
                        <ItemTemplate>
                            &nbsp;
                        </ItemTemplate>
                    </asp:TemplateField>
         </Columns>
    </asp:GridView>

    </div>
    </form>
</body>
</html>
