package com.project.NBFC.Model;

import javax.persistence.Entity;
import javax.persistence.Id;

@Entity
public class admin_login 
{
	@Id
	private int aid;
	private String aemail;
	private String apass;

	private int getAid() {
		return aid;
	}
	
	public String getAemail() {
		return aemail;
	}

	private String getApass() {
		return apass;
	}
	
}
