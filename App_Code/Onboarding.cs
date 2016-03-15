using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

/// <summary>
/// Summary description for Onboarding
/// </summary>
public class Onboarding
{
	public Onboarding()
	{
		//
		// TODO: Add constructor logic here
		//
	}

    [Serializable]
    public class Selection
    {
        public Selection(int QuestionID, string Tag)
        {
            this.QuestionID = QuestionID;
            this.Tag = Tag;
        }
        public int QuestionID { get; set; }
        public string Tag { get; set; }
    }

    public static string GetString(SqlDataReader dr, string field)
    {
        int i = dr.GetOrdinal(field);
        return dr.IsDBNull(i) ? "" : dr.GetString(i);
    }

    public static int GetInt(SqlDataReader dr, string field)
    {
        int i = dr.GetOrdinal(field);
        return dr.IsDBNull(i) ? 0 : dr.GetInt32(i);
    }

    public class Client {
        public int Id {get;set;}
        public string Name {get;set;}
        public string Email { get; set; }
        public string allowNext { get; set; }
    }

    [Serializable]
    public class LandingPage
    {
        public LandingPage()
        {
            Name = "New Landing Page";
        }
        public int Id { get; set; }
        public int ClientId { get; set; }
        public string Name { get; set; }
        public string Visible { get; set; }
        public string Content { get; set; }
    }

    [Serializable]
    public class Activity
    {
        public Activity()
        {
            Name = "New Activity";
        }
        public int Id { get; set; }
        public int ClientId { get; set; }
        public string Name { get; set; }
        public string Visible { get; set; }
        public string Hidden { get; set; }
        public string Content { get; set; }
        public string Topic { get; set; }
        public string Week { get; set; }
        public string Day { get; set; }
        public string Time { get; set; } 
    }

    [Serializable]
    public class Question
    {
        public Question()
        {
            Name = "New Question";
            Id = 42;
        }
        public int Id { get; set; }
        public int ClientId { get; set; }
        public string Name { get; set; }
        public string Visible { get; set; }
        public string Hidden { get; set; }
    }

    [Serializable]
    public class Option
    {
        public Option()
        {
            Name = "New Question";
            Tag = "NEW";
            Id = 42;
        }
        public int Id { get; set; }
        public int QuestionId { get; set; }
        public string Name { get; set; }
        public string Tag { get; set; }
        public string Visible { get; set; }
        public string Hidden { get; set; }
        public Boolean Selected { get; set; }

    }

    [Serializable]
    public class Condition
    { 
        public int Id { get; set; }
        public int idActivity { get; set; }
        public string QuestionName { get; set; }
        public int idQuestion { get; set; }
        public string Tags { get; set; }
        public string isNegative { get; set; }
    }

    public static List<Client> GetClients(){
        List<Client> result = new List<Client>();
        string cs = ConfigurationManager.ConnectionStrings["mdf"].ConnectionString;
        using (SqlConnection dbConnection = new SqlConnection(cs))
        {
            dbConnection.Open();
            SqlCommand myCommand = new SqlCommand("Select ID,Name,Email,allowNext from obClient");
            myCommand.Connection = dbConnection;
            myCommand.CommandType = CommandType.Text;
            using (SqlDataReader dr = myCommand.ExecuteReader())
            {
                while (dr.Read())
                {
                    Client client = new Client();
                    client.Id = dr.GetInt32(dr.GetOrdinal("ID"));
                    client.Name = dr.GetString(dr.GetOrdinal("Name"));
                    client.Email = dr.GetString(dr.GetOrdinal("Email"));
                    client.allowNext = GetString(dr,"allowNext");
                    result.Add(client);
                }
            }
        }
        return result;
    }
    public static Client GetClient(int ID)
    {
        List<Client> result = new List<Client>();
        string cs = ConfigurationManager.ConnectionStrings["mdf"].ConnectionString;
        using (SqlConnection dbConnection = new SqlConnection(cs))
        {
            dbConnection.Open();
            SqlCommand myCommand = new SqlCommand("Select ID,Name,Email,allowNext from obClient where id = @id");
            myCommand.Connection = dbConnection;
            myCommand.CommandType = CommandType.Text;
            myCommand.Parameters.AddWithValue("@id", ID.ToString());
            using (SqlDataReader dr = myCommand.ExecuteReader())
            {
                while (dr.Read())
                {
                    Client c = new Client();
                    c.Id = dr.GetInt32(dr.GetOrdinal("ID"));
                    c.Name = dr.GetString(dr.GetOrdinal("Name"));
                    c.Email = dr.GetString(dr.GetOrdinal("Email"));
                    c.allowNext = GetString(dr,"allowNext");
                    result.Add(c);
                }
            }
        }
        return result.FirstOrDefault();
    }

    public static void SetClient(Client o)
    {
        string cs = ConfigurationManager.ConnectionStrings["mdf"].ConnectionString;
        using (SqlConnection dbConnection = new SqlConnection(cs))
        {
            dbConnection.Open();
            SqlCommand myCommand = new SqlCommand("Update obClient set Name = @Name,Email = @Email, allowNext=@allowNext where id = @id");
            myCommand.Connection = dbConnection;
            myCommand.CommandType = CommandType.Text;
            myCommand.Parameters.AddWithValue("@id", o.Id.ToString());
            myCommand.Parameters.AddWithValue("@Name", o.Name.ToString());
            myCommand.Parameters.AddWithValue("@Email", o.Email.ToString());
            myCommand.Parameters.AddWithValue("@allowNext", o.allowNext.ToString());
            myCommand.ExecuteNonQuery();
        }
    }

    public static List<LandingPage> GetLandingPages(int ClientID) {
        List<LandingPage> result = new List<LandingPage>();
        string cs = ConfigurationManager.ConnectionStrings["mdf"].ConnectionString;
        using (SqlConnection dbConnection = new SqlConnection(cs))
        {
            dbConnection.Open();
            SqlCommand myCommand = new SqlCommand("Select ID,Name,Visible,Content from obLandingPage where idClient = @idClient  order by SortOrder, id");
            myCommand.Connection = dbConnection;
            myCommand.CommandType = CommandType.Text;
            myCommand.Parameters.AddWithValue("@idClient", ClientID.ToString());
            using (SqlDataReader dr = myCommand.ExecuteReader())
            {
                while (dr.Read())
                {
                    LandingPage c = new LandingPage();
                    c.Id = dr.GetInt32(dr.GetOrdinal("ID"));
                    c.Name = dr.GetString(dr.GetOrdinal("Name"));
                    c.Visible = dr.GetString(dr.GetOrdinal("Visible"));
                    c.Content = GetString(dr,"Content");
                    result.Add(c);
                }
            }
        }
        return result;
    }
    public static LandingPage GetLandingPage(int ID)
    {
        List<LandingPage> result = new List<LandingPage>();
        string cs = ConfigurationManager.ConnectionStrings["mdf"].ConnectionString;
        using (SqlConnection dbConnection = new SqlConnection(cs))
        {
            dbConnection.Open();
            SqlCommand myCommand = new SqlCommand("Select ID,Name,Visible,Content,idClient from obLandingPage where id = @id");
            myCommand.Connection = dbConnection;
            myCommand.CommandType = CommandType.Text;
            myCommand.Parameters.AddWithValue("@id", ID.ToString());
            using (SqlDataReader dr = myCommand.ExecuteReader())
            {
                while (dr.Read())
                {
                    LandingPage c = new LandingPage();
                    c.Id = dr.GetInt32(dr.GetOrdinal("ID"));
                    c.Name = dr.GetString(dr.GetOrdinal("Name"));
                    c.Visible = dr.GetString(dr.GetOrdinal("Visible"));
                    c.Content = GetString(dr,"Content");
                    c.ClientId = dr.GetInt32(dr.GetOrdinal("idClient"));
                    result.Add(c);
                }
            }
        }
        return result.FirstOrDefault();
    }

    public static void SetLandingPage(LandingPage o)
    {
        string cs = ConfigurationManager.ConnectionStrings["mdf"].ConnectionString;
        using (SqlConnection dbConnection = new SqlConnection(cs))
        {
            dbConnection.Open();
            SqlCommand myCommand = new SqlCommand("Update obLandingPage set Name = @Name,Visible = @Visible, Content = @Content where id = @id");
            myCommand.Connection = dbConnection;
            myCommand.CommandType = CommandType.Text;
            myCommand.Parameters.AddWithValue("@id", o.Id.ToString());
            myCommand.Parameters.AddWithValue("@Name", o.Name.ToString());
            myCommand.Parameters.AddWithValue("@Visible", o.Visible.ToString());
            myCommand.Parameters.AddWithValue("@Content", o.Content.ToString());
            myCommand.ExecuteNonQuery();
        }
    }

    public static List<Question> GetQuestions(int ClientID)
    {
        List<Question> result = new List<Question>();
        string cs = ConfigurationManager.ConnectionStrings["mdf"].ConnectionString;
        using (SqlConnection dbConnection = new SqlConnection(cs))
        {
            dbConnection.Open();
            SqlCommand myCommand = new SqlCommand("Select ID,Name,Visible,Hidden from obQuestion where idClient = @idClient  order by SortOrder, id");
            myCommand.Connection = dbConnection;
            myCommand.CommandType = CommandType.Text;
            myCommand.Parameters.AddWithValue("@idClient", ClientID.ToString());
            using (SqlDataReader dr = myCommand.ExecuteReader())
            {
                while (dr.Read())
                {
                    Question c = new Question();
                    c.Id = dr.GetInt32(dr.GetOrdinal("ID"));
                    c.Name = dr.GetString(dr.GetOrdinal("Name"));
                    c.Visible = dr.GetString(dr.GetOrdinal("Visible"));
                    c.Hidden = dr.GetString(dr.GetOrdinal("Hidden"));
                    result.Add(c);
                }
            }
        }
        return result;
    }
    
    public static Question GetQuestion(int ID)
    {
        List<Question> result = new List<Question>();
        string cs = ConfigurationManager.ConnectionStrings["mdf"].ConnectionString;
        using (SqlConnection dbConnection = new SqlConnection(cs))
        {
            dbConnection.Open();
            SqlCommand myCommand = new SqlCommand("Select ID,Name,Visible,Hidden,idClient from obQuestion where id = @id");
            myCommand.Connection = dbConnection;
            myCommand.CommandType = CommandType.Text;
            myCommand.Parameters.AddWithValue("@id", ID.ToString());
            using (SqlDataReader dr = myCommand.ExecuteReader())
            {
                while (dr.Read())
                {
                    Question c = new Question();
                    c.Id = dr.GetInt32(dr.GetOrdinal("ID"));
                    c.Name = dr.GetString(dr.GetOrdinal("Name"));
                    c.Visible = dr.GetString(dr.GetOrdinal("Visible"));
                    c.Hidden = dr.GetString(dr.GetOrdinal("Hidden"));
                    c.ClientId = dr.GetInt32(dr.GetOrdinal("idClient"));
                    result.Add(c);
                }
            }
        }
        return result.FirstOrDefault();
    }

    public static void SetQuestion(Question o)
    {
        List<Question> result = new List<Question>();
        string cs = ConfigurationManager.ConnectionStrings["mdf"].ConnectionString;
        using (SqlConnection dbConnection = new SqlConnection(cs))
        {
            dbConnection.Open();
            SqlCommand myCommand = new SqlCommand("Update obQuestion set Name = @Name,Visible = @Visible, Hidden = @Hidden where id = @id");
            myCommand.Connection = dbConnection;
            myCommand.CommandType = CommandType.Text;
            myCommand.Parameters.AddWithValue("@id", o.Id.ToString());
            myCommand.Parameters.AddWithValue("@Name", o.Name.ToString());
            myCommand.Parameters.AddWithValue("@Visible", o.Visible.ToString());
            myCommand.Parameters.AddWithValue("@Hidden", o.Hidden.ToString());
            myCommand.ExecuteNonQuery();
        }
    }

    public static List<Activity> GetActivities(int ClientID)
    {
        List<Activity> result = new List<Activity>();
        string cs = ConfigurationManager.ConnectionStrings["mdf"].ConnectionString;
        using (SqlConnection dbConnection = new SqlConnection(cs))
        {
            dbConnection.Open();
            SqlCommand myCommand = new SqlCommand("Select ID,Name,Content,Topic,Week,Day,Time from obActivity where idClient = @idClient order by SortOrder, id");
            myCommand.Connection = dbConnection;
            myCommand.CommandType = CommandType.Text;
            myCommand.Parameters.AddWithValue("@idClient", ClientID.ToString());
            using (SqlDataReader dr = myCommand.ExecuteReader())
            {
                while (dr.Read())
                {
                    Activity c = new Activity();
                    c.Id = dr.GetInt32(dr.GetOrdinal("ID"));
                    c.Content = GetString(dr,"Content");
                    c.Topic = GetString(dr,"Topic");
                    c.Week = GetString(dr,"Week");
                    c.Day = GetString(dr,"Day");
                    c.Time = GetString(dr,"Time");
                    result.Add(c);
                }
            }
        }
        return result;
    }
    public static Activity GetActivity(int ID)
    {
        List<Activity> result = new List<Activity>();
        string cs = ConfigurationManager.ConnectionStrings["mdf"].ConnectionString;
        using (SqlConnection dbConnection = new SqlConnection(cs))
        {
            dbConnection.Open();
            SqlCommand myCommand = new SqlCommand("Select ID,idClient,Content,Topic,Week,Day,Time  from obActivity where id = @id");
            myCommand.Connection = dbConnection;
            myCommand.CommandType = CommandType.Text;
            myCommand.Parameters.AddWithValue("@id", ID.ToString());
            using (SqlDataReader dr = myCommand.ExecuteReader())
            {
                while (dr.Read())
                {
                    Activity c = new Activity();
                    c.Id = dr.GetInt32(dr.GetOrdinal("ID"));
                    c.ClientId = dr.GetInt32(dr.GetOrdinal("idClient"));
                    c.Content = GetString(dr, "Content");
                    c.Topic = GetString(dr, "Topic");
                    c.Week = GetString(dr, "Week");
                    c.Day = GetString(dr, "Day");
                    c.Time = GetString(dr, "Time");
                    result.Add(c);
                }
            }
        }
        return result.FirstOrDefault();
    }

    public static void SetActivity(Activity o)
    {
        string cs = ConfigurationManager.ConnectionStrings["mdf"].ConnectionString;
        using (SqlConnection dbConnection = new SqlConnection(cs))
        {
            dbConnection.Open();
            SqlCommand myCommand = new SqlCommand(@"Update obActivity set Content = @Content,Topic=@Topic,Week=@Week,Day=@Day,Time=@Time
                where id = @id");
            myCommand.Connection = dbConnection;
            myCommand.CommandType = CommandType.Text;
            myCommand.Parameters.AddWithValue("@id", o.Id.ToString());
            //myCommand.Parameters.AddWithValue("@Name", o.Name.ToString());
            //myCommand.Parameters.AddWithValue("@Visible", o.Visible.ToString());
            //myCommand.Parameters.AddWithValue("@Hidden", o.Hidden.ToString());
            myCommand.Parameters.AddWithValue("@Content",o.Content.ToString());
            myCommand.Parameters.AddWithValue("@Topic",o.Topic.ToString());
            myCommand.Parameters.AddWithValue("@Week",o.Week.ToString());
            myCommand.Parameters.AddWithValue("@Day",o.Day.ToString());
            myCommand.Parameters.AddWithValue("@Time", o.Time.ToString());
            myCommand.ExecuteNonQuery();
        }
    }


    public static List<Option> GetOptions(int ID)
    {
        List<Option> result = new List<Option>();
        string cs = ConfigurationManager.ConnectionStrings["mdf"].ConnectionString;
        using (SqlConnection dbConnection = new SqlConnection(cs))
        {
            dbConnection.Open();
            SqlCommand myCommand = new SqlCommand("Select ID,Name,Tag,Visible,Hidden from obOption where idQuestion = @idQuestion order by SortOrder, id");
            myCommand.Connection = dbConnection;
            myCommand.CommandType = CommandType.Text;
            myCommand.Parameters.AddWithValue("@idQuestion", ID.ToString());
            using (SqlDataReader dr = myCommand.ExecuteReader())
            {
                while (dr.Read())
                {
                    Option c = new Option();
                    c.Id = dr.GetInt32(dr.GetOrdinal("ID"));
                    c.Name = dr.GetString(dr.GetOrdinal("Name"));
                    c.Tag = GetString(dr,"Tag");
                    c.Visible = dr.GetString(dr.GetOrdinal("Visible"));
                    c.Hidden = dr.GetString(dr.GetOrdinal("Hidden"));
                    c.Selected = true;
                    result.Add(c);
                }
            }
        }
        return result;
    }

    public static Option GetOption(int ID)
    {
        List<Option> result = new List<Option>();
        string cs = ConfigurationManager.ConnectionStrings["mdf"].ConnectionString;
        using (SqlConnection dbConnection = new SqlConnection(cs))
        {
            dbConnection.Open();
            SqlCommand myCommand = new SqlCommand("Select ID,Name,Tag,Visible,Hidden,idQuestion from obOption where id = @id");
            myCommand.Connection = dbConnection;
            myCommand.CommandType = CommandType.Text;
            myCommand.Parameters.AddWithValue("@id", ID.ToString());
            using (SqlDataReader dr = myCommand.ExecuteReader())
            {
                while (dr.Read())
                {
                    Option c = new Option();
                    c.Id = dr.GetInt32(dr.GetOrdinal("ID"));
                    c.Name = GetString(dr,"Name");
                    c.Tag = GetString(dr,"Tag");
                    c.Visible = dr.GetString(dr.GetOrdinal("Visible"));
                    c.Hidden = dr.GetString(dr.GetOrdinal("Hidden"));
                    c.QuestionId = dr.GetInt32(dr.GetOrdinal("idQuestion"));
                    result.Add(c);
                }
            }
        }
        return result.FirstOrDefault();
    }
    public static void SetOption(Option option)
    {
        string cs = ConfigurationManager.ConnectionStrings["mdf"].ConnectionString;
        using (SqlConnection dbConnection = new SqlConnection(cs))
        {
            dbConnection.Open();
            SqlCommand myCommand = new SqlCommand("Update obOption set Name = @Name, Tag = @Tag, Visible = @Visible, Hidden = @Hidden where id = @id");
            myCommand.Connection = dbConnection;
            myCommand.CommandType = CommandType.Text;
            myCommand.Parameters.AddWithValue("@id", option.Id.ToString());
            myCommand.Parameters.AddWithValue("@Name", option.Name.ToString());
            myCommand.Parameters.AddWithValue("@Tag", option.Tag.ToString());
            myCommand.Parameters.AddWithValue("@Visible", option.Visible.ToString());
            myCommand.Parameters.AddWithValue("@Hidden", option.Hidden.ToString());
            myCommand.ExecuteNonQuery();
        }
    }

    /**************************************************************************************************************************************/
    public static void AddQuestion(int ClientID)
    {
        string cs = ConfigurationManager.ConnectionStrings["mdf"].ConnectionString;
        using (SqlConnection dbConnection = new SqlConnection(cs))
        {
            dbConnection.Open();
            SqlCommand myCommand = new SqlCommand("Insert obQuestion (idClient,Name,SortOrder,visible,hidden) values (@idClient,'New Question',0,'','')");
            myCommand.Connection = dbConnection;
            myCommand.CommandType = CommandType.Text;
            myCommand.Parameters.AddWithValue("@idClient", ClientID.ToString());
            myCommand.ExecuteNonQuery();
       }
    }
    public static void DeleteQuestion(int Id)
    {
        string cs = ConfigurationManager.ConnectionStrings["mdf"].ConnectionString;
        using (SqlConnection dbConnection = new SqlConnection(cs))
        {
            dbConnection.Open();
            SqlCommand myCommand = new SqlCommand("Delete from obQuestion where id = @id");
            myCommand.Connection = dbConnection;
            myCommand.CommandType = CommandType.Text;
            myCommand.Parameters.AddWithValue("@id", Id.ToString());
            myCommand.ExecuteNonQuery();
        }
    }
    public static void UpQuestion(int Id)
    {
        string cs = ConfigurationManager.ConnectionStrings["mdf"].ConnectionString;
        using (SqlConnection dbConnection = new SqlConnection(cs))
        {
            dbConnection.Open();
            SqlCommand myCommand = new SqlCommand("obSortObject");
            myCommand.Connection = dbConnection;
            myCommand.CommandType = CommandType.StoredProcedure;
            myCommand.Parameters.AddWithValue("@id", Id.ToString());
            myCommand.Parameters.AddWithValue("@Object", "obQuestion");
            myCommand.Parameters.AddWithValue("@Direction", "Up");
            myCommand.ExecuteNonQuery();
        }
    }
    public static void DownQuestion(int Id)
    {
        string cs = ConfigurationManager.ConnectionStrings["mdf"].ConnectionString;
        using (SqlConnection dbConnection = new SqlConnection(cs))
        {
            dbConnection.Open();
            SqlCommand myCommand = new SqlCommand("obSortObject");
            myCommand.Connection = dbConnection;
            myCommand.CommandType = CommandType.StoredProcedure;
            myCommand.Parameters.AddWithValue("@id", Id.ToString());
            myCommand.Parameters.AddWithValue("@Object", "obQuestion");
            myCommand.Parameters.AddWithValue("@Direction", "Down");
            myCommand.ExecuteNonQuery();
        }
    }
    /******************************************************************************************************************************/
    public static void AddLandingPage(int ClientID)
    {
        string cs = ConfigurationManager.ConnectionStrings["mdf"].ConnectionString;
        using (SqlConnection dbConnection = new SqlConnection(cs))
        {
            dbConnection.Open();
            SqlCommand myCommand = new SqlCommand("Insert obLandingPage (idClient,Name, SortOrder, visible, hidden) values (@idClient,'New Landing Page', 0, '','')");
            myCommand.Connection = dbConnection;
            myCommand.CommandType = CommandType.Text;
            myCommand.Parameters.AddWithValue("@idClient", ClientID.ToString());
            myCommand.ExecuteNonQuery();
        }
    }
    public static void DeleteLandingPage(int Id)
    {
        string cs = ConfigurationManager.ConnectionStrings["mdf"].ConnectionString;
        using (SqlConnection dbConnection = new SqlConnection(cs))
        {
            dbConnection.Open();
            SqlCommand myCommand = new SqlCommand("Delete from obLandingPage where id = @id");
            myCommand.Connection = dbConnection;
            myCommand.CommandType = CommandType.Text;
            myCommand.Parameters.AddWithValue("@id", Id.ToString());
            myCommand.ExecuteNonQuery();
        }
    }
    public static void UpLandingPage(int Id)
    {
        string cs = ConfigurationManager.ConnectionStrings["mdf"].ConnectionString;
        using (SqlConnection dbConnection = new SqlConnection(cs))
        {
            dbConnection.Open();
            SqlCommand myCommand = new SqlCommand("obSortObject");
            myCommand.Connection = dbConnection;
            myCommand.CommandType = CommandType.StoredProcedure;
            myCommand.Parameters.AddWithValue("@id", Id.ToString());
            myCommand.Parameters.AddWithValue("@Object", "obLandingPage");
            myCommand.Parameters.AddWithValue("@Direction", "Up");
            myCommand.ExecuteNonQuery();
        }
    }
    public static void DownLandingPage(int Id)
    {
        string cs = ConfigurationManager.ConnectionStrings["mdf"].ConnectionString;
        using (SqlConnection dbConnection = new SqlConnection(cs))
        {
            dbConnection.Open();
            SqlCommand myCommand = new SqlCommand("obSortObject");
            myCommand.Connection = dbConnection;
            myCommand.CommandType = CommandType.StoredProcedure;
            myCommand.Parameters.AddWithValue("@id", Id.ToString());
            myCommand.Parameters.AddWithValue("@Object", "obLandingPage");
            myCommand.Parameters.AddWithValue("@Direction", "Down");
            myCommand.ExecuteNonQuery();
        }
    }
    /******************************************************************************************************************************/
    public static void AddActivity(int ClientID)
    {
        string cs = ConfigurationManager.ConnectionStrings["mdf"].ConnectionString;
        using (SqlConnection dbConnection = new SqlConnection(cs))
        {
            dbConnection.Open();
            SqlCommand myCommand = new SqlCommand("Insert obActivity (idClient,Name,SortOrder,visible,hidden) values (@idClient,'New Activity',0,'','')");
            myCommand.Connection = dbConnection;
            myCommand.CommandType = CommandType.Text;
            myCommand.Parameters.AddWithValue("@idClient", ClientID.ToString());
            myCommand.ExecuteNonQuery();
        }
    }
    public static void DeleteActivity(int Id)
    {
        string cs = ConfigurationManager.ConnectionStrings["mdf"].ConnectionString;
        using (SqlConnection dbConnection = new SqlConnection(cs))
        {
            dbConnection.Open();
            SqlCommand myCommand = new SqlCommand("Delete from obActivity where id = @id");
            myCommand.Connection = dbConnection;
            myCommand.CommandType = CommandType.Text;
            myCommand.Parameters.AddWithValue("@id", Id.ToString());
            myCommand.ExecuteNonQuery();
        }
    }
    public static void UpActivity(int Id)
    {
        string cs = ConfigurationManager.ConnectionStrings["mdf"].ConnectionString;
        using (SqlConnection dbConnection = new SqlConnection(cs))
        {
            dbConnection.Open();
            SqlCommand myCommand = new SqlCommand("obSortObject");
            myCommand.Connection = dbConnection;
            myCommand.CommandType = CommandType.StoredProcedure;
            myCommand.Parameters.AddWithValue("@id", Id.ToString());
            myCommand.Parameters.AddWithValue("@Object", "obActivity");
            myCommand.Parameters.AddWithValue("@Direction", "Up");
            myCommand.ExecuteNonQuery();
        }
    }
    public static void DownActivity(int Id)
    {
        string cs = ConfigurationManager.ConnectionStrings["mdf"].ConnectionString;
        using (SqlConnection dbConnection = new SqlConnection(cs))
        {
            dbConnection.Open();
            SqlCommand myCommand = new SqlCommand("obSortObject");
            myCommand.Connection = dbConnection;
            myCommand.CommandType = CommandType.StoredProcedure;
            myCommand.Parameters.AddWithValue("@id", Id.ToString());
            myCommand.Parameters.AddWithValue("@Object", "obActivity");
            myCommand.Parameters.AddWithValue("@Direction", "Down");
            myCommand.ExecuteNonQuery();
        }
    }
    /******************************************************************************************************************************/
    public static void AddOption(int QuestionID)
    {
        string cs = ConfigurationManager.ConnectionStrings["mdf"].ConnectionString;
        using (SqlConnection dbConnection = new SqlConnection(cs))
        {
            dbConnection.Open();
            SqlCommand myCommand = new SqlCommand("Insert obOption (idQuestion,Name,SortOrder,visible,hidden) values (@idQuestion,'New Option',0,'','')");
            myCommand.Connection = dbConnection;
            myCommand.CommandType = CommandType.Text;
            myCommand.Parameters.AddWithValue("@idQuestion", QuestionID.ToString());
            myCommand.ExecuteNonQuery();
        }
    }
    public static void DeleteOption(int Id)
    {
        string cs = ConfigurationManager.ConnectionStrings["mdf"].ConnectionString;
        using (SqlConnection dbConnection = new SqlConnection(cs))
        {
            dbConnection.Open();
            SqlCommand myCommand = new SqlCommand("Delete from obOption where id = @id");
            myCommand.Connection = dbConnection;
            myCommand.CommandType = CommandType.Text;
            myCommand.Parameters.AddWithValue("@id", Id.ToString());
            myCommand.ExecuteNonQuery();
        }
    }
    public static void UpOption(int Id)
    {
        string cs = ConfigurationManager.ConnectionStrings["mdf"].ConnectionString;
        using (SqlConnection dbConnection = new SqlConnection(cs))
        {
            dbConnection.Open();
            SqlCommand myCommand = new SqlCommand("obSortObject");
            myCommand.Connection = dbConnection;
            myCommand.CommandType = CommandType.StoredProcedure;
            myCommand.Parameters.AddWithValue("@id", Id.ToString());
            myCommand.Parameters.AddWithValue("@Object", "obOption");
            myCommand.Parameters.AddWithValue("@Direction", "Up");
            myCommand.ExecuteNonQuery();
        }
    }
    public static void DownOption(int Id)
    {
        string cs = ConfigurationManager.ConnectionStrings["mdf"].ConnectionString;
        using (SqlConnection dbConnection = new SqlConnection(cs))
        {
            dbConnection.Open();
            SqlCommand myCommand = new SqlCommand("obSortObject");
            myCommand.Connection = dbConnection;
            myCommand.CommandType = CommandType.StoredProcedure;
            myCommand.Parameters.AddWithValue("@id", Id.ToString());
            myCommand.Parameters.AddWithValue("@Object", "obOption");
            myCommand.Parameters.AddWithValue("@Direction", "Down");
            myCommand.ExecuteNonQuery();
        }
    }
    /******************************************************************************************************************************/
    public static List<Condition> GetConditions(int ActivityID)
    {
        List<Condition> result = new List<Condition>();
        string cs = ConfigurationManager.ConnectionStrings["mdf"].ConnectionString;
        using (SqlConnection dbConnection = new SqlConnection(cs))
        {
            dbConnection.Open();
            SqlCommand myCommand = new SqlCommand(@"Select ID,idQuestion, (select name from obQuestion where id=obCondition.idQuestion) QuestionName
                    ,Tags,isNegative 
                    from obCondition 
                    where idActivity = @idActivity  order by SortOrder, id");
            myCommand.Connection = dbConnection;
            myCommand.CommandType = CommandType.Text;
            myCommand.Parameters.AddWithValue("@idActivity", ActivityID.ToString());
            using (SqlDataReader dr = myCommand.ExecuteReader())
            {
                while (dr.Read())
                {
                    Condition c = new Condition();
                    c.Id = dr.GetInt32(dr.GetOrdinal("ID"));
                    c.QuestionName = GetString(dr,"QuestionName");
                    c.idQuestion = GetInt(dr,"idQuestion");
                    c.Tags = GetString(dr,"Tags");
                    c.isNegative = GetString(dr,"isNegative");
                    result.Add(c);
                }
            }
        }
        return result;
    }
    public static Condition GetCondition(int ID)
    {
        Condition result = new Condition();
        string cs = ConfigurationManager.ConnectionStrings["mdf"].ConnectionString;
        using (SqlConnection dbConnection = new SqlConnection(cs))
        {
            dbConnection.Open();
            SqlCommand myCommand = new SqlCommand(@"Select ID,idActivity,idQuestion
                    ,Tags,isNegative 
                    from obCondition 
                    where id = @id order by SortOrder, id");
            myCommand.Connection = dbConnection;
            myCommand.CommandType = CommandType.Text;
            myCommand.Parameters.AddWithValue("@id", ID.ToString());
            using (SqlDataReader dr = myCommand.ExecuteReader())
            {
                while (dr.Read())
                {
                    Condition c = new Condition();
                    c.Id = dr.GetInt32(dr.GetOrdinal("ID"));
                    c.idActivity = GetInt(dr, "idActivity");
                    c.idQuestion = GetInt(dr, "idQuestion");
                    c.Tags = GetString(dr, "Tags");
                    c.isNegative = GetString(dr, "isNegative");
                    result = c;
                }
            }
        }
        return result;
    }
    public static void SetCondition(Condition o)
    {
        string cs = ConfigurationManager.ConnectionStrings["mdf"].ConnectionString;
        using (SqlConnection dbConnection = new SqlConnection(cs))
        {
            dbConnection.Open();
            SqlCommand myCommand = new SqlCommand("Update obCondition set idQuestion = @idQuestion, Tags = @Tags where id = @id");
            myCommand.Connection = dbConnection;
            myCommand.CommandType = CommandType.Text;
            myCommand.Parameters.AddWithValue("@id", o.Id.ToString());
            myCommand.Parameters.AddWithValue("@idQuestion", o.idQuestion);
            myCommand.Parameters.AddWithValue("@Tags", o.Tags.ToString());
            myCommand.ExecuteNonQuery();
        }
    }


    public static void AddCondition(int ActivityID)
    {
        string cs = ConfigurationManager.ConnectionStrings["mdf"].ConnectionString;
        using (SqlConnection dbConnection = new SqlConnection(cs))
        {
            dbConnection.Open();
            SqlCommand myCommand = new SqlCommand("Insert obCondition (idActivity,idQuestion,Tags,isNegative) values (@idActivity,null,null,null)");
            myCommand.Connection = dbConnection;
            myCommand.CommandType = CommandType.Text;
            myCommand.Parameters.AddWithValue("@idActivity", ActivityID.ToString());
            myCommand.ExecuteNonQuery();
        }
    }
    public static void DeleteCondition(int Id)
    {
        string cs = ConfigurationManager.ConnectionStrings["mdf"].ConnectionString;
        using (SqlConnection dbConnection = new SqlConnection(cs))
        {
            dbConnection.Open();
            SqlCommand myCommand = new SqlCommand("Delete from obCondition where id = @id");
            myCommand.Connection = dbConnection;
            myCommand.CommandType = CommandType.Text;
            myCommand.Parameters.AddWithValue("@id", Id.ToString());
            myCommand.ExecuteNonQuery();
        }
    }
    public static void UpCondition(int Id)
    {
        string cs = ConfigurationManager.ConnectionStrings["mdf"].ConnectionString;
        using (SqlConnection dbConnection = new SqlConnection(cs))
        {
            dbConnection.Open();
            SqlCommand myCommand = new SqlCommand("obSortObject");
            myCommand.Connection = dbConnection;
            myCommand.CommandType = CommandType.StoredProcedure;
            myCommand.Parameters.AddWithValue("@id", Id.ToString());
            myCommand.Parameters.AddWithValue("@Object", "obCondition");
            myCommand.Parameters.AddWithValue("@Direction", "Up");
            myCommand.ExecuteNonQuery();
        }
    }
    public static void DownCondition(int Id)
    {
        string cs = ConfigurationManager.ConnectionStrings["mdf"].ConnectionString;
        using (SqlConnection dbConnection = new SqlConnection(cs))
        {
            dbConnection.Open();
            SqlCommand myCommand = new SqlCommand("obSortObject");
            myCommand.Connection = dbConnection;
            myCommand.CommandType = CommandType.StoredProcedure;
            myCommand.Parameters.AddWithValue("@id", Id.ToString());
            myCommand.Parameters.AddWithValue("@Object", "obCondition");
            myCommand.Parameters.AddWithValue("@Direction", "Down");
            myCommand.ExecuteNonQuery();
        }
    }

    public static int GetClientIDForCondition(int ID) {
        int result = 0;
        string cs = ConfigurationManager.ConnectionStrings["mdf"].ConnectionString;
        using (SqlConnection dbConnection = new SqlConnection(cs))
        {
            dbConnection.Open();
            SqlCommand myCommand = new SqlCommand(@"Select idClient from obActivity where ID = (select idActivity from obCondition where id = @id)");
            myCommand.Connection = dbConnection;
            myCommand.CommandType = CommandType.Text;
            myCommand.Parameters.AddWithValue("@id", ID.ToString());
            using (SqlDataReader dr = myCommand.ExecuteReader())
            {
                while (dr.Read())
                {
                    result = dr.GetInt32(dr.GetOrdinal("idClient"));
                }
            }
        }
        return result;
    }
}