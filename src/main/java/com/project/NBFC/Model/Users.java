package com.project.NBFC.Model;

import java.text.SimpleDateFormat;
import java.time.ZoneId;
import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;

import org.hibernate.annotations.GenericGenerator;

@Entity
public class Users 
{
	
	@Id
	@GenericGenerator(name="user_seq",strategy = "increment")
	@GeneratedValue(generator="user_seq")
	private int account_no;
	private String fullname;
	private String password;
	private String cpassword;
	private String email;
	private String address;
	private String contact;
	private double balance=2000.0;
	private String gender;
	private Date dob;
	private String branch="NBFC";
	private String adhaar_photo;
	private String profile_photo;
	private String pan_photo;
	
	public String getAdhaar_photo() {
		return adhaar_photo;
	}
	public void setAdhaar_photo(String adhaar_photo) {
		this.adhaar_photo = adhaar_photo;
	}
	public String getPan_photo() {
		return pan_photo;
	}
	public void setPan_photo(String pan_photo) {
		this.pan_photo = pan_photo;
	}
	public String getProfile_photo() {
		return profile_photo;
	}
	public void setProfile_photo(String profile_photo) {
		this.profile_photo = profile_photo;
	}
	
	public int getAccount_no() {
		return account_no;
	}
	public void setAccount_no(int account_no) {
		this.account_no = account_no;
	}
	public String getFullname() {
		return fullname;
	}
	public void setFullname(String fullname) {
		this.fullname = fullname;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public String getCpassword() {
		return cpassword;
	}
	public void setCpassword(String cpassword) {
		this.cpassword = cpassword;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
	}
	public String getContact() {
		return contact;
	}
	public void setContact(String contact) {
		this.contact = contact;
	}
	public double getBalance() {
		return balance;
	}
	public void setBalance(double balance) {
		this.balance = balance;
	}
	public String getGender() {
		return gender;
	}
	public void setGender(String gender) {
		this.gender = gender;
	}
	
	public Date getDob() {
		return dob;
	}
	
	public String getDateOfBirth() {
		SimpleDateFormat formatter = new SimpleDateFormat("dd MMM yyyy"); 
		
		return formatter.format(dob);
	}
	
	public void setDob(Date dob) {
		this.dob = dob;
	}
	public String getBranch() {
		return branch;
	}
	public void setBranch(String branch) {
		this.branch = branch;
	}
	
	
}
