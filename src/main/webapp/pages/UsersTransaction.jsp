<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<h2>welcome For Transaction</h2>
<form action="transaction" method="post">
<input type="text" name="sender">
<input type="text" name="receiver">
<input type="text" name="amount">
<label>Send</label>
<input type="radio" name="action" value="Send">

<button type="submit">Send</button>
</form>
<script type="text/javascript">

</script>
</body>
</html>