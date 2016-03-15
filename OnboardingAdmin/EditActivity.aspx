<%@ Page Language="C#" AutoEventWireup="true" CodeFile="EditActivity.aspx.cs" Inherits="Onboarding_EditActivity"  MasterPageFile="Onboarding.master" ValidateRequest="false"  %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script src="//cdn.tinymce.com/4/tinymce.min.js"></script>
    <script>        tinymce.init({ selector: '.HtmlEditor'
                                    ,plugins: "link" });</script>
    <a href="default.aspx">home</a>
    <H1>Edit Activity</H1>

    <table>
        <tr>
            <td style="vertical-align:top; padding:10px;">Content</td>
            <td style="vertical-align:top; padding:10px;"><asp:TextBox ID="txtContent" runat="server" Width="600" Height="200" TextMode="MultiLine" CssClass="HtmlEditor"></asp:TextBox></td>
        </tr>
        <tr>
            <td style="vertical-align:top; padding:10px;">Topic Category</td>
            <td style="vertical-align:top; padding:10px;"><asp:TextBox ID="txtTopic" runat="server" Width="200"></asp:TextBox></td>
        </tr>
        <tr>
            <td style="vertical-align:top; padding:10px;">Onboarding Week</td>
            <td style="vertical-align:top; padding:10px;"><asp:TextBox ID="txtWeek" runat="server" Width="200"></asp:TextBox></td>
        </tr>
        <tr>
            <td style="vertical-align:top; padding:10px;">Onboarding Day</td>
            <td style="vertical-align:top; padding:10px;"><asp:TextBox ID="txtDay" runat="server" Width="200"></asp:TextBox></td>
        </tr>
        <tr>
            <td style="vertical-align:top; padding:10px;">Est.Time</td>
            <td style="vertical-align:top; padding:10px;"><asp:TextBox ID="txtTime" runat="server" Width="200"></asp:TextBox></td>
        </tr>
        <tr>
            <td style="vertical-align:top; padding:10px;">&nbsp;</td>
            <td style="vertical-align:top; padding:10px;"><asp:Button ID="btnSave" runat="server" Text="Update" OnClick="btnUpdate_Click"/>
        </tr>
        <tr>
            <td style="vertical-align:top; padding:10px;">Conditions</td>
            <td><asp:GridView runat="server" ID="gvConditions" AutoGenerateColumns="False" ShowHeader="false" CellPadding="10" GridLines="None">
                <Columns>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:LinkButton ID="LinkButton1" runat="server" OnClick="btnDeleteCondition_Click" CommandArgument='<%# Eval("Id") %>' Text="Delete"></asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:HyperLinkField Text="Edit" DataNavigateUrlFields="Id" DataNavigateUrlFormatString="EditCondition.aspx?Id={0}" />
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:LinkButton ID="LinkButton2" runat="server" OnClick="btnUpCondition_Click" CommandArgument='<%# Eval("Id") %>' Text="Up"></asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:LinkButton ID="LinkButton3" runat="server" OnClick="btnDownCondition_Click" CommandArgument='<%# Eval("Id") %>' Text="Down"></asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField  DataField="QuestionName" />
                    <asp:BoundField  DataField="Tags" />
                </Columns>
            </asp:GridView>
           <div style="padding:10px" ><asp:LinkButton ID="btnAddQuestion" runat="server" OnClick="btnAddCondition_Click" Text="Add New Condition &gt;&gt;" /></div>
            </td>
        </tr>
    </table>

    
</asp:Content>
