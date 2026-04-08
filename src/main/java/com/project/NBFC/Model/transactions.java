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

@Entity
public class transactions 
{
	@Id
	@GeneratedValue(strategy=GenerationType.AUTO)
	private int tid;
	@OneToOne
	private Users sender;
	@OneToOne
	private Users receiver;
	public int getTid() {
		return tid;
	}
	public void setTid(int tid) {
		this.tid = tid; 
	}
	private double amount;
	@CreationTimestamp
	private LocalDateTime date;
	private String messages;
	
	
	public String getMessages() {
		return messages;
	}
	public void setMessages(String messages) {
		this.messages = messages;
	}
	public Users getSender() {
		return sender;
	}
	public void setSender(Users sender) {
		this.sender = sender;
	}
	public Users getReceiver() {
		return receiver;
	}
	public void setReceiver(Users receiver) {
		this.receiver = receiver;
	}
	public double getAmount() {
		return amount;
	}
	public void setAmount(double amount) {
		this.amount = amount;
	}
	public LocalDateTime getDate() {
		return date;
	}
	public String getFormatedDate() {
		SimpleDateFormat formatter = new SimpleDateFormat("dd MMM yyyy, hh:mm a"); 
		
		Date inp = Date.from(date.atZone(ZoneId.systemDefault()).toInstant());
		
		return formatter.format(inp);
	}
	public void setDate(LocalDateTime date) {
		this.date = date;
	}
	
	
}
