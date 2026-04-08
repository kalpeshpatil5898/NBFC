package com.project.NBFC.Model;

import java.util.List;

public class ResponseUsers {
	
	String msg;
	List<Users> users;
	
	public String getMsg() {
		return msg;
	}
	public void setMsg(String msg) {
		this.msg = msg;
	}
	public List<Users> getUsers() {
		return users;
	}
	public void setUsers(List<Users> users) {
		this.users = users;
	}
	
	
}
