package com.project.NBFC.Dao;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.project.NBFC.Model.Users;
import com.project.NBFC.Repo.UsersRepo;
import com.project.NBFC.Services.UserService;
@Service
public class UsersDao implements UserService
{

	@Autowired
	UsersRepo ur;
	
	public Users checkdata(String email)
	{
		return ur.findByEmail(email);
	}
	
	public void savedata(Users u1)
	{
		 ur.save(u1);
	}

	@Override
	public Users checkBoth(String email, String password) {
		return ur.findByEmailAndPassword(email,password);
	}

	@Override
	public Users getUserbyname(String fullname) {
		return ur.findByFullnameLike(fullname);
	}

	@Override
	public List<Users> getByFullName(String fullname, String account_no) {
		
		return ur.findByFullnameOrAccount_no(fullname, account_no);
	}

	@Override
	public Users getUserByAccountNo(int account_no) {
		
		return ur.getById(account_no);
	}

	@Override
	public List<Users> getallusers() {
		
		return ur.findAll();
	}

	
}
