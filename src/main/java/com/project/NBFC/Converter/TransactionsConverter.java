package com.project.NBFC.Converter;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.xhtmlrenderer.pdf.ITextRenderer;

import com.project.NBFC.Model.NBFC;
import com.project.NBFC.Model.Users;
import com.project.NBFC.Model.transactions;

public class TransactionsConverter {
	
    public static String htmlToXhtml(String html) throws IOException {
    	Document document = Jsoup.parse(html);

        document.outputSettings().syntax(Document.OutputSettings.Syntax.xml);
        
        return document.html();
    }
    
    public static byte[] xhtmlToPdf(String xhtml) throws IOException {
        ITextRenderer iTextRenderer = new ITextRenderer();
        iTextRenderer.setDocumentFromString(xhtml);
        iTextRenderer.layout();
        
        ByteArrayOutputStream buffer = new ByteArrayOutputStream();
        
        iTextRenderer.createPDF(buffer);
        
        byte[] pdfAsBytes = buffer.toByteArray();
        
        return pdfAsBytes;
    }
    
    
    public static String processHtml(String type, ArrayList<transactions> transactions, Users user, NBFC nbfc) {
    	
    	String head = "";
    	
    	String trans = "";
    	
    	Date printTime = new Date();
    	
    	SimpleDateFormat formatter = new SimpleDateFormat("E, dd MMM yyyy hh:mm a");  
	    String date= formatter.format(printTime);
	    
    	if(type.equals("admin")) {
    		head += "<p>Wallet Balance: <span> " + Double.toString(nbfc.getWalletBalance()) + "</span></p>";
    		head += "<p>Date & Time: <span>" + date + "</span></p>";
    	}
    	else {
    		head += "<p>Account No. <span>" + user.getAccount_no() + "</span></p>";
    		head += "<p>Name: <span>" + user.getFullname() + "</span></p>";
    		head += "<p>Wallet Balance: <span>&#8377 " + user.getBalance() + "</span></p>";
    		head += "<p>Date & Time: <span>" + date + "</span></p>";
    	}
    	
    	int i = 1;
    	for(transactions t : transactions) { 
    		
    		String amtClass = "";
    		String recClass = "";
    		String sendClass = "";
    		
    		if(t.getReceiver().getAccount_no() == user.getAccount_no()) {
    			amtClass = "credit";
    			recClass = "highlight";
    		}else {
    			amtClass = "debit";
    			sendClass = "highlight";
    		}
    		
    		String receiver = Integer.toString(t.getReceiver().getAccount_no());
    		String sender = Integer.toString(t.getSender().getAccount_no());
    		
    		if(type.equals("admin")) {
    			if(user.getAccount_no() == t.getReceiver().getAccount_no()) {
    				receiver = "NBFC";
    			}else {
    				sender = "NBFC";
    			}
    		}
    		else {
    			if(t.getReceiver().getAccount_no() == 211001000) {
    				receiver = "NBFC";
    			}
    			else if(t.getSender().getAccount_no() == 211001000) {
    				sender = "NBFC";
    			}    			
    		}
    		
    		
    		trans += "<tr>"
    				+ "<td>" + i + "</td>"
    				+ "<td>" + t.getMessages() +"</td>"
    				+ "<td class='" + amtClass + "'>" + t.getAmount() + "</td>"
    				+ "<td class='" + recClass + "'>" + receiver + "</td>"
    				+ "<td class='" + sendClass + "'>" + sender + "</td>"
    				+ "</tr>";
    		i++;
    	}
    	
    	String html = "<!DOCTYPE html>\r\n"
    			+ "<html lang=\"en\">\r\n"
    			+ "\r\n"
    			+ "<head>\r\n"
    			+ "    <meta charset=\"UTF-8\">\r\n"
    			+ "    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\r\n"
    			+ "    <title>All Transactions</title>\r\n"
    			+ "    <!-- <link rel=\"stylesheet\" href=\"transactions.css\"> -->\r\n"
    			+ "\r\n"
    			+ "    <style>\r\n"
    			+ "        * {\r\n"
    			+ "            box-sizing: border-box;\r\n"
    			+ "            padding: 0;\r\n"
    			+ "            margin: 0;\r\n"
    			+ "            font-family: Verdana, sans-serif;\r\n"
    			+ "        }\r\n"
    			+ "\r\n"
    			+ "        :root {\r\n"
    			+ "            --primary-color: #00d000;\r\n"
    			+ "            --dark-primary: #00aa00;\r\n"
    			+ "            --light-primary: #00ff00;\r\n"
    			+ "            --bg-color: #00ff0009;\r\n"
    			+ "            --fcolor-light: rgb(245, 245, 245);\r\n"
    			+ "            --fcolor-dark: #4d4d4d;\r\n"
    			+ "            --fcolor-dark2: #6b6b6b;\r\n"
    			+ "        }\r\n"
    			+ "\r\n"
    			+ "        body {\r\n"
    			+ "            display: flex;\r\n"
    			+ "            flex-direction: column;\r\n"
    			+ "            justify-content: space-between;\r\n"
    			+ "            align-items: flex-start;\r\n"
    			+ "            border: 2px solid #4d4d4d;\r\n"
    			+ "            padding: 3px;\r\n"
    			+ "            border-radius: 10px;\r\n"
    			+ "        }\r\n"
    			+ "\r\n"
    			+ "        .outer-div{\r\n"
    			+ "            display: flex;\r\n"
    			+ "            flex-direction: column;\r\n"
    			+ "            justify-content: space-between;\r\n"
    			+ "            align-items: flex-start;\r\n"
    			+ "            width: 100%;\r\n"
    			+ "            border: 2px solid #4d4d4d;\r\n"
    			+ "            padding: 10px;\r\n"
    			+ "            border-radius: 10px;\r\n"
    			+ "        }\r\n"
    			+ "\r\n"
    			+ "        .company-name {\r\n"
    			+ "            color: #00d000;\r\n"
    			+ "        }\r\n"
    			+ "\r\n"
    			+ "        .heading {\r\n"
    			+ "            /* align-self: center; */\r\n"
    			+ "            width: 100%;\r\n"
    			+ "            text-align: center;\r\n"
    			+ "            margin-top: 20px;\r\n"
    			+ "            letter-spacing: 0.6px;\r\n"
    			+ "            color: #4d4d4d;\r\n"
    			+ "        }\r\n"
    			+ "\r\n"
    			+ "        .details {\r\n"
    			+ "            width: 100%;\r\n"
    			+ "            margin-top: 20px;\r\n"
    			+ "        }\r\n"
    			+ "\r\n"
    			+ "        .details p {\r\n"
    			+ "            width: 50%;\r\n"
    			+ "            color: #4d4d4d;\r\n"
    			+ "            font-weight: 600;\r\n"
    			+ "            padding: 2px;\r\n"
    			+ "            margin-bottom: 5px;\r\n"
    			+ "        }\r\n"
    			+ "\r\n"
    			+ "        .details p span {\r\n"
    			+ "            color: #6b6b6b;\r\n"
    			+ "        }\r\n"
    			+ "\r\n"
    			+ "        table {\r\n"
    			+ "            margin-top: 30px;\r\n"
    			+ "            align-self: center;\r\n"
    			+ "            width: 100%;\r\n"
    			+ "            border-spacing: 4px 10px;\r\n"
    			+ "        }\r\n"
    			+ "\r\n"
    			+ "        table tr {\r\n"
    			+ "            margin-top: 10px;\r\n"
    			+ "        }\r\n"
    			+ "\r\n"
    			+ "        table tr:nth-child(even) > *{\r\n"
    			+ "            background-color: #ebebeb;\r\n"
    			+ "        }\r\n"
    			+ "\r\n"
    			+ "        table tr > * {\r\n"
    			+ "            padding: 9px;\r\n"
    			+ "            /* border: 2px solid white; */\r\n"
    			+ "            border-radius: 20px;\r\n"
    			+ "            text-align: center;\r\n"
    			+ "            color: #4d4d4d;\r\n"
    			+ "        }\r\n"
    			+ "        \r\n"
    			+ "        table .table-heading th{\r\n"
    			+ "            background-color: #75beff;\r\n"
    			+ "            color: white;\r\n"
    			+ "        }\r\n"
    			+ "\r\n"
    			+ "        table tr th:nth-of-type(1),\r\n"
    			+ "        table tr td:nth-of-type(1) {\r\n"
    			+ "            width: 10%;\r\n"
    			+ "        }\r\n"
    			+ "\r\n"
    			+ "        table tr th:nth-of-type(2),\r\n"
    			+ "        table tr td:nth-of-type(2) {\r\n"
    			+ "            width: 24%;\r\n"
    			+ "        }\r\n"
    			+ "\r\n"
    			+ "        table tr th:nth-of-type(3),\r\n"
    			+ "        table tr td:nth-of-type(3) {\r\n"
    			+ "            width: 20%;\r\n"
    			+ "        }\r\n"
    			+ "\r\n"
    			+ "        table tr th:nth-of-type(4),\r\n"
    			+ "        table tr td:nth-of-type(4) {\r\n"
    			+ "            width: 23%;\r\n"
    			+ "        }\r\n"
    			+ "\r\n"
    			+ "        table tr th:nth-of-type(5),\r\n"
    			+ "        table tr td:nth-of-type(5) {\r\n"
    			+ "            width: 23%;\r\n"
    			+ "        }\r\n"
    			+ ".debit{color: red;}"
    			+ ".credit{color: green;}"
    			+ ".highlight{font-weight: 600;}"
    			+ "    </style>\r\n"
    			+ "</head>\r\n"
    			+ "\r\n"
    			+ "<body>\r\n"
    			+ "    <div class=\"outer-div\">\r\n"
    			+ "        <h1 class=\"company-name\">NBFC Plus</h1>\r\n"
    			+ "        <h2 class=\"heading\">~: All Transactions :~</h2>\r\n"
    			+ "        <div class=\"details\">\r\n"
    			+ head
    			+ "        </div>\r\n"
    			+ "\r\n"
    			+ "        <table id=\"transaction-table\">\r\n"
    			+ "            <tr class=\"table-heading\">\r\n"
    			+ "                <th>Sr No.</th>\r\n"
    			+ "                <th>Details</th>\r\n"
    			+ "                <th>Amount</th>\r\n"
    			+ "                <th>Receiver</th>\r\n"
    			+ "                <th>Sender</th>\r\n"
    			+ "            </tr>\r\n"
    			+ trans
    			+ "        </table>\r\n"
    			+ "    </div>\r\n"
    			+ "</body>\r\n"
    			+ "\r\n"
    			+ "</html>";
    	
    	return html;
    }

}
