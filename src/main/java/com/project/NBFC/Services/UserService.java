package com.project.NBFC.Services;

import java.util.List;

import com.project.NBFC.Model.Users;

public interface UserService 
{
	public Users checkdata(String uemail);
	
	public void savedata(Users u1);
	
	public Users checkBoth(String uemail,String upass);
	
	public Users getUserbyname(String fullname);
	
	public List<Users> getByFullName(String fullname,String account_no);
	
	public Users getUserByAccountNo(int account_no);
	
	public List<Users> getallusers();
}
