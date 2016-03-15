<%@ Page Language="C#" AutoEventWireup="true" CodeFile="EditOption.aspx.cs" Inherits="Onboarding_EditOption"  MasterPageFile="Onboarding.master" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <a href="default.aspx">home</a>
    <H1>Edit Option</H1>

    <table>
        <tr>
            <td style="vertical-align:top; padding:10px;">Name</td>
            <td style="vertical-align:top; padding:10px;"><asp:TextBox ID="txtName" runat="server" Width="200"></asp:TextBox></td>
        </tr>
        <tr>
            <td style="vertical-align:top; padding:10px;">Tag</td>
            <td style="vertical-align:top; padding:10px;"><asp:TextBox ID="txtTag" runat="server" Width="200"></asp:TextBox></td>
        </tr>
        <tr>
            <td style="vertical-align:top; padding:10px;">Visible if</td>
            <td style="vertical-align:top; padding:10px;"><asp:TextBox ID="txtShow" runat="server" Width="200"></asp:TextBox></td>
        </tr>
        <tr>
            <td style="vertical-align:top; padding:10px;">Hidden if</td>
            <td style="vertical-align:top; padding:10px;"><asp:TextBox ID="txtHide" runat="server" Width="200"></asp:TextBox></td>
        </tr>
        <tr>
            <td style="vertical-align:top; padding:10px;">&nbsp;</td>
            <td style="vertical-align:top; padding:10px;"><asp:Button ID="btnSave" runat="server" Text="Update" OnClick="btnUpdate_Click"/>
        </tr>
    </table>

    
</asp:Content>
