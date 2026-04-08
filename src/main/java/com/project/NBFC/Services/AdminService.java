package com.project.NBFC.Services;

import com.project.NBFC.Model.admin_login;

public interface AdminService 
{
	public admin_login checkBoth(String aemail,String apass);
}
