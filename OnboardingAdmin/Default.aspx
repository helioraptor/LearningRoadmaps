<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="Onboarding_Default" MasterPageFile="Onboarding.master" %>

<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <a href="default.aspx">home</a>
    <H1>Clients</H1>
    <asp:GridView ID="gvClients" runat="server" AutoGenerateColumns="false">
        <Columns>
            <asp:BoundField DataField="Name" HeaderText="Name" />
            <asp:BoundField DataField="Email" HeaderText="Email" />
            <asp:HyperLinkField DataNavigateUrlFields="ID" DataNavigateUrlFormatString="Client.aspx?ID={0}" HeaderText="Admin View" Text="edit" /> 
            <asp:HyperLinkField DataNavigateUrlFields="Name" DataNavigateUrlFormatString="../{0}/Default.aspx" HeaderText="Client View" Text="view" /> 
        </Columns>
    </asp:GridView>
</asp:Content>
