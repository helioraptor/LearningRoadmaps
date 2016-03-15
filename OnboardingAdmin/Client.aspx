<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Client.aspx.cs" Inherits="Onboarding_Client" MasterPageFile="Onboarding.master" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <a href="default.aspx">home</a>
    <H1>Edit Client Settings</H1>

    <table>
        <tr>
            <td style="vertical-align:top; padding:10px;">Name</td>
            <td><asp:TextBox ID="txtName" runat="server" Width="200px"/></td>
        </tr>
        <tr>
            <td style="vertical-align:top; padding:10px;">Email</td>
            <td><asp:TextBox ID="txtEmail" runat="server" Width="200px"/></td>
        </tr>
        <tr>
            <td style="vertical-align:top; padding:10px;">&nbsp;</td>
            <td><asp:Button ID="btnSave" runat="server" Text="Update" OnClick="btnUpdate_Click"/>&nbsp;<a href="#">Preview</a></td>
        </tr>
        <tr>
            <td style="vertical-align:top; padding:10px;">Questions</td>
            <td>
              <asp:GridView runat="server" ID="gvQuestions" AutoGenerateColumns="False" ShowHeader="false" CellPadding="10" GridLines="None">
                <Columns>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:LinkButton runat="server" OnClick="btnDeleteQuestion_Click" CommandArgument='<%# Eval("Id") %>' Text="Delete"></asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:HyperLinkField Text="Edit" DataNavigateUrlFields="Id" DataNavigateUrlFormatString="EditQuestion.aspx?Id={0}" />
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:LinkButton runat="server" OnClick="btnUpQuestion_Click" CommandArgument='<%# Eval("Id") %>' Text="Up"></asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:LinkButton runat="server" OnClick="btnDownQuestion_Click" CommandArgument='<%# Eval("Id") %>' Text="Down"></asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField  DataField="Name" />
                    <asp:BoundField  DataField="Visible" />
                    <asp:BoundField  DataField="Hidden" />
                </Columns>
            </asp:GridView>
            <div style="padding:10px" ><asp:LinkButton ID="btnAddQuestion" runat="server" OnClick="btnAddQuestion_Click" Text="Add New Question &gt;&gt;" /></div>
            </td>
        </tr>

        <tr>
            <td style="vertical-align:top; padding:10px;">Allow navigation</td>
            <td>
                <asp:TextBox runat="server" ID="txtNext"></asp:TextBox>
            </td>
        </tr>

        <tr>
            <td style="vertical-align:top; padding:10px;">Landing pages</td>
            <td>
               <asp:GridView runat="server" ID="gvLandingPages" AutoGenerateColumns="False" ShowHeader="false" CellPadding="10" GridLines="None">
                <Columns>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:LinkButton runat="server" OnClick="btnDeleteLandingPage_Click" CommandArgument='<%# Eval("Id") %>' Text="Delete"></asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:HyperLinkField Text="Edit" DataNavigateUrlFields="Id" DataNavigateUrlFormatString="EditLandingPage.aspx?Id={0}" />
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:LinkButton runat="server" OnClick="btnUpLandingPage_Click" CommandArgument='<%# Eval("Id") %>' Text="Up"></asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:LinkButton runat="server" OnClick="btnDownLandingPage_Click" CommandArgument='<%# Eval("Id") %>' Text="Down"></asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField  DataField="Name" />
                    <asp:BoundField  DataField="Visible" />
                </Columns>
            </asp:GridView>
            <div style="padding:10px" ><asp:LinkButton ID="LinkButton3" runat="server" OnClick="btnAddLandingPage_Click" Text="Add New Landing Page &gt;&gt;" /></div>
        </td>
        </tr>
        <tr>
            <td style="vertical-align:top; padding:10px;">Activities</td>
            <td>
            <div style="padding:10px" ><asp:LinkButton runat="server" OnClick="btnAddActivity_Click" Text="Edit Activities &gt;&gt;" /></div>
            </td>
        </tr>
    </table>
</asp:Content>
