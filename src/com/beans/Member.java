package com.beans;

public class Member {
	private int itemId;
	private int memberId;
	private String itemStatus;
	private String itemType;
	private String borrowDateTime;
	private String dueDateTime;
	private String returnDateTime;
	private String title;
	private String author;
	private int borrowed;
	private int overdue;
	private int totalCount;
	private String currentDateTime;

	public Member(int memberId, int itemId, String itemStatus, String itemType, String borrowDateTime,
			String dueDateTime, String returnDateTime, String title, String author, String currentDateTime) {
		super();
		setMemberId(memberId);
		setItemId(itemId);
		setItemStatus(itemStatus);
		setItemType(itemType);
		setBorrowDateTime(borrowDateTime);
		setDueDateTime(dueDateTime);
		setReturnDateTime(returnDateTime);
		setTitle(title);
		setAuthor(author);
		setCurrentDateTime(currentDateTime);
	}

	public Member(String titleIn) {
		setTitle(titleIn);
	}

	public Member(String authorIn, String itemTypeIn) {
		setAuthor(authorIn);
		setItemType(itemTypeIn);
	}

	public Member(String itemTypeIn, int borrowedIn, int overdueIn, int totalCountIn) {
		setItemType(itemTypeIn);
		setBorrowed(borrowedIn);
		setOverdue(overdueIn);
		setTotalCount(totalCountIn);
	}

	public Member(int memberId2, int itemId2, String itemType2, String dueDateTime2, String title2, String author2,
			String currentDateTime2) {
		setMemberId(memberId2);
		setItemId(itemId2);
		setItemType(itemType2);
		setDueDateTime(dueDateTime2);
		setTitle(title2);
		setAuthor(author2);
		setCurrentDateTime(currentDateTime2);
	}

	public Member(int itemIdIn) {
		setItemId(itemIdIn);
	}

	public Member(int memberIdIn, int itemIdIn, String currentDateTimeIn) {
		setMemberId(memberIdIn);
		setItemId(itemIdIn);
		setCurrentDateTime(currentDateTimeIn);
	}

	public Member(int memberId2, int itemId2, String itemType2, String borrowDateTime2, String returnDateTime2,
			String title2, String author2, String currentDateTime2) {
		setMemberId(memberId2);
		setItemId(itemId2);
		setItemType(itemType2);
		setBorrowDateTime(borrowDateTime2);
		setReturnDateTime(returnDateTime2);
		setTitle(title2);
		setAuthor(author2);
		setCurrentDateTime(currentDateTime2);
	}

	public Member(String itemStatus2, String borrowDateTime2, String dueDateTime2, String returnDateTime2,
			String currentDateTime2) {
		setItemStatus(itemStatus2);
		setBorrowDateTime(borrowDateTime2);
		setDueDateTime(dueDateTime2);
		setReturnDateTime(returnDateTime2);
		setCurrentDateTime(currentDateTime2);
	}

	public Member() {
	}

	public Member(int itemId2, String currentDateTime2) {
		setItemId(itemId2);
		setCurrentDateTime(currentDateTime2);
	}

	public int getItemId() {
		return itemId;
	}

	public void setItemId(int itemId) {
		this.itemId = itemId;
	}

	public int getMemberId() {
		return memberId;
	}

	public void setMemberId(int memberId) {
		this.memberId = memberId;
	}

	public String getItemStatus() {
		return itemStatus;
	}

	public void setItemStatus(String itemStatus) {
		this.itemStatus = itemStatus;
	}

	public String getItemType() {
		return itemType;
	}

	public void setItemType(String itemType) {
		this.itemType = itemType;
	}

	public String getBorrowDateTime() {
		return borrowDateTime;
	}

	public void setBorrowDateTime(String borrowDateTime) {
		this.borrowDateTime = borrowDateTime;
	}

	public String getDueDateTime() {
		return dueDateTime;
	}

	public void setDueDateTime(String dueDateTime) {
		this.dueDateTime = dueDateTime;
	}

	public String getReturnDateTime() {
		return returnDateTime;
	}

	public void setReturnDateTime(String returnDateTime) {
		this.returnDateTime = returnDateTime;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getAuthor() {
		return author;
	}

	public void setAuthor(String author) {
		this.author = author;
	}

	public int getBorrowed() {
		return borrowed;
	}

	public void setBorrowed(int borrowed) {
		this.borrowed = borrowed;
	}

	public int getOverdue() {
		return overdue;
	}

	public void setOverdue(int overdue) {
		this.overdue = overdue;
	}

	public int getTotalCount() {
		return totalCount;
	}

	public void setTotalCount(int totalCount) {
		this.totalCount = totalCount;
	}

	public String getCurrentDateTime() {
		return currentDateTime;
	}

	public void setCurrentDateTime(String currentDateTime) {
		this.currentDateTime = currentDateTime;
	}

}
