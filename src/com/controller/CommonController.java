package com.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URISyntaxException;
import java.net.URL;
import java.nio.file.Paths;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import com.beans.Member;
import com.beans.Login;
import com.beans.Master;
import com.dao.CommonDao;

@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 5, // 5MB
		maxFileSize = 1024 * 1024 * 10, // 10MB
		maxRequestSize = 1024 * 1024 * 50) // 50MB
public class CommonController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static final String SAVE_DIR = "uploadFiles";
	private CommonDao dataDao;

	public void init() {
		String jdbcURL = getServletContext().getInitParameter("jdbcURL");
		String jdbcUsername = getServletContext().getInitParameter("jdbcUsername");
		String jdbcPassword = getServletContext().getInitParameter("jdbcPassword");
		String emailId = getServletContext().getInitParameter("emailId");
		String emailPassword = getServletContext().getInitParameter("emailPassword");
		dataDao = new CommonDao(jdbcURL, jdbcUsername, jdbcPassword, emailId, emailPassword);

	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doGet(request, response);
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String action = request.getServletPath();

		try {
			switch (action) {
			case "/upload":
				uploadData(request, response);
				break;
			case "/process":
				uploadPage(request, response);
				break;
			case "/view":
				searchPage(request, response);
				break;
			case "/statistics":
				statistics(request, response);
				break;
			case "/searchById":
				searchById(request, response);
				break;
			case "/topBooks":
				topBooks(request, response);
				break;
			case "/topAuthors":
				topAuthors(request, response);
				break;
			case "/topJournals":
				topJournals(request, response);
				break;
			case "/summary":
				summary(request, response);
				break;
			case "/search":
				searchInventory(request, response);
				break;
			case "/download":
				downloadData(request, response);
				break;
			case "/defaulter":
				defaulterRecords(request, response);
				break;
			case "/email":
				emailDefaulter(request, response);
				break;
			case "/sendEmail":
				sendEmail(request, response);
				break;
			case "/loginPage":
				loginPage(request, response);
				break;
			case "/login":
				loginApp(request, response);
				break;
			case "/logout":
				logoutApp(request, response);
				break;
			case "/register":
				newRegister(request, response);
				break;
			case "/requestPassword":
				forgotPassword(request, response);
				break;
			case "/addMaster":
				addMaster(request, response);
				break;
			case "/insertMaster":
				insertMaster(request, response);
				break;
			case "/editMaster":
				editMaster(request, response);
				break;
			case "/updateMaster":
				updateMaster(request, response);
				break;
			case "/deleteMaster":
				deleteMaster(request, response);
				break;
			case "/addMemberRecord":
				addMember(request, response);
				break;
			case "/insertMemberRecord":
				insertMember(request, response);
				break;
			case "/deleteMemberRecord":
				deleteMember(request, response);
				break;
			case "/editMemberRecord":
				editMember(request, response);
				break;
			case "/updateMemberRecord":
				updateMember(request, response);
				break;				
			case "/updateCurrentDateTime":
				updateCurrentDateTime(request, response);
				break;
			case "/fetchMemberData":
				fetchMemberData(request, response);
				break;
			default:
				showHomePage(request, response);
				break;
			}
		} catch (SQLException ex) {
			throw new ServletException(ex);
		} catch (URISyntaxException ex) {
			throw new ServletException(ex);
		} catch (ParseException ex) {
			throw new ServletException(ex);
		}
	}

	private void fetchMemberData(HttpServletRequest request, HttpServletResponse response) 
			throws SQLException, ServletException, IOException {
		int itemId = Integer.parseInt(request.getParameter("itemId"));
		int memberId = Integer.parseInt(request.getParameter("memberId"));
		Master data = dataDao.fetchMemberData(itemId, memberId);
		RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/MemberForm.jsp");
		request.setAttribute("fetchedData", data);
		dispatcher.forward(request, response);
		
	}

	private void updateCurrentDateTime(HttpServletRequest request, HttpServletResponse response) 
			throws SQLException, ServletException, IOException {
		String currentDateTime = request.getParameter("currentDateTime");
		String updateMessage = "";
		try {
			List<Member> listData = dataDao.listAllRecords();
			dataDao.updateCurrentDateTime(listData, currentDateTime);
			List<Member> listMemberData = dataDao.listAllRecords();
			dataDao.updateItemStatus(listMemberData);
		//	updateMessage = "Updated Status Date Successfully!";
		} catch (Exception ex) {
			ex.printStackTrace();
			updateMessage = "There were an error: " + ex.getMessage();
		} finally {
			RequestDispatcher dispatcher = request
					.getRequestDispatcher("/WEB-INF/jsp/Statistics.jsp?updateMessage=" + updateMessage);
			dispatcher.forward(request, response);
		}
		
	}

	private void updateMember(HttpServletRequest request, HttpServletResponse response) 
			throws SQLException, ServletException, IOException {	
		String returnDateTime = null;
		int memberId = Integer.parseInt(request.getParameter("memberId"));
		int itemId = Integer.parseInt(request.getParameter("itemId"));
		String itemStatus = request.getParameter("itemStatus");
		String itemType = request.getParameter("itemType");
		String borrowDateTime = request.getParameter("borrowDateTime");
		String dueDateTime = request.getParameter("dueDateTime");
		String returnDT = request.getParameter("returnDateTime");
		if(returnDT == "") {
			returnDateTime = "NOT RETURNED";
		} else {
			returnDateTime = returnDT;
		}
		String title = request.getParameter("title");
		String author = request.getParameter("author");
		String updateMessage = "";
		try {
			Member data = dataDao.getCurrentData(1);
			Member memberDao = new Member(memberId, itemId, itemStatus, itemType, borrowDateTime, dueDateTime, returnDateTime, title, author, data.getCurrentDateTime());
			dataDao.updateNewMemberRecord(memberDao);
		//	updateMessage = "Updated Successfully!";
		} catch (Exception ex) {
			ex.printStackTrace();
			updateMessage = "There were an error: " + ex.getMessage();
		} finally {
			RequestDispatcher dispatcher = request
					.getRequestDispatcher("/WEB-INF/jsp/MemberInventory.jsp?updateMessage=" + updateMessage);
			dispatcher.forward(request, response);
		}
		
	}

	private void editMember(HttpServletRequest request, HttpServletResponse response) 
			throws SQLException, ServletException, IOException {
		int itemId = Integer.parseInt(request.getParameter("id"));
		Member data = dataDao.getMemberData(itemId);
		RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/MemberForm.jsp");
		request.setAttribute("data", data);
		dispatcher.forward(request, response);
		
	}

	private void deleteMember(HttpServletRequest request, HttpServletResponse response)
			throws SQLException, ServletException, IOException {
		int itemId = Integer.parseInt(request.getParameter("id"));
		String deleteMessage = "";
		try {
			Member memberDao = new Member(itemId);
			dataDao.deleteMemberRecord(memberDao);
			//deleteMessage = "Deleted Successfully!";
		} catch (Exception ex) {
			ex.printStackTrace();
			deleteMessage = "There were an error: " + ex.getMessage();
		} finally {
			RequestDispatcher dispatcher = request
					.getRequestDispatcher("/WEB-INF/jsp/MemberInventory.jsp?deleteMessage=" + deleteMessage);
			dispatcher.forward(request, response);
		}

	}

	private void insertMember(HttpServletRequest request, HttpServletResponse response) 
			throws SQLException, ServletException, IOException, ParseException {
		int memberId = Integer.parseInt(request.getParameter("memberId"));
		int itemId = Integer.parseInt(request.getParameter("itemId"));
		String itemType = request.getParameter("itemType");
		String borrowDateTime = request.getParameter("borrowDateTime");
		String returnDateTime = "NOT RETURNED";
		String title = request.getParameter("title");
		String author = request.getParameter("author");
		String insertMessage = "";
		Member memberdata = null; 
		try {
			Member data = dataDao.getCurrentData(1);
			if(data == null) {
				data = dataDao.setCurrentDateTime(itemId);
			}
			memberdata = new Member(memberId, itemId, itemType, borrowDateTime, returnDateTime, title, author, data.getCurrentDateTime());
			dataDao.insertNewMemberRecord(memberdata);
			//insertMessage = "Added Successfully!";
		} catch (Exception ex) {
			ex.printStackTrace();
			insertMessage = "There were an error: " + ex.getMessage();
		} finally {
			RequestDispatcher dispatcher = request
					.getRequestDispatcher("/WEB-INF/jsp/MemberInventory.jsp?insertMessage=" + insertMessage);
			dispatcher.forward(request, response);
		}		
	}

	private void addMember(HttpServletRequest request, HttpServletResponse response) 
			throws SQLException, ServletException, IOException {
		List<Master> listMasterData = dataDao.listMasterRecords();
		request.setAttribute("listMasterData", listMasterData);
		RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/MemberForm.jsp");
		dispatcher.forward(request, response);
	}

	private void updateMaster(HttpServletRequest request, HttpServletResponse response) 
			throws SQLException, ServletException, IOException {	
		int itemId = Integer.parseInt(request.getParameter("itemId"));
		String itemType = request.getParameter("itemType");
		String title = request.getParameter("title");
		String author = request.getParameter("author");
		String publisher = request.getParameter("publisher");
		int publicationYear = Integer.parseInt(request.getParameter("publicationYear"));
		int publicationEdition = Integer.parseInt(request.getParameter("edition"));
		String subject = request.getParameter("subject");
		String updateMessage = "";
		try {
			Master masterDao = new Master(itemId, itemType, title, author, publisher, publicationYear,
					publicationEdition, subject);
			dataDao.updateNewMasterRecord(masterDao);
		//	updateMessage = "Updated Successfully!";
		} catch (Exception ex) {
			ex.printStackTrace();
			updateMessage = "There were an error: " + ex.getMessage();
		} finally {
			RequestDispatcher dispatcher = request
					.getRequestDispatcher("/WEB-INF/jsp/MasterInventory.jsp?updateMessage=" + updateMessage);
			dispatcher.forward(request, response);
		}
		
	}

	private void deleteMaster(HttpServletRequest request, HttpServletResponse response) 
			throws SQLException, ServletException, IOException {
		  	int itemId = Integer.parseInt(request.getParameter("id"));
		  	String deleteMessage = "";
		  try {
	        Master masterDao = new Master(itemId);
	        dataDao.deleteMaster(masterDao);
	       // deleteMessage = "Deleted Successfully!";
		  }catch (Exception ex){
			  ex.printStackTrace();
			  deleteMessage = "There were an error: " + ex.getMessage();
		  }finally {
			  RequestDispatcher dispatcher = request
						.getRequestDispatcher("/WEB-INF/jsp/MasterInventory.jsp?deleteMessage=" + deleteMessage);
				dispatcher.forward(request, response);
		  }
	}

	private void editMaster(HttpServletRequest request, HttpServletResponse response) 
			throws SQLException, ServletException, IOException {
		int itemId = Integer.parseInt(request.getParameter("id"));
		Master data = dataDao.getMasterData(itemId);
		RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/MasterForm.jsp");
		request.setAttribute("data", data);
		dispatcher.forward(request, response);

	}

	private void insertMaster(HttpServletRequest request, HttpServletResponse response)
			throws SQLException, ServletException, IOException {
		int itemId = Integer.parseInt(request.getParameter("itemId"));
		String itemType = request.getParameter("itemType");
		String title = request.getParameter("title");
		String author = request.getParameter("author");
		String publisher = request.getParameter("publisher");
		int publicationYear = Integer.parseInt(request.getParameter("publicationYear"));
		int publicationEdition = Integer.parseInt(request.getParameter("edition"));
		String subject = request.getParameter("subject");
		String insertMessage = "";
		try {
			Master masterDao = new Master(itemId, itemType, title, author, publisher, publicationYear,
					publicationEdition, subject);
			dataDao.insertNewMasterRecord(masterDao);
			//insertMessage = "Added Successfully!";
		} catch (Exception ex) {
			ex.printStackTrace();
			insertMessage = "There were an error: " + ex.getMessage();
		} finally {
			RequestDispatcher dispatcher = request
					.getRequestDispatcher("/WEB-INF/jsp/MasterInventory.jsp?insertMessage=" + insertMessage);
			dispatcher.forward(request, response);
		}

	}

	private void addMaster(HttpServletRequest request, HttpServletResponse response)
			throws SQLException, ServletException, IOException {
		RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/MasterForm.jsp");
		dispatcher.forward(request, response);
	}

	private void forgotPassword(HttpServletRequest request, HttpServletResponse response)
			throws SQLException, ServletException, IOException {
		String name = request.getParameter("registeredUserName");
		String email = request.getParameter("registeredUserEmail");
		String securityAnswer = request.getParameter("registeredUserSecurityAnswer");
		String passMessage = "";
		Login data = dataDao.fetchPassword(name, email, securityAnswer);
		if (isNull(data)) {
			passMessage = "Incorrect Credentials! Please Try Again.";
		} else {
			passMessage = "Please note down your login password: [" + data.getPassword() + "]";
		}
		RequestDispatcher dispatcher = request
				.getRequestDispatcher("/WEB-INF/jsp/LoginPage.jsp?passMessage=" + passMessage);
		dispatcher.forward(request, response);
	}

	private void newRegister(HttpServletRequest request, HttpServletResponse response)
			throws SQLException, ServletException, IOException {
		String name = request.getParameter("newUser");
		String email = request.getParameter("email");
		String password = request.getParameter("password");
		String securityAnswer = request.getParameter("secuityAnswer");
		String resultMessage = "";
		try {
			Login loginDao = new Login(name, email, password, securityAnswer);
			dataDao.newRegistration(loginDao);
			resultMessage = "Registered Successfully!";
		} catch (Exception ex) {
			ex.printStackTrace();
			resultMessage = "There were an error: " + ex.getMessage();
		} finally {
			RequestDispatcher dispatcher = request
					.getRequestDispatcher("/WEB-INF/jsp/LoginPage.jsp?message=" + resultMessage);
			dispatcher.forward(request, response);
		}
	}

	private void logoutApp(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/Logout.jsp");
		dispatcher.forward(request, response);
	}

	private void loginApp(HttpServletRequest request, HttpServletResponse response)
			throws SQLException, ServletException, IOException {
		String email = request.getParameter("email");
		String password = request.getParameter("password");
		String errorMessage = "";
		Login data = dataDao.loginCheck(email, password);
		if (isNull(data)) {
			errorMessage = "Incorrect Credentials! Please Try Again.";
			RequestDispatcher dispatcher = request
					.getRequestDispatcher("/WEB-INF/jsp/LoginPage.jsp?errorMessage=" + errorMessage);
			dispatcher.forward(request, response);
		} else {
			if (email.equalsIgnoreCase("admin123@gmail.com") && password.equals("admin@123")) {
				HttpSession session = request.getSession();
				session.setAttribute("email", data.getEmail());
				session.setAttribute("name", data.getName());
				RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/Welcome.jsp");
				dispatcher.forward(request, response);
			} else {
				HttpSession session = request.getSession();
				session.setAttribute("email", data.getEmail());
				session.setAttribute("name", data.getName());
				RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/Welcome.jsp");
				dispatcher.forward(request, response);
			}
		}
	}

	private boolean isNull(Login data) {
		return data == null;
	}

	private void loginPage(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/LoginPage.jsp");
		dispatcher.forward(request, response);
	}

	private void statistics(HttpServletRequest request, HttpServletResponse response)
			throws SQLException, ServletException, IOException {
		List<Member> listData = dataDao.listAllRecords();
		request.setAttribute("listData", listData);
		RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/Statistics.jsp");
		dispatcher.forward(request, response);

	}

	private void sendEmail(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String recipient = request.getParameter("recipient");
		String subject = request.getParameter("subject");
		String content = request.getParameter("content");
		String resultMessage = "";

		try {
			dataDao.sendEmail(recipient, subject, content);
			resultMessage = "E-mail sent successfully";
		} catch (Exception ex) {
			ex.printStackTrace();
			resultMessage = "There were an error: " + ex.getMessage();
		} finally {
			RequestDispatcher dispatcher = request
					.getRequestDispatcher("/WEB-INF/jsp/EmailForm.jsp?message=" + resultMessage);
			dispatcher.forward(request, response);
		}

	}

	private void emailDefaulter(HttpServletRequest request, HttpServletResponse response)
			throws SQLException, ServletException, IOException {
		int id = 0;
		if (request.getParameter("selectedMemberId") != null) {
			id = Integer.parseInt(request.getParameter("selectedMemberId"));
		}
		Member data = dataDao.getEmailData(id);
		RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/EmailForm.jsp");
		request.setAttribute("data", data);
		dispatcher.forward(request, response);
	}

	private void defaulterRecords(HttpServletRequest request, HttpServletResponse response)
			throws SQLException, ServletException, IOException {
		List<Member> defaulterList = dataDao.listDefaulterRecords();
		request.setAttribute("defaulterList", defaulterList);
		RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/DefaulterPage.jsp");
		dispatcher.forward(request, response);
	}

	private void downloadData(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException, URISyntaxException { 
		URL res = getClass().getClassLoader().getResource("SampleDataSheet.xlsm");
		File downloadFile = Paths.get(res.toURI()).toFile();
		String filePath = downloadFile.getAbsolutePath();
		FileInputStream inStream = new FileInputStream(downloadFile);

		ServletContext context = getServletContext();

		String mimeType = context.getMimeType(filePath);
		if (mimeType == null) { 
			mimeType = "application/octet-stream";
		}

		response.setContentType(mimeType);
		response.setContentLength((int) downloadFile.length());

		String headerKey = "Content-Disposition";
		String headerValue = String.format("attachment; filename=\"%s\"", downloadFile.getName());
		response.setHeader(headerKey, headerValue);

		OutputStream outStream = response.getOutputStream();

		byte[] buffer = new byte[4096];
		int bytesRead = -1;

		while ((bytesRead = inStream.read(buffer)) != -1) {
			outStream.write(buffer, 0, bytesRead);
		}

		inStream.close();
		outStream.close();
	}

	private void searchInventory(HttpServletRequest request, HttpServletResponse response)
			throws SQLException, ServletException, IOException {
		List<Master> listMasterData = dataDao.listMasterRecords();
		request.setAttribute("listMasterData", listMasterData);
		RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/MasterInventory.jsp");
		dispatcher.forward(request, response);
	}

	private void summary(HttpServletRequest request, HttpServletResponse response)
			throws SQLException, ServletException, IOException {
		List<Member> listSummary = dataDao.listSummary();
		int borrowed = listSummary.get(listSummary.size() - 1).getBorrowed();
		int overdue = listSummary.get(listSummary.size() - 1).getOverdue();
		int totalCount = listSummary.get(listSummary.size() - 1).getTotalCount();
		int grandTotal = totalCount - (borrowed + overdue);
		request.setAttribute("grandTotal", grandTotal);
		request.setAttribute("listSummary", listSummary);
		RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/Summary.jsp");
		dispatcher.forward(request, response);
	}

	private void topJournals(HttpServletRequest request, HttpServletResponse response)
			throws SQLException, ServletException, IOException {
		List<Member> listJournals = dataDao.topReadJournals();
		request.setAttribute("listJournals", listJournals);
		RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/TopReadJournals.jsp");
		dispatcher.forward(request, response);
	}

	private void topAuthors(HttpServletRequest request, HttpServletResponse response)
			throws SQLException, ServletException, IOException {
		List<Member> listAuthors = dataDao.topAuthors();
		request.setAttribute("listAuthors", listAuthors);
		RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/TopAuthors.jsp");
		dispatcher.forward(request, response);
	}

	private void topBooks(HttpServletRequest request, HttpServletResponse response)
			throws SQLException, ServletException, IOException {
		List<Member> listBooks = dataDao.topReadBooks();
		request.setAttribute("listBooks", listBooks);
		RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/TopReadBooks.jsp");
		dispatcher.forward(request, response);

	}

	private void searchById(HttpServletRequest request, HttpServletResponse response)
			throws SQLException, ServletException, IOException {
		int id = 0;
		if (request.getParameter("id") != null) {
			id = Integer.parseInt(request.getParameter("id"));
		}
		Member data = dataDao.getData(id);
		RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/SearchIdView.jsp");
		request.setAttribute("data", data);
		dispatcher.forward(request, response);
	}

	private void searchPage(HttpServletRequest request, HttpServletResponse response)
			throws SQLException, ServletException, IOException {
		List<Member> listData = dataDao.listAllRecords();
		request.setAttribute("listData", listData);
		RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/MemberInventory.jsp");
		dispatcher.forward(request, response);

	}

	private void uploadPage(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/UploadPage.jsp");
		dispatcher.forward(request, response);
	}

	private void uploadData(HttpServletRequest request, HttpServletResponse response)
			throws SQLException, ServletException, IOException {
		String appPath = request.getServletContext().getRealPath("");
		String savePath = appPath + File.separator + SAVE_DIR;

		File fileSaveDir = new File(savePath);
		if (!fileSaveDir.exists()) {
			fileSaveDir.mkdir();
		}

		for (Part part : request.getParts()) {
			String fileName = extractFileName(part);
			fileName = new File(fileName).getName();
			part.write(savePath + File.separator + fileName);
			/* CommonDao dataDao = new CommonDao(savePath + File.separator + fileName); */

			dataDao.uploadExcelData(savePath + File.separator + fileName);
		}
	}

	private String extractFileName(Part part) {
		String contentDisp = part.getHeader("content-disposition");
		String[] items = contentDisp.split(";");
		for (String s : items) {
			if (s.trim().startsWith("filename")) {
				return s.substring(s.indexOf("=") + 2, s.length() - 1);
			}
		}
		return "";
	}

	private void showHomePage(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/Welcome.jsp");
		dispatcher.forward(request, response);
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}
}
