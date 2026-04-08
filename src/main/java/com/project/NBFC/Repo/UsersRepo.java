package com.project.NBFC.Repo;

import java.util.Collection;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.project.NBFC.Model.Users;

@Repository
public interface UsersRepo extends JpaRepository<Users,Integer>
{
	
	public Users findByEmail(String email);
	public Users findByEmailAndPassword(String email,String password);
	
	public Users findByFullnameLike(String fullname);
	
	@Query(value="select * from Users where fullname ilike ?1 or Cast(account_no as character varying(255)) ilike ?2 and account_no != 211001000",nativeQuery = true)
	List<Users> findByFullnameOrAccount_no(String fullname,String account_no);
	
	//public Users findByAccount_no(int account_no);
}
