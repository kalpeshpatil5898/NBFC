package com.project.NBFC.Model;

import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.OneToOne;

import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.GenericGenerator;

@Entity 
public class Loan 
{
	@Id
	@GenericGenerator(name="loan_seq",strategy = "increment")
	@GeneratedValue(generator="loan_seq")
	private int lid;
	@OneToOne
	private Users appliedUser;
	
	@OneToOne
	private Guarantors guarantor_1;
	@OneToOne
	private Guarantors guarantor_2;
	
	@CreationTimestamp
	private LocalDateTime date;
	
	private String loanType;
	
	private int loanTenure;
	
	private double loanAmount;
	
	private double interestRate=36;
	
	private String status = "Pending";
	
	private double monthlyEmi;
	
	private double paidAmount = 0;
	
	public double getPaidAmount() {
		return paidAmount;
	}

	public void setPaidAmount(double paidAmount) {
		this.paidAmount = paidAmount;
	}

	//@CreationTimestamp
	private Date nextEmiDate;
	
	private double totalInterest;
	
	public Date getNextEmiDate() {
		return nextEmiDate;
	}

	public void setNextEmiDate(Date nextEmiDate) {
		this.nextEmiDate = nextEmiDate;
	}

	private double totalAmount;

	
	public double getMonthlyEmi() {
		return monthlyEmi;
	}

	public void setMonthlyEmi(double monthlyEmi) {
		this.monthlyEmi = monthlyEmi;
	}

	public double getTotalInterest() {
		return totalInterest;
	}

	public void setTotalInterest(double totalInterest) {
		this.totalInterest = totalInterest;
	}

	public double getTotalAmount() {
		return totalAmount;
	}

	public void setTotalAmount(double totalAmount) {
		this.totalAmount = totalAmount;
	}

	public Guarantors getGuarantor_1() {
		return guarantor_1;
	}

	public void setGuarantor_1(Guarantors guarantor_1) {
		this.guarantor_1 = guarantor_1;
	}

	public Guarantors getGuarantor_2() {
		return guarantor_2;
	}

	public void setGuarantor_2(Guarantors guarantor_2) {
		this.guarantor_2 = guarantor_2;
	}


	public int getLid() {
		return lid;
	}

	public void setLid(int lid) {
		this.lid = lid;
	}

	

	public Users getAppliedUser() {
		return appliedUser;
	}

	public void setAppliedUser(Users appliedUser) {
		this.appliedUser = appliedUser;
	}

	public LocalDateTime getDate() {
		return date;
	}

	public void setDate(LocalDateTime date) {
		this.date = date;
	}
	public String getFormatedDate() {
		SimpleDateFormat formatter = new SimpleDateFormat("dd MMM yyyy"); 
		
		return formatter.format(nextEmiDate);
	}
	
	public boolean isDued() {
		Date today = new Date();
		
		return nextEmiDate.before(today);
	}
	
	public String getLoanType() {
		return loanType;
	}

	public void setLoanType(String loanType) {
		this.loanType = loanType;
	}

	public int getLoanTenure() {
		return loanTenure;
	}

	public void setLoanTenure(int loanTenure) {
		this.loanTenure = loanTenure;
	}

	
	public double getLoanAmount() {
		return loanAmount;
	}

	public void setLoanAmount(double loanAmount) {
		this.loanAmount = loanAmount;
	}

	public double getInterestRate() {
		return interestRate;
	}

	public void setInterestRate(double interestRate) {
		this.interestRate = interestRate;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	
	
}
