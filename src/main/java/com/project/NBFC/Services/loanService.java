package com.project.NBFC.Services;

import java.util.List;

import com.project.NBFC.Model.Loan;
import com.project.NBFC.Model.Users;

public interface loanService 
{
	public void saveloandata(Loan l1);
	
	public List<Loan> getAllLoans();
	
	public List<Loan> getinfoByUser(Users appliedUser);
	
	public Loan getbyid(int id);
	
	public List<Loan> getUpcomingEmi(int days);
	
	public List<Loan> getByEmi(int account_no);

	public List<Loan> getAllLoansByStatus(String string);
}
