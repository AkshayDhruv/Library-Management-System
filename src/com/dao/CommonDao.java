package com.dao;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Properties;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import org.apache.poi.openxml4j.util.ZipSecureFile;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellType;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import com.beans.Login;
import com.beans.Master;
import com.beans.Member;

public class CommonDao {
	private String dbURL;
	private String dbUser;
	private String dbPass;
	private String emailId;
	private String emailPassword;
	private String samedate;

	public CommonDao(String jdbcURL, String jdbcUsername, String jdbcPassword, String emailId, String emailPassword) {
		this.dbURL = jdbcURL;
		this.dbUser = jdbcUsername;
		this.dbPass = jdbcPassword;
		this.emailId = emailId;
		this.emailPassword = emailPassword;
	}

	public Master fetchMemberData(int itemIdIn, int memberIdIn) throws SQLException {
		Master data = null;
		Connection connection = null;

		try {
			DriverManager.registerDriver(new org.postgresql.Driver());
			connection = DriverManager.getConnection(dbURL, dbUser, dbPass);
			if (connection == null) {
				System.err.println("Database not connected");
			}
			connection.setAutoCommit(false);

			String selectId = "select * from master_data where ITEM_ID = ?";

			PreparedStatement selectStatement = connection.prepareStatement(selectId);
			selectStatement.setInt(1, itemIdIn);
			ResultSet resultSet = selectStatement.executeQuery();
			if (resultSet.next()) {
				int memberId = memberIdIn;
				int itemId = itemIdIn;
				String itemType = resultSet.getString("ITEM_TYPE");
				String title = resultSet.getString("TITLE");
				String author = resultSet.getString("AUTHOR");

				data = new Master(memberId, itemId, itemType, title, author);
			}

			resultSet.close();
			selectStatement.close();
			connection.commit();
			connection.close();
		} catch (SQLException e) {
			System.err.println("Database Error: " + e.getMessage());
			e.printStackTrace();
		}
		return data;
	}

	public Member setCurrentDateTime(int itemId) {
		Member data = null;
		Date date = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy hh:mm a");
		String currentDateTime = sdf.format(date);
		data = new Member(itemId, currentDateTime);
		return data;
	}

	public boolean updateItemStatus(List<Member> listMemberData) throws SQLException, ParseException {
		Connection connection = null;
		boolean currentDateTimeUpdated = false;
		SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy hh:mm a");
		String itemStatus = null;

		try {
			DriverManager.registerDriver(new org.postgresql.Driver());
			connection = DriverManager.getConnection(dbURL, dbUser, dbPass);
			if (connection == null) {
				System.err.println("Database not connected");
			}
			connection.setAutoCommit(false);

			for (Member obj : listMemberData) {
				int memberId = obj.getMemberId();
				int itemId = obj.getItemId();
				String currentDateTime = obj.getCurrentDateTime();
				String borrowDateTime = obj.getBorrowDateTime();
				String dueDateTime = obj.getDueDateTime();
				String returnDateTime = obj.getReturnDateTime();

				Date current = sdf.parse(currentDateTime);
				Date borrow = sdf.parse(borrowDateTime);
				Date due = sdf.parse(dueDateTime);

				int diff = current.compareTo(due);
				if (diff > 0 && returnDateTime.trim().equalsIgnoreCase("NOT RETURNED")) {
					itemStatus = "Over Due";
				} else {
					int diff1 = current.compareTo(borrow);
					if (diff1 > 0 && returnDateTime.trim().equalsIgnoreCase("NOT RETURNED")) {
						itemStatus = "Borrowed";
					} else if (diff1 > 0 && diff <= 0) {
						itemStatus = "Borrowed";
					} else {
						itemStatus = "Shelf";
					}
				}

				String updateItemStaus = "UPDATE HISTORICAL_DATA SET ITEM_STATUS = ? WHERE CURRENT_DATETIME = ? AND ITEM_ID = ? AND MEMBER_ID = ?";
				PreparedStatement statement = connection.prepareStatement(updateItemStaus);
				statement.setString(1, itemStatus);
				statement.setString(2, currentDateTime);
				statement.setInt(3, itemId);
				statement.setInt(4, memberId);
				currentDateTimeUpdated = statement.executeUpdate() > 0;
				statement.close();
			}

			connection.commit();
			connection.close();
		} catch (SQLException e) {
			System.err.println("Database Error: " + e.getMessage());
			e.printStackTrace();
		}
		return currentDateTimeUpdated;

	}

	public boolean updateCurrentDateTime(List<Member> listData, String currentDateTime)
			throws SQLException, ParseException {
		Connection connection = null;
		boolean currentDateTimeUpdated = false;
		DateFormat formatter = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
		DateFormat dateFormat = new SimpleDateFormat("MM/dd/yyyy hh:mm a");
		Date date = null;
		String origCurrentDateTime = null;
		date = (Date) formatter.parse(currentDateTime);
		dateFormat = new SimpleDateFormat("MM/dd/yyyy hh:mm a");
		currentDateTime = dateFormat.format(date);

		try {
			DriverManager.registerDriver(new org.postgresql.Driver());
			connection = DriverManager.getConnection(dbURL, dbUser, dbPass);
			if (connection == null) {
				System.err.println("Database not connected");
			}
			connection.setAutoCommit(false);

			for (Member obj : listData) {
				origCurrentDateTime = obj.getCurrentDateTime();

				String updateCurrentDT = "UPDATE HISTORICAL_DATA SET CURRENT_DATETIME = ? WHERE CURRENT_DATETIME = ?";

				PreparedStatement statement = connection.prepareStatement(updateCurrentDT);
				statement.setString(1, currentDateTime);
				statement.setString(2, origCurrentDateTime);

				currentDateTimeUpdated = statement.executeUpdate() > 0;
				statement.close();
			}
			connection.commit();
			connection.close();
		} catch (SQLException e) {
			System.err.println("Database Error: " + e.getMessage());
			e.printStackTrace();
		}
		return currentDateTimeUpdated;
	}

	public boolean deleteMemberRecord(Member memberDao) throws SQLException {
		Connection connection = null;
		boolean rowDeleted = false;

		try {
			DriverManager.registerDriver(new org.postgresql.Driver());
			connection = DriverManager.getConnection(dbURL, dbUser, dbPass);
			if (connection == null) {
				System.err.println("Database not connected");
			}
			connection.setAutoCommit(false);
			String deleteMaster = "Delete from HISTORICAL_DATA where item_id = ?";

			PreparedStatement statement = connection.prepareStatement(deleteMaster);
			statement.setInt(1, memberDao.getItemId());

			rowDeleted = statement.executeUpdate() > 0;
			statement.close();
			connection.commit();
			connection.close();
		} catch (SQLException e) {
			System.err.println("Database Error: " + e.getMessage());
			e.printStackTrace();
		}
		return rowDeleted;

	}

	public boolean updateNewMemberRecord(Member memberDao) throws SQLException, ParseException {
		Connection connection = null;
		boolean memberRowUpdated = false;
		DateFormat formatter = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
		DateFormat dateFormat = new SimpleDateFormat("MM/dd/yyyy hh:mm a");
		SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy hh:mm a");
		Calendar c = Calendar.getInstance();
		Date date = null;
		String dueDateTime = null;
		String itemStatus = null;

		try {
			String itemType = memberDao.getItemType();
			String processdueDateTime = memberDao.getBorrowDateTime();
			if (itemType.trim().equalsIgnoreCase("Book") || itemType.trim().equalsIgnoreCase("Reference Book")) {
				c.setTime(formatter.parse(processdueDateTime));
				c.add(Calendar.MONTH, 2);
				processdueDateTime = formatter.format(c.getTime());
				date = (Date) formatter.parse(processdueDateTime);
				dueDateTime = dateFormat.format(date);
			} else if (itemType.trim().equalsIgnoreCase("Journal") || itemType.trim().equalsIgnoreCase("Conference Procedings")) {
				c.setTime(formatter.parse(processdueDateTime));
				c.add(Calendar.DATE, 2);
				processdueDateTime = formatter.format(c.getTime());
				date = (Date) formatter.parse(processdueDateTime);
				dueDateTime = dateFormat.format(date);
			} else if (itemType.trim().equalsIgnoreCase("CD")) {
				c.setTime(formatter.parse(processdueDateTime));
				c.add(Calendar.HOUR_OF_DAY, 3);
				processdueDateTime = formatter.format(c.getTime());
				date = (Date) formatter.parse(processdueDateTime);
				dueDateTime = dateFormat.format(date);
			}
			String borrowDateTime = memberDao.getBorrowDateTime();
			date = (Date) formatter.parse(borrowDateTime);
			dateFormat = new SimpleDateFormat("MM/dd/yyyy hh:mm a");
			borrowDateTime = dateFormat.format(date);
			String returnDateTime = memberDao.getReturnDateTime();
			if (returnDateTime.trim().equalsIgnoreCase("NOT RETURNED")) {
				returnDateTime = "NOT RETURNED";
			} else {
				date = (Date) formatter.parse(returnDateTime);
				dateFormat = new SimpleDateFormat("MM/dd/yyyy hh:mm a");
				returnDateTime = dateFormat.format(date);
			}
			String currentDataTime = memberDao.getCurrentDateTime();

			Date current = sdf.parse(currentDataTime);
			Date borrow = sdf.parse(borrowDateTime);
			Date due = sdf.parse(dueDateTime);

			int diff = current.compareTo(due);
			if (diff > 0 && returnDateTime.trim().equalsIgnoreCase("NOT RETURNED")) {
				itemStatus = "Over Due";
			} else {
				int diff1 = current.compareTo(borrow);
				if (diff1 > 0 && returnDateTime.trim().equalsIgnoreCase("NOT RETURNED")) {
					itemStatus = "Borrowed";
				} else if (diff1 > 0 && diff <= 0) {
					itemStatus = "Borrowed";
				} else {
					itemStatus = "Shelf";
				}

			}

			DriverManager.registerDriver(new org.postgresql.Driver());
			connection = DriverManager.getConnection(dbURL, dbUser, dbPass);
			if (connection == null) {
				System.err.println("Database not connected");
			}
			connection.setAutoCommit(false);
			String updateNewMaster = "Update HISTORICAL_DATA SET ITEM_STATUS = ?, ITEM_TYPE = ?, BORROW_DATETIME = ?, DUE_DATETIME = ?, RETURN_DATETIME = ?, TITLE = ?, AUTHOR = ? where ITEM_ID = ? and MEMBER_ID = ?";

			PreparedStatement statement = connection.prepareStatement(updateNewMaster);
			statement.setString(1, itemStatus);
			statement.setString(2, itemType);
			statement.setString(3, borrowDateTime);
			statement.setString(4, dueDateTime);
			statement.setString(5, returnDateTime);
			statement.setString(6, memberDao.getTitle());
			statement.setString(7, memberDao.getAuthor());
			statement.setInt(8, memberDao.getItemId());
			statement.setInt(9, memberDao.getMemberId());

			memberRowUpdated = statement.executeUpdate() > 0;
			statement.close();
			connection.commit();
			connection.close();
		} catch (SQLException e) {
			System.err.println("Database Error: " + e.getMessage());
			e.printStackTrace();
		}
		return memberRowUpdated;

	}

	public Member getMemberData(int id) throws SQLException {
		Member data = null;
		Connection connection = null;
		String returnDateTime = null;
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");

		try {
			DriverManager.registerDriver(new org.postgresql.Driver());
			connection = DriverManager.getConnection(dbURL, dbUser, dbPass);
			if (connection == null) {
				System.err.println("Database not connected");
			}
			connection.setAutoCommit(false);

			String selectId = "select * from historical_data where ITEM_ID = ?";

			PreparedStatement selectStatement = connection.prepareStatement(selectId);
			selectStatement.setInt(1, id);
			ResultSet resultSet = selectStatement.executeQuery();
			if (resultSet.next()) {
				int memberId = resultSet.getInt("MEMBER_ID");
				int itemId = resultSet.getInt("ITEM_ID");
				String itemStatus = resultSet.getString("ITEM_STATUS");
				String itemType = resultSet.getString("ITEM_TYPE");
				String borrowDT = resultSet.getString("BORROW_DATETIME");
				LocalDateTime borrowDateT = LocalDateTime.parse(borrowDT.trim(),
						DateTimeFormatter.ofPattern("MM/dd/yyyy hh:mm a"));
				String borrowDateTime = borrowDateT.format(formatter);
				String dueDT = resultSet.getString("DUE_DATETIME");
				LocalDateTime dueDateT = LocalDateTime.parse(dueDT.trim(), DateTimeFormatter.ofPattern("MM/dd/yyyy hh:mm a"));
				String dueDateTime = dueDateT.format(formatter);
				String returnDT = resultSet.getString("RETURN_DATETIME");
				if (returnDT.trim().equalsIgnoreCase("NOT RETURNED")) {
					returnDateTime = returnDT.trim();
				} else {
					LocalDateTime returnDateT = LocalDateTime.parse(returnDT.trim(),
							DateTimeFormatter.ofPattern("MM/dd/yyyy hh:mm a"));
					returnDateTime = returnDateT.format(formatter);
				}
				String title = resultSet.getString("TITLE");
				String author = resultSet.getString("AUTHOR");
				String currentDateTime = resultSet.getString("CURRENT_DATETIME");

				data = new Member(memberId, itemId, itemStatus, itemType, borrowDateTime, dueDateTime, returnDateTime,
						title, author, currentDateTime);
			}

			resultSet.close();
			selectStatement.close();
			connection.commit();
			connection.close();
		} catch (SQLException e) {
			System.err.println("Database Error: " + e.getMessage());
			e.printStackTrace();
		}
		return data;
	}

	public Member getCurrentData(int i) throws SQLException {
		Member data = null;
		Connection connection = null;

		try {
			DriverManager.registerDriver(new org.postgresql.Driver());
			connection = DriverManager.getConnection(dbURL, dbUser, dbPass);
			if (connection == null) {
				System.err.println("Database not connected");
			}
			connection.setAutoCommit(false);

			String selectId = "select MEMBER_ID,ITEM_ID,CURRENT_DATETIME from historical_data limit ?";

			PreparedStatement selectStatement = connection.prepareStatement(selectId);
			selectStatement.setInt(1, i);
			ResultSet resultSet = selectStatement.executeQuery();
			if (resultSet.next()) {
				int memberId = resultSet.getInt("MEMBER_ID");
				int itemId = resultSet.getInt("ITEM_ID");
				String currentDateTime = resultSet.getString("CURRENT_DATETIME");

				data = new Member(memberId, itemId, currentDateTime);
			}

			resultSet.close();
			selectStatement.close();
			connection.commit();
			connection.close();
		} catch (SQLException e) {
			System.err.println("Database Error: " + e.getMessage());
			e.printStackTrace();
		}
		return data;
	}

	public boolean insertNewMemberRecord(Member memberDao) throws SQLException, ParseException {
		Connection connection = null;
		boolean memberRowInserted = false;
		DateFormat formatter = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
		DateFormat dateFormat = new SimpleDateFormat("MM/dd/yyyy hh:mm a");
		SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy hh:mm a");
		Calendar c = Calendar.getInstance();
		Date date = null;
		String dueDateTime = null;
		String itemStatus = null;

		try {
			String itemType = memberDao.getItemType();
			String returnDateTime = memberDao.getReturnDateTime();
			String processdueDateTime = memberDao.getBorrowDateTime();
			if (itemType.trim().equalsIgnoreCase("Book") || itemType.trim().equalsIgnoreCase("Reference Book")) {
				c.setTime(formatter.parse(processdueDateTime));
				c.add(Calendar.MONTH, 2);
				processdueDateTime = formatter.format(c.getTime());
				date = (Date) formatter.parse(processdueDateTime);
				dueDateTime = dateFormat.format(date);
			} else if (itemType.trim().equalsIgnoreCase("Journal") || itemType.trim().equalsIgnoreCase("Conference Procedings")) {
				c.setTime(formatter.parse(processdueDateTime));
				c.add(Calendar.DATE, 2);
				processdueDateTime = formatter.format(c.getTime());
				date = (Date) formatter.parse(processdueDateTime);
				dueDateTime = dateFormat.format(date);
			} else if (itemType.trim().equalsIgnoreCase("CD")) {
				c.setTime(formatter.parse(processdueDateTime));
				c.add(Calendar.HOUR_OF_DAY, 3);
				processdueDateTime = formatter.format(c.getTime());
				date = (Date) formatter.parse(processdueDateTime);
				dueDateTime = dateFormat.format(date);
			}
			String borrowDateTime = memberDao.getBorrowDateTime();
			date = (Date) formatter.parse(borrowDateTime);
			dateFormat = new SimpleDateFormat("MM/dd/yyyy hh:mm a");
			borrowDateTime = dateFormat.format(date);
			String currentDataTime = memberDao.getCurrentDateTime();

			Date current = sdf.parse(currentDataTime);
			Date borrow = sdf.parse(borrowDateTime);
			Date due = sdf.parse(dueDateTime);

			int diff = current.compareTo(due);
			if (diff > 0 && returnDateTime.trim().equalsIgnoreCase("NOT RETURNED")) {
				itemStatus = "Over Due";
			} else {
				int diff1 = current.compareTo(borrow);
				if (diff1 > 0 && returnDateTime.trim().equalsIgnoreCase("NOT RETURNED")) {
					itemStatus = "Borrowed";
				} else {
					itemStatus = "Shelf";
				}

			}

			DriverManager.registerDriver(new org.postgresql.Driver());
			connection = DriverManager.getConnection(dbURL, dbUser, dbPass);
			if (connection == null) {
				System.err.println("Database not connected");
			}
			connection.setAutoCommit(false);

			Statement stmt = connection.createStatement();
			String checkmastertable = "SELECT count(*) FROM pg_tables where tablename = 'MASTER_DATA'";
			ResultSet rs = stmt.executeQuery(checkmastertable);
			rs.next();
			int rowCount = rs.getInt(1);
			if (rowCount == 0) {
				String createHistoricalTable = "CREATE TABLE IF NOT EXISTS historical_data (" + "    MEMBER_ID INT NOT NULL,"
						+ "    ITEM_ID INT NOT NULL," + "    ITEM_STATUS CHAR(1000)," + "    ITEM_TYPE CHAR(1000),"
						+ "    BORROW_DATETIME CHAR(1000)," + "    DUE_DATETIME CHAR(1000)," + "    RETURN_DATETIME CHAR(1000),"
						+ "    TITLE CHAR(1000)," + "    AUTHOR CHAR(1000)," + "    CURRENT_DATETIME CHAR(1000)" + ")";
				PreparedStatement createHStatement = connection.prepareStatement(createHistoricalTable);
				createHStatement.executeUpdate();

				String insertNewMember = "Insert into HISTORICAL_DATA (MEMBER_ID, ITEM_ID, ITEM_STATUS, ITEM_TYPE, BORROW_DATETIME, DUE_DATETIME, RETURN_DATETIME, TITLE, AUTHOR, CURRENT_DATETIME) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

				PreparedStatement statement = connection.prepareStatement(insertNewMember);
				statement.setInt(1, memberDao.getMemberId());
				statement.setInt(2, memberDao.getItemId());
				statement.setString(3, itemStatus);
				statement.setString(4, itemType);
				statement.setString(5, borrowDateTime);
				statement.setString(6, dueDateTime);
				statement.setString(7, returnDateTime);
				statement.setString(8, memberDao.getTitle());
				statement.setString(9, memberDao.getAuthor());
				statement.setString(10, currentDataTime);

				memberRowInserted = statement.executeUpdate() > 0;
				statement.close();
				createHStatement.close();
			} else {
				String insertNewMember = "Insert into HISTORICAL_DATA (MEMBER_ID, ITEM_ID, ITEM_STATUS, ITEM_TYPE, BORROW_DATETIME, DUE_DATETIME, RETURN_DATETIME, TITLE, AUTHOR, CURRENT_DATETIME) values (?, ?, ?, ?, ?::timestamp, ?::timestamp, ?::timestamp, ?, ?, ?::timestamp)";

				PreparedStatement statement = connection.prepareStatement(insertNewMember);
				statement.setInt(1, memberDao.getMemberId());
				statement.setInt(2, memberDao.getItemId());
				statement.setString(3, itemStatus);
				statement.setString(4, itemType);
				statement.setString(5, borrowDateTime);
				statement.setString(6, dueDateTime);
				statement.setString(7, returnDateTime);
				statement.setString(8, memberDao.getTitle());
				statement.setString(9, memberDao.getAuthor());
				statement.setString(10, currentDataTime);

				memberRowInserted = statement.executeUpdate() > 0;
				statement.close();
			}
			connection.commit();
			connection.close();
		} catch (SQLException e) {
			System.err.println("Database Error: " + e.getMessage());
			e.printStackTrace();
		}
		return memberRowInserted;

	}

	public boolean deleteMaster(Master masterDao) throws SQLException {
		Connection connection = null;
		boolean rowDeleted = false;

		try {
			DriverManager.registerDriver(new org.postgresql.Driver());
			connection = DriverManager.getConnection(dbURL, dbUser, dbPass);
			if (connection == null) {
				System.err.println("Database not connected");
			}
			connection.setAutoCommit(false);
			String deleteMaster = "Delete from MASTER_DATA where item_id = ?";

			PreparedStatement statement = connection.prepareStatement(deleteMaster);
			statement.setInt(1, masterDao.getItemId());

			rowDeleted = statement.executeUpdate() > 0;
			statement.close();
			connection.commit();
			connection.close();
		} catch (SQLException e) {
			System.err.println("Database Error: " + e.getMessage());
			e.printStackTrace();
		}
		return rowDeleted;

	}

	public boolean updateNewMasterRecord(Master masterDao) throws SQLException {
		Connection connection = null;
		boolean masterRowUpdated = false;

		try {
			DriverManager.registerDriver(new org.postgresql.Driver());
			connection = DriverManager.getConnection(dbURL, dbUser, dbPass);
			if (connection == null) {
				System.err.println("Database not connected");
			}
			connection.setAutoCommit(false);
			String updateNewMaster = "Update MASTER_DATA SET ITEM_TYPE = ?, TITLE = ?, AUTHOR = ?, PUBLISHER = ?, PUBLICATION_YEAR = ?,PUBLICATION_EDITION = ?, SUBJECT = ? where ITEM_ID = ?";

			PreparedStatement statement = connection.prepareStatement(updateNewMaster);
			statement.setString(1, masterDao.getItemType());
			statement.setString(2, masterDao.getTitle());
			statement.setString(3, masterDao.getAuthor());
			statement.setString(4, masterDao.getPublisher());
			statement.setInt(5, masterDao.getPublicationYear());
			statement.setInt(6, masterDao.getPublicationEdition());
			statement.setString(7, masterDao.getSubject());
			statement.setInt(8, masterDao.getItemId());

			masterRowUpdated = statement.executeUpdate() > 0;
			statement.close();
			connection.commit();
			connection.close();
		} catch (SQLException e) {
			System.err.println("Database Error: " + e.getMessage());
			e.printStackTrace();
		}
		return masterRowUpdated;

	}

	public Master getMasterData(int itemIdIn) throws SQLException {
		Master data = null;
		Connection connection = null;

		try {
			DriverManager.registerDriver(new org.postgresql.Driver());
			connection = DriverManager.getConnection(dbURL, dbUser, dbPass);
			if (connection == null) {
				System.err.println("Database not connected");
			}
			connection.setAutoCommit(false);

			String selectId = "select * from master_data where item_id = ?";

			PreparedStatement selectStatement = connection.prepareStatement(selectId);
			selectStatement.setInt(1, itemIdIn);
			ResultSet resultSet = selectStatement.executeQuery();
			if (resultSet.next()) {
				int itemId = resultSet.getInt("ITEM_ID");
				String itemType = resultSet.getString("ITEM_TYPE");
				String title = resultSet.getString("TITLE");
				String author = resultSet.getString("AUTHOR");
				String publisher = resultSet.getString("PUBLISHER");
				int publicationYear = resultSet.getInt("PUBLICATION_YEAR");
				int publicationEdition = resultSet.getInt("PUBLICATION_EDITION");
				String subject = resultSet.getString("SUBJECT");

				data = new Master(itemId, itemType, title, author, publisher, publicationYear, publicationEdition,
						subject);
			}

			resultSet.close();
			selectStatement.close();
			connection.commit();
			connection.close();
		} catch (SQLException e) {
			System.err.println("Database Error: " + e.getMessage());
			e.printStackTrace();
		}
		return data;
	}

	public boolean insertNewMasterRecord(Master masterDao) throws SQLException {
		Connection connection = null;
		boolean masterRowInserted = false;

		try {
			DriverManager.registerDriver(new org.postgresql.Driver());
			connection = DriverManager.getConnection(dbURL, dbUser, dbPass);
			if (connection == null) {
				System.err.println("Database not connected");
			}
			connection.setAutoCommit(false);

			Statement stmt = connection.createStatement();
			String checkmastertable = "SELECT count(*) FROM pg_tables where tablename = 'MASTER_DATA'";
			ResultSet rs = stmt.executeQuery(checkmastertable);
			rs.next();
			int rowCount = rs.getInt(1);
			if (rowCount == 0) {
				String createMasterTable = "CREATE TABLE IF NOT EXISTS master_data (" + "    ITEM_ID INT NOT NULL,"
						+ "    ITEM_TYPE CHAR(1000) NOT NULL," + "    TITLE CHAR(1000)," + "    AUTHOR CHAR(1000),"
						+ "    PUBLISHER CHAR(1000)," + "    PUBLICATION_YEAR INT," + "    PUBLICATION_EDITION INT,"
						+ "    SUBJECT CHAR(1000)" + ")";
				PreparedStatement createMStatement = connection.prepareStatement(createMasterTable);
				createMStatement.executeUpdate();

				String insertNewMaster = "Insert into MASTER_DATA (ITEM_ID,ITEM_TYPE,TITLE,AUTHOR,PUBLISHER,PUBLICATION_YEAR,PUBLICATION_EDITION,SUBJECT) values (?, ?, ?, ?, ?, ?, ?, ?)";

				PreparedStatement statement = connection.prepareStatement(insertNewMaster);
				statement.setInt(1, masterDao.getItemId());
				statement.setString(2, masterDao.getItemType());
				statement.setString(3, masterDao.getTitle());
				statement.setString(4, masterDao.getAuthor());
				statement.setString(5, masterDao.getPublisher());
				statement.setInt(6, masterDao.getPublicationYear());
				statement.setInt(7, masterDao.getPublicationEdition());
				statement.setString(8, masterDao.getSubject());

				masterRowInserted = statement.executeUpdate() > 0;
				statement.close();
				createMStatement.close();
			} else {
				String insertNewMaster = "Insert into MASTER_DATA (ITEM_ID,ITEM_TYPE,TITLE,AUTHOR,PUBLISHER,PUBLICATION_YEAR,PUBLICATION_EDITION,SUBJECT) values (?, ?, ?, ?, ?, ?, ?, ?)";

				PreparedStatement statement = connection.prepareStatement(insertNewMaster);
				statement.setInt(1, masterDao.getItemId());
				statement.setString(2, masterDao.getItemType());
				statement.setString(3, masterDao.getTitle());
				statement.setString(4, masterDao.getAuthor());
				statement.setString(5, masterDao.getPublisher());
				statement.setInt(6, masterDao.getPublicationYear());
				statement.setInt(7, masterDao.getPublicationEdition());
				statement.setString(8, masterDao.getSubject());

				masterRowInserted = statement.executeUpdate() > 0;
				statement.close();
			}
			connection.commit();
			connection.close();
		} catch (SQLException e) {
			System.err.println("Database Error: " + e.getMessage());
			e.printStackTrace();
		}
		return masterRowInserted;

	}

	public Login fetchPassword(String nameIn, String emailIn, String securityAnswerIn) throws SQLException {
		Login data = null;
		Connection connection = null;

		try {
			DriverManager.registerDriver(new org.postgresql.Driver());
			connection = DriverManager.getConnection(dbURL, dbUser, dbPass);
			if (connection == null) {
				System.err.println("Database not connected");
			}
			connection.setAutoCommit(false);
			String selectPassword = "select user_password from ( select user_password from login_data where user_name= ? and user_email_id= ? and user_security_answer = ? group by user_password) AS x limit 1";

			PreparedStatement statement = connection.prepareStatement(selectPassword);
			statement.setString(1, nameIn);
			statement.setString(2, emailIn);
			statement.setString(3, securityAnswerIn);
			ResultSet resultSet = statement.executeQuery();
			while (resultSet.next()) {
				String password = resultSet.getString("USER_PASSWORD");
				data = new Login(password);
			}
			resultSet.close();
			statement.close();
			connection.commit();
			connection.close();
		} catch (SQLException e) {
			System.err.println("Database Error: " + e.getMessage());
			e.printStackTrace();
		}
		return data;
	}

	public boolean newRegistration(Login loginDao) throws SQLException {
		Connection connection = null;
		boolean rowInserted = false;

		try {
			DriverManager.registerDriver(new org.postgresql.Driver());
			connection = DriverManager.getConnection(dbURL, dbUser, dbPass);
			if (connection == null) {
				System.err.println("Database not connected");
			}
			connection.setAutoCommit(false);

			String createLoginTable = "CREATE TABLE IF NOT EXISTS login_data (" + "    USER_NAME CHAR(50) NOT NULL,"
					+ "    USER_EMAIL_ID CHAR(50)  NOT NULL," + "    USER_PASSWORD CHAR(50) NOT NULL,"
					+ "    USER_SECURITY_ANSWER CHAR(50) NOT NULL" + ")";
			PreparedStatement createStatement = connection.prepareStatement(createLoginTable);
			createStatement.executeUpdate();
			createStatement.close();

			String insertNewUser = "INSERT INTO login_data (USER_NAME, USER_EMAIL_ID, USER_PASSWORD, USER_SECURITY_ANSWER) VALUES (?, ?, ?, ?)";

			PreparedStatement statement = connection.prepareStatement(insertNewUser);
			statement.setString(1, loginDao.getName());
			statement.setString(2, loginDao.getEmail());
			statement.setString(3, loginDao.getPassword());
			statement.setString(4, loginDao.getSecurityAnswer());
			rowInserted = statement.executeUpdate() > 0;

			statement.close();
			connection.commit();
			connection.close();
		} catch (SQLException e) {
			System.err.println("Database Error: " + e.getMessage());
			e.printStackTrace();
		}
		return rowInserted;
	}

	public Login loginCheck(String emailIn, String passwordIn) throws SQLException {
		Login data = null;
		Connection connection = null;

		try {
			DriverManager.registerDriver(new org.postgresql.Driver());
			connection = DriverManager.getConnection(dbURL, dbUser, dbPass);
			if (connection == null) {
				System.err.println("Database not connected");
			}
			connection.setAutoCommit(false);
			String selectEmailId = "select * from login_data where user_email_id = ?";

			PreparedStatement statement = connection.prepareStatement(selectEmailId);
			statement.setString(1, emailIn);
			ResultSet resultSet = statement.executeQuery();
			while (resultSet.next()) {
				String name = resultSet.getString("USER_NAME");
				String emailId = resultSet.getString("USER_EMAIL_ID");
				String password = resultSet.getString("USER_PASSWORD");
				data = new Login(name, emailId, password);
			}
			resultSet.close();
			statement.close();
			connection.commit();
			connection.close();
		} catch (SQLException e) {
			System.err.println("Database Error: " + e.getMessage());
			e.printStackTrace();
		}
		return data;

	}

	public List<Member> listAllRecords() throws SQLException {
		List<Member> listData = new ArrayList<>();
		Connection connection = null;
		Member data = null;
		try {
			DriverManager.registerDriver(new org.postgresql.Driver());
			connection = DriverManager.getConnection(dbURL, dbUser, dbPass);
			if (connection == null) {
				System.err.println("Database not connected");
			}
			connection.setAutoCommit(false);
			String dataList = "SELECT * FROM historical_data";
			Statement statement = connection.createStatement();
			ResultSet resultSet = statement.executeQuery(dataList);
			while (resultSet.next()) {
				int memberId = resultSet.getInt("MEMBER_ID");
				int itemId = resultSet.getInt("ITEM_ID");
				String itemStatus = resultSet.getString("ITEM_STATUS");
				String itemType = resultSet.getString("ITEM_TYPE");
				String borrowDateTime = resultSet.getString("BORROW_DATETIME");
				String dueDateTime = resultSet.getString("DUE_DATETIME");
				String returnDateTime = resultSet.getString("RETURN_DATETIME");
				String title = resultSet.getString("TITLE");
				String author = resultSet.getString("AUTHOR");
				String currentDateTime = resultSet.getString("CURRENT_DATETIME");

				data = new Member(memberId, itemId, itemStatus, itemType, borrowDateTime, dueDateTime, returnDateTime,
						title, author, currentDateTime);
				listData.add(data);
			}
			resultSet.close();
			statement.close();
			connection.commit();
			connection.close();
		} catch (SQLException e) {
			System.err.println("Database Error: " + e.getMessage());
			e.printStackTrace();
		}
		return listData;
	}

	public Member getData(int id) throws SQLException {
		Member data = null;
		Connection connection = null;

		try {
			DriverManager.registerDriver(new org.postgresql.Driver());
			connection = DriverManager.getConnection(dbURL, dbUser, dbPass);
			if (connection == null) {
				System.err.println("Database not connected");
			}
			connection.setAutoCommit(false);

			String selectId = "select * from historical_data where ITEM_ID = ?";

			PreparedStatement selectStatement = connection.prepareStatement(selectId);
			selectStatement.setInt(1, id);
			ResultSet resultSet = selectStatement.executeQuery();
			if (resultSet.next()) {
				int memberId = resultSet.getInt("MEMBER_ID");
				int itemId = resultSet.getInt("ITEM_ID");
				String itemStatus = resultSet.getString("ITEM_STATUS");
				String itemType = resultSet.getString("ITEM_TYPE");
				String borrowDateTime = resultSet.getString("BORROW_DATETIME");
				String dueDateTime = resultSet.getString("DUE_DATETIME");
				String returnDateTime = resultSet.getString("RETURN_DATETIME");
				String title = resultSet.getString("TITLE");
				String author = resultSet.getString("AUTHOR");
				String currentDateTime = resultSet.getString("CURRENT_DATETIME");

				data = new Member(memberId, itemId, itemStatus, itemType, borrowDateTime, dueDateTime, returnDateTime,
						title, author, currentDateTime);
			}

			resultSet.close();
			selectStatement.close();
			connection.commit();
			connection.close();
		} catch (SQLException e) {
			System.err.println("Database Error: " + e.getMessage());
			e.printStackTrace();
		}
		return data;
	}

	public void uploadExcelData(String filepath) throws SQLException {
		String excelFilePath = filepath;
		Workbook workbook = null;
		Connection connection = null;
		SimpleDateFormat formatter;
		int batchSize = 20;

		try {
			FileInputStream inputStream = new FileInputStream(excelFilePath);
			String inputFilename = new File(excelFilePath).getName();
			String fileExtension = inputFilename.substring(inputFilename.lastIndexOf(".") + 1, inputFilename.length());
			if (!("xlsm".trim().equalsIgnoreCase(fileExtension)) && !("xlsx".trim().equalsIgnoreCase(fileExtension))) {
				inputStream.close();
				throw new FileNotFoundException();
			} else {
				DriverManager.registerDriver(new org.postgresql.Driver());
				connection = DriverManager.getConnection(dbURL, dbUser, dbPass);
				if (connection == null) {
					System.err.println("Database not connected");
				}
				connection.setAutoCommit(false);

				ZipSecureFile.setMinInflateRatio(0);
				workbook = new XSSFWorkbook(inputStream);

				Sheet historicalSheet = workbook.getSheetAt(7);
				Iterator<Row> rowIterator = historicalSheet.iterator();
				Sheet masterSheet = workbook.getSheetAt(6);
				Iterator<Row> masterRowIterator = masterSheet.iterator();

				String createHistoricalTable = "CREATE TABLE IF NOT EXISTS historical_data ("
						+ "    MEMBER_ID INT NOT NULL," + "    ITEM_ID INT NOT NULL," + "    ITEM_STATUS CHAR(1000),"
						+ "    ITEM_TYPE CHAR(1000)," + "    BORROW_DATETIME CHAR(1000)," + "    DUE_DATETIME CHAR(1000),"
						+ "    RETURN_DATETIME CHAR(1000)," + "    TITLE CHAR(1000)," + "    AUTHOR CHAR(1000),"
						+ "    CURRENT_DATETIME CHAR(1000)" + ")";
				PreparedStatement createHStatement = connection.prepareStatement(createHistoricalTable);
				createHStatement.executeUpdate();
				String createMasterTable = "CREATE TABLE IF NOT EXISTS master_data (" + "    ITEM_ID INT NOT NULL,"
						+ "    ITEM_TYPE CHAR(1000) NOT NULL," + "    TITLE CHAR(1000)," + "    AUTHOR CHAR(1000),"
						+ "    PUBLISHER CHAR(1000)," + "    PUBLICATION_YEAR INT," + "    PUBLICATION_EDITION INT,"
						+ "    SUBJECT CHAR(1000)" + ")";
				PreparedStatement createMStatement = connection.prepareStatement(createMasterTable);
				createMStatement.executeUpdate();

				String deleteHistoricalTable = "TRUNCATE table historical_data";
				PreparedStatement deleteHStatement = connection.prepareStatement(deleteHistoricalTable);
				deleteHStatement.executeUpdate();
				String deleteMasterTable = "TRUNCATE table master_data";
				PreparedStatement deleteMStatement = connection.prepareStatement(deleteMasterTable);
				deleteMStatement.executeUpdate();
				
				
				String sql = "INSERT INTO historical_data (MEMBER_ID, ITEM_ID, ITEM_STATUS, ITEM_TYPE, BORROW_DATETIME, DUE_DATETIME, RETURN_DATETIME, TITLE, AUTHOR, CURRENT_DATETIME) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
				PreparedStatement insertStatement = connection.prepareStatement(sql);
				int count = 0;
				rowIterator.next();
				while (rowIterator.hasNext()) {
					Row nextRow = rowIterator.next();
					Iterator<Cell> cellIterator = nextRow.cellIterator();
					while (cellIterator.hasNext()) {
						Cell nextCell = cellIterator.next();
						int columnIndex = nextCell.getColumnIndex();
						switch (columnIndex) {
						case 0:
							int memberId = (int) nextCell.getNumericCellValue();
							if (memberId != 0) {
								insertStatement.setInt(1, memberId);
							} else {
								insertStatement.setNull(1, java.sql.Types.BIGINT);
							}
							break;
						case 1:
							int itemId = (int) nextCell.getNumericCellValue();
							if (itemId != 0) {
								insertStatement.setInt(2, itemId);
							} else {
								insertStatement.setNull(2, java.sql.Types.BIGINT);
							}
							break;
						case 2:
							String itemType = nextCell.getStringCellValue();
							if (itemType != null) {
								insertStatement.setString(4, itemType);
							} else {
								insertStatement.setString(4, "UNKOWN");
							}
							break;
						case 3:
							Date borrowDate = nextCell.getDateCellValue();
							if (borrowDate != null) {
								formatter = new SimpleDateFormat("MM/dd/yyyy hh:mm a");
								String newBorrowedDate = formatter.format(borrowDate);
								insertStatement.setString(5, newBorrowedDate);
							} else {
								insertStatement.setString(5, "NOT BORROWED");
							}
							break;
						case 5:
							Date dueDate = nextCell.getDateCellValue();
							if (dueDate != null) {
								formatter = new SimpleDateFormat("MM/dd/yyyy hh:mm a");
								String newDueDate = formatter.format(dueDate);
								insertStatement.setString(6, newDueDate);
							} else {
								insertStatement.setString(6, "NOT DUE");
							}
							break;
						case 7:
							CellType type = nextCell.getCellType();
							if (type == CellType.STRING) {
								insertStatement.setString(7, "NOT RETURNED");
							} else {
								Date returnDate = nextCell.getDateCellValue();
								if (returnDate != null) {
									formatter = new SimpleDateFormat("MM/dd/yyyy hh:mm a");
									String newReturnDate = formatter.format(returnDate);
									insertStatement.setString(7, newReturnDate);
								} else {
									insertStatement.setString(7, "NOT RETURNED");
								}
							}
							break;
						case 9:
							String itemStatus = nextCell.getStringCellValue();
							if (itemStatus != null) {
								insertStatement.setString(3, itemStatus);
							} else {
								insertStatement.setString(3, "UNKOWN");
							}
							break;
						case 11:
							Date currentDate = nextCell.getDateCellValue();
							if (currentDate != null) {
								formatter = new SimpleDateFormat("MM/dd/yyyy hh:mm a");
								String newCurrentDate = formatter.format(currentDate);
								setSamedate(newCurrentDate);
								insertStatement.setString(10, newCurrentDate);
							} else {
								insertStatement.setString(10, getSamedate());
							}
							break;
						case 12:
							String author = nextCell.getStringCellValue();
							if (author != null) {
								insertStatement.setString(9, author);
							} else {
								insertStatement.setString(9, "UNKOWN");
							}
							break;
						case 13:
							String title = nextCell.getStringCellValue();
							if (title != null) {
								insertStatement.setString(8, title);
							} else {
								insertStatement.setString(8, "UNKOWN");
							}
							break;
						}
					}
					insertStatement.addBatch();

					if (count % batchSize == 0) {
						insertStatement.executeBatch();
					}
				}

				String query = "INSERT INTO master_data (ITEM_ID, ITEM_TYPE, TITLE, AUTHOR, PUBLISHER, "
						+ "PUBLICATION_YEAR, PUBLICATION_EDITION, SUBJECT) VALUES " + "(?, ?, ?, ?, ?, ?, ?, ?)";
				PreparedStatement insertMasterStatement = connection.prepareStatement(query);
				int counter = 0;
				masterRowIterator.next();
				while (masterRowIterator.hasNext()) {
					Row nextMasterRow = masterRowIterator.next();
					Iterator<Cell> cellMasterIterator = nextMasterRow.cellIterator();
					while (cellMasterIterator.hasNext()) {
						Cell nextMasterCell = cellMasterIterator.next();
						int masterColumnIndex = nextMasterCell.getColumnIndex();
						switch (masterColumnIndex) {
						case 0:
							int masterItemId = (int) nextMasterCell.getNumericCellValue();
							if (masterItemId != 0)
								insertMasterStatement.setInt(1, masterItemId);
							else
								insertMasterStatement.setNull(1, java.sql.Types.BIGINT);
							break;
						case 1:
							String masterItemType = nextMasterCell.getStringCellValue();
							if (masterItemType != null)
								insertMasterStatement.setString(2, masterItemType);
							else
								insertMasterStatement.setString(2, "UNKOWN");
							break;
						case 2:
							String masterTitle = nextMasterCell.getStringCellValue();
							if (masterTitle != null)
								insertMasterStatement.setString(3, masterTitle);
							else
								insertMasterStatement.setString(3, "UNKOWN");
							break;
						case 3:
							String masterAuthor = nextMasterCell.getStringCellValue();
							if (masterAuthor != null)
								insertMasterStatement.setString(4, masterAuthor);
							else
								insertMasterStatement.setString(4, "UNKOWN");
							break;
						case 4:
							String masterPublisher = nextMasterCell.getStringCellValue();
							if (masterPublisher != null)
								insertMasterStatement.setString(5, masterPublisher);
							else
								insertMasterStatement.setString(5, "UNKOWN");
							break;
						case 5:
							int masterPublicationYear = (int) nextMasterCell.getNumericCellValue();
							if (masterPublicationYear != 0)
								insertMasterStatement.setInt(6, masterPublicationYear);
							else
								insertMasterStatement.setNull(6, java.sql.Types.BIGINT);
							break;
						case 6:
							int masterPublicationEdition = (int) nextMasterCell.getNumericCellValue();
							if (masterPublicationEdition != 0)
								insertMasterStatement.setInt(7, masterPublicationEdition);
							else
								insertMasterStatement.setNull(7, java.sql.Types.BIGINT);
							break;
						case 7:
							String masterSubject = nextMasterCell.getStringCellValue();
							if (masterSubject != null)
								insertMasterStatement.setString(8, masterSubject);
							else
								insertMasterStatement.setString(8, "UNKOWN");
							break;
						default:
							break;
						}

					}
					insertMasterStatement.addBatch();

					if (counter % batchSize == 0) {
						insertMasterStatement.executeBatch();
					}
				}

				connection.commit();
				deleteHStatement.close();
				deleteMStatement.close();
				createHStatement.close();
				createMStatement.close();
				insertStatement.close();
				insertMasterStatement.close();
				workbook.close();
				inputStream.close();
				connection.commit();
				connection.close();
			}
		} catch (FileNotFoundException ex3) {
			System.out.println("Invalid file Error. File Could not be uploaded." + ex3.getMessage());
			ex3.printStackTrace();
		} catch (IOException ex1) {
			System.out.println("Error reading file." + ex1.getMessage());
			ex1.printStackTrace();
		} catch (SQLException ex2) {
			System.out.println("Database Error: " + ex2.getMessage());
			ex2.printStackTrace();
		}
	}

	public void searchById(Member data) throws SQLException {
		int itemId = data.getItemId();
		Connection connection = null;
		try {
			DriverManager.registerDriver(new org.postgresql.Driver());
			connection = DriverManager.getConnection(dbURL, dbUser, dbPass);
			if (connection == null) {
				System.err.println("Database not connected");
			}
			connection.setAutoCommit(false);
			String query = "select * from historical_data where ITEM_ID=" + itemId + " ";
			PreparedStatement selectStatement = connection.prepareStatement(query);
			selectStatement.executeUpdate();
		} catch (SQLException ex2) {
			System.err.println("Database Error: " + ex2.getMessage());
			ex2.printStackTrace();
		}
	}

	public List<Member> topReadBooks() throws SQLException {
		List<Member> listBooks = new ArrayList<>();
		Connection connection = null;
		Member data = null;
		try {
			DriverManager.registerDriver(new org.postgresql.Driver());
			connection = DriverManager.getConnection(dbURL, dbUser, dbPass);
			if (connection == null) {
				System.err.println("Database not connected");
			}
			connection.setAutoCommit(false);
			String dataList = "select title from (select title from historical_data where item_type='Book' GROUP BY title ORDER BY COUNT(title) DESC) AS x limit 10";
			Statement statement = connection.createStatement();
			ResultSet resultSet = statement.executeQuery(dataList);
			while (resultSet.next()) {
				String title = resultSet.getString("TITLE");
				data = new Member(title);
				listBooks.add(data);
			}
			resultSet.close();
			statement.close();
			connection.commit();
			connection.close();
		} catch (SQLException e) {
			System.err.println("Database Error: " + e.getMessage());
			e.printStackTrace();
		}
		return listBooks;
	}

	public List<Member> topAuthors() throws SQLException {
		List<Member> listAuthors = new ArrayList<>();
		Connection connection = null;
		Member data = null;
		try {
			DriverManager.registerDriver(new org.postgresql.Driver());
			connection = DriverManager.getConnection(dbURL, dbUser, dbPass);
			if (connection == null) {
				System.err.println("Database not connected");
			}
			connection.setAutoCommit(false);
			String dataList = "select author,item_type from (select author,item_type from historical_data where coalesce(author, '') != '' GROUP BY author,item_type ORDER BY COUNT(author) DESC) AS x limit 10";
			Statement statement = connection.createStatement();
			ResultSet resultSet = statement.executeQuery(dataList);
			while (resultSet.next()) {
				String author = resultSet.getString("AUTHOR");
				String itemType = resultSet.getString("ITEM_TYPE");
				data = new Member(author, itemType);
				listAuthors.add(data);
			}
			resultSet.close();
			statement.close();
			connection.commit();
			connection.close();
		} catch (SQLException e) {
			System.err.println("Database Error: " + e.getMessage());
			e.printStackTrace();
		}
		return listAuthors;
	}

	public List<Member> topReadJournals() throws SQLException {
		List<Member> listJournals = new ArrayList<>();
		Connection connection = null;
		Member data = null;
		try {
			DriverManager.registerDriver(new org.postgresql.Driver());
			connection = DriverManager.getConnection(dbURL, dbUser, dbPass);
			if (connection == null) {
				System.err.println("Database not connected");
			}
			connection.setAutoCommit(false);
			String dataList = "select title from (select title from historical_data where item_type='Journal' and coalesce(title, '') != '' GROUP BY title ORDER BY COUNT(title) DESC) AS x limit 5";
			Statement statement = connection.createStatement();
			ResultSet resultSet = statement.executeQuery(dataList);
			while (resultSet.next()) {
				String title = resultSet.getString("TITLE");
				data = new Member(title);
				listJournals.add(data);
			}
			resultSet.close();
			statement.close();
			connection.commit();
			connection.close();
		} catch (SQLException e) {
			System.err.println("Database Error: " + e.getMessage());
			e.printStackTrace();
		}
		return listJournals;
	}

	public List<Member> listSummary() throws SQLException {
		List<Member> listSummary = new ArrayList<>();
		Connection connection = null;
		Member data = null;
		try {
			DriverManager.registerDriver(new org.postgresql.Driver());
			connection = DriverManager.getConnection(dbURL, dbUser, dbPass);
			if (connection == null) {
				System.err.println("Database not connected");
			}
			connection.setAutoCommit(false);

			String dropTable = "drop table IF EXISTS summary";
			Statement dropStatement = connection.createStatement();
			dropStatement.executeUpdate(dropTable);
			connection.commit();

			String createTable = "CREATE TABLE IF NOT EXISTS SUMMARY AS (SELECT item_type, borrowed, overdue, total_count FROM ((SELECT a1.item_type, a1.borrowed, a1.overdue, a2.total_count FROM (SELECT  q1.item_type, q1.borrowed, q2.overDue FROM (SELECT rn.item_type, coalesce(borrowed, 0) as borrowed FROM (SELECT 'Reference Book' as item_type UNION ALL SELECT 'CD' UNION ALL SELECT 'Journal' UNION ALL SELECT 'Book' UNION ALL SELECT 'Conference Procedings')rn LEFT JOIN (SELECT  item_type, count(item_type) borrowed FROM historical_data where item_status = 'Borrowed' GROUP BY item_type)n on n.item_type = rn.item_type)q1 INNER JOIN (SELECT rn.item_type, coalesce(overdue, 0) as overdue FROM (SELECT 'Reference Book' as item_type UNION ALL SELECT 'CD' UNION ALL SELECT 'Journal' UNION ALL SELECT 'Book' UNION ALL SELECT 'Conference Procedings')rn LEFT JOIN (SELECT  item_type, count(item_type) overdue FROM historical_data where item_status = 'Over Due' GROUP BY item_type)n on n.item_type = rn.item_type)q2 ON q1.item_type = q2.item_type)a1 INNER JOIN (SELECT DISTINCT item_type, count(item_type) total_count FROM master_data GROUP BY item_type)a2 ON a1.item_type = a2.item_type ORDER BY a2.total_count asc) UNION (SELECT item_type, borrowed, overdue, total_count FROM (SELECT * FROM (SELECT 'Grand Total' as item_type) AS x,(select sum(borrowed) as borrowed from (SELECT count(item_status) as borrowed FROM historical_data where item_status = 'Borrowed' GROUP BY item_type ORDER BY count(item_status)) AS k) AS y, (select sum(overDue) as overDue from (SELECT count(item_status) as overDue FROM historical_data where item_status = 'Over Due' GROUP BY item_type ORDER BY count(item_status)) AS l) AS z, (select sum(total_count) as total_count from (SELECT count(item_type) as total_count FROM master_data GROUP BY item_type ORDER BY count(item_type)) as m) AS w) AS v)) AS p ORDER BY total_count asc)";
			Statement createStatement = connection.createStatement();
			createStatement.executeUpdate(createTable);
			connection.commit();

			String dataList = "SELECT * FROM SUMMARY";
			Statement statement = connection.createStatement();
			ResultSet resultSet = statement.executeQuery(dataList);
			while (resultSet.next()) {
				String itemType = resultSet.getString("ITEM_TYPE");
				int borrowed = resultSet.getInt("BORROWED");
				int overdue = resultSet.getInt("OVERDUE");
				int totalCount = resultSet.getInt("TOTAL_COUNT");

				data = new Member(itemType, borrowed, overdue, totalCount);
				listSummary.add(data);
			}
			resultSet.close();
			statement.close();
			dropStatement.close();
			createStatement.close();
			connection.commit();
			connection.close();
		} catch (SQLException e) {
			System.err.println("Database Error: " + e.getMessage());
			e.printStackTrace();
		}
		return listSummary;
	}

	public List<Master> listMasterRecords() throws SQLException {
		List<Master> listMasterData = new ArrayList<>();
		Connection connection = null;
		Master data = null;
		try {
			DriverManager.registerDriver(new org.postgresql.Driver());
			connection = DriverManager.getConnection(dbURL, dbUser, dbPass);
			if (connection == null) {
				System.err.println("Database not connected");
			}
			connection.setAutoCommit(false);
			String dataList = "SELECT * FROM Master_DATA";
			Statement statement = connection.createStatement();
			ResultSet resultSet = statement.executeQuery(dataList);
			while (resultSet.next()) {
				int itemId = resultSet.getInt("ITEM_ID");
				String itemType = resultSet.getString("ITEM_TYPE");
				String title = resultSet.getString("TITLE");
				String author = resultSet.getString("AUTHOR");
				String publisher = resultSet.getString("PUBLISHER");
				int publicationYear = resultSet.getInt("PUBLICATION_YEAR");
				int publicationEdition = resultSet.getInt("PUBLICATION_EDITION");
				String subject = resultSet.getString("SUBJECT");
				data = new Master(itemId, itemType, title, author, publisher, publicationYear, publicationEdition,
						subject);
				listMasterData.add(data);
			}
			resultSet.close();
			statement.close();
			connection.commit();
			connection.close();
		} catch (SQLException e) {
			System.err.println("Database Error: " + e.getMessage());
			e.printStackTrace();
		}
		return listMasterData;
	}

	public List<Member> listDefaulterRecords() throws SQLException {
		List<Member> defaulterList = new ArrayList<>();
		Connection connection = null;
		Member data = null;
		try {
			DriverManager.registerDriver(new org.postgresql.Driver());
			connection = DriverManager.getConnection(dbURL, dbUser, dbPass);
			if (connection == null) {
				System.err.println("Database not connected");
			}
			connection.setAutoCommit(false);
			String dataList = "select * from (select distinct member_id, item_id, item_type, due_datetime, title, author from historical_data where item_status='Over Due') AS m, (select * from (select current_datetime from historical_data) AS x limit 1) AS n";
			Statement statement = connection.createStatement();
			ResultSet resultSet = statement.executeQuery(dataList);
			while (resultSet.next()) {
				int memberId = resultSet.getInt("MEMBER_ID");
				int itemId = resultSet.getInt("ITEM_ID");
				String itemType = resultSet.getString("ITEM_TYPE");
				String dueDateTime = resultSet.getString("DUE_DATETIME");
				String title = resultSet.getString("TITLE");
				String author = resultSet.getString("AUTHOR");
				String currentDateTime = resultSet.getString("CURRENT_DATETIME");

				data = new Member(memberId, itemId, itemType, dueDateTime, title, author, currentDateTime);
				defaulterList.add(data);
			}
			resultSet.close();
			statement.close();
			connection.commit();
			connection.close();
		} catch (SQLException e) {
			System.err.println("Database Error: " + e.getMessage());
			e.printStackTrace();
		}
		return defaulterList;
	}

	public Member getEmailData(int id) throws SQLException {
		Member data = null;
		Connection connection = null;

		try {
			DriverManager.registerDriver(new org.postgresql.Driver());
			connection = DriverManager.getConnection(dbURL, dbUser, dbPass);
			if (connection == null) {
				System.err.println("Database not connected");
			}
			connection.setAutoCommit(false);

			String selectId = "select * from (select distinct member_id, item_id, item_type, due_datetime, title, author from historical_data where item_status='Over Due' and member_id = ?) AS m, (select * from (select current_datetime from historical_data) AS x limit 1) AS n";

			PreparedStatement selectStatement = connection.prepareStatement(selectId);
			selectStatement.setInt(1, id);
			ResultSet resultSet = selectStatement.executeQuery();
			if (resultSet.next()) {
				int memberId = resultSet.getInt("MEMBER_ID");
				int itemId = resultSet.getInt("ITEM_ID");
				String itemType = resultSet.getString("ITEM_TYPE");
				String dueDateTime = resultSet.getString("DUE_DATETIME");
				String title = resultSet.getString("TITLE");
				String author = resultSet.getString("AUTHOR");
				String currentDateTime = resultSet.getString("CURRENT_DATETIME");

				data = new Member(memberId, itemId, itemType, dueDateTime, title, author, currentDateTime);
			}

			resultSet.close();
			selectStatement.close();
			connection.commit();
			connection.close();
		} catch (SQLException e) {
			System.err.println("Database Error: " + e.getMessage());
			e.printStackTrace();
		}
		return data;
	}

	public void sendEmail(String recipient, String subject, String content)
			throws AddressException, MessagingException {
		Properties properties = new Properties();
		properties.setProperty("mail.transport.protocol", "smtp");
		properties.setProperty("mail.host", "smtp.gmail.com");
		properties.put("mail.smtp.port", "465");
		properties.put("mail.smtp.auth", "true");
		properties.put("mail.smtp.starttls.enable", "true");
		properties.put("mail.debug", "false");
		properties.put("mail.smtp.socketFactory.port", "465");
		properties.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
		properties.put("mail.smtp.socketFactory.fallback", "false");

		Session session = Session.getInstance(properties, new javax.mail.Authenticator() {
			protected PasswordAuthentication getPasswordAuthentication() {
				return new PasswordAuthentication(emailId, emailPassword);
			}
		});

		Transport transport = session.getTransport();
		InternetAddress addressFrom = new InternetAddress(emailId);

		MimeMessage msg = new MimeMessage(session);

		msg.setSender(addressFrom);
		msg.setSubject(subject);
		msg.setSentDate(new Date());
		msg.setContent(content, "text/plain");
		msg.setFrom(new InternetAddress(emailId));
		msg.addRecipient(Message.RecipientType.TO, new InternetAddress(recipient));

		transport.connect();
		Transport.send(msg);
		transport.close();
	}

	public String getSamedate() {
		return samedate;
	}

	public void setSamedate(String samedate) {
		this.samedate = samedate;
	}
}
