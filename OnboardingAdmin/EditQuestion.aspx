<%@ Page Language="C#" AutoEventWireup="true" CodeFile="EditQuestion.aspx.cs" Inherits="Onboarding_EditQuestion"  MasterPageFile="Onboarding.master" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <a href="default.aspx">home</a>
    <H1>Edit Question</H1>

    <table>
        <tr>
            <td style="vertical-align:top; padding:10px;">Name</td>
            <td style="vertical-align:top; padding:10px;"><asp:TextBox ID="txtName" runat="server" Width="200"></asp:TextBox></td>
        </tr>
        <tr>
            <td style="vertical-align:top; padding:10px;">Show if</td>
            <td style="vertical-align:top; padding:10px;"><asp:TextBox ID="txtShow" runat="server" Width="200"></asp:TextBox></td>
        </tr>
        <tr>
            <td style="vertical-align:top; padding:10px;">Hide if</td>
            <td style="vertical-align:top; padding:10px;"><asp:TextBox ID="txtHide" runat="server" Width="200"></asp:TextBox></td>
        </tr>
        <tr>
            <td style="vertical-align:top; padding:10px;">&nbsp;</td>
            <td style="vertical-align:top; padding:10px;"><asp:Button ID="btnSave" runat="server" Text="Update" OnClick="btnUpdate_Click"/>
        </tr>
        <tr>
            <td style="vertical-align:top; padding:10px;">Options</td>
            <td><asp:GridView runat="server" ID="gvOptions" AutoGenerateColumns="False" ShowHeader="false" CellPadding="10" GridLines="None">
                <Columns>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:LinkButton runat="server" OnClick="btnDeleteOption_Click" CommandArgument='<%# Eval("Id") %>' Text="Delete"></asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:HyperLinkField Text="Edit" DataNavigateUrlFields="Id" DataNavigateUrlFormatString="EditOption.aspx?Id={0}" />
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:LinkButton runat="server" OnClick="btnUpOption_Click" CommandArgument='<%# Eval("Id") %>' Text="Up"></asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:LinkButton ID="LinkButton3" runat="server" OnClick="btnDownOption_Click" CommandArgument='<%# Eval("Id") %>' Text="Down"></asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField  DataField="Name" />
                    <asp:BoundField  DataField="Visible" />
                    <asp:BoundField  DataField="Hidden" />
                </Columns>
            </asp:GridView>
           <div style="padding:10px" ><asp:LinkButton ID="btnAddQuestion" runat="server" OnClick="btnAddOption_Click" Text="Add New Option &gt;&gt;" /></div>
            </td>
        </tr>

    </table>

    
</asp:Content>
