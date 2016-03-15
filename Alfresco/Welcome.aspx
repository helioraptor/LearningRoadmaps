<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Welcome.aspx.cs" Inherits="Onboarding_Client_Welcome" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link type="text/css" rel="Stylesheet" href="Style.css" />
</head>
<body>

<div style="text-align: center; ">
    <form id="form1" runat="server">
	<div style="margin-bottom: 0px; margin-left: auto; margin-right: auto; margin-top: 0px; overflow: hidden; position: relative; word-wrap: break-word;  background: transparent; text-align: center; width:800px;" id="body_content">
		<table cellspacing="0" cellpadding="0" border="0" width="100%">
			<tr>
				<td rowspan="2">
					<img src="img/Logo.png" width="400px" border="none" />
				</td>
				<td class="header">
					Onboarding Program Overview
				</td>
			</tr>
			<td  class="subheader"><asp:Label runat="server" ID="lblLanding"></asp:Label></td>
			<tr>
			</tr>
		</table>

        <div class="Content">
		<asp:Label runat="server" ID="lblContent"></asp:Label>
        </div>

		<asp:Button ID="btnNext" runat="server" OnClick="btnNext_Click" Text="Continue" />
        </div>
        </form>
</div>


</body>
</html>
