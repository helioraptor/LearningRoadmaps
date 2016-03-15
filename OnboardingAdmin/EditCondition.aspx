<%@ Page Language="C#" AutoEventWireup="true" CodeFile="EditCondition.aspx.cs" Inherits="Onboarding_EditCondition"  MasterPageFile="Onboarding.master" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <a href="default.aspx">home</a>
    <H1>Edit Condition</H1>

    <table>
        <tr>
            <td style="vertical-align:top; padding:10px;">Question</td>
            <td style="vertical-align:top; padding:10px;"><asp:DropDownList ID="cbQuestions" DataTextField="Name" DataValueField="id" runat="server"></asp:DropDownList></td>
        </tr>
                <tr>
            <td style="vertical-align:top; padding:10px;">Tags</td>
            <td style="vertical-align:top; padding:10px;">
            <asp:GridView ID="gvOptions" runat="server" AutoGenerateColumns="false" ShowHeader="false" GridLines="None" OnRowDataBound="gvOptions_RowDataBound">
                <Columns>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:CheckBox id="cb1" runat="server" ></asp:CheckBox>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:Label ID="l1" runat="server" Text='<%# Eval("Name") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
            </td>
        </tr>
        <tr>
            <td style="vertical-align:top; padding:10px;">&nbsp;</td>
            <td style="vertical-align:top; padding:10px;"><asp:Button ID="btnSave" runat="server" Text="Update" OnClick="btnUpdate_Click"/>
        </tr>
    </table>

    
</asp:Content>
