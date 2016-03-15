<%@ Page Language="C#" AutoEventWireup="true" CodeFile="EditLandingPage.aspx.cs" Inherits="Onboarding_EditLandingPage"  MasterPageFile="Onboarding.master" ValidateRequest="False" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script src="//cdn.tinymce.com/4/tinymce.min.js"></script>
    <script>        tinymce.init({ selector: '.HtmlEditor'
                                    , plugins: "link image"
        });</script>

    <a href="default.aspx">home</a>
    <H1>Edit Option</H1>

    <table>
        <tr>
            <td style="vertical-align:top; padding:10px;">Name</td>
            <td style="vertical-align:top; padding:10px;"><asp:TextBox ID="txtName" runat="server" Width="200"></asp:TextBox></td>
        </tr>
        <tr>
            <td style="vertical-align:top; padding:10px;">Visible if</td>
            <td style="vertical-align:top; padding:10px;"><asp:TextBox ID="txtShow" runat="server" Width="200"></asp:TextBox></td>
        </tr>
        <tr>
            <td style="vertical-align:top; padding:10px;">Content</td>
            <td style="vertical-align:top; padding:10px;"><asp:TextBox ID="txtContent" runat="server" Width="200" CssClass="HtmlEditor"></asp:TextBox></td>
        </tr>
        <tr>
            <td style="vertical-align:top; padding:10px;">&nbsp;</td>
            <td style="vertical-align:top; padding:10px;"><asp:Button ID="btnSave" runat="server" Text="Update" OnClick="btnUpdate_Click"/>
        </tr>
    </table>

    
</asp:Content>
