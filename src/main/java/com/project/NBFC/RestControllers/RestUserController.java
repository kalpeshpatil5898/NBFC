package com.project.NBFC.RestControllers;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

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
import com.project.NBFC.Model.Repayments;
import com.project.NBFC.Model.ResponseUsers;
import com.project.NBFC.Model.SearchInput;
import com.project.NBFC.Model.Users;
import com.project.NBFC.Model.transactions;
import com.project.NBFC.Repo.UsersRepo;
import com.project.NBFC.Services.NBFCService;
import com.project.NBFC.Services.TransactionService;
import com.project.NBFC.Services.UserService;
import com.project.NBFC.Services.loanService;

@RestController
public class RestUserController 
{
	@Autowired
	UserService us;
	
	@Autowired
	loanService ls;
	
	@Autowired
	NBFCService ns;
	
	@Autowired
	TransactionService ts;
	
	@PostMapping("/api/getUsers")
	public ResponseEntity<?> getSearchResultViaAjax(@RequestBody SearchInput search,Errors errors)
	{
		ResponseUsers r = new ResponseUsers();
//		System.out.println(search.getSearchString()); 
		
		if(errors.hasErrors())
		{
			r.setMsg(errors.getAllErrors()
					.stream().map(x -> x.getDefaultMessage())
					.collect(Collectors.joining(",")));
			return ResponseEntity.badRequest().body(r);
		}
		
		List<Users> users = us.getByFullName(search.getSearchString(),search.getSearchString());
		if(users.isEmpty())
		{
			r.setMsg("No user found");
		}
		else
		{
			r.setMsg("success");
		}
		r.setUsers(users);
		return ResponseEntity.ok(r);
	}
	
	
	
	@RequestMapping("/api/download_pdf/{userAccNo}")
	public ResponseEntity<InputStreamResource> downloadMethod(@PathVariable int userAccNo) throws IOException {
		
		Users user = us.getUserByAccountNo(userAccNo);
		
		ArrayList<transactions> transactions = (ArrayList<transactions>) ts.getAllTransactions(user, user);
		
		String html = TransactionsConverter.processHtml("user", transactions, user, null);
		
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
	
	@PostMapping("/api/repayment")
	public ResponseEntity<?> getRepayments(@RequestBody Repayments rp)
	{
		Users u1 = us.getUserByAccountNo(rp.getAccount_no());
		
		Loan l1 = ls.getbyid(rp.getLid());
		
		NBFC n = ns.getbyid(1);
		
		double lateFee = rp.getLate_fee();
		
		Date d = new Date();
		
		double amount=0;
		
		if(l1.getNextEmiDate().equals(d) || l1.getNextEmiDate().before(d))
		{
			n.setTotalRepayments(n.getTotalRepayments() + l1.getMonthlyEmi());
			u1.setBalance(u1.getBalance() - l1.getMonthlyEmi());
			amount = amount + l1.getMonthlyEmi();
			
		}
		else
		{
			n.setTotalRepayments(n.getTotalRepayments() + l1.getMonthlyEmi()+ lateFee );
			u1.setBalance(u1.getBalance() - l1.getMonthlyEmi()- lateFee);
			amount = amount + l1.getMonthlyEmi() + lateFee;
		}
		
		l1.setPaidAmount(l1.getPaidAmount()+ l1.getMonthlyEmi());
		
		if(l1.getPaidAmount() == l1.getTotalAmount()) {
			l1.setStatus("Closed");
		}
		else {
			Calendar calendar = Calendar.getInstance();
			
			calendar.setTime(l1.getNextEmiDate());
			
			calendar.add(Calendar.MONTH, 1);
			
			l1.setNextEmiDate(calendar.getTime());
			l1.setStatus("Active");
		}
		
		us.savedata(u1);
		
		ls.saveloandata(l1);
		
		ns.saveNBFCinfo(n);
		
		Users nbfcUsers = us.getUserByAccountNo(211001000);
		 transactions t1 = new transactions();
		 t1.setAmount(amount);
		 t1.setSender(u1);
		 t1.setReceiver(nbfcUsers);
		 t1.setMessages("Loan Installment");
		 ts.savetransaction(t1);
		return ResponseEntity.ok(l1);
	}
	
	
	@PostMapping("/api/getEmis")
	public List<Loan> getByEmiDate(@RequestBody Emi em)
	{
		List<Loan> l1 = ls.getByEmi(em.getAccount_no());
		 
		return l1;
	}
	
	
	
	
	
}
