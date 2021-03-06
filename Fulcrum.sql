USE [master]
GO
/****** Object:  Database [SQL2012_978285_fulcrum]    Script Date: 1/24/2016 10:29:43 AM ******/
CREATE DATABASE [SQL2012_978285_fulcrum]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'SQL2012_978285_fulcrum_data', FILENAME = N'e:\sqldata\SQL2012_978285_fulcrum_data.mdf' , SIZE = 11264KB , MAXSIZE = 1024000KB , FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'SQL2012_978285_fulcrum_log', FILENAME = N'f:\sqllog\SQL2012_978285_fulcrum_log.ldf' , SIZE = 2816KB , MAXSIZE = 1024000KB , FILEGROWTH = 10%)
GO
ALTER DATABASE [SQL2012_978285_fulcrum] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [SQL2012_978285_fulcrum].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [SQL2012_978285_fulcrum] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [SQL2012_978285_fulcrum] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [SQL2012_978285_fulcrum] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [SQL2012_978285_fulcrum] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [SQL2012_978285_fulcrum] SET ARITHABORT OFF 
GO
ALTER DATABASE [SQL2012_978285_fulcrum] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [SQL2012_978285_fulcrum] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [SQL2012_978285_fulcrum] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [SQL2012_978285_fulcrum] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [SQL2012_978285_fulcrum] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [SQL2012_978285_fulcrum] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [SQL2012_978285_fulcrum] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [SQL2012_978285_fulcrum] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [SQL2012_978285_fulcrum] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [SQL2012_978285_fulcrum] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [SQL2012_978285_fulcrum] SET  DISABLE_BROKER 
GO
ALTER DATABASE [SQL2012_978285_fulcrum] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [SQL2012_978285_fulcrum] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [SQL2012_978285_fulcrum] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [SQL2012_978285_fulcrum] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [SQL2012_978285_fulcrum] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [SQL2012_978285_fulcrum] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [SQL2012_978285_fulcrum] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [SQL2012_978285_fulcrum] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [SQL2012_978285_fulcrum] SET  MULTI_USER 
GO
ALTER DATABASE [SQL2012_978285_fulcrum] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [SQL2012_978285_fulcrum] SET DB_CHAINING OFF 
GO
ALTER DATABASE [SQL2012_978285_fulcrum] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [SQL2012_978285_fulcrum] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [SQL2012_978285_fulcrum]
GO
/****** Object:  StoredProcedure [dbo].[EventPlanGet]    Script Date: 1/24/2016 10:29:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
exec dbo.EventPlanGet
*/
create procedure [dbo].[EventPlanGet] 
as
begin
	with T as (select distinct account_market, program_title from Schedule)
	select * from (
	select T.program_title
		   ,T.account_market
		   ,p.Value
	 from T
	 left outer join EventPlan p on p.account_market = t.account_market and p.program_title = t.program_title
	 UNION ALL 
	 (select program_title,account_market,value from EventPlan p where not exists (select 1 from Schedule t where p.account_market = t.account_market and p.program_title = t.program_title))) T2
	 order by program_title, account_market
end


GO
/****** Object:  StoredProcedure [dbo].[EventPlanSet]    Script Date: 1/24/2016 10:29:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
exec dbo.EventPlanGet


*/
create procedure [dbo].[EventPlanSet] (
	@Program varchar(255)
    ,@Market varchar(255) 
    ,@Value varchar(255)
)
as
begin
	if exists(select 1 from EventPlan where account_market = @market and program_title = @Program)
		update EventPlan set Value = @Value where account_market = @market and program_title = @Program
	else
		Insert EventPlan(account_market,program_title,value) values (@market,@Program,@Value)
end

GO
/****** Object:  StoredProcedure [dbo].[Evolve2]    Script Date: 1/24/2016 10:29:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
create table T(X int,Y int, CONSTRAINT PK_T PRIMARY KEY(X,Y))
*/
create procedure [dbo].[Evolve2]
as
begin
WITH N AS (Select -1 AS N UNION Select 0 UNION Select 1)
,Area AS (SELECT DISTINCT T.X + X.N X 
						 ,T.Y + Y.N Y
				FROM T
				JOIN N X ON 1=1
				JOIN N Y ON 1=1)
,Cell AS (SELECT A.X,A.Y
		  ,CASE WHEN T.X IS NULL THEN 0 ELSE 1 END Generation
		  ,(Select count(1) from T 
			 WHERE ABS(T.X - A.X) < 2 
		   	   AND ABS(T.Y - A.Y) < 2 
			   AND (T.X<>A.X OR T.Y<>A.Y)) Neighbours
		  FROM Area A
		  LEFT OUTER JOIN T ON T.X = A.X and T.Y = A.Y)
MERGE INTO T
 USING (SELECT X,Y FROM Cell 
				   WHERE (Generation=0 and Neighbours=3) 
				   OR (Generation=1 AND Neighbours in (2,3))) as S
 ON S.X = T.X AND S.Y = T.Y
WHEN NOT MATCHED BY TARGET
 THEN INSERT(X,Y) VALUES (S.X,S.Y)
WHEN NOT MATCHED BY SOURCE
 THEN DELETE;	
end

GO
/****** Object:  StoredProcedure [dbo].[GetAccountTypes]    Script Date: 1/24/2016 10:29:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
exec GetAccountTypes

Select top 3 account_classification, count(1) Number
from Schedule
where account_classification != ''
group by account_segment, account_classification
order by account_classification,count(1) desc


*/

create procedure [dbo].[GetAccountTypes] (
	 @Brand varchar(255) = NULL
	,@Program varchar(255) = NULL
	,@Market  varchar(255) = NULL
	,@Channel varchar(255) = NULL
	,@Classification varchar(255) = NULL
	,@Status  varchar(255) = NULL
	,@From datetime = NULL
	,@To datetime = NULL)
as
BEGIN

Select account_segment, account_classification, count(1) Number
from Schedule
where account_classification != ''
group by account_segment, account_classification
order by account_segment,count(1) desc


END;




GO
/****** Object:  StoredProcedure [dbo].[GetBarSpend]    Script Date: 1/24/2016 10:29:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
exec GetBarSpend
*/

create procedure [dbo].[GetBarSpend] 
as
begin

Select CASE account_segment WHEN 'On_Premise' THEN 
CASE WHEN Program_title LIKE '%Off Premise%' THEN 'Off_Premise' 
	 WHEN Program_title LIKE '%Special Event%' THEN 'Special_Event' 
	 ELSE 'On_Premise' END
ELSE account_segment END account_segment
, Program_title, Convert(Numeric(8,2), avg(total_actual_event_bar_spend)) [Actual], 
ISNULL((Select SUM(BarSpend) from ProgramPlan where program_title = Schedule.program_title),0) [Plan]
from Schedule
where Program_title is not null
group by CASE account_segment WHEN 'On_Premise' THEN 
CASE WHEN Program_title LIKE '%Off Premise%' THEN 'Off_Premise' 
	 WHEN Program_title LIKE '%Special Event%' THEN 'Special_Event' 
	 ELSE 'On_Premise' END
ELSE account_segment END, Program_title
-- having (Select SUM(BarSpend) from ProgramPlan where program_title = Schedule.program_title) > 0
order by CASE account_segment WHEN 'On_Premise' THEN 
CASE WHEN Program_title LIKE '%Off Premise%' THEN 'Off_Premise' 
	 WHEN Program_title LIKE '%Special Event%' THEN 'Special_Event' 
	 ELSE 'On_Premise' END
ELSE account_segment END, Program_title

end



GO
/****** Object:  StoredProcedure [dbo].[GetEventResults]    Script Date: 1/24/2016 10:29:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
exec GetEventResults
select name from syscolumns where id=object_id('Schedule') and name like '%class%'
select * from Schedule_Stg where status = 'Completed'

select account_classification from Schedule

sp_helptext GetEvents

Select distinct account_city, account_segment, 100 as Value
into EventPlan
from Schedule

select * from EventPlan
delete from EventPlan where account_segment = ''

exec GetEventResults 'All','All','All','All','All','All','All','All','All',NULL,NULL
*/

create procedure [dbo].[GetEventResults] (
	 @Brand varchar(255) = NULL
	,@Program varchar(255) = NULL
	,@Market  varchar(255) = NULL
	,@Region  varchar(255) = NULL
	,@City  varchar(255) = NULL
	,@State  varchar(255) = NULL
	,@Channel varchar(255) = NULL
	,@Classification varchar(255) = NULL
	,@Status  varchar(255) = 'All'
	,@From datetime = NULL
	,@To datetime = NULL)
as
BEGIN

select 
 program_title program
, Convert(varchar(255),promo_event_date,1)
+ ' ' + substring(convert(varchar(20), promo_event_start_time, 9), 13, 5)
+ '-' + substring(convert(varchar(20), promo_event_end_time, 9), 13, 5) + ' ' + substring(convert(varchar(30), promo_event_end_time, 9), 25, 2) Event_Date 
, s.event_account_name
, s.account_classification
, s.account_market account_city
,(select sum(Value) from EventPlan where account_market = s.account_market and EventPlan.program_title = s.program_title ) Planned
, _of_consumer_attendance Attendatnce
, _of_consumers_engaged Engaged
, _of_consumers_sampled Sampled
, total_drinks_sold Sold
, total_actual_event_bar_spend Spend

from Schedule s
left outer join Accounts a on a.fulcrum_id = s.account_name_lookup
where (@Brand = 'All' OR s.brands_sampled like '%' + @Brand + '%')
	AND (@Program = 'All' OR s.program_title = @Program)
	AND (@Market = 'All' OR s.account_market = @Market)
	AND (@Channel = 'All' OR @Channel LIKE '%' + s.account_segment + '%' )
	AND (@Classification = 'All' OR s.account_classification = @Classification)
	AND (@City = 'All' OR s.account_city = @City)
	AND (@State = 'All' OR s.account_state = @State)
	AND (@From IS NULL OR s.promo_event_date >= @From)
	AND (@To IS NULL OR s.promo_event_date <= @To)
	AND s.status = 'Completed'
	--AND s.account_segment = 'On_Premise'
ORDER BY s.account_city,program_title,event_account_name,promo_event_date
END;

GO
/****** Object:  StoredProcedure [dbo].[GetEvents]    Script Date: 1/24/2016 10:29:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
exec dbo.GetEvents @Status = 'Alsl'
select status, count(1)
from Schedule 
group by status
use Fulcrum

select brands_sampled from Schedule_Stg_Bkp
where id = object_id('Schedule') and name like '%brand%'

*/
create procedure [dbo].[GetEvents] (
	 @Brand varchar(255) = NULL
	,@Program varchar(255) = NULL
	,@Market  varchar(255) = NULL
	,@Region  varchar(255) = NULL
	,@State varchar(255) = NULL
	,@City varchar(255) = NULL
	,@Channel varchar(255) = NULL
	,@Classification varchar(255) = NULL
	,@Status  varchar(255) = NULL
	,@From datetime = NULL
	,@To datetime = NULL)
as
BEGIN

select 
s.project  brand
, s.program_title program

, Convert(varchar(255),promo_event_date,1) Event_Date
, datename(dw,promo_event_date) [Day]
, s.event_account_name account_name
, promo_event_start_time Start_Time
, promo_event_end_time End_Time
, s.account_street_address
, s.account_city
, s.account_state 
, s.account_zip
, s.account_contact
,s.account_phone_ account_phone
,s.[account_manager_email] email
,s.Status
from Schedule s
left outer join Accounts a on a.fulcrum_id = s.account_name_lookup
where (@Brand = 'All' OR s.brands_sampled like '%' + @Brand + '%')
	AND (@Program = 'All' OR s.program_title = @Program)
	AND (@Market = 'All' OR s.account_market = @Market)
	AND (@Channel = 'All' OR @Channel LIKE '%' + s.account_segment + '%' )
	AND (@Classification = 'All' OR s.account_classification = @Classification)
	AND (@Status = 'All' OR s.Status = 'Scheduled')
	AND (@City = 'All' OR s.account_city = @City)
	AND (@State = 'All' OR s.account_state = @State)
	AND (@From IS NULL OR s.promo_event_date >= @From)
	AND (@To IS NULL OR s.promo_event_date <= @To)
ORDER BY promo_event_date;

END;



GO
/****** Object:  StoredProcedure [dbo].[GetEventsActivitySummary]    Script Date: 1/24/2016 10:29:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
exec dbo.GetEvents @Status = 'Alsl'
select status, count(1)
from Schedule 
group by status
use Fulcrum

select brands_sampled from Schedule_Stg_Bkp
where id = object_id('Schedule') and name like '%brand%'

*/
create procedure [dbo].[GetEventsActivitySummary] (
	 @Brand varchar(255) = NULL
	,@Program varchar(255) = NULL
	,@Market  varchar(255) = NULL
	,@Region  varchar(255) = NULL
	,@State varchar(255) = NULL
	,@City varchar(255) = NULL
	,@Channel varchar(255) = NULL
	,@Classification varchar(255) = NULL
	,@Status  varchar(255) = NULL
	,@From datetime = NULL
	,@To datetime = NULL)
as
BEGIN

select 
s.account_market 
, s.program_title program

, Convert(varchar(255),promo_event_date,1) Event_Date
, datename(dw,promo_event_date) [Day]
, s.event_account_name account_name
, LTRIM(substring(convert(varchar(20), promo_event_start_time, 9), 13, 5)) + ' ' + substring(convert(varchar(30), promo_event_start_time, 9), 25, 2) Start_Time
, substring(convert(varchar(20), promo_event_end_time, 9), 13, 5) + ' ' + substring(convert(varchar(30), promo_event_end_time, 9), 25, 2) End_Time
, s.account_street_address
, s.account_city
, s.account_state 
, s.account_zip
, s.account_contact
,s.account_phone_ account_phone
,s.[account_manager_email] email
,s.Status
,s._of_consumer_attendance attened
,s._of_consumers_sampled sampled
,ISNULL(s.total_drinks_sold,s.total_bottles_sold) sold
,total_actual_event_bar_spend spend
from Schedule s
left outer join Accounts a on a.fulcrum_id = s.account_name_lookup
where (@Brand = 'All' OR s.brands_sampled like '%' + @Brand + '%')
	AND (@Program = 'All' OR s.program_title = @Program)
	AND (@Market = 'All' OR s.account_market = @Market)
	AND (@Channel = 'All' OR @Channel LIKE '%' + s.account_segment + '%' )
	AND (@Classification = 'All' OR s.account_classification = @Classification)
	AND (@Status = 'All' OR s.Status = 'Scheduled')
	AND (@City = 'All' OR s.account_city = @City)
	AND (@State = 'All' OR s.account_state = @State)
	AND (@From IS NULL OR s.promo_event_date >= @From)
	AND (@To IS NULL OR s.promo_event_date <= @To)
ORDER BY account_market, promo_event_date;

END;




GO
/****** Object:  StoredProcedure [dbo].[GetEventsHeader]    Script Date: 1/24/2016 10:29:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
*/

create procedure [dbo].[GetEventsHeader](
	 @Brand varchar(255) = NULL
	,@Program varchar(255) = NULL
	,@Market  varchar(255) = NULL
	,@Region  varchar(255) = NULL
	,@State varchar(255) = NULL
	,@City varchar(255) = NULL
	,@Channel varchar(255) = NULL
	,@Classification varchar(255) = NULL
	,@Status  varchar(255) = NULL
	,@From datetime = NULL
	,@To datetime = NULL)
as 
begin
Declare @TotalScheduled int
	, @TotalPlanned int
	, @TotalExecuted int
	, @NationalScheduled int
	, @NationalExecuted int
	, @NationalTotal int

select  @TotalScheduled = Count(1) 
from Schedule s
left outer join Accounts a on a.fulcrum_id = s.account_name_lookup
where (@Brand = 'All' OR s.brands_sampled like '%' + @Brand + '%')
	AND (@Program = 'All' OR s.program_title = @Program)
	AND (@Market = 'All' OR s.account_market = @Market)
	AND (@Channel = 'All' OR @Channel LIKE '%' + s.account_segment + '%' )
	AND (@Classification = 'All' OR s.account_classification = @Classification)
	AND (s.Status = 'Scheduled')
	AND (@City = 'All' OR s.account_city = @City)
	AND (@State = 'All' OR s.account_state = @State)
	AND (@From IS NULL OR s.promo_event_date >= @From)
	AND (@To IS NULL OR s.promo_event_date <= @To)

select  @TotalExecuted = Count(1) 
from Schedule s
left outer join Accounts a on a.fulcrum_id = s.account_name_lookup
where (@Brand = 'All' OR s.brands_sampled like '%' + @Brand + '%')
	AND (@Program = 'All' OR s.program_title = @Program)
	AND (@Market = 'All' OR s.account_market = @Market)
	AND (@Channel = 'All' OR @Channel LIKE '%' + s.account_segment + '%' )
	AND (@Classification = 'All' OR s.account_classification = @Classification)
	AND (s.Status = 'Completed')
	AND (@City = 'All' OR s.account_city = @City)
	AND (@State = 'All' OR s.account_state = @State)
	AND (@From IS NULL OR s.promo_event_date >= @From)
	AND (@To IS NULL OR s.promo_event_date <= @To)


select  @TotalPlanned = SUM(Value) 
from EventPlan s
where (@Program = 'All' OR s.program_title = @Program)
	AND (@Market = 'All' OR s.account_market = @Market)


select  @NationalScheduled = Count(1) 
from Schedule s
where (s.Status = 'Scheduled')

select  @NationalExecuted = Count(1) 
from Schedule s
where (s.Status = 'Completed')

Select @NationalTotal  = @NationalScheduled + @NationalExecuted

Select @TotalScheduled TotalScheduled
	, @TotalPlanned TotalPlanned
	, @TotalExecuted TotalExecuted
	, @NationalScheduled NationalScheduled
	, @NationalExecuted NationalExecuted
	, @NationalTotal NationalTotal

end



GO
/****** Object:  StoredProcedure [dbo].[GetEventStats]    Script Date: 1/24/2016 10:29:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
exec GetEventStats
*/

create procedure [dbo].[GetEventStats] (
	 @Brand varchar(255) = NULL
	,@Program varchar(255) = NULL
	,@Market  varchar(255) = NULL
	,@Region  varchar(255) = NULL
	,@Channel varchar(255) = NULL
	,@Classification varchar(255) = NULL
	,@Status  varchar(255) = NULL
	,@From datetime = NULL
	,@To datetime = NULL)
as
BEGIN
 declare @TotalPlanned int
		,@TotalCompleted int
		,@TotalScheduled int
		,@TotalCancelled int
		,@TotalAccounts int
		,@TotalAccountsOn int
		,@TotalAccountsOff int
		,@AvgAttendanceOn int
		,@AvgAttendanceOff int
		,@AvgEngagedOn int
		,@AvgSampledOn int
		,@AvgEngagedOff int
		,@AvgSampledOff int
		,@TotalAttendanceOn int
		,@TotalEngagedOn int
		,@TotalSampledOn int
		,@AvgDrinksSoldOn int
		,@TotalDrinksSoldOn int
		,@BottlesSoldPlan int
		,@BottlesSoldActual int
		,@PlanAttendanceOn int
		,@PlanAvgAttendanceOn int
		,@PlanEngagedOn int
		,@PlanAvgEngagedOn int
		,@PlanSampledOn int
		,@PlanAvgSampledOn int
		,@PlanDrinksSoldOn int
		,@PlanAvgDrinksSoldOn int
		,@TotalAttendanceOff int
		,@TotalEngagedOff int
		,@TotalBottlesSoldOff int
		,@AvgBottlesSoldOff int
		,@TotalSampledOff int

 Select @PlanAttendanceOn = AVG(Attendance)
		,@PlanEngagedOn = AVG(Engagement)
		,@PlanSampledOn = AVG(Sampled)
		,@PlanDrinksSoldOn = AVG(DrinksSold)
		from ProgramPlan;

 Select @TotalPlanned = Sum(Value) from EventPlan;
 Select @TotalCompleted = count(1) from Schedule where status = 'Completed';
 Select @TotalScheduled = count (1) from Schedule where status = 'Scheduled';
 Select @TotalCancelled = count(1) from Schedule where status = 'Cancelled'
 Select @TotalAccounts  = count(distinct(account_city+event_account_name)) from Schedule;
 Select @TotalAccountsOn = count(distinct(account_city+event_account_name)) from Schedule where account_segment = 'On_Premise'
 Select @TotalAccountsOff = count(distinct(account_city+event_account_name)) from Schedule where account_segment = 'Off_Premise'

 /*Select count(distinct(account_name_lookup)) from Schedule;
 Select count(distinct(account_name_lookup)) from Schedule where account_segment = 'On_Premise'
 Select count(distinct(account_name_lookup)) from Schedule where account_segment = 'Off_Premise'
 select * from schedule */

  Select @AvgAttendanceOn = AVG(_of_consumer_attendance)
	    ,@TotalAttendanceOn = SUM(_of_consumer_attendance) 
		from Schedule where account_segment = 'On_Premise' and status = 'Completed'
		and _of_consumer_attendance > 0;

 Select @AvgAttendanceOff = AVG(_of_consumer_attendance) 
  ,@TotalAttendanceOff = SUM(_of_consumer_attendance) 
 from Schedule where account_segment = 'Off_Premise' and status = 'Completed'
 and _of_consumer_attendance > 0;

 Select @AvgEngagedOn = AVG(_of_consumers_engaged) 
		,@TotalEngagedOn = SUM(_of_consumers_engaged) 
	from Schedule where account_segment = 'On_Premise' and status = 'Completed' 
	and _of_consumers_engaged > 0;

 Select @AvgEngagedOff = ISNULL(AVG(_of_consumers_engaged),0) 
 		,@TotalEngagedOff = SUM(_of_consumers_engaged) 
 from Schedule where account_segment = 'Off_Premise' and status = 'Completed'
 and _of_consumers_engaged > 0;

 Select @AvgSampledOn = ISNULL(AVG(_of_consumers_sampled),0) 
		,@TotalSampledOn = ISNULL(SUM(_of_consumers_sampled),0) 
 from Schedule where account_segment = 'On_Premise' and status = 'Completed'
 and _of_consumers_sampled > 0;

 Select @AvgSampledOff = ISNULL(AVG(_of_consumers_sampled),0) 
 		,@TotalSampledOff = ISNULL(SUM(_of_consumers_sampled),0) 
 from Schedule where account_segment = 'Off_Premise' and status = 'Completed'
 and _of_consumers_sampled > 0;

 Select @AvgDrinksSoldOn = ISNULL(AVG(total_drinks_sold),0) 
		,@TotalDrinksSoldOn = ISNULL(SUM(total_drinks_sold),0) 
 from Schedule where account_segment = 'On_Premise' and status = 'Completed'
 and total_drinks_sold > 0;

Select @AvgBottlesSoldOff = ISNULL(AVG(convert(int,total_bottles_sold)),0) 
		,@TotalBottlesSoldOff = ISNULL(SUM(convert(int,total_bottles_sold)),0) 
 from Schedule where account_segment = 'Off_Premise' and status = 'Completed'
 and total_bottles_sold > 0;
  
Select @BottlesSoldPlan = (Select SUM(BottlesSold) from ProgramPlan)
	 , @BottlesSoldActual = (Select SUM(Convert(int,total_bottles_sold)) from Schedule)

 Select @TotalPlanned TotalPlanned
	    ,@TotalCompleted TotalCompleted
	    ,@TotalScheduled TotalScheduled
		,@TotalCancelled TotalCancelled
		,@TotalPlanned - @TotalCompleted - @TotalScheduled TotalRemaining
		/* ,(Select count(1) from Schedule where account_segment = 'On_Premise' and status = 'Completed' and _of_consumer_attendance < @AvgAttendanceOn) TotalBelowAttendanceOn
		,(Select count(1) from Schedule where account_segment = 'On_Premise' and status = 'Completed' and _of_consumers_engaged < @AvgEngagedOn) TotalBelowEngagedOn
		,(Select count(1) from Schedule where account_segment = 'On_Premise' and status = 'Completed' and _of_consumers_sampled < @AvgSampledOn) TotalBelowSampledOn
		,(Select count(1) from Schedule where account_segment = 'On_Premise' and status = 'Completed' and _of_consumers_sampled >= @AvgSampledOn) TotalAboveSampledOn
		,(Select count(1) from Schedule where account_segment = 'Off_Premise' and status = 'Completed' and _of_consumer_attendance < @AvgAttendanceOff) TotalBelowAttendanceOff
		,(Select count(1) from Schedule where account_segment = 'Off_Premise' and status = 'Completed' and _of_consumers_engaged < @AvgEngagedOff) TotalBelowEngagedOff
		,(Select count(1) from Schedule where account_segment = 'Off_Premise' and status = 'Completed' and _of_consumers_sampled < @AvgSampledOff) TotalBelowSampledOff
		,(Select count(1) from Schedule where account_segment = 'Off_Premise' and status = 'Completed' and _of_consumers_sampled >= @AvgSampledOff) TotalAboveSampledOff
		*/
		,@TotalAccounts TotalAccounts
		,@TotalAccountsOn TotalAccountsOn
		,@TotalAccountsOff TotalAccountsOff
		
		,@PlanAttendanceOn PlanAttendanceOn
		,@TotalAttendanceOn TotalAttendanceOn
		,@PlanAvgAttendanceOn PlanAvgAttendanceOn
		,@AvgAttendanceOn AvgAttendanceOn

		,@PlanEngagedOn PlanEngagedOn
		,@TotalEngagedOn TotalEngagedOn
		,@PlanAvgEngagedOn PlanAvgEngagedOn
		,@AvgEngagedOn AvgEngagedOn

		,@PlanSampledOn PlanSampledOn
		,@TotalSampledOn TotalSampledOn
		,@PlanAvgSampledOn PlanAvgSampledOn
		,@AvgSampledOn AvgSampledOn

		/*,@AvgAttendanceOff AvgAttendanceOff
		,@AvgEngagedOff AvgEngagedOff
		,@AvgSampledOff AvgSampledOff*/

		,@PlanDrinksSoldOn PlanDrinksSoldOn
		,@TotalDrinksSoldOn TotalDrinksSoldOn
		,@PlanAvgDrinksSoldOn PlanAvgDrinksSoldOn
		,@AvgDrinksSoldOn AvgDrinksSoldOn

		,@BottlesSoldPlan BottlesSoldPlan
		,@BottlesSoldActual BottlesSoldActual

		,@TotalAttendanceOff TotalAttendanceOff
		,@AvgAttendanceOff AvgAttendanceOff
		,@TotalEngagedOff TotalEngagedOff
		,@AvgEngagedOff AvgEngagedOff
		,@TotalBottlesSoldOff TotalBottlesSoldOff
		,@AvgBottlesSoldOff AvgBottlesSoldOff
		,@TotalSampledOff TotalSampledOff
		,@AvgSampledOff AvgSampledOff

 END;

 



GO
/****** Object:  StoredProcedure [dbo].[GetLife]    Script Date: 1/24/2016 10:29:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[GetLife]
as
begin
exec Evolve2;

WITH    q AS
        (
        SELECT  0 AS N
        UNION ALL
        SELECT  N + 1
        FROM    q
        WHERE   N < 40
        )
SELECT  X.N X, Y.N Y, CASE WHEN NOT (T.X IS NULL) THEN '+' ELSE NULL END Alive
FROM q X
JOIN q Y on 1=1
Left outer join T on T.X = X.N and T.Y = Y.N
where Y.N < 30
end
GO
/****** Object:  StoredProcedure [dbo].[GetParamValues]    Script Date: 1/24/2016 10:29:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
exec GetParamValues 'region'
*/

create procedure [dbo].[GetParamValues] (
	 @param varchar(255),
	 @parent varchar(255) = NULL --parent value
)
as begin

IF @param='brand'
BEGIN
	select 'All' Value
	union ALL
	select 'Bayou Silver' Value
	union ALL
	select 'Bayou Spice'
	union ALL
	select 'Bayou Satsuma'
	union ALL
	select 'Bayou Select 750ML'
END
ELSE IF @param='region'
BEGIN
	select 'All' Value
	union ALL
	select 'Central'  Value
	union ALL
	select 'Southeast'
END
ELSE
BEGIN
	select 'All' Value
	union ALL
	select distinct 
	ISNULL(
	 CASE @param
	  WHEN 'program' THEN program_title 
	  WHEN 'market' THEN account_market
	  WHEN 'region' THEN account_region
      WHEN 'channel' THEN account_segment
      WHEN 'class' THEN account_classification
      WHEN 'state' THEN account_state
      WHEN 'city' THEN account_city
      WHEN 'status' THEN status
    END,'')
	from Schedule
	where (ISNULL(@parent,'All') = 'All') 
	OR (@param = 'state' and @parent = 'Central' and account_state IN ('LA','TX'))
	OR (@param = 'state' and @parent = 'Southeast' and account_state IN ('AL','FL','GA','MS'))
	OR (@param = 'market' and account_state = @parent)
	OR (@param = 'city' and account_market = @parent)
END;

end


GO
/****** Object:  StoredProcedure [dbo].[GetPlanExecution]    Script Date: 1/24/2016 10:29:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
exec GetPlanExecution

select * from Schedule where account_market in ('New Orleans','Baton Rouge') --67

*/
create procedure [dbo].[GetPlanExecution]
AS
BEGIN
WITH A AS(
	Select Distinct * from 
	(Select Distinct program_title, CASE account_market WHEN 'Lake Charles' THEN 'Lafayette' WHEN 'New Orleans' THEN 'Baton Rouge' ELSE account_market END account_market from Schedule 
	union all 
	Select Distinct program_title,  CASE account_market WHEN 'Lake Charles' THEN 'Lafayette' WHEN 'New Orleans' THEN 'Baton Rouge' ELSE account_market END from EventPlan ) aa)
,T AS(Select program_title,  CASE account_market WHEN 'Lake Charles' THEN 'Lafayette' WHEN 'New Orleans' THEN 'Baton Rouge' ELSE account_market END account_market
	, status, count(1) Num
from Schedule
group by program_title, CASE account_market WHEN 'Lake Charles' THEN 'Lafayette' WHEN 'New Orleans' THEN 'Baton Rouge' ELSE account_market END, status)
select ISNULL(a.account_market,'Unknown') account_market
	,  ISNULL(a.program_title,'Unknown') program_title
	, CASE(SUM(ISNULL(p.value,0))) WHEN 0 THEN NULL ELSE SUM(ISNULL(p.value,0)) END as Planned
	, CASE(SUM(ISNULL(t1.Num,0))) WHEN 0 THEN NULL ELSE SUM(ISNULL(t1.Num,0)) END as Scheduled	
	, CASE(SUM(ISNULL(t1.Num,0)) + SUM(ISNULL(t2.Num,0))) WHEN 0 THEN NULL ELSE SUM(ISNULL(t1.Num,0)) + SUM(ISNULL(t2.Num,0)) END as Total
	, SUM(ISNULL(p.value,0)) - SUM(ISNULL(t1.Num,0)) - SUM(ISNULL(t2.Num,0)) as Remain
	, SUM(t2.Num) as Executed
	from A
	left outer join (select program_title
					,CASE account_market WHEN 'Lake Charles' THEN 'Lafayette' WHEN 'New Orleans' THEN 'Baton Rouge' ELSE account_market END account_market
					,SUM(value) value
					from EventPlan 
					group by program_title
					,CASE account_market WHEN 'Lake Charles' THEN 'Lafayette' WHEN 'New Orleans' THEN 'Baton Rouge' ELSE account_market END) p ON ISNULL(a.program_title,'') = ISNULL(p.program_title,'') 
																																				  AND ISNULL(a.account_market,'') = ISNULL(p.account_market,'') 
	left outer join T t1 on ISNULL(t1.account_market,'') = ISNULL(a.account_market,'') and ISNULL(t1.program_title,'') = ISNULL(a.program_title,'') and t1.Status = 'Scheduled'
	left outer join T t2 on ISNULL(t2.account_market,'') = ISNULL(a.account_market,'') and ISNULL(t2.program_title,'') = ISNULL(a.program_title,'') and t2.Status = 'Completed'
	group by a.account_market
		   , a.program_title
	order by a.account_market
END


GO
/****** Object:  StoredProcedure [dbo].[GetProgramStats]    Script Date: 1/24/2016 10:29:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
exec GetProgramStats

select * from EventPlan

select * from schedule
*/

create procedure [dbo].[GetProgramStats]
as begin
	Select program_title
		, (select MAX(account_segment) from Schedule s1 where s1.Program_title = s.program_title) account_segment
		, (select SUM(Value) from EventPlan where program_title = s.program_title) Planned
		, (select count(1) from Schedule s1 where s1.status = 'Scheduled' and s1.program_title = s.program_title) Scheduled
		, (select count(1) from Schedule s1 where s1.status = 'Completed' and s1.program_title = s.program_title) Executed
		, count(1) Total from Schedule s
	where program_title IS NOT NULL
	group by program_title
	order by (select MAX(account_segment) from Schedule s1 where s1.Program_title = s.program_title), program_title
end



GO
/****** Object:  StoredProcedure [dbo].[LoadData]    Script Date: 1/24/2016 10:29:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
exec LoadData
select * from Schedule
select * from Schedule_Stg_Bkp
select * from Schedule_Bkp

select name from syscolumns where id = object_id('Schedule_Stg_Bkp') and name like '%region%'
select distinct account_region from Schedule_Stg_Bkp

ALTER TABLE Schedule ALTER COLUMN promo_event_start_time varchar(255)
ALTER TABLE Schedule ALTER COLUMN promo_event_end_time varchar(255)

truncate table Schedule
*/

create procedure [dbo].[LoadData] 
as
begin

IF exists (select 1 from sysobjects where id=object_id('Schedule_Bkp'))
	EXEC('drop table Schedule_Bkp');

Select * INTO Schedule_Bkp from Schedule

TRUNCATE TABLE Schedule  

Insert Schedule(fulcrum_id,
	status,
	account_market,
	account_name_lookup,
	event_account_name,
	account_street_address,
	account_city,
	account_state,
	account_zip,
	account_phone_,
	account_region,
	account_segment,
	account_classification,
	account_website,
	account_manager_email,
	account_contact,
	program_title,
	brands_sampled,
	promo_event_date,
	promo_event_start_time,
	promo_event_end_time,
	total_drinks_sold,
	total_bottles_sold,
	total_actual_event_bar_spend,
	_of_consumer_attendance,
	_of_consumers_engaged,
	_of_consumers_sampled)
Select fulcrum_id, 
	status,
	account_market,
	account_name_lookup,
	event_account_name,
	account_street_address,
	account_city,
	account_state,
	account_zip,
	account_phone_,
	account_region,
	account_segment,
	account_classification,
	account_website,
	account_manager_email,
	account_contact,
	program_title,
	brands_sampled,
	Convert(smalldatetime,promo_event_date),
	promo_event_start_time,
	promo_event_end_time,
	total_drinks_sold_on_premise,
	total_bottles_sold_off_premise,
	total_actual_event_bar_spend,
	_of_consumer_attendance,
	_of_consumers_engaged,
	_of_consumers_sampled
from Schedule_Stg

IF exists (select 1 from sysobjects where id=object_id('Schedule_Stg_Bkp'))
	EXEC('drop table Schedule_Stg_Bkp');

Select * INTO Schedule_Stg_Bkp from Schedule_Stg

TRUNCATE TABLE Schedule_Stg  

Exec LoadDataEx;

end


GO
/****** Object:  StoredProcedure [dbo].[LoadDataEx]    Script Date: 1/24/2016 10:29:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
select status, count(1) 
from Schedule 
group by Status
where status <> 'Cancelled'


select @@Version
*/

create procedure [dbo].[LoadDataEx]
as
begin


Update Schedule set account_segment = 'On_Premise' where account_segment is null
Update Schedule set  account_segment = 'On_Premise' where account_segment = 'On-Premise'
Update Schedule set  account_state = 'TX' where account_state = 'Texas'
Update Schedule set  account_state = 'LA' where account_state = 'Louisiana'
Update Schedule set  program_title = REPLACE(program_title,'_OnPremise',' OnPremise') where program_title like '%_OnPremise%'
Update Schedule set  program_title = REPLACE(program_title,'_OffPremise',' OffPremise') where program_title like '%_OffPremise%'
Update Schedule set  program_title = REPLACE(program_title,'Bayou_','Bayou ') where program_title like 'Bayou_%'
Update Schedule set  program_title = REPLACE(program_title,'Margarita_','Margarita ') where program_title like '%Margarita_%'
update Schedule set program_title = 'Bayou Satsuma Shots' where program_title = 'Bayou Satsuma_Shots'
update Schedule set program_title = 'Bayou Holiday OffPremise' where program_title = 'Bayou Portfolio OffPremise'
update Schedule set program_title = 'Bayou Rum Off Premise' where program_title = 'Bayou Holiday OffPremise'
Update Schedule set account_segment = 'Off_Premise' where account_segment = 'Off-Premise'
update Schedule set program_title = 'Bayou Special Event' where program_title = 'Bayou SpecialEvent'

Update Settings set value = Convert(varchar,dateadd(hour,-4,GETUTCDATE())) where name = 'LastFulcrumPull'

end

GO
/****** Object:  StoredProcedure [dbo].[obSortObject]    Script Date: 1/24/2016 10:29:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[obSortObject](
@id int
,@Object varchar(255)
,@Direction varchar(255)
)
as
begin
declare @ParentID varchar(255);
Select  @ParentID = CASE WHEN @Object = 'obOption' THEN 'idQuestion' Else 'idClient' END;

	EXEC('WITH T AS (
Select 
Id
,Row_Number() OVER (ORDER BY SortOrder, id) * 10 + CASE WHEN id = '+@id+' THEN 15 * CASE WHEN ''Up'' = '''+ @Direction + ''' THEN -1 ELSE 1 END ELSE 0 END N
From '+@Object+'
where '+@ParentID+ ' = (Select '+@ParentID+ ' from '+@Object+' where id='+@id+')
)
Update '+@Object+' 
set SortOrder = T.N
from '+@Object+',T
Where '+@Object+'.Id  = T.Id')
end


GO
/****** Object:  StoredProcedure [dbo].[ProgramPlanGet]    Script Date: 1/24/2016 10:29:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
exec dbo.ProgramPlanGet
*/
create procedure [dbo].[ProgramPlanGet] 
as
begin
	with T as (select distinct Program_Title from Schedule)
	select T.Program_Title
	,p.Attendance
	,p.Engagement
	,p.Sampled
	,p.DrinksSold
	,p.BarSpend
	,p.BottlesSold
	 from T
	 left outer join ProgramPlan p on p.Program_Title = t.program_title
end
GO
/****** Object:  StoredProcedure [dbo].[ProgramPlanSet]    Script Date: 1/24/2016 10:29:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
        myCommand.Parameters.AddWithValue("Program", Program);
        myCommand.Parameters.AddWithValue("Attendace", Attendace);
        myCommand.Parameters.AddWithValue("AvgAttendace", AvgAttendace);
        myCommand.Parameters.AddWithValue("Engagement", Engagement);
        myCommand.Parameters.AddWithValue("AvgEngagement", AvgEngagement);
        myCommand.Parameters.AddWithValue("Sampled", Sampled);
        myCommand.Parameters.AddWithValue("AvgSampled", AvgSampled);
        myCommand.Parameters.AddWithValue("DrinksSold", DrinksSold);
        myCommand.Parameters.AddWithValue("AvgDrinksSold", AvgDrinksSold);
        myCommand.Parameters.AddWithValue("BarSpend", BarSpend);
        myCommand.Parameters.AddWithValue("BottlesSold", BottlesSold);

		select * from ProgramPlan


*/
create procedure [dbo].[ProgramPlanSet] (
	@Program varchar(255)
    ,@Attendance varchar(255) 
    ,@Engagement varchar(255)
	,@Sampled varchar(255)
	,@DrinksSold varchar(255)
	,@BarSpend varchar(255)
	,@BottlesSold varchar(255)
)
as
begin
	if exists(select 1 from ProgramPlan where program_title = @Program)
		update ProgramPlan set 
			Attendance = Convert(int,@Attendance) 
			,Engagement = Convert(int,@Engagement)
			,Sampled  = Convert(int,@Sampled)
			,DrinksSold  = Convert(int,@DrinksSold)
			,BarSpend  = Convert(int,@BarSpend)
			,BottlesSold  = Convert(int,@BottlesSold)
			where program_title = @Program
	else
		Insert ProgramPlan(program_title,Attendance
			,Engagement
			,Sampled
			,DrinksSold
			,BarSpend
			,BottlesSold)
		values (@Program
				,Convert(int,@Attendance)
				,Convert(int,@Engagement)
				,Convert(int,@Sampled)
				,Convert(int,@DrinksSold)
				,Convert(int,@BarSpend)
				,Convert(int,@BottlesSold))
end

GO
/****** Object:  StoredProcedure [dbo].[RestoreData]    Script Date: 1/24/2016 10:29:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[RestoreData] 
as
begin
	if exists(select 1 from Schedule_Bkp)
	begin
		truncate table Schedule

		Insert into Schedule Select * from Schedule_Bkp
	end
end
GO
/****** Object:  UserDefinedFunction [dbo].[F]    Script Date: 1/24/2016 10:29:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[F](@X int, @Y int)
returns int
as 
begin
	declare @r int
	Select @r = count(1) from T	
	WHERE ABS(T.X - @X) < 2
	AND ABS(T.Y - @Y) < 2
	AND NOT (T.X=@X AND T.Y=@Y)
	return @r
end

GO
/****** Object:  Table [dbo].[Accounts]    Script Date: 1/24/2016 10:29:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Accounts](
	[fulcrum_id] [varchar](36) NULL,
	[created_at] [varchar](23) NULL,
	[updated_at] [varchar](23) NULL,
	[created_by] [varchar](25) NULL,
	[updated_by] [varchar](25) NULL,
	[system_created_at] [varchar](23) NULL,
	[system_updated_at] [varchar](23) NULL,
	[version] [smallint] NULL,
	[status] [varchar](9) NULL,
	[project] [varchar](18) NULL,
	[assigned_to] [varchar](19) NULL,
	[latitude] [real] NULL,
	[longitude] [real] NULL,
	[geometry] [varchar](47) NULL,
	[account_name] [varchar](52) NULL,
	[account_segment] [varchar](13) NULL,
	[account_classification] [varchar](10) NULL,
	[account_classification_other] [varchar](max) NULL,
	[account_address_sub_thoroughfare] [varchar](32) NULL,
	[account_address_thoroughfare] [varchar](34) NULL,
	[account_address_locality] [varchar](21) NULL,
	[account_address_sub_admin_area] [varchar](16) NULL,
	[account_address_admin_area] [varchar](8) NULL,
	[account_address_postal_code] [varchar](8) NULL,
	[account_address_country] [varchar](13) NULL,
	[account_address_suite] [varchar](4) NULL,
	[account_address_full] [varchar](90) NULL,
	[account_street_address] [varchar](18) NULL,
	[account_city] [varchar](13) NULL,
	[account_zip_code] [int] NULL,
	[account_state] [varchar](9) NULL,
	[account_region] [varchar](9) NULL,
	[account_market] [varchar](12) NULL,
	[account_phone_] [bigint] NULL,
	[accout_email_address] [varchar](27) NULL,
	[account_website] [varchar](52) NULL,
	[account_buyers_name] [varchar](52) NULL,
	[distributor_reps] [varchar](73) NULL,
	[distributor_reps_other] [varchar](max) NULL,
	[class_b_wholesale] [varchar](max) NULL,
	[account_manager_name] [varchar](453) NULL,
	[account_manager_email] [varchar](max) NULL,
	[account_contact_2_name] [varchar](90) NULL,
	[account_contact_2_email] [varchar](max) NULL,
	[account_tdlinx_id] [varchar](max) NULL,
	[account_capacity] [varchar](max) NULL,
	[bayou_rum_products_placed] [varchar](100) NULL,
	[bayou_rum_products_placed_other] [varchar](38) NULL,
	[bayou_on_back_bar] [varchar](3) NULL,
	[promotional_programs_executed] [varchar](25) NULL,
	[promotional_programs_executed_other] [varchar](max) NULL,
	[drink_price_well] [real] NULL,
	[drink_price_premium] [smallint] NULL,
	[drink_price_feature] [real] NULL,
	[off_premise_shelf_price] [varchar](max) NULL,
	[inventory_silver_bottles] [smallint] NULL,
	[inventory_spice_bottles] [int] NULL,
	[inventory_satsuma_bottles] [smallint] NULL,
	[photos_of_account_drink_menus] [varchar](max) NULL,
	[photos_of_account_drink_menus_caption] [varchar](max) NULL,
	[photos_of_account_drink_menus_url] [varchar](max) NULL,
	[photos_of_account_displays] [varchar](max) NULL,
	[photos_of_account_displays_caption] [varchar](max) NULL,
	[photos_of_account_displays_url] [varchar](max) NULL,
	[photos_of_account_business_card] [varchar](max) NULL,
	[photos_of_account_business_card_caption] [varchar](max) NULL,
	[photos_of_account_business_card_url] [varchar](max) NULL,
	[account_photos] [varchar](max) NULL,
	[account_photos_caption] [varchar](max) NULL,
	[account_photos_url] [varchar](max) NULL,
	[account_videos] [varchar](max) NULL,
	[account_videos_caption] [varchar](max) NULL,
	[account_videos_url] [varchar](max) NULL,
	[date_for_next_appointment] [datetime] NULL,
	[account_commentsnotes] [varchar](591) NULL,
	[gps_altitude] [varchar](max) NULL,
	[gps_horizontal_accuracy] [varchar](max) NULL,
	[gps_vertical_accuracy] [varchar](max) NULL,
	[gps_speed] [varchar](max) NULL,
	[gps_course] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[EventPlan]    Script Date: 1/24/2016 10:29:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EventPlan](
	[account_market] [varchar](255) NULL,
	[program_title] [varchar](255) NULL,
	[Value] [int] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[obActivity]    Script Date: 1/24/2016 10:29:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[obActivity](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idClient] [int] NOT NULL,
	[content] [varchar](max) NULL,
	[topic] [varchar](255) NULL,
	[week] [varchar](255) NULL,
	[time] [varchar](255) NULL,
	[day] [varchar](255) NULL,
	[visible] [varchar](255) NOT NULL,
	[hidden] [varchar](255) NOT NULL,
	[Name] [varchar](255) NULL,
	[SortOrder] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[obClient]    Script Date: 1/24/2016 10:29:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[obClient](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](255) NULL,
	[email] [varchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[obLandingPage]    Script Date: 1/24/2016 10:29:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[obLandingPage](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idClient] [int] NOT NULL,
	[name] [varchar](255) NULL,
	[content] [varchar](max) NULL,
	[visible] [varchar](255) NOT NULL,
	[hidden] [varchar](255) NOT NULL,
	[SortOrder] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[obOption]    Script Date: 1/24/2016 10:29:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[obOption](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idQuestion] [int] NOT NULL,
	[name] [varchar](255) NULL,
	[tag] [varchar](255) NULL,
	[visible] [varchar](255) NOT NULL,
	[hidden] [varchar](255) NOT NULL,
	[SortOrder] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[obQuestion]    Script Date: 1/24/2016 10:29:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[obQuestion](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idClient] [int] NOT NULL,
	[name] [varchar](255) NULL,
	[visible] [varchar](255) NULL,
	[hidden] [varchar](255) NOT NULL,
	[SortOrder] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ProgramPlan]    Script Date: 1/24/2016 10:29:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ProgramPlan](
	[program_title] [varchar](255) NULL,
	[Attendance] [int] NULL,
	[Engagement] [int] NULL,
	[Sampled] [int] NULL,
	[DrinksSold] [int] NULL,
	[BarSpend] [int] NULL,
	[BottlesSold] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Results1]    Script Date: 1/24/2016 10:29:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Results1](
	[fulcrum_id] [nvarchar](255) NULL,
	[created_at] [nvarchar](255) NULL,
	[updated_at] [nvarchar](255) NULL,
	[created_by] [nvarchar](255) NULL,
	[updated_by] [nvarchar](255) NULL,
	[system_created_at] [nvarchar](255) NULL,
	[system_updated_at] [nvarchar](255) NULL,
	[version] [float] NULL,
	[status] [nvarchar](255) NULL,
	[project] [nvarchar](255) NULL,
	[assigned_to] [nvarchar](255) NULL,
	[latitude] [float] NULL,
	[longitude] [float] NULL,
	[geometry] [nvarchar](255) NULL,
	[select_role] [nvarchar](255) NULL,
	[account_market] [nvarchar](255) NULL,
	[account_name_lookup] [nvarchar](255) NULL,
	[event_account_name] [nvarchar](255) NULL,
	[account_street_address] [nvarchar](255) NULL,
	[account_city] [nvarchar](255) NULL,
	[account_state] [nvarchar](255) NULL,
	[account_zip] [float] NULL,
	[account_phone_] [float] NULL,
	[account_region] [nvarchar](255) NULL,
	[account_segment] [nvarchar](255) NULL,
	[account_classification] [nvarchar](255) NULL,
	[account_website] [nvarchar](255) NULL,
	[account_manager_email] [nvarchar](255) NULL,
	[account_contact] [nvarchar](255) NULL,
	[account_location_sub_thoroughfare] [nvarchar](255) NULL,
	[account_location_thoroughfare] [nvarchar](255) NULL,
	[account_location_locality] [nvarchar](255) NULL,
	[account_location_sub_admin_area] [nvarchar](255) NULL,
	[account_location_admin_area] [nvarchar](255) NULL,
	[account_location_postal_code] [nvarchar](255) NULL,
	[account_location_country] [nvarchar](255) NULL,
	[account_location_suite] [nvarchar](255) NULL,
	[account_location_full] [nvarchar](255) NULL,
	[program_title] [nvarchar](255) NULL,
	[program_title_other] [nvarchar](255) NULL,
	[promo_event_date] [datetime] NULL,
	[promo_event_start_time] [datetime] NULL,
	[promo_event_end_time] [datetime] NULL,
	[event_osm] [datetime] NULL,
	[event_osm_other] [nvarchar](255) NULL,
	[event_staff] [nvarchar](255) NULL,
	[event_staff_other] [nvarchar](255) NULL,
	[brands_sampled] [nvarchar](255) NULL,
	[brands_sampled_other] [nvarchar](255) NULL,
	[cocktails_sampled] [nvarchar](255) NULL,
	[cocktails_sampled_other] [nvarchar](255) NULL,
	[did_account_purchase_a_bayou_rum_chill_machine] [nvarchar](255) NULL,
	[did_account_have_a_working_bayou_rums_chill_machine] [nvarchar](255) NULL,
	[does_account_have_competitive_chill_machines] [nvarchar](255) NULL,
	[list_competitive_chill_machine_brands] [nvarchar](255) NULL,
	[list_competitive_chill_machine_brands_other] [nvarchar](255) NULL,
	[drink_regular_price] [float] NULL,
	[drink_feature_price] [float] NULL,
	[negotiated_sample_price] [nvarchar](255) NULL,
	[planned_event_bar_spend_before_tip] [nvarchar](255) NULL,
	[planned_event_bar_tab_tip] [nvarchar](255) NULL,
	[total_planned_event_bar_spend] [nvarchar](255) NULL,
	[actual_event_bar_spend_before_tip] [float] NULL,
	[actual_event_bar_tab_tip] [float] NULL,
	[total_actual_event_bar_spend] [float] NULL,
	[_of_consumer_attendance] [float] NULL,
	[_of_consumers_engaged] [float] NULL,
	[_of_consumers_sampled] [float] NULL,
	[_of_bartenders_trained] [float] NULL,
	[_of_wait_staff_trained] [float] NULL,
	[good_target_account_for_brand] [nvarchar](255) NULL,
	[event_comments] [nvarchar](255) NULL,
	[suggestions] [nvarchar](255) NULL,
	[event_rating] [nvarchar](255) NULL,
	[event_photos_min_3] [nvarchar](255) NULL,
	[event_photos_min_3_caption] [nvarchar](255) NULL,
	[event_photos_min_3_url] [nvarchar](255) NULL,
	[event_videos] [nvarchar](255) NULL,
	[event_videos_caption] [nvarchar](255) NULL,
	[event_videos_url] [nvarchar](255) NULL,
	[gps_altitude] [float] NULL,
	[gps_horizontal_accuracy] [float] NULL,
	[gps_vertical_accuracy] [nvarchar](255) NULL,
	[gps_speed] [nvarchar](255) NULL,
	[gps_course] [float] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[s1]    Script Date: 1/24/2016 10:29:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[s1](
	[fulcrum_id] [varchar](36) NULL,
	[created_at] [varchar](23) NULL,
	[updated_at] [varchar](23) NULL,
	[created_by] [varchar](19) NULL,
	[updated_by] [varchar](25) NULL,
	[system_created_at] [varchar](23) NULL,
	[system_updated_at] [varchar](23) NULL,
	[version] [bigint] NULL,
	[status] [varchar](9) NULL,
	[project] [varchar](18) NULL,
	[assigned_to] [varchar](19) NULL,
	[latitude] [float] NULL,
	[longitude] [float] NULL,
	[geometry] [varchar](42) NULL,
	[select_role] [varchar](3) NULL,
	[account_market] [varchar](11) NULL,
	[account_name_lookup] [varchar](36) NULL,
	[event_account_name] [varchar](35) NULL,
	[account_street_address] [varchar](38) NULL,
	[account_city] [varchar](12) NULL,
	[account_state] [varchar](9) NULL,
	[account_zip] [bigint] NULL,
	[account_phone_] [bigint] NULL,
	[account_region] [varchar](9) NULL,
	[account_segment] [varchar](10) NULL,
	[account_classification] [varchar](10) NULL,
	[account_website] [varchar](38) NULL,
	[account_manager_email] [varchar](8) NULL,
	[account_contact] [varchar](9) NULL,
	[account_location_sub_thoroughfare] [varchar](max) NULL,
	[account_location_thoroughfare] [varchar](max) NULL,
	[account_location_locality] [varchar](max) NULL,
	[account_location_sub_admin_area] [varchar](max) NULL,
	[account_location_admin_area] [varchar](max) NULL,
	[account_location_postal_code] [varchar](max) NULL,
	[account_location_country] [varchar](max) NULL,
	[account_location_suite] [varchar](max) NULL,
	[account_location_full] [varchar](max) NULL,
	[program_title] [varchar](25) NULL,
	[program_title_other] [varchar](max) NULL,
	[promo_event_date] [datetime] NULL,
	[promo_event_start_time] [datetime] NULL,
	[promo_event_end_time] [datetime] NULL,
	[event_osm] [varchar](max) NULL,
	[event_osm_other] [varchar](13) NULL,
	[event_staff] [varchar](max) NULL,
	[event_staff_other] [varchar](13) NULL,
	[brands_sampled] [varchar](57) NULL,
	[brands_sampled_other] [varchar](max) NULL,
	[cocktails_sampled] [varchar](68) NULL,
	[cocktails_sampled_other] [varchar](31) NULL,
	[did_account_purchase_a_bayou_rum_chill_machine] [varchar](2) NULL,
	[did_account_have_a_working_bayou_rums_chill_machine] [varchar](3) NULL,
	[does_account_have_competitive_chill_machines] [varchar](3) NULL,
	[list_competitive_chill_machine_brands] [varchar](20) NULL,
	[list_competitive_chill_machine_brands_other] [varchar](max) NULL,
	[drink_regular_price] [bigint] NULL,
	[drink_feature_price] [bigint] NULL,
	[negotiated_sample_price] [varchar](max) NULL,
	[planned_event_bar_spend_before_tip] [bigint] NULL,
	[planned_event_bar_tab_tip] [bigint] NULL,
	[total_planned_event_bar_spend] [bigint] NULL,
	[actual_event_bar_spend_before_tip] [float] NULL,
	[actual_event_bar_tab_tip] [float] NULL,
	[total_actual_event_bar_spend] [float] NULL,
	[_of_consumer_attendance] [bigint] NULL,
	[_of_consumers_engaged] [bigint] NULL,
	[_of_consumers_sampled] [bigint] NULL,
	[_of_bartenders_trained] [bigint] NULL,
	[_of_wait_staff_trained] [bigint] NULL,
	[good_target_account_for_brand] [varchar](3) NULL,
	[event_comments] [varchar](172) NULL,
	[suggestions] [varchar](49) NULL,
	[event_rating] [varchar](17) NULL,
	[event_photos_min_3] [varchar](max) NULL,
	[event_photos_min_3_caption] [varchar](12) NULL,
	[event_photos_min_3_url] [varchar](574) NULL,
	[event_videos] [varchar](max) NULL,
	[event_videos_caption] [varchar](max) NULL,
	[event_videos_url] [varchar](max) NULL,
	[gps_altitude] [float] NULL,
	[gps_horizontal_accuracy] [bigint] NULL,
	[gps_vertical_accuracy] [bigint] NULL,
	[gps_speed] [float] NULL,
	[gps_course] [float] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Schedule]    Script Date: 1/24/2016 10:29:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Schedule](
	[fulcrum_id] [varchar](36) NULL,
	[created_at] [varchar](255) NULL,
	[updated_at] [varchar](255) NULL,
	[created_by] [varchar](255) NULL,
	[updated_by] [varchar](255) NULL,
	[system_created_at] [varchar](255) NULL,
	[system_updated_at] [varchar](255) NULL,
	[version] [smallint] NULL,
	[status] [varchar](255) NULL,
	[project] [varchar](255) NULL,
	[assigned_to] [varchar](255) NULL,
	[latitude] [real] NULL,
	[longitude] [real] NULL,
	[geometry] [varchar](255) NULL,
	[select_role] [varchar](255) NULL,
	[account_market] [varchar](255) NULL,
	[account_name_lookup] [varchar](255) NULL,
	[event_account_name] [varchar](255) NULL,
	[account_street_address] [varchar](255) NULL,
	[account_city] [varchar](255) NULL,
	[account_state] [varchar](255) NULL,
	[account_zip] [int] NULL,
	[account_phone_] [bigint] NULL,
	[account_region] [varchar](255) NULL,
	[account_segment] [varchar](255) NULL,
	[account_classification] [varchar](255) NULL,
	[account_website] [varchar](255) NULL,
	[account_manager_email] [varchar](255) NULL,
	[account_contact] [varchar](255) NULL,
	[account_location_sub_thoroughfare] [varchar](max) NULL,
	[account_location_thoroughfare] [varchar](max) NULL,
	[account_location_locality] [varchar](max) NULL,
	[account_location_sub_admin_area] [varchar](max) NULL,
	[account_location_admin_area] [varchar](max) NULL,
	[account_location_postal_code] [varchar](max) NULL,
	[account_location_country] [varchar](max) NULL,
	[account_location_suite] [varchar](max) NULL,
	[account_location_full] [varchar](max) NULL,
	[program_title] [varchar](255) NULL,
	[program_title_other] [varchar](max) NULL,
	[promo_event_date] [datetime] NULL,
	[promo_event_start_time] [varchar](255) NULL,
	[promo_event_end_time] [varchar](255) NULL,
	[event_osm] [varchar](max) NULL,
	[event_osm_other] [varchar](255) NULL,
	[event_staff] [varchar](max) NULL,
	[event_staff_other] [varchar](255) NULL,
	[brands_sampled] [varchar](255) NULL,
	[brands_sampled_other] [varchar](max) NULL,
	[cocktails_sampled] [varchar](255) NULL,
	[cocktails_sampled_other] [varchar](255) NULL,
	[did_account_purchase_a_bayou_rum_chill_machine] [varchar](255) NULL,
	[did_account_have_a_working_bayou_rums_chill_machine] [varchar](255) NULL,
	[does_account_have_competitive_chill_machines] [varchar](255) NULL,
	[list_competitive_chill_machine_brands] [varchar](255) NULL,
	[list_competitive_chill_machine_brands_other] [varchar](max) NULL,
	[drink_regular_price] [smallint] NULL,
	[drink_feature_price] [smallint] NULL,
	[negotiated_sample_price] [smallint] NULL,
	[planned_event_bar_spend_before_tip] [smallint] NULL,
	[planned_event_bar_tab_tip] [smallint] NULL,
	[total_planned_event_bar_spend] [smallint] NULL,
	[actual_event_bar_spend_before_tip] [real] NULL,
	[actual_event_bar_tab_tip] [real] NULL,
	[total_actual_event_bar_spend] [real] NULL,
	[total_drinks_sold] [smallint] NULL,
	[_of_consumer_attendance] [smallint] NULL,
	[_of_consumers_engaged] [smallint] NULL,
	[_of_consumers_sampled] [smallint] NULL,
	[_of_bartenders_trained] [smallint] NULL,
	[_of_wait_staff_trained] [smallint] NULL,
	[good_target_account_for_brand] [varchar](255) NULL,
	[event_comments] [varchar](255) NULL,
	[suggestions] [varchar](255) NULL,
	[event_rating] [varchar](255) NULL,
	[Column 75] [varchar](max) NULL,
	[event_videos_url] [varchar](max) NULL,
	[gps_altitude] [real] NULL,
	[gps_horizontal_accuracy] [smallint] NULL,
	[gps_vertical_accuracy] [smallint] NULL,
	[gps_speed] [real] NULL,
	[gps_course] [real] NULL,
	[total_bottles_sold] [varchar](255) NULL,
	[event_photos_min_3] [varchar](max) NULL,
	[total_drinks_sold_on_premise] [int] NULL,
	[total_bottles_sold_off_premise] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Schedule_Bkp]    Script Date: 1/24/2016 10:29:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Schedule_Bkp](
	[fulcrum_id] [varchar](36) NULL,
	[created_at] [varchar](255) NULL,
	[updated_at] [varchar](255) NULL,
	[created_by] [varchar](255) NULL,
	[updated_by] [varchar](255) NULL,
	[system_created_at] [varchar](255) NULL,
	[system_updated_at] [varchar](255) NULL,
	[version] [smallint] NULL,
	[status] [varchar](255) NULL,
	[project] [varchar](255) NULL,
	[assigned_to] [varchar](255) NULL,
	[latitude] [real] NULL,
	[longitude] [real] NULL,
	[geometry] [varchar](255) NULL,
	[select_role] [varchar](255) NULL,
	[account_market] [varchar](255) NULL,
	[account_name_lookup] [varchar](255) NULL,
	[event_account_name] [varchar](255) NULL,
	[account_street_address] [varchar](255) NULL,
	[account_city] [varchar](255) NULL,
	[account_state] [varchar](255) NULL,
	[account_zip] [int] NULL,
	[account_phone_] [bigint] NULL,
	[account_region] [varchar](255) NULL,
	[account_segment] [varchar](255) NULL,
	[account_classification] [varchar](255) NULL,
	[account_website] [varchar](255) NULL,
	[account_manager_email] [varchar](255) NULL,
	[account_contact] [varchar](255) NULL,
	[account_location_sub_thoroughfare] [varchar](max) NULL,
	[account_location_thoroughfare] [varchar](max) NULL,
	[account_location_locality] [varchar](max) NULL,
	[account_location_sub_admin_area] [varchar](max) NULL,
	[account_location_admin_area] [varchar](max) NULL,
	[account_location_postal_code] [varchar](max) NULL,
	[account_location_country] [varchar](max) NULL,
	[account_location_suite] [varchar](max) NULL,
	[account_location_full] [varchar](max) NULL,
	[program_title] [varchar](255) NULL,
	[program_title_other] [varchar](max) NULL,
	[promo_event_date] [datetime] NULL,
	[promo_event_start_time] [varchar](255) NULL,
	[promo_event_end_time] [varchar](255) NULL,
	[event_osm] [varchar](max) NULL,
	[event_osm_other] [varchar](255) NULL,
	[event_staff] [varchar](max) NULL,
	[event_staff_other] [varchar](255) NULL,
	[brands_sampled] [varchar](255) NULL,
	[brands_sampled_other] [varchar](max) NULL,
	[cocktails_sampled] [varchar](255) NULL,
	[cocktails_sampled_other] [varchar](255) NULL,
	[did_account_purchase_a_bayou_rum_chill_machine] [varchar](255) NULL,
	[did_account_have_a_working_bayou_rums_chill_machine] [varchar](255) NULL,
	[does_account_have_competitive_chill_machines] [varchar](255) NULL,
	[list_competitive_chill_machine_brands] [varchar](255) NULL,
	[list_competitive_chill_machine_brands_other] [varchar](max) NULL,
	[drink_regular_price] [smallint] NULL,
	[drink_feature_price] [smallint] NULL,
	[negotiated_sample_price] [smallint] NULL,
	[planned_event_bar_spend_before_tip] [smallint] NULL,
	[planned_event_bar_tab_tip] [smallint] NULL,
	[total_planned_event_bar_spend] [smallint] NULL,
	[actual_event_bar_spend_before_tip] [real] NULL,
	[actual_event_bar_tab_tip] [real] NULL,
	[total_actual_event_bar_spend] [real] NULL,
	[total_drinks_sold] [smallint] NULL,
	[_of_consumer_attendance] [smallint] NULL,
	[_of_consumers_engaged] [smallint] NULL,
	[_of_consumers_sampled] [smallint] NULL,
	[_of_bartenders_trained] [smallint] NULL,
	[_of_wait_staff_trained] [smallint] NULL,
	[good_target_account_for_brand] [varchar](255) NULL,
	[event_comments] [varchar](255) NULL,
	[suggestions] [varchar](255) NULL,
	[event_rating] [varchar](255) NULL,
	[Column 75] [varchar](max) NULL,
	[event_videos_url] [varchar](max) NULL,
	[gps_altitude] [real] NULL,
	[gps_horizontal_accuracy] [smallint] NULL,
	[gps_vertical_accuracy] [smallint] NULL,
	[gps_speed] [real] NULL,
	[gps_course] [real] NULL,
	[total_bottles_sold] [varchar](255) NULL,
	[event_photos_min_3] [varchar](max) NULL,
	[total_drinks_sold_on_premise] [int] NULL,
	[total_bottles_sold_off_premise] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Schedule_old]    Script Date: 1/24/2016 10:29:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Schedule_old](
	[fulcrum_id] [varchar](255) NULL,
	[created_at] [varchar](255) NULL,
	[updated_at] [varchar](255) NULL,
	[created_by] [varchar](255) NULL,
	[updated_by] [varchar](255) NULL,
	[system_created_at] [varchar](255) NULL,
	[system_updated_at] [varchar](255) NULL,
	[version] [smallint] NULL,
	[status] [varchar](255) NULL,
	[project] [varchar](255) NULL,
	[assigned_to] [varchar](255) NULL,
	[latitude] [real] NULL,
	[longitude] [real] NULL,
	[geometry] [varchar](255) NULL,
	[select_role] [varchar](255) NULL,
	[account_market] [varchar](255) NULL,
	[account_name] [varchar](255) NULL,
	[account_street_address] [varchar](255) NULL,
	[account_city] [varchar](255) NULL,
	[account_state] [varchar](255) NULL,
	[account_zip] [int] NULL,
	[account_phone_] [bigint] NULL,
	[account_region] [varchar](255) NULL,
	[account_segment] [varchar](255) NULL,
	[account_classification] [varchar](255) NULL,
	[account_website] [varchar](255) NULL,
	[account_manager_email] [varchar](max) NULL,
	[account_location_sub_thoroughfare] [varchar](max) NULL,
	[account_location_thoroughfare] [varchar](max) NULL,
	[account_location_locality] [varchar](max) NULL,
	[account_location_sub_admin_area] [varchar](max) NULL,
	[account_location_admin_area] [varchar](max) NULL,
	[account_location_postal_code] [varchar](max) NULL,
	[account_location_country] [varchar](max) NULL,
	[account_location_suite] [varchar](max) NULL,
	[account_location_full] [varchar](max) NULL,
	[program_title] [varchar](255) NULL,
	[program_title_other] [varchar](max) NULL,
	[promo_event_date] [datetime] NULL,
	[promo_event_start_time] [datetime] NULL,
	[promo_event_end_time] [datetime] NULL,
	[event_osm] [varchar](max) NULL,
	[event_osm_other] [varchar](255) NULL,
	[event_staff] [varchar](max) NULL,
	[event_staff_other] [varchar](max) NULL,
	[brands_sampled] [varchar](255) NULL,
	[brands_sampled_other] [varchar](max) NULL,
	[cocktails_sampled] [varchar](255) NULL,
	[cocktails_sampled_other] [varchar](255) NULL,
	[did_account_purchase_a_bayou_rum_chill_machine] [varchar](255) NULL,
	[did_account_have_a_working_bayou_rums_chill_machine] [varchar](255) NULL,
	[does_account_have_competitive_chill_machines] [varchar](255) NULL,
	[list_competitive_chill_machine_brands] [varchar](255) NULL,
	[list_competitive_chill_machine_brands_other] [varchar](max) NULL,
	[drink_regular_price] [real] NULL,
	[drink_feature_price] [real] NULL,
	[negotiated_sample_price] [real] NULL,
	[planned_event_bar_spend_before_tip] [smallint] NULL,
	[planned_event_bar_tab_tip] [smallint] NULL,
	[total_planned_event_bar_spend] [smallint] NULL,
	[actual_event_bar_spend_before_tip] [smallint] NULL,
	[actual_event_bar_tab_tip] [smallint] NULL,
	[total_actual_event_bar_spend] [smallint] NULL,
	[_of_consumer_attendance] [smallint] NULL,
	[_of_consumers_engaged] [smallint] NULL,
	[_of_consumers_sampled] [smallint] NULL,
	[_of_bartenders_trained] [smallint] NULL,
	[_of_wait_staff_trained] [smallint] NULL,
	[good_target_account_for_brand] [varchar](255) NULL,
	[event_comments] [varchar](255) NULL,
	[suggestions] [varchar](255) NULL,
	[event_rating] [varchar](255) NULL,
	[event_photos_min_3] [varchar](max) NULL,
	[event_photos_min_3_caption] [varchar](max) NULL,
	[event_photos_min_3_url] [varchar](max) NULL,
	[event_videos] [varchar](max) NULL,
	[event_videos_caption] [varchar](max) NULL,
	[event_videos_url] [varchar](max) NULL,
	[gps_altitude] [real] NULL,
	[gps_horizontal_accuracy] [real] NULL,
	[gps_vertical_accuracy] [real] NULL,
	[gps_speed] [real] NULL,
	[gps_course] [real] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Schedule_Stg]    Script Date: 1/24/2016 10:29:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Schedule_Stg](
	[fulcrum_id] [varchar](max) NULL,
	[created_at] [varchar](max) NULL,
	[updated_at] [varchar](max) NULL,
	[created_by] [varchar](max) NULL,
	[updated_by] [varchar](max) NULL,
	[system_created_at] [varchar](max) NULL,
	[system_updated_at] [varchar](max) NULL,
	[version] [varchar](max) NULL,
	[status] [varchar](max) NULL,
	[project] [varchar](max) NULL,
	[assigned_to] [varchar](max) NULL,
	[latitude] [varchar](max) NULL,
	[longitude] [varchar](max) NULL,
	[geometry] [varchar](max) NULL,
	[select_role] [varchar](max) NULL,
	[account_market] [varchar](max) NULL,
	[account_name_lookup] [varchar](max) NULL,
	[event_account_name] [varchar](max) NULL,
	[account_street_address] [varchar](max) NULL,
	[account_city] [varchar](max) NULL,
	[account_state] [varchar](max) NULL,
	[account_zip] [varchar](max) NULL,
	[account_phone_] [varchar](max) NULL,
	[account_region] [varchar](max) NULL,
	[account_segment] [varchar](max) NULL,
	[account_classification] [varchar](max) NULL,
	[account_website] [varchar](max) NULL,
	[account_manager_email] [varchar](max) NULL,
	[account_contact] [varchar](max) NULL,
	[account_location_sub_thoroughfare] [varchar](max) NULL,
	[account_location_thoroughfare] [varchar](max) NULL,
	[account_location_locality] [varchar](max) NULL,
	[account_location_sub_admin_area] [varchar](max) NULL,
	[account_location_admin_area] [varchar](max) NULL,
	[account_location_postal_code] [varchar](max) NULL,
	[account_location_country] [varchar](max) NULL,
	[account_location_suite] [varchar](max) NULL,
	[account_location_full] [varchar](max) NULL,
	[program_title] [varchar](max) NULL,
	[program_title_other] [varchar](max) NULL,
	[promo_event_date] [varchar](max) NULL,
	[promo_event_start_time] [varchar](max) NULL,
	[promo_event_end_time] [varchar](max) NULL,
	[event_osm] [varchar](max) NULL,
	[event_osm_other] [varchar](max) NULL,
	[event_staff] [varchar](max) NULL,
	[event_staff_other] [varchar](max) NULL,
	[brands_sampled] [varchar](max) NULL,
	[brands_sampled_other] [varchar](max) NULL,
	[cocktails_sampled] [varchar](max) NULL,
	[cocktails_sampled_other] [varchar](max) NULL,
	[did_account_purchase_a_bayou_rum_chill_machine] [varchar](max) NULL,
	[did_account_have_a_working_bayou_rums_chill_machine] [varchar](max) NULL,
	[does_account_have_competitive_chill_machines] [varchar](max) NULL,
	[list_competitive_chill_machine_brands] [varchar](max) NULL,
	[list_competitive_chill_machine_brands_other] [varchar](max) NULL,
	[drink_regular_price] [varchar](max) NULL,
	[drink_feature_price] [varchar](max) NULL,
	[negotiated_sample_price] [varchar](max) NULL,
	[planned_event_bar_spend_before_tip] [varchar](max) NULL,
	[planned_event_bar_tab_tip] [varchar](max) NULL,
	[total_planned_event_bar_spend] [varchar](max) NULL,
	[actual_event_bar_spend_before_tip] [varchar](max) NULL,
	[actual_event_bar_tab_tip] [varchar](max) NULL,
	[total_actual_event_bar_spend] [varchar](max) NULL,
	[total_drinks_sold] [varchar](max) NULL,
	[total_bottles_sold] [varchar](max) NULL,
	[_of_consumer_attendance] [varchar](max) NULL,
	[_of_consumers_engaged] [varchar](max) NULL,
	[_of_consumers_sampled] [varchar](max) NULL,
	[_of_bartenders_trained] [varchar](max) NULL,
	[_of_wait_staff_trained] [varchar](max) NULL,
	[good_target_account_for_brand] [varchar](max) NULL,
	[event_comments] [varchar](max) NULL,
	[suggestions] [varchar](max) NULL,
	[event_rating] [varchar](max) NULL,
	[event_videos] [varchar](max) NULL,
	[event_videos_caption] [varchar](max) NULL,
	[event_videos_url] [varchar](max) NULL,
	[gps_altitude] [varchar](max) NULL,
	[gps_horizontal_accuracy] [varchar](max) NULL,
	[gps_vertical_accuracy] [varchar](max) NULL,
	[gps_speed] [varchar](max) NULL,
	[gps_course] [varchar](max) NULL,
	[total_drinks_sold_on_premise] [int] NULL,
	[total_bottles_sold_off_premise] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Schedule_Stg_Bkp]    Script Date: 1/24/2016 10:29:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Schedule_Stg_Bkp](
	[fulcrum_id] [varchar](max) NULL,
	[created_at] [varchar](max) NULL,
	[updated_at] [varchar](max) NULL,
	[created_by] [varchar](max) NULL,
	[updated_by] [varchar](max) NULL,
	[system_created_at] [varchar](max) NULL,
	[system_updated_at] [varchar](max) NULL,
	[version] [varchar](max) NULL,
	[status] [varchar](max) NULL,
	[project] [varchar](max) NULL,
	[assigned_to] [varchar](max) NULL,
	[latitude] [varchar](max) NULL,
	[longitude] [varchar](max) NULL,
	[geometry] [varchar](max) NULL,
	[select_role] [varchar](max) NULL,
	[account_market] [varchar](max) NULL,
	[account_name_lookup] [varchar](max) NULL,
	[event_account_name] [varchar](max) NULL,
	[account_street_address] [varchar](max) NULL,
	[account_city] [varchar](max) NULL,
	[account_state] [varchar](max) NULL,
	[account_zip] [varchar](max) NULL,
	[account_phone_] [varchar](max) NULL,
	[account_region] [varchar](max) NULL,
	[account_segment] [varchar](max) NULL,
	[account_classification] [varchar](max) NULL,
	[account_website] [varchar](max) NULL,
	[account_manager_email] [varchar](max) NULL,
	[account_contact] [varchar](max) NULL,
	[account_location_sub_thoroughfare] [varchar](max) NULL,
	[account_location_thoroughfare] [varchar](max) NULL,
	[account_location_locality] [varchar](max) NULL,
	[account_location_sub_admin_area] [varchar](max) NULL,
	[account_location_admin_area] [varchar](max) NULL,
	[account_location_postal_code] [varchar](max) NULL,
	[account_location_country] [varchar](max) NULL,
	[account_location_suite] [varchar](max) NULL,
	[account_location_full] [varchar](max) NULL,
	[program_title] [varchar](max) NULL,
	[program_title_other] [varchar](max) NULL,
	[promo_event_date] [varchar](max) NULL,
	[promo_event_start_time] [varchar](max) NULL,
	[promo_event_end_time] [varchar](max) NULL,
	[event_osm] [varchar](max) NULL,
	[event_osm_other] [varchar](max) NULL,
	[event_staff] [varchar](max) NULL,
	[event_staff_other] [varchar](max) NULL,
	[brands_sampled] [varchar](max) NULL,
	[brands_sampled_other] [varchar](max) NULL,
	[cocktails_sampled] [varchar](max) NULL,
	[cocktails_sampled_other] [varchar](max) NULL,
	[did_account_purchase_a_bayou_rum_chill_machine] [varchar](max) NULL,
	[did_account_have_a_working_bayou_rums_chill_machine] [varchar](max) NULL,
	[does_account_have_competitive_chill_machines] [varchar](max) NULL,
	[list_competitive_chill_machine_brands] [varchar](max) NULL,
	[list_competitive_chill_machine_brands_other] [varchar](max) NULL,
	[drink_regular_price] [varchar](max) NULL,
	[drink_feature_price] [varchar](max) NULL,
	[negotiated_sample_price] [varchar](max) NULL,
	[planned_event_bar_spend_before_tip] [varchar](max) NULL,
	[planned_event_bar_tab_tip] [varchar](max) NULL,
	[total_planned_event_bar_spend] [varchar](max) NULL,
	[actual_event_bar_spend_before_tip] [varchar](max) NULL,
	[actual_event_bar_tab_tip] [varchar](max) NULL,
	[total_actual_event_bar_spend] [varchar](max) NULL,
	[total_drinks_sold] [varchar](max) NULL,
	[total_bottles_sold] [varchar](max) NULL,
	[_of_consumer_attendance] [varchar](max) NULL,
	[_of_consumers_engaged] [varchar](max) NULL,
	[_of_consumers_sampled] [varchar](max) NULL,
	[_of_bartenders_trained] [varchar](max) NULL,
	[_of_wait_staff_trained] [varchar](max) NULL,
	[good_target_account_for_brand] [varchar](max) NULL,
	[event_comments] [varchar](max) NULL,
	[suggestions] [varchar](max) NULL,
	[event_rating] [varchar](max) NULL,
	[event_videos] [varchar](max) NULL,
	[event_videos_caption] [varchar](max) NULL,
	[event_videos_url] [varchar](max) NULL,
	[gps_altitude] [varchar](max) NULL,
	[gps_horizontal_accuracy] [varchar](max) NULL,
	[gps_vertical_accuracy] [varchar](max) NULL,
	[gps_speed] [varchar](max) NULL,
	[gps_course] [varchar](max) NULL,
	[total_drinks_sold_on_premise] [int] NULL,
	[total_bottles_sold_off_premise] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Settings]    Script Date: 1/24/2016 10:29:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Settings](
	[name] [varchar](255) NULL,
	[value] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[T]    Script Date: 1/24/2016 10:29:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T](
	[X] [int] NOT NULL,
	[Y] [int] NOT NULL,
 CONSTRAINT [PK_T] PRIMARY KEY CLUSTERED 
(
	[X] ASC,
	[Y] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[T1]    Script Date: 1/24/2016 10:29:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T1](
	[X] [int] NOT NULL,
	[Y] [int] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[T2]    Script Date: 1/24/2016 10:29:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T2](
	[X] [int] NOT NULL,
	[Y] [int] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[T3]    Script Date: 1/24/2016 10:29:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T3](
	[X] [int] NULL,
	[Y] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[T4]    Script Date: 1/24/2016 10:29:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T4](
	[X] [int] NULL,
	[Y] [int] NULL
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[obActivity] ADD  CONSTRAINT [df_obActivity_Visible]  DEFAULT ('') FOR [visible]
GO
ALTER TABLE [dbo].[obActivity] ADD  CONSTRAINT [df_obActivity_Hidden]  DEFAULT ('') FOR [hidden]
GO
ALTER TABLE [dbo].[obActivity] ADD  DEFAULT ((9999999)) FOR [SortOrder]
GO
ALTER TABLE [dbo].[obLandingPage] ADD  CONSTRAINT [df_obLandingPage_Visible]  DEFAULT ('') FOR [visible]
GO
ALTER TABLE [dbo].[obLandingPage] ADD  CONSTRAINT [df_obLandingPage_Hidden]  DEFAULT ('') FOR [hidden]
GO
ALTER TABLE [dbo].[obLandingPage] ADD  DEFAULT ((9999999)) FOR [SortOrder]
GO
ALTER TABLE [dbo].[obOption] ADD  CONSTRAINT [df_obOption_Visible]  DEFAULT ('') FOR [visible]
GO
ALTER TABLE [dbo].[obOption] ADD  CONSTRAINT [df_obOption_Hidden]  DEFAULT ('') FOR [hidden]
GO
ALTER TABLE [dbo].[obOption] ADD  DEFAULT ((9999999)) FOR [SortOrder]
GO
ALTER TABLE [dbo].[obQuestion] ADD  CONSTRAINT [df_obQuestion_Visible]  DEFAULT ('') FOR [visible]
GO
ALTER TABLE [dbo].[obQuestion] ADD  CONSTRAINT [df_obQuestion_Hidden]  DEFAULT ('') FOR [hidden]
GO
ALTER TABLE [dbo].[obQuestion] ADD  DEFAULT ((9999999)) FOR [SortOrder]
GO
ALTER TABLE [dbo].[obActivity]  WITH CHECK ADD  CONSTRAINT [FK_Activity_Client] FOREIGN KEY([idClient])
REFERENCES [dbo].[obClient] ([id])
GO
ALTER TABLE [dbo].[obActivity] CHECK CONSTRAINT [FK_Activity_Client]
GO
ALTER TABLE [dbo].[obLandingPage]  WITH CHECK ADD  CONSTRAINT [FK_Landing_Client] FOREIGN KEY([idClient])
REFERENCES [dbo].[obClient] ([id])
GO
ALTER TABLE [dbo].[obLandingPage] CHECK CONSTRAINT [FK_Landing_Client]
GO
ALTER TABLE [dbo].[obOption]  WITH CHECK ADD  CONSTRAINT [FK_Option_Select] FOREIGN KEY([idQuestion])
REFERENCES [dbo].[obQuestion] ([id])
GO
ALTER TABLE [dbo].[obOption] CHECK CONSTRAINT [FK_Option_Select]
GO
ALTER TABLE [dbo].[obQuestion]  WITH CHECK ADD  CONSTRAINT [FK_Select_Client] FOREIGN KEY([idClient])
REFERENCES [dbo].[obClient] ([id])
GO
ALTER TABLE [dbo].[obQuestion] CHECK CONSTRAINT [FK_Select_Client]
GO
USE [master]
GO
ALTER DATABASE [SQL2012_978285_fulcrum] SET  READ_WRITE 
GO
