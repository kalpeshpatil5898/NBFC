package com.project.NBFC.Services;

import java.util.Date;
import java.util.List;

import com.project.NBFC.Model.Users;
import com.project.NBFC.Model.transactions;

public interface TransactionService 
{
	public void savetransaction(transactions t1);
	
	public List<transactions> getAllTransactions(Users sender,Users receiver);
	
	public Double getCollectionsForDay(Date date);
	
	public List<transactions> getallTransaction();
	
	
}
