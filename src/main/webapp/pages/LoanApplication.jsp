<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix = "spring" uri = "http://www.springframework.org/tags" %>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Loan Application</title>
</head>
<body>

<h1>Loan Application</h1>
<form action="saveloan" method="post" enctype=multipart/form-data>
<label>Name of Applicant :</label><br>
<select>
<option value="Mr.">Mr.</option>
<option value="Mrs.">Mrs.</option>
<option value="Miss.">Miss.</option>
</select>
<input type="text" name="fullname" value="${user.fullname}">
<br>
<label>Email :</label>
<input type="email" name="email" value="${user.email}">
<br>
<label>Number :</label>
<input type="text" name="contact" value="${user.contact}">

<br>
<label>Address :</label>
<input type="text" name="address" value="${user.address}">

<br>
<label>Birth Date :</label>
<input type="text" name="bdate" value="${user.dob}">
<br>
<label>Loan Type</label><br>
<select name="loanType">
<option value="Home Loan">Home Loan</option>
<option value="Car Loan">Car Loan</option>
<option value="Gold Loan">Gold Loan</option>
<option value="Education Loan">Education Loan</option>
</select>
<br>
<label>Loan Amount :</label>
<input type="text" name="loanAmount">
<br>
<label>Interest Rate :</label>
<input type="text" name="interestRate" value="3%" disabled>
<br>
<label>Documents :</label><br>
<label>Adhar Card :</label>
<input type="file" name="adharfile">
<label>Pan Card :</label>
<input type="file" name="panfile">
<label>Photo :</label>
<input type="file" name="photofile">
<button type="submit">Submit</button>
</form>

</body>
</html>