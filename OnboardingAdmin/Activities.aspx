<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Activities.aspx.cs" Inherits="Onboarding_Activities" MasterPageFile="Onboarding.master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <a href="default.aspx">home</a>
    <H1>Edit Activities</H1>

    <asp:GridView runat="server" ID=gvActivities AutoGenerateColumns="false">
        <Columns>
                    <asp:TemplateField HeaderText="Content">
                        <ItemTemplate>
                            <asp:Label runat="server" Text='<%# Eval("Content") %>' />
                 
                            <br/>    
                            <asp:LinkButton ID="LinkButton5" runat="server" OnClick="btnEditActivity_Click" Text="Edit" CommandArgument='<%# Eval("Id") %>'  />         
                            <asp:LinkButton ID="LinkButton2" runat="server" OnClick="btnDeleteActivity_Click" CommandArgument='<%# Eval("Id") %>' Text="Delete"></asp:LinkButton>
                            <asp:LinkButton ID="LinkButton3" runat="server" OnClick="btnUpActivity_Click" CommandArgument='<%# Eval("Id") %>' Text="Up"></asp:LinkButton>
                            <asp:LinkButton ID="LinkButton4" runat="server" OnClick="btnDownActivity_Click" CommandArgument='<%# Eval("Id") %>' Text="Down"></asp:LinkButton>
                            
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Topic">
                        <ItemTemplate>
                            <asp:Label  runat="server" Text='<%# Eval("Topic") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Week">
                        <ItemTemplate>
                            <asp:Label  runat="server" Text='<%# Eval("Week") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Day">
                        <ItemTemplate>
                            <asp:Label  runat="server" Text='<%# Eval("Day") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Time">
                        <ItemTemplate>
                            <asp:Label  runat="server" Text='<%# Eval("Time") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>

        </Columns>
    </asp:GridView><br/>

    <asp:LinkButton ID="LinkButton1" runat="server" OnClick="btnAddActivity_Click" Text="Add Activity &gt;&gt;" />



</asp:Content>