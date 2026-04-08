package com.project.NBFC.Dao;

import java.util.Calendar;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.project.NBFC.Model.Loan;
import com.project.NBFC.Model.Users;
import com.project.NBFC.Repo.loanRepo;
import com.project.NBFC.Services.loanService;

@Service
public class LoanDao implements loanService
{
	@Autowired
	loanRepo lr;

	@Override
	public void saveloandata(Loan l1) 
	{
		lr.save(l1);
	}

	@Override
	public List<Loan> getAllLoans() {
		return lr.findAll();
	}
	@Override
	public List<Loan> getinfoByUser(Users appliedUser) {
		
		return lr.findByAppliedUser(appliedUser);
	}

	@Override
	public Loan getbyid(int id) {
		return lr.getById(id);
	}

	@Override
	public List<Loan> getByEmi(int account_no) {
		return lr.findByAppliedUserAccountNo(account_no);
	}

	@Override
	public List<Loan> getUpcomingEmi(int days) {
		// TODO Auto-generated method stub
		 Calendar calendar = Calendar.getInstance();
			
		 calendar.add(Calendar.DATE, days);
		
		return lr.getUpcomingEmi(calendar.getTime());
	}

	@Override
	public List<Loan> getAllLoansByStatus(String string) {
		// TODO Auto-generated method stub
		return lr.findByStatus(string);
	}

}
