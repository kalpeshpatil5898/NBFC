package com.project.NBFC.Repo;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.project.NBFC.Model.NBFC;
import com.project.NBFC.Model.Users;
import com.project.NBFC.Model.transactions;

@Repository
public interface TransactionRepo extends JpaRepository<transactions,Integer>
{
	
	public List<transactions> findBySenderOrReceiverOrderByDateDesc(Users sender,Users receiver);
	
	public List<transactions> findBySenderOrReceiver(NBFC sender,NBFC receiver);
	
	@Query(value="select sum(amount) from transactions where receiver_account_no = 211001000 and to_char(date, 'YYYY-MM-dd') = ?1", nativeQuery = true)
	public Double getCollectionsForDay(String date);
}
