package com.project.NBFC.Repo;

import java.util.Date;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.project.NBFC.Model.Loan;
import com.project.NBFC.Model.Users;

@Repository
public interface loanRepo extends JpaRepository<Loan,Integer>
{
	//public Loan findByFullname(String fullname);
	
	//public Loan findByEmail(String email);
	public List<Loan> findByAppliedUser(Users appliedUser);
	
	public List<Loan> findByStatus(String status);
	
	@Query(value = "select * from loan where applied_user_account_no = ?1 and (status='Disbursed' or status='Active') order by next_emi_date",nativeQuery = true)
	public List<Loan> findByAppliedUserAccountNo(int account_no);

	@Query(value = "select * from loan where (status='Active' or status='Disbursed') and next_emi_date < :due order by next_emi_date", nativeQuery = true)
	public List<Loan> getUpcomingEmi(@Param("due") Date d);
}


