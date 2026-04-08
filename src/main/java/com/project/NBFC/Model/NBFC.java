package com.project.NBFC.Model;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity
public class NBFC 
{
	@Id
	@GeneratedValue(strategy=GenerationType.AUTO)
	private int id;
	private double walletBalance;
	private double totalRepayments;
	private double totalDisbursed;
	private int totalLoans;
	private int totalUsers;
	
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public double getWalletBalance() {
		return walletBalance;
	}
	public void setWalletBalance(double walletBalance) {
		this.walletBalance = walletBalance;
	}
	public double getTotalRepayments() {
		return totalRepayments;
	}
	public void setTotalRepayments(double totalRepayments) {
		this.totalRepayments = totalRepayments;
	}
	public double getTotalDisbursed() {
		return totalDisbursed;
	}
	public void setTotalDisbursed(double totalDisbursed) {
		this.totalDisbursed = totalDisbursed;
	}
	public int getTotalLoans() {
		return totalLoans;
	}
	public void setTotalLoans(int totalLoans) {
		this.totalLoans = totalLoans;
	}
	public int getTotalUsers() {
		return totalUsers;
	}
	public void setTotalUsers(int totalUsers) {
		this.totalUsers = totalUsers;
	}
	
	
}
