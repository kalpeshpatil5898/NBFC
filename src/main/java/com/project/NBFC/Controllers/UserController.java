package com.project.NBFC.Controllers;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.project.NBFC.Model.Guarantors;
import com.project.NBFC.Model.Loan;
import com.project.NBFC.Model.NBFC;
import com.project.NBFC.Model.Users;
import com.project.NBFC.Model.transactions;
import com.project.NBFC.Repo.TransactionRepo;
import com.project.NBFC.Services.GuarantorService;
import com.project.NBFC.Services.NBFCService;
import com.project.NBFC.Services.TransactionService;
import com.project.NBFC.Services.UserService;
import com.project.NBFC.Services.loanService;



@Controller
public class UserController 
{
	@Autowired
	UserService us;
	
	@Autowired
	TransactionService ts;
	
	@Autowired
	loanService ls;
	
	@Autowired
	GuarantorService gs;
	
	@Autowired
	NBFCService ns;
	
	//Mapping for Registration
	@RequestMapping("/")
	public String one()
	{
		return "UserRegister";
	}
	
	//Validation for Registration
	@PostMapping("/checkUser")
	public String two(@RequestParam("email") String email,@ModelAttribute("u1") Users u1)
	{
		Users u = us.checkdata(email);
		if(u==null)
		{
			if(u1.getPassword().equals(u1.getCpassword()))
			{
				us.savedata(u1);
				NBFC n1 = ns.getbyid(1);
				n1.setTotalUsers(n1.getTotalUsers()+1);
				ns.saveNBFCinfo(n1);
				return "redirect:/UserLogin";
			}
		}
		return "UserRegister";
	}
	
	//Mapping for Login
	@RequestMapping("/UserLogin")
	public String three()
	{
		return "UserLogin";
	}
	
	//Validation for Login
	@PostMapping("/checkEmailPass")
	public String four(@RequestParam("email") String email,@RequestParam("password") String password,HttpSession s1,ModelMap model)
	{
		Users u = us.checkBoth(email,password);
		if(u==null)
		{
			return "redirect:/UserLogin";
		}
		s1.setAttribute("temp",u.getEmail());
		//Users u1 = us.checkdata(x);
		List<transactions> t = ts.getAllTransactions(u,u);
		model.addAttribute("transaction", t);
		
		model.addAttribute("user", u);
		
		model.addAttribute("tab","home");
		
		return "Userdashboard";
	}
	
	//Mapping for Dashboard
	@RequestMapping("/Userdashboard")
	public String five(HttpServletRequest request)
	{
		HttpSession s1 = request.getSession(false);
		String x= (String) s1.getAttribute("temp");
		System.out.println(x);
		if(x==null)
		{
			return "redirect:/UserLogin";
		}
		return "Userdashboard";
	}
	
	//Mapping for side bar in Dashboard(Home)
	@RequestMapping("/home")
	public String seven(HttpServletRequest request,ModelMap model)
	{
		HttpSession s1 = request.getSession(false);
		String x= (String) s1.getAttribute("temp");
		
		if(x==null)
		{
			return "redirect:/UserLogin";
		}
		//Users u = us.checkBoth(email,password);
		Users u1 = us.checkdata(x);
		List<transactions> t = ts.getAllTransactions(u1,u1);
		model.addAttribute("transaction", t);
		model.addAttribute("user", u1);
		
		model.addAttribute("tab","home");
		return "Userdashboard";
	}
	
	//Mapping for transaction from
	@RequestMapping("/sendMoney")
	public String transaction(ModelMap model,HttpServletRequest request)
	{

		HttpSession s1 = request.getSession(false);
		String x= (String) s1.getAttribute("temp");
		
		if(x==null)
		{
			return "redirect:/UserLogin";
		}
		Users u1 = us.checkdata(x);
		model.addAttribute("user", u1);
		model.addAttribute("tab","UserTransferMoney");
		return "Userdashboard";
	}
	
	//After Transaction
	@PostMapping("/transaction")
	public String saveTransaction(@ModelAttribute("t1") transactions t1,HttpServletRequest request,ModelMap model)
	{
		ts.savetransaction(t1);
		
		HttpSession s1 = request.getSession(false);
		String x= (String) s1.getAttribute("temp");
		if(x==null)
		{
			return "redirect:/UserLogin";
		}
		
		Users u1 = us.checkdata(x);
		Users u2 = us.checkdata(t1.getReceiver().getEmail());
		
		u2.setBalance(t1.getReceiver().getBalance() + t1.getAmount());
		
		u1.setBalance(t1.getSender().getBalance()-t1.getAmount());
		
		//u1.setBalance(u1.getBalance()-t1.getAmount());
		//Users u1 = us.checkdata(x);
		us.savedata(u1);
		us.savedata(u2);
		List<transactions> t = ts.getAllTransactions(t1.getSender(),t1.getSender());
		model.addAttribute("transaction", t);
		model.addAttribute("user", u1);
		model.addAttribute("tab","home");
		return "Userdashboard";
	}
	
	//Mapping for Loan Application
	@RequestMapping("/applyLoan")
	public String LoanApplication(ModelMap model,HttpServletRequest request)
	{
		HttpSession s1 = request.getSession(false);
		String x= (String) s1.getAttribute("temp");
		
		if(x==null)
		{
			return "redirect:/UserLogin";
		}
		
		Users u = us.checkdata(x);
		model.addAttribute("user", u);
		model.addAttribute("tab","UserLoan");
		return "Userdashboard";
	}
	
	//Mapping for side bar in Dashboard(Loans)
	@RequestMapping("/loans")
	public String usersLoans(HttpServletRequest request,ModelMap model)
	{
		HttpSession s1 = request.getSession(false);
		String x= (String) s1.getAttribute("temp");
		if(x==null)
		{
			return "redirect:/UserLogin";
		}
		model.addAttribute("tab","loans");
		Users u1 = us.checkdata(x);
		List<Loan> loanuser = ls.getinfoByUser(u1);
		model.addAttribute("loan",loanuser);
		return "Userdashboard";
	}
	
	//Mapping for Loan Application 
	@RequestMapping("/application")
	public String Loanapplication(HttpServletRequest request,ModelMap model)
	{
		HttpSession s1 = request.getSession(false);
		String x= (String) s1.getAttribute("temp");
		
		if(x==null)
		{
			return "redirect:/UserLogin";
		}
		Users u1 = us.checkdata(x);
		model.addAttribute("user",u1);
		return "LoanApplication";
	}
	
	//Mapping for save all Loans
	@PostMapping("/saveloan")
	public String saveLoanInfo(HttpServletRequest request,@ModelAttribute("l1") Loan l1,
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
		
		HttpSession s1 = request.getSession(false);
		String x= (String) s1.getAttribute("temp");
		
		if(x==null)
		{
			return "redirect:/UserLogin";
		}
		Users u = us.checkdata(x);
		
		// User Files Upload if uploaded
		
		int accountNo = u.getAccount_no();
		String Photo_name = "UserProfile.jpg";
		String Adhaar_name = "UserAdhaar.jpg";
		String Pan_name = "UserPan.jpg";
		
		
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
		
		return "redirect:/loans";
	}
	
	@RequestMapping("/profile")
	public String userFrofile(HttpServletRequest request,ModelMap model)
	{
		HttpSession s1 = request.getSession(false);
		String x= (String) s1.getAttribute("temp");
		
		if(x==null)
		{
			return "redirect:/UserLogin";
		}
		Users u1 = us.checkdata(x);
		model.addAttribute("user", u1);
		model.addAttribute("tab","profile");
		return "Userdashboard";
	}
	
	// mapping for repayments tab
	@RequestMapping("/repayments")
	public String goToRepayments(HttpServletRequest request,ModelMap model)
	{
		HttpSession s1 = request.getSession(false);
		String x= (String) s1.getAttribute("temp");
		
		if(x==null)
		{
			return "redirect:/UserLogin";
		}
		Users u1 = us.checkdata(x);
		model.addAttribute("user", u1);
		model.addAttribute("tab","repayment");
		return "Userdashboard";
	}
	
	
	
	@PostMapping("/saveDocs")
	public String savedocuments(ModelMap model,HttpServletRequest request,
			@RequestParam("profile_photo") MultipartFile photo,@RequestParam("adhaar_photo") MultipartFile adhaar,@RequestParam("pan_photo") MultipartFile pan)throws Exception
	{
		HttpSession s1 = request.getSession(false);
		String x= (String) s1.getAttribute("temp");
		
		if(x==null)
		{
			return "redirect:/UserLogin";
		}
		
		Users u = us.checkdata(x);
		
		int accountNo = u.getAccount_no();
		String Photo_name = "UserProfile.jpg";
		String Adhaar_name = "UserAdhaar.jpg";
		String Pan_name = "UserPan.jpg";
			
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
		
		if(!photo.getOriginalFilename().equals("")) {
			u.setProfile_photo(Photo_name);
			
			BufferedOutputStream f1 = new BufferedOutputStream(new FileOutputStream(file+"/"+Photo_name));
			byte[] b = photo.getBytes();
			f1.write(b);
			f1.close();
		}
		
		if(!adhaar.getOriginalFilename().equals("")) {
			u.setAdhaar_photo(Adhaar_name);
			
			BufferedOutputStream f2 = new BufferedOutputStream(new FileOutputStream(file+"/"+Adhaar_name));
			byte[] b1 = adhaar.getBytes();
			f2.write(b1);
			f2.close();
		}

		if(!pan.getOriginalFilename().equals("")) {
			u.setPan_photo(Pan_name);
			
			BufferedOutputStream f3 = new BufferedOutputStream(new FileOutputStream(file+"/"+Pan_name));
			byte[] b2 = pan.getBytes();
			f3.write(b2);
			f3.close();
		}
		
		us.savedata(u);
		
		return "redirect:/home";
	}
	
	@PostMapping("/updatePassword")
	public String updatepassword(HttpServletRequest request ,@RequestParam("email") String email,@RequestParam("password") String pass,@RequestParam("cpassword") String cpass)
	{
		
		Users u1 = us.checkdata(email);
		u1.setPassword(pass);
		u1.setCpassword(cpass);
		us.savedata(u1);			
		return "redirect:/UserLogin";
	}
	
	//Mapping for Login
		@RequestMapping("/forgotPassword")
		public String forgotpassword(HttpServletRequest request,ModelMap model)
		{
			return "forgotPassword";
		}
		
	
	//Mapping for Logout
	@RequestMapping("/logoutUser")
	public String six(HttpServletRequest request)
	{
		HttpSession s1 = request.getSession();
		s1.invalidate();
		return "redirect:/UserLogin";
	}
}
