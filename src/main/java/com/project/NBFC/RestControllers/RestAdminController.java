package com.project.NBFC.RestControllers;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.InputStreamResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.Errors;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.project.NBFC.Converter.TransactionsConverter;
import com.project.NBFC.Model.Emi;
import com.project.NBFC.Model.Loan;
import com.project.NBFC.Model.NBFC;
import com.project.NBFC.Model.ResponseChartData;
import com.project.NBFC.Model.SuccessResponse;
import com.project.NBFC.Model.Users;
import com.project.NBFC.Model.chartTypeSearch;
import com.project.NBFC.Model.searchLoan;
import com.project.NBFC.Model.transactions;
import com.project.NBFC.Services.NBFCService;
import com.project.NBFC.Services.TransactionService;
import com.project.NBFC.Services.UserService;
import com.project.NBFC.Services.loanService;
import com.twilio.Twilio;
import com.twilio.rest.api.v2010.account.Message;
import com.twilio.type.PhoneNumber;


@RestController
@RequestMapping("/api/admin")
public class RestAdminController 
{
	@Autowired
	loanService ls;
	
	@Autowired
	UserService us;
	
	@Autowired
	NBFCService ns;
	
	@Autowired
	TransactionService ts;
	
	
	@RequestMapping("/download_pdf")
	public ResponseEntity<InputStreamResource> downloadMethod() throws IOException {
		
		Users admin = us.getUserByAccountNo(211001000);
		
		NBFC nbfc = ns.getbyid(1);
		
		ArrayList<transactions> transactions = (ArrayList<transactions>) ts.getAllTransactions(admin, admin);
		
		String html = TransactionsConverter.processHtml("admin", transactions, admin, nbfc);
		
		byte[] gen_pdf = TransactionsConverter.xhtmlToPdf(TransactionsConverter.htmlToXhtml(html));
		
		ByteArrayInputStream bi = new ByteArrayInputStream(gen_pdf);
		
		Date currentTime = new Date();
		
	    SimpleDateFormat formatter = new SimpleDateFormat("E_dd_MMM_yyyy HH.mm.ss");  
	    String strDate= formatter.format(currentTime);  
	    
		return ResponseEntity.status(HttpStatus.OK)
				.contentType(MediaType.APPLICATION_PDF)
				.header(HttpHeaders.CONTENT_DISPOSITION, "inline;filename=Transaction_" + strDate + ".pdf")
				.body(new InputStreamResource(bi));
	}
	
	

	@SuppressWarnings("deprecation")
	@PostMapping("/changeStatus")
	public ResponseEntity<?> change_status(@RequestBody searchLoan search)
	{
		Loan l1 = ls.getbyid(search.getLoanid());
		
		l1.setStatus(search.getStatus());
		
		if(l1.getStatus().equals("Disbursed"))
		{
			 Users u = us.getUserByAccountNo(l1.getAppliedUser().getAccount_no());
			 u.setBalance(u.getBalance()+ l1.getLoanAmount());
			 us.savedata(u);
			 
			 NBFC n = ns.getbyid(1);
			 n.setWalletBalance(n.getWalletBalance()- l1.getLoanAmount());
			 n.setTotalDisbursed(n.getTotalDisbursed() + l1.getLoanAmount());
			 ns.saveNBFCinfo(n);
			 
			 Users nbfcUsers = us.getUserByAccountNo(211001000);
			 transactions t1 = new transactions();
			 t1.setAmount(l1.getLoanAmount());
			 t1.setSender(nbfcUsers);
			 t1.setReceiver(u);
			 t1.setMessages("Loan Credited");
			 ts.savetransaction(t1);
			 
			 Date emiDate = new Date();
			 
			 Calendar calendar = Calendar.getInstance();
				
			 calendar.setTime(emiDate);
			
			 calendar.add(Calendar.MONTH, 1);
			
			 l1.setNextEmiDate(calendar.getTime());
			 
		}
		
		ls.saveloandata(l1);
		
		return ResponseEntity.ok(search);
	}
	
	@PostMapping("/getCollectionsData")
	public ResponseEntity<?> getCollectionDataViaAjax(@RequestBody chartTypeSearch search, Errors errros){
		
		ResponseChartData r = new ResponseChartData();
		
		
		Calendar calendar  = Calendar.getInstance();
		calendar.add(Calendar.DATE, 0);
		
		
		String type = search.getType();
		
		int no_of_days = 0;
		SimpleDateFormat formatter;
		
		if(type.equals("weekly")) {
			no_of_days = 7;
			
			formatter = new SimpleDateFormat("EEEE, dd MMM");
		}else {
			no_of_days = 30;
			
			formatter = new SimpleDateFormat("dd MMM yyyy");
		}
		
		
		ArrayList<Double> values = new ArrayList<Double>();
		ArrayList<String> labels = new ArrayList<String>();
		
		
		for(int i = 0; i < no_of_days; i++) {
			Date currentDate = new Date(calendar.getTimeInMillis());
			
			Double amount = ts.getCollectionsForDay(currentDate);
			
			if(amount == null) {
				values.add(0.0);
			}else {
				values.add(amount);
			}
			
			labels.add(formatter.format(currentDate));
			
			calendar.add(Calendar.DATE, -1);
			
		}
		
		Collections.reverse(labels);
		Collections.reverse(values);
		
		r.setLabels(labels);
		r.setValues(values);	
		
		return ResponseEntity.ok(r);
	}
	
	
	@GetMapping("/addMoney/{amount}")
	public ResponseEntity<?> addMoney(@PathVariable(name="amount") double amount){
		NBFC n = ns.getbyid(1);
		
		n.setWalletBalance(n.getWalletBalance() + amount);
		
		ns.saveNBFCinfo(n);
		
		return ResponseEntity.ok(n);
	}
	
	
	@GetMapping("/sendAlerts")
	public ResponseEntity<?> sendSms(){
		
		List<Loan> pendingEMIs =ls.getUpcomingEmi(2);
		
        Twilio.init(System.getenv("TWILIO_SID"), System.getenv("TWILIO_AUTH"));
        
        
        SuccessResponse res = new SuccessResponse();

		for(Loan loan: pendingEMIs) {
			var senderContact = loan.getAppliedUser().getContact();	
			
			double emi = loan.getMonthlyEmi();
			
			String msg = "";
			
			Date today = new Date();
			
			if(loan.getNextEmiDate().before(today)) {
				msg += "Your EMI of Rs." + emi + ".00💵 is due as on " + loan.getFormatedDate();
			}
			else {
				msg += "Your EMI of Rs." + emi + ".00💵 will be due on " + loan.getFormatedDate();
			}
			
			msg += ". Please pay it by logging into NBFC Plus portal.";
			
			// Normal Msg
	        Message.creator(new PhoneNumber("+91" + senderContact), new PhoneNumber("+13236885893"), msg).create();
			
		}
		
		res.setMsg("Success");
		
		return ResponseEntity.ok(res);
//		return ResponseEntity.ok(null);
	}
	
	

}
