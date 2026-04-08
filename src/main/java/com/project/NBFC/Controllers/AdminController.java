	package com.project.NBFC.Controllers;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.project.NBFC.Model.Guarantors;
import com.project.NBFC.Model.Loan;
import com.project.NBFC.Model.NBFC;
import com.project.NBFC.Model.Users;
import com.project.NBFC.Model.admin_login;
import com.project.NBFC.Model.transactions;
import com.project.NBFC.Services.AdminService;
import com.project.NBFC.Services.GuarantorService;
import com.project.NBFC.Services.NBFCService;
import com.project.NBFC.Services.TransactionService;
import com.project.NBFC.Services.UserService;
import com.project.NBFC.Services.loanService;

@Controller
public class AdminController 
{
	@Autowired
	AdminService as;
	
	@Autowired
	loanService ls;
	
	@Autowired
	UserService us;
	
	@Autowired
	NBFCService ns;
	
	@Autowired
	TransactionService ts;
	
	@Autowired
	GuarantorService gs;
	
	@Autowired
	ServletContext context; 
	
	
	@RequestMapping("/adminLogin")
	public String One()
	{
		return "adminLogin";
	}
	
	@PostMapping("/checkinfo")
	public String two(@RequestParam("aemail") String aemail,@RequestParam("apass") String apass,HttpSession s1,ModelMap model)
	{
		admin_login al=as.checkBoth(aemail, apass);
		if(al==null)
		{
			return "redirect:/adminLogin";
		}
		s1.setAttribute("temp", al.getAemail());
		
		NBFC n1 = ns.getbyid(1);
		model.addAttribute("nbfc",n1);
		
		List<Loan> l1 =ls.getAllLoans();
		model.addAttribute("loans",l1);
		
		List<Loan> pendingCol =ls.getUpcomingEmi(2);
		model.addAttribute("pending",pendingCol);
		
		model.addAttribute("tab","Dashboard");
		return "Admindashboard";
		
	}
	
	@RequestMapping("/Admindashboard")
	public String three(HttpServletRequest request)
	{
		HttpSession s1 = request.getSession(false);
		String x= (String) s1.getAttribute("temp");
		if(x==null)
		{
			return "redirect:/adminLogin";
		}
		return "Admindashboard";
	}
	
	@RequestMapping({"/Dashboard","/single-loans/Dashboard"})
	public String getTransaction(HttpServletRequest request,ModelMap model)
	{
		
        System.out.println("******************* " + System.getenv("twilio_auth"));
		HttpSession s1 = request.getSession(false);
		String x= (String) s1.getAttribute("temp");
		if(x==null)
		{
			return "redirect:/adminLogin";
		}
		
		//List<Users> u1 =us.getallusers();
		List<Loan> pendingCol =ls.getUpcomingEmi(2);
		model.addAttribute("pending",pendingCol);
		
		NBFC n1 = ns.getbyid(1);
		model.addAttribute("nbfc",n1);
		List<Loan> l1 =ls.getAllLoans();
		model.addAttribute("loans",l1);
		model.addAttribute("tab","Dashboard");
		return "Admindashboard";
	}
	
	@RequestMapping({"/Users","/single-loans/Users"})
	public String getAllUsers(HttpServletRequest request,ModelMap model)
	{
		HttpSession s1 = request.getSession(false);
		String x= (String) s1.getAttribute("temp");
		if(x==null)
		{
			return "redirect:/adminLogin";
		}
		
		List<Users> u1 =us.getallusers();
		model.addAttribute("users",u1);
		model.addAttribute("tab","Users");
		return "Admindashboard";
	}
	@RequestMapping({"/admin-loans","/single-loans/admin-loans"})
	public String getAllLoanInfo(HttpServletRequest request,ModelMap model) throws JsonProcessingException
	{
		HttpSession s1 = request.getSession(false);
		String x= (String) s1.getAttribute("temp");
		if(x==null)
		{
			return "redirect:/adminLogin";
		}
		
		List<Loan> l1 =ls.getAllLoans();
		model.addAttribute("loans",l1);
		
		List<Loan> pending =ls.getAllLoansByStatus("Pending");
		List<Loan> approve =ls.getAllLoansByStatus("Approved");
		List<Loan> disbursed =ls.getAllLoansByStatus("Disbursed");
		List<Loan> active =ls.getAllLoansByStatus("Active");
		List<Loan> rejected =ls.getAllLoansByStatus("Rejected");
		List<Loan> closed =ls.getAllLoansByStatus("Closed");
		
		ArrayList<Integer> a = new ArrayList<Integer>();
		a.add(pending.size());
		a.add(approve.size());
		a.add(disbursed.size());
		a.add(active.size());
		a.add(rejected.size());
		a.add(closed.size());
		
		ObjectMapper om = new ObjectMapper();
		String json = om.writeValueAsString(a);
		model.addAttribute("count_array",json);
		
		model.addAttribute("tab","admin-loans");
		return "Admindashboard";
	}
	
	@RequestMapping({"/newLoan","/single-loans/newLoan"})
	public String apply_new_Loan(HttpServletRequest request,ModelMap model)
	{
		HttpSession s1 = request.getSession(false);
		String x= (String) s1.getAttribute("temp");
		if(x==null)
		{
			return "redirect:/adminLogin";
		}
		
		model.addAttribute("tab","New-Loan");
		return "Admindashboard";
	}
	
	@RequestMapping({"/emi-calc","/single-loans/emi-calc"})
	public String calculate_emi(HttpServletRequest request,ModelMap model)
	{
		HttpSession s1 = request.getSession(false);
		String x= (String) s1.getAttribute("temp");
		if(x==null)
		{
			return "redirect:/adminLogin";
		}
		
		model.addAttribute("tab","emi-calc");
		return "Admindashboard";
	}
	
	@RequestMapping({"/fund","/single-loans/fund"})
	public String all_transaction_fund(HttpServletRequest request,ModelMap model)
	{
		HttpSession s1 = request.getSession(false);
		String x= (String) s1.getAttribute("temp");
		if(x==null)
		{
			return "redirect:/adminLogin";
		}
		model.addAttribute("tab","fund");
		NBFC n1 = ns.getbyid(1);
		Users u = us.getUserByAccountNo(211001000);
		model.addAttribute("nbfc",n1);
		List<transactions> tt = ts.getAllTransactions(u,u);
		model.addAttribute("transaction",tt);
		return "Admindashboard";
	}
	
	@GetMapping("/single-loans/{lid}")
	public String single_loan(@PathVariable int lid,HttpServletRequest request,ModelMap model)
	{
		HttpSession s1 = request.getSession(false);
		String x= (String) s1.getAttribute("temp");
		if(x==null)
		{
			return "redirect:/adminLogin";
		}
		//System.out.println(lid);
		Loan l1 = ls.getbyid(lid);
		model.addAttribute("loans",l1);
		model.addAttribute("tab","single-loans");
		return "Admindashboard";
	}
	
	
	@RequestMapping({"/adduser","/single-loans/adduser"})
	public String add_user(HttpServletRequest request,ModelMap model)
	{
		HttpSession s1 = request.getSession(false);
		String x= (String) s1.getAttribute("temp");
		if(x==null)
		{
			return "redirect:/adminLogin";
		}
		model.addAttribute("tab","AddUser");
		return "Admindashboard";
	}
	
	@PostMapping({"/addAdminUser","/single-loans/addAdminUser"})
	public String add_admin_user(@ModelAttribute("u1") Users u1,ModelMap model)
	{
		String password="nbfc@default";
		String cpassword="nbfc@default";
		
		u1.setPassword(password);
		u1.setCpassword(cpassword);
		
		us.savedata(u1);
		
		NBFC n1 = ns.getbyid(1);
		n1.setTotalUsers(n1.getTotalUsers()+1);
		ns.saveNBFCinfo(n1);
		
		model.addAttribute("tab","Users");
		return "Admindashboard";
	}
	
	
	// Save Loan 
	
	@PostMapping({"/adminSaveLoan", "/single-loans/adminSaveLoan"})
	public String saveLoanInfo(HttpServletRequest request,@ModelAttribute("l1") Loan l1,
			@RequestParam("user-account-no") Integer userAccountNo,
			@RequestParam("profile-photo") MultipartFile userProfilePhoto, 
			@RequestParam("adhaar-photo") MultipartFile userAdhaarPhoto, 
			@RequestParam("pan-photo") MultipartFile userPanPhoto, 
			@RequestParam("guarantor_1") int g1_id,
			@RequestParam("guarantor_2") int g2_id,
			@RequestParam("guarantor-1-adhaar-photo") MultipartFile  g1_adhaar_photo, 
			@RequestParam("guarantor-1-pan-photo") MultipartFile g1_pan_photo,
			@RequestParam("guarantor-2-adhaar-photo") MultipartFile g2_adhaar_photo,
			@RequestParam("guarantor-2-pan-photo") MultipartFile g2_pan_photo) throws Exception
	{
		

		Users u = us.getUserByAccountNo(userAccountNo);
		
		
		// User Files Upload if uploaded
		
		int accountNo = u.getAccount_no();
		String Photo_name = "UserProfile.jpg";
		String Adhaar_name = "UserAdhaar.jpg";
		String Pan_name = "UserPan.jpg";
		
//		String relPath = "C:\\\\Users\\\\punam sonawane\\\\Final_Project_workspace\\\\NBFC\\\\src\\\\main\\\\resources\\\\static\\\\documents";
		String relPath = System.getProperty("user.dir") + File.separator + "documents";
		
		File temp = new File(relPath);
		
		if(!temp.exists())
		{
			temp.mkdir();
		}
		
		File file = new File(relPath + File.separator + Integer.toString(accountNo));
		
		if(!file.exists())
		{
			file.mkdir();
		}
		
		if(!userProfilePhoto.getOriginalFilename().equals("")) {
			u.setProfile_photo(Photo_name);
			
			BufferedOutputStream f1 = new BufferedOutputStream(new FileOutputStream(file+"/"+Photo_name));
			byte[] b = userProfilePhoto.getBytes();
			f1.write(b);
			f1.close();
			
		}
		
		if(!userAdhaarPhoto.getOriginalFilename().equals("")) {
			u.setAdhaar_photo(Adhaar_name);
			
			BufferedOutputStream f2 = new BufferedOutputStream(new FileOutputStream(file+"/"+Adhaar_name));
			byte[] b1 = userAdhaarPhoto.getBytes();
			f2.write(b1);
			f2.close();
			
		}

		if(!userPanPhoto.getOriginalFilename().equals("")) {
			u.setPan_photo(Pan_name);
			
			BufferedOutputStream f3 = new BufferedOutputStream(new FileOutputStream(file+"/"+Pan_name));
			byte[] b2 = userPanPhoto.getBytes();
			f3.write(b2);
			f3.close();
		}
		
		us.savedata(u);
		
		// Handling Guarantors 
		
		Users g1_user = us.getUserByAccountNo(g1_id);
		Users g2_user = us.getUserByAccountNo(g2_id);
		
		Guarantors guarantor1 = new Guarantors();
		Guarantors guarantor2 = new Guarantors();
		
		guarantor1.setParentUser(g1_user);
		guarantor2.setParentUser(g2_user);
		
		// Guarantor 1 Docs Saving

		String g1_adhaar = "g_adhaar.jpg";
		String g1_pan = "g_pan.jpg";
		
		
		File g1_file = new File(relPath + File.separator + Integer.toString(accountNo) + File.separator + "G" + Integer.toString(g1_id));
		if(!g1_file.exists())
		{
			g1_file.mkdir();
		}
		
		
		if(!g1_adhaar_photo.getOriginalFilename().equals("")) {
			guarantor1.setAdhaar(g1_adhaar);
			
			BufferedOutputStream f = new BufferedOutputStream(new FileOutputStream(g1_file+"/"+ g1_adhaar));
			byte[] b = g1_adhaar_photo.getBytes();
			f.write(b);
			f.close();
		}

		if(!g1_pan_photo.getOriginalFilename().equals("")) {
			guarantor1.setPan(g1_pan);
			
			BufferedOutputStream f = new BufferedOutputStream(new FileOutputStream(g1_file+"/"+ g1_pan));
			byte[] b = g1_pan_photo.getBytes();
			f.write(b);
			f.close();
		}
		
		// Guarantor 2 Docs Saving
		
		String g2_adhaar = "g_adhaar.jpg";
		String g2_pan = "g_pan.jpg";
		
		
		File g2_file = new File(relPath + File.separator + Integer.toString(accountNo) + File.separator + "G" + Integer.toString(g2_id));
		if(!g2_file.exists())
		{
			g2_file.mkdir();
		}
		
		
		if(!g2_adhaar_photo.getOriginalFilename().equals("")) {
			guarantor2.setAdhaar(g2_adhaar);
			
			BufferedOutputStream f = new BufferedOutputStream(new FileOutputStream(g2_file+"/"+ g2_adhaar));
			byte[] b = g2_adhaar_photo.getBytes();
			f.write(b);
			f.close();
		}
		
		if(!g2_pan_photo.getOriginalFilename().equals("")) {
			guarantor2.setPan(g2_pan);
			
			BufferedOutputStream f = new BufferedOutputStream(new FileOutputStream(g2_file+"/"+ g2_pan));
			byte[] b = g2_pan_photo.getBytes();
			f.write(b);
			f.close();
		}
		
		guarantor1 = gs.saveGuarantor(guarantor1);
		guarantor2 = gs.saveGuarantor(guarantor2);
		
		l1.setAppliedUser(u);
		l1.setGuarantor_1(guarantor1);
		l1.setGuarantor_2(guarantor2);
		//System.out.println(l1.getInterestRate());
		ls.saveloandata(l1);
		
		NBFC n1 = ns.getbyid(1);
		n1.setTotalLoans(n1.getTotalLoans()+1);
		ns.saveNBFCinfo(n1);
		
		return "redirect:/admin-loans";
	}
	
	
	
	
	
	
	
	@RequestMapping({"/logout","/single-loans/logout"})
	public String four(HttpServletRequest request)
	{
		HttpSession s1 = request.getSession();
		s1.invalidate();
		return "redirect:/adminLogin";
	}
}
