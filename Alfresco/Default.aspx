<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="Onboarding_Client_Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link type="text/css" rel="Stylesheet" href="Style.css" />
</head>
<body>
    <form id="form1" runat="server">
    <div>

          <div style="margin-bottom: 0px; margin-left: auto; margin-right: auto; margin-top: 0px; overflow: hidden; position: relative; word-wrap: break-word;  background: transparent; text-align: center; width:800px;" id="body_content">
	<img src="img/Logo.png" width="500px" border="none" />
	<p style="font-size:12px;">

	The goal of the Learning Roadmap is to enhance productivity for all colleagues roles.
This tool produces a customized learning plan based on your role, location and experience level. 
Please answer the questions below to begin building your learning roadmap.
 It will serve as your guide and help enhance your skills and success.	
	</p>



     <asp:GridView ID="gvQuestions" runat="server" OnRowDataBound="gvQuestions_RowDataBound" AutoGenerateColumns="false" GridLines="None"  ShowHeader="false" >
        <Columns>
            <asp:BoundField DataField="Name" ItemStyle-CssClass="caption"  />
            <asp:TemplateField ItemStyle-CssClass="control">
                <ItemTemplate>
                    <asp:HiddenField ID="hiddenQuestionId" runat="server" />
                    <asp:DropDownList id="ddlOptions" runat="server" 
                            DataTextField="Name"
                            DataValueField="Tag"
                            OnSelectedIndexChanged="ddlOptionSelectedIndexChanged" 
                            AutoPostBack="true"></asp:DropDownList>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
     </asp:GridView>

     <asp:Button ID="btnNext" runat="server" OnClick="btnNext_Click" Text="Next" />
    </div>
    </form>
</body>
</html>
