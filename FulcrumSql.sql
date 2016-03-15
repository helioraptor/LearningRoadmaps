USE [master]
GO

/****** Object:  Database [SQL2012_978285_fulcrum]    Script Date: 1/24/2016 10:25:03 AM ******/
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

ALTER DATABASE [SQL2012_978285_fulcrum] SET  READ_WRITE 
GO
