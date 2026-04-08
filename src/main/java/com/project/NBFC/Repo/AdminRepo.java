package com.project.NBFC.Repo;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.project.NBFC.Model.admin_login;

@Repository
public interface AdminRepo extends JpaRepository<admin_login,Integer>
{
	public admin_login findByAemailAndApass(String aemail,String apass);
}
