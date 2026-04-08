package com.project.NBFC.Dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.project.NBFC.Model.admin_login;
import com.project.NBFC.Repo.AdminRepo;
import com.project.NBFC.Services.AdminService;

@Service
public class AdminDao implements AdminService
{
	@Autowired
	AdminRepo ar;
	
	public admin_login checkBoth(String aemail,String epass)
	{
		return ar.findByAemailAndApass(aemail, epass);
	}

}
