package com.project.NBFC.Model;

public class Repayments 
{
	private int lid;
	private int account_no;
	private double late_fee;
	
	public int getAccount_no() {
		return account_no;
	}
	public void setAccount_no(int account_no) {
		this.account_no = account_no;
	}
	public int getLid() {
		return lid;
	}
	public void setLid(int lid) {
		this.lid = lid;
	}
	public double getLate_fee() {
		return late_fee;
	}
	public void setLate_fee(double late_fee) {
		this.late_fee = late_fee;
	}
	
}
 