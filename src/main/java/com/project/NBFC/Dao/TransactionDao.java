package com.project.NBFC.Dao;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.project.NBFC.Model.Users;
import com.project.NBFC.Model.transactions;
import com.project.NBFC.Repo.TransactionRepo;
import com.project.NBFC.Services.TransactionService;

@Service
public class TransactionDao implements TransactionService
{
	@Autowired
	TransactionRepo tr;
	
	@Override
	public void savetransaction(transactions t1) {
		tr.save(t1);
	}

	@Override
	public List<transactions> getAllTransactions(Users sender,Users receiver) {
		
		return tr.findBySenderOrReceiverOrderByDateDesc(sender,receiver);
	}
	
	@Override
	public Double getCollectionsForDay(Date date) {
		
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
		
		return tr.getCollectionsForDay(formatter.format(date));
	}

	@Override
	public List<transactions> getallTransaction() {
		
		return tr.findAll();
	}
}
