package com.project.NBFC.Model;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.OneToOne;

import org.hibernate.annotations.GenericGenerator;

@Entity
public class Guarantors
{
	@Id
	@GenericGenerator(name="guarantor_seq",strategy = "increment")
	@GeneratedValue(generator="guarantor_seq")
	private int gid;
	private String Adhaar;
	private String pan;
	@OneToOne
	private Users parentUser;
	
	public Users getParentUser() {
		return parentUser;
	}
	public void setParentUser(Users parentUser) {
		this.parentUser = parentUser;
	}
	public int getGid() {
		return gid;
	}
	public void setGid(int gid) {
		this.gid = gid;
	}
	
	
	public String getAdhaar() {
		return Adhaar;
	}
	public void setAdhaar(String adhaar) {
		Adhaar = adhaar;
	}
	public String getPan() {
		return pan;
	}
	public void setPan(String pan) {
		this.pan = pan;
	}
	
}
