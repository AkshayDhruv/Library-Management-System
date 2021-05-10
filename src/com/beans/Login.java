package com.beans;

public class Login {
	private String name;
	private String email;
	private String password;
	private String securityAnswer;
	
	public Login(String nameIn, String emailIdIn, String passwordIn) {
		super();
		setName(nameIn);
		setEmail(emailIdIn);
		setPassword(passwordIn);
	}

	public Login(String passwordIn) {
		setPassword(passwordIn);
	}

	public Login(String name, String email, String password, String securityAnswer) {
		super();
		this.name = name;
		this.email = email;
		this.password = password;
		this.securityAnswer = securityAnswer;
	}

	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}

	public String getSecurityAnswer() {
		return securityAnswer;
	}

	public void setSecurityAnswer(String securityAnswer) {
		this.securityAnswer = securityAnswer;
	}

}
