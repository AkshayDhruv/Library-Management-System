package com.beans;

public class Master {
	private int itemId;
	private String itemType;
	private String title;
	private String author;
	private String publisher;
	private int publicationYear;
	private int publicationEdition;
	private String subject;
	private int memberId;

	public Master(int itemId, String itemType, String title, String author, String publisher, int publicationYear,
			int publicationEdition, String subject) {
		super();
		setItemId(itemId);
		setItemType(itemType);
		setTitle(title);
		setAuthor(author);
		setPublisher(publisher);
		setPublicationYear(publicationYear);
		setPublicationEdition(publicationEdition);
		setSubject(subject);
	}

	public Master(int itemIdIn) {
		setItemId(itemIdIn);
	}

	public Master(int memberId2, int itemId2, String itemType2, String title2, String author2) {
		setMemberId(memberId2);
		setItemId(itemId2);
		setItemType(itemType2);
		setTitle(title2);
		setAuthor(author2);
	}

	public int getItemId() {
		return itemId;
	}

	public void setItemId(int itemId) {
		this.itemId = itemId;
	}

	public String getItemType() {
		return itemType;
	}

	public void setItemType(String itemType) {
		this.itemType = itemType;
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

	public String getPublisher() {
		return publisher;
	}

	public void setPublisher(String publisher) {
		this.publisher = publisher;
	}

	public int getPublicationYear() {
		return publicationYear;
	}

	public void setPublicationYear(int publicationYear) {
		this.publicationYear = publicationYear;
	}

	public int getPublicationEdition() {
		return publicationEdition;
	}

	public void setPublicationEdition(int publicationEdition) {
		this.publicationEdition = publicationEdition;
	}

	public String getSubject() {
		return subject;
	}

	public void setSubject(String subject) {
		this.subject = subject;
	}

	public int getMemberId() {
		return memberId;
	}

	public void setMemberId(int memberId) {
		this.memberId = memberId;
	}

}
