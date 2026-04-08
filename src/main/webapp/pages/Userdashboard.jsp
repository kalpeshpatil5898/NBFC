<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link
	href="https://fonts.googleapis.com/css2?family=Monoton&family=Poppins:wght@100;200;300;400;500;600;700;800;900&display=swap"
	rel="stylesheet">
<script src="https://kit.fontawesome.com/898070658c.js"
	crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"
	integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo="
	crossorigin="anonymous"></script>
<link rel="stylesheet" href="/CSS/dashboard.css">
<link rel="stylesheet" href="/CSS/form.css">
<link rel="stylesheet" href="/CSS/loader.css">
<title>NBFCPlus Dashboard</title>
</head>

<body>
	<div id="entire-page-loader">
		<img src="/images/loaderImage.png">
		<div class="inside">
			<span style="--i: 0;"></span> <span style="--i: 1;"></span> <span
				style="--i: 2;"></span> <span style="--i: 3;"></span> <span
				style="--i: 4;"></span> <span style="--i: 5;"></span> <span
				style="--i: 6;"></span>
		</div>
	</div>
	<script>
			$(window).on('load', function(){
			   $('#entire-page-loader').hide();
			});	
	</script>


	<header id="dashboard-header">
		<h1>
			NBFC <img src="/images/graph-icon.svg" alt="" srcset=""> Plus
		</h1>
		<a class="logout-btn" href="logoutUser"> Logout <img
			src="/images/logout.svg" alt="" srcset=""></a>
	</header>
	<section id="dashboard">
		<div id="side-bar">
			<nav>
				<ul id="side-bar-list">
					<li class=""
						style="--c: #8e67f0; --s1: #8e67f084; --s2: #8e67f051;"><a
						href="home"><i class="fa-solid fa-house  icon-color"></i> <span>Home</span></a>
					</li>
					<li style="--c: #ff3c6a; --s1: #f9225484; --s2: #f9225451;"><a
						href="profile"><i class="fa-solid fa-user icon-color"></i> <span>Profile</span></a>
					</li>
					<!-- <li style="--c: #3d85c6;--s1: #3d85c684;--s2: #3d85c651;">
                        <a href="#"><i class="fa-solid fa-signature icon-color"></i> <span>guarantor</span></a>
                    </li> -->
					<li style="--c: #57D357; --s1: #57D35784; --s2: #57D35751;"><a
						href="loans"><i
							class="fa-solid fa-money-check-dollar icon-color"></i> <span>Loans</span></a>
					</li>
					<li style="--c: #4da2ec; --s1: #4da2ec84; --s2: #4da2ec51;"><a
						href="repayments"><i
							class="fa-solid fa-hand-holding-dollar icon-color"></i> <span>Repayments</span></a>
					</li>
				</ul>
			</nav>
		</div>

		<div id="content-section">

			<c:if test="${tab == 'home'}">
				<div class="content home-page">
					<div id="section-name">
						<h1>Home ></h1>
					</div>
					<div class="account-container">
						<div class="left">
							<h1>Hello, ${user.getFullname()} !!!</h1>
						</div>
						<div class="right">
							<img src="/images/account_image.png" alt="" srcset="">
						</div>
					</div>
					<div id="bottom-section">
						<div class="account-details">
							<div class="left">
								<div class="bg-img">
									<img src="/images/graph.svg" alt="" srcset="">
								</div>
								<h3>Account No:</h3>
								<h3 class="acc-no">${user.getAccount_no()}</h3>

								<h1>Overall Balance:</h1>
								<h1 class="account-balance">&#8377 ${user.getBalance()}</h1>
							</div>
							<div class="right">
								<img src="/images/money-transfer.png" alt="" srcset="">
								<p>Transfer Money</p>
								<a href="sendMoney">Send Money</a>
							</div>
						</div>
						<div id="transactions-container">
							<div class="header">
								<h3>Recent transactions</h3>
								<p>

									<c:choose>
										<c:when test="${transaction.size() == 0}">
											<a href="/api/download_pdf/${user.getAccount_no()}"
												target="_blank" class="disabled">Download &nbsp;<i
												class="fa-regular fa-file-pdf"></i></a>
										</c:when>
										<c:otherwise>
											<a href="/api/download_pdf/${user.getAccount_no()}"
												target="_blank">Download &nbsp;<i
												class="fa-regular fa-file-pdf"></i></a>
										</c:otherwise>
									</c:choose>
								</p>
							</div>
							<div class="transactions">
								<c:if test="${transaction.size() == 0}">
									<div id="universal_no_results">
										<img src="/images/notfound.png" alt="" srcset="">
										<h2>No Transactions Found</h2>
									</div>
								</c:if>
								<ul>
									<c:forEach items="${transaction}" var="e">

										<li>
											<div class="details">
												<h3>${e.getMessages()}</h3>
												<p>${e.getFormatedDate()}</p>
											</div> <c:if
												test="${user.getAccount_no() == e.getSender().getAccount_no()}">
												<span class="money debit">- &#8377 ${e.getAmount()}</span>
											</c:if> <c:if
												test="${user.getAccount_no() == e.getReceiver().getAccount_no()}">
												<span class="money credit">+ &#8377 ${e.getAmount()}</span>
											</c:if>
										</li>

									</c:forEach>
								</ul>
							</div>
						</div>
						<div class="loan-apply">
							<div class="details">
								<h1>Get Instant Loan with NBFC Plus</h1>
								<p>Enjoy attractive interest rate starting from 3.0%</p>
							</div>
							<a href="applyLoan" class="apply-loan-btn">Apply Now</a>
						</div>
					</div>
				</div>
			</c:if>
			<c:if test="${tab == 'UserTransferMoney'}">
				<div class="content send-money">
					<div id="section-name">
						<h1>Home > Transfer Money ></h1>
					</div>
					<div id="transfer-money-container">
						<img src="/images/graph.svg" alt="" srcset="" class="bg-graph">
						<h1 class="title">Send Money</h1>
						<p class="smsg">Transfer money to Other's account</p>
						<div class="message-wrap">
							<div class="message" id="message"></div>
						</div>
						<form action="transaction" method="post" class="form"
							id="send-money-form">
							<input type="number" name="sender" id="sender"
								value="${user.getAccount_no()}" hidden>
							<div class="input">
								<label for="receiversearch">Receiver Account Number or
									Name</label> <i class="fa-regular fa-user" for="receiversearch"></i> <input
									type="number" name="receiver" id="receiver" class="receiver"
									autocomplete="nope" hidden> <input type="text"
									name="receiversearch" id="receiversearch"
									class="searchForReceiverInp" autocomplete="nope"
									onkeyup="searchForReceiver(this, ${user.getAccount_no()})"
									onfocus="searchForReceiver(this, ${user.getAccount_no()})">
							</div>
							<div class="receivers-list-container"></div>
							<div class="input">
								<label for="amount">Amount</label> <i
									class="fa-solid fa-indian-rupee-sign" for="amount"></i> <input
									type="number" name="amount" id="amount" class="amount">
							</div>
							<div class="input">
								<label for="messages">Transaction Details</label> <i
									class="fa-regular fa-comment" for="messages"></i> <input
									type="text" name="messages" id="messages" class="messages">
							</div>

							<button type="submit" class="transaction-submit"
								onclick="validate()">Transfer Money</button>
						</form>
					</div>
				</div>
			</c:if>
			<c:if test="${tab == 'profile'}">
				<div class="content profile-page">
					<div id="section-name">
						<h1>Profile ></h1>
					</div>
					<div id="profile-container">
						<div id="profile-toggle-btns">
							<span class="general-btn" onclick="show_general()">General</span>
							<span class="doc-btn" onclick="show_docs()">Documents</span>
						</div>
						<div id="profile-content">
							<div id="general-profile-content">
								<div class="profile-field">
									<h4 class="profile-label">
										<i class="fa-regular fa-user" for="fullname"></i> Full Name
									</h4>
									<h4 class="profile-text">${user.getFullname()}</h4>
								</div>
								<div class="profile-field">
									<h4 class="profile-label">
										<i class="fa-regular fa-envelope" for="email"></i> Email
									</h4>
									<h4 class="profile-text">${user.getEmail()}</h4>
								</div>
								<div class="profile-field">
									<h4 class="profile-label">
										<i class="fa-solid fa-phone" for="phoneno"></i> Mobile No.
									</h4>
									<h4 class="profile-text">${user.getContact()}</h4>
								</div>
								<div class="profile-field">
									<h4 class="profile-label">
										<i class="fa-solid fa-venus-mars"></i> Gender
									</h4>
									<h4 class="profile-text">${user.getGender()}</h4>
								</div>
								<div class="profile-field">
									<h4 class="profile-label">
										<i class="fa-solid fa-calendar-days"></i> Date of Brith
									</h4>
									<h4 class="profile-text">${user.getDateOfBirth()}</h4>
								</div>
								<div class="profile-field">
									<h4 class="profile-label">
										<i class="fa-solid fa-location-dot"></i> Address
									</h4>
									<h4 class="profile-text">${user.getAddress()}</h4>
								</div>
							</div>
							<div id="documents-content">
								<form action="saveDocs" method="post"
									enctype=multipart/form-data>
									<div class="heading-doc">
										Upload or Update Documents <span style="color: red;">*</span>
										<button type="submit" id="profile-doc-save-btn" disabled>Save</button>

									</div>
									<div class="photo-upload">
										<label class="photo-label">Profile Photo</label>
										<c:choose>
											<c:when test="${user.getProfile_photo()!= null}">
												<img id="profile-photo-preveiw"
													src="/documents/${user.getAccount_no()}/UserProfile.jpg"
													for="profile-profile-photo" alt="Profile Photo">
											</c:when>
											<c:otherwise>
												<img id="profile-photo-preveiw"
													src="/images/image-upload-icon.png"
													for="profile-profile-photo" alt="Profile Photo">
											</c:otherwise>

										</c:choose>

										<p class="uploaded-file-name" id="profile-photo-file-name">No
											File Chosen</p>
										<label for="profile-profile-photo"
											class="photo-label upload-btn">Upload</label> <input
											type="file" name="profile_photo" id="profile-profile-photo"
											onchange="fileChosen(this, 'profile', 'documents-content')"
											accept=".jpg, .png, .jpeg" hidden>
									</div>
									<div class="photo-upload">
										<label class="photo-label">Adhaar Card</label>
										<c:choose>
											<c:when test="${user.getAdhaar_photo()!= null}">
												<img id="adhaar-photo-preveiw"
													src="/documents/${user.getAccount_no()}/UserAdhaar.jpg"
													for="profile-adhaar-photo" alt="Adhaar Card Photo">
											</c:when>
											<c:otherwise>
												<img id="adhaar-photo-preveiw"
													src="/images/image-upload-icon.png"
													for="profile-adhaar-photo" alt="Adhaar Card Photo">
											</c:otherwise>
										</c:choose>
										<p class="uploaded-file-name" id="adhaar-photo-file-name">No
											File Chosen</p>
										<label for="profile-adhaar-photo"
											class="photo-label upload-btn">Upload</label> <input
											type="file" name="adhaar_photo" id="profile-adhaar-photo"
											onchange="fileChosen(this, 'adhaar', 'documents-content')"
											accept=".jpg, .png, .jpeg" hidden>
									</div>
									<div class="photo-upload">
										<label class="photo-label">Pan Card</label>
										<c:choose>
											<c:when test="${user.getPan_photo()!= null}">
												<img id="pan-photo-preveiw"
													src="/documents/${user.getAccount_no()}/UserPan.jpg"
													for="profile-pan-photo" alt="Pan Card Photo">
											</c:when>
											<c:otherwise>
												<img id="pan-photo-preveiw"
													src="/images/image-upload-icon.png" for="profile-pan-photo"
													alt="Pan Card Photo">
											</c:otherwise>
										</c:choose>
										<p class="uploaded-file-name" id="pan-photo-file-name">No
											File Chosen</p>
										<label for="profile-pan-photo" class="photo-label upload-btn">Upload</label>
										<input type="file" name="pan_photo" id="profile-pan-photo"
											onchange="fileChosen(this, 'pan', 'documents-content')"
											accept=".jpg, .png, .jpeg" hidden>
									</div>
								</form>
							</div>
						</div>
					</div>
				</div>
			</c:if>
			<c:if test="${tab == 'loans'}">
				<div class="content loans-page">
					<div id="section-name">
						<h1>Loans ></h1>
					</div>
					<div id="apply-loan-btn-container">
						<div class="details">
							<h1>Get Instant Loan with NBFC Plus</h1>
							<p>Enjoy attractive interest rate starting from 3.0%</p>
						</div>
						<a href="applyLoan" class="apply-loan-btn">Apply Now</a>
					</div>
					<div id="all-loans-container">
						<div class="heading">
							<p class="loan-id">Id</p>
							<p class="loan-type">Loan Type</p>
							<p class="loan-status">Status</p>
							<p class="loan-amount">Total Loan</p>
						</div>
						<div id="user-loans-div">
							<c:if test="${loan.size() == 0}">
								<div id="universal_no_results">
									<img src="/images/notfound.png" alt="" srcset="">
									<h2>No Loans Found!! &nbsp; Apply for New Loan</h2>
								</div>
							</c:if>


							<script type="text/javascript">
	                    
		                    function getDot(status, element){
		            			
		            			var d = {
		                            'Pending': 'yellow',
		                            'Approved': 'cyan',
		                            'Disbursed': 'blue',
		                            'Active': 'green',
		                            'Rejected': 'red',
		                            'Closed': 'grey',
		                        }
	
		                        var dot_class = d[status];
		                        
		                        var ele = "#all-loans-container #user-loans-div " + "#" + element;
		                        
		                        $(ele).addClass(dot_class + "-dot");
		                        
	            			}  
	                    </script>
							<c:forEach items="${loan}" var="e">
								<div class="user-loan-div">
									<div class="visible-part">
										<p class="loan-id">${e.getLid()}</p>
										<p class="loan-type">${e.getLoanType()}</p>
										<p class="loan-status">
											<span class="status-dot" id="spanFor${e.getLid()}"><script
													type="text/javascript">getDot("${e.getStatus()}", "spanFor${e.getLid()}")</script></span>${e.getStatus()}</p>
										<p class="loan-amount">&#8377 ${e.getLoanAmount()}</p>
										<button type="button" class="loan-toggle-btn"
											onclick="toggleLoan(this)">
											<i class="fa-solid fa-chevron-right"></i>
										</button>
									</div>
									<div class="hidden-part">
										<div class="loan-component">
											<p>Total Amount</p>
											<p>&#8377 ${e.getTotalAmount()}</p>
										</div>
										<div class="loan-component">
											<p>Monthly EMI</p>
											<p>&#8377 ${e.getMonthlyEmi()}</p>
										</div>
										<div class="loan-component">
											<p>Guarantor 1</p>
											<p>${e.getGuarantor_1().getParentUser().getFullname()}</p>
										</div>

										<div class="loan-component">
											<p>Annual Interest Rate</p>
											<p>36% p.a</p>
										</div>
										<div class="loan-component">
											<p>Tenure in Years</p>
											<p>${e.getLoanTenure()}yr</p>
										</div>
										<div class="loan-component">
											<p>Guarantor 2</p>
											<p>${e.getGuarantor_2().getParentUser().getFullname()}</p>
										</div>
									</div>
								</div>
							</c:forEach>

						</div>
					</div>
				</div>

			</c:if>
			<c:if test="${tab == 'UserLoan'}">
				<div class="content apply-loan">
					<script type="text/javascript">
            		var user_account_no = ${user.getAccount_no()};
            	</script>
					<div id="section-name">
						<h1>Loans > Apply Loan ></h1>
					</div>
					<div id="loan-apply-container">
						<img src="/images/graph.svg" alt="" srcset="" class="bg-graph">
						<h1 class="title">
							Step <span id="step-number">1</span> of 5 : <span
								id="loan-page-detail-heading">Personal Details</span>
						</h1>
						<div class="message-wrap">
							<div class="message" id="message"></div>
						</div>
						<form action="saveloan" method="post" class="form"
							id="loan-apply-form" enctype=multipart/form-data>
							<div id="loan-pages">
								<div id="loan-page-1">
									<div class="input">
										<label for="fullname">Full Name</label> <i
											class="fa-regular fa-user" for="fullname"></i> <input
											type="text" name="fullname" value="${user.getFullname()}"
											id="fullname" class="fullname default" autocomplete="nope">
									</div>
									<div class="single-line-inputs">
										<div class="input">
											<label for="email">Email</label> <i
												class="fa-regular fa-envelope" for="email"></i> <input
												type="text" name="email" value="${user.getEmail()}"
												id="email" class="email default" autocomplete="nope">
										</div>
										<div class="input">
											<label for="phoneno">Mobile</label> <i
												class="fa-solid fa-phone" for="phoneno"></i> <span>+91
												- </span> <input type="number" name="contact"
												value="${user.getContact()}" id="phoneno"
												class="phoneno default" autocomplete="nope">
										</div>
									</div>
									<div class="single-line-inputs">
										<div class="input">
											<label for="dateofbirth">Date of Birth</label> <i
												class="fa-regular fa-user" for="dateofbirth"></i> <input
												type="text" name="dob" value="${user.getDateOfBirth()}"
												id="dateofbirth" class="dateofbirth default"
												autocomplete="nope">
										</div>
										<div class="gender-input">
											<i class="fa-solid fa-venus-mars"></i>
											<p class="gender-label">Gender</p>

											<c:if test="${user.getGender() == 'Male'}">
												<input type="radio" name="gender" id="male"
													class="male default" value="Male" checked>
												<label for="male"><i class="fa-solid fa-mars"></i>
													Male</label>
												<input type="radio" name="gender" id="female"
													class="female default" value="Female">
												<label for="female"><i class="fa-solid fa-venus"></i>
													Female</label>
											</c:if>
											<c:if test="${user.getGender() == 'Female'}">
												<input type="radio" name="gender" id="male"
													class="male default" value="Male">
												<label for="male"><i class="fa-solid fa-mars"></i>
													Male</label>
												<input type="radio" name="gender" id="female"
													class="female default" value="Female" checked>
												<label for="female"><i class="fa-solid fa-venus"></i>
													Female</label>
											</c:if>
										</div>
									</div>
									<div class="input">
										<label for="address">Address</label><i
											class="fa-solid fa-location-dot"></i> <input type="text"
											name="address" value="${user.getAddress()}" id="address"
											class="address default" autocomplete="nope">
									</div>
								</div>
								<div id="loan-page-2">
									<div class="left">
										<div class="loan-input loan-type-div">
											<label for="loan-type">Loan Type</label>
											<div class="select-container">
												<div class="select">
													<input type="text" name="loanType" id="loan-type"
														placeholder="Select" onfocus="this.blur();">
												</div>
												<div class="option-container">
													<div class="option">
														<label> Home Loan </label>
													</div>
													<div class="option">
														<label> Car Loan</label>
													</div>
													<div class="option">
														<label>Personal Loan</label>
													</div>
												</div>
											</div>
										</div>
										<div class="loan-input loan-amount-div">
											<label for="loan-amount">Loan Amount (&#8377) </label> <input
												type="number" name="loanAmount" id="loan-amount"
												value="100000" min="10000" max="1000000"
												oninput="amount_change(this.value)"> <input
												type="range" name="loan-amount-slider"
												id="loan-amount-slider" value="100000" min="10000"
												max="1000000" oninput="amount_change(this.value)">
										</div>
										<div class="loan-input loan-interest-rate-div">
											<label for="loan-interest-rate">Interest Rate (p.a)</label> <input
												type="text" value="36%" name="interestRate"
												id="loan-interest-rate" disabled>
										</div>
										<div class="loan-input loan-tenure-div">
											<label for="loan-tenure">Loan Tenure (Yrs)</label> <input
												type="number" name="loanTenure" id="loan-tenure"
												oninput="yr_change(this.value)" value="5" min="1" max="32">
											<input type="range" name="loanTenure" id="loan-tenure-slider"
												oninput="yr_change(this.value)" value="5" min="1" max="32">
										</div>
									</div>
									<div class="right">
										<div id="interest-pie-chart" class="interest-pie-chart">
											<canvas id="interest-pie-chart-canvas"></canvas>
										</div>
										<div class="interest-details">
											<div class="legends">
												<p>
													<span style="background-color: rgb(0, 208, 0);"></span>
													Total Interest
												</p>
												<p>
													<span style="background-color: rgb(225, 225, 225);"></span>
													Principal Amount
												</p>
											</div>
											<div class="counts">
												<div>
													<p>Monthly EMI :</p>
													<input type="number" name="monthlyEmi"
														id="monthly-emi-input" hidden>
													<p id="monthly-emi-box"></p>
												</div>
												<div>
													<p>Total Interest :</p>
													<input type="number" name="totalInterest"
														id="total-interest-input" hidden>
													<p id="total-interest-box"></p>
												</div>
												<div>
													<p>Total Amount :</p>
													<input type="number" name="totalAmount"
														id="total-amount-input" hidden>
													<p id="total-amount-box"></p>
												</div>
											</div>
										</div>
									</div>
								</div>
								<div id="loan-page-3">
									<div class="photo-upload">
										<label class="photo-label">Profile Photo</label>
										<c:choose>
											<c:when test="${user.getProfile_photo()!= null}">
												<img id="profile-photo-preveiw"
													src="/documents/${user.getAccount_no()}/UserProfile.jpg"
													for="profile-profile-photo" alt="Profile Photo">
											</c:when>
											<c:otherwise>
												<img id="profile-photo-preveiw"
													src="/images/image-upload-icon.png"
													for="profile-profile-photo" alt="Profile Photo">
											</c:otherwise>

										</c:choose>
										<p class="uploaded-file-name" id="profile-photo-file-name">No
											File Chosen</p>
										<label for="profile-photo" class="photo-label upload-btn">Upload</label>
										<input type="file" name="profile-photo" id="profile-photo"
											onchange="fileChosen(this, 'profile', 'loan-page-3')"
											accept=".jpg, .png, .jpeg" hidden>
									</div>
									<div class="photo-upload">
										<label class="photo-label">Adhaar Card</label>
										<c:choose>
											<c:when test="${user.getAdhaar_photo()!= null}">
												<img id="adhaar-photo-preveiw"
													src="/documents/${user.getAccount_no()}/UserAdhaar.jpg"
													for="profile-adhaar-photo" alt="Adhaar Card Photo">
											</c:when>
											<c:otherwise>
												<img id="adhaar-photo-preveiw"
													src="/images/image-upload-icon.png"
													for="profile-adhaar-photo" alt="Adhaar Card Photo">
											</c:otherwise>
										</c:choose>
										<p class="uploaded-file-name" id="adhaar-photo-file-name">No
											File Chosen</p>
										<label for="adhaar-photo" class="photo-label upload-btn">Upload</label>
										<input type="file" name="adhaar-photo" id="adhaar-photo"
											onchange="fileChosen(this, 'adhaar', 'loan-page-3')"
											accept=".jpg, .png, .jpeg" hidden>
									</div>
									<div class="photo-upload">
										<label class="photo-label">Pan Card</label>
										<c:choose>
											<c:when test="${user.getPan_photo()!= null}">
												<img id="pan-photo-preveiw"
													src="/documents/${user.getAccount_no()}/UserPan.jpg"
													for="profile-pan-photo" alt="Pan Card Photo">
											</c:when>
											<c:otherwise>
												<img id="pan-photo-preveiw"
													src="/images/image-upload-icon.png" for="profile-pan-photo"
													alt="Pan Card Photo">
											</c:otherwise>
										</c:choose>
										<p class="uploaded-file-name" id="pan-photo-file-name">No
											File Chosen</p>
										<label for="pan-photo" class="photo-label upload-btn">Upload</label>
										<input type="file" name="pan-photo" id="pan-photo"
											onchange="fileChosen(this, 'pan', 'loan-page-3')"
											accept=".jpg, .png, .jpeg" hidden>
									</div>
								</div>
								<div id="loan-page-4">
									<!-- <div class="heading">
                                    <h3> guarantor (Jamindaar)</h3>
                                    <button id="add-nominee-btn"><span>Add guarantor</span><i class="fa-solid fa-plus"></i></button>
                                </div> -->
									<div id="guarantor-search-box" class="input">
										<label for="guarantor-search">Search Guarantor</label> <i
											class="fa-brands fa-searchengin" for="guarantor-search"></i>
										<input type="text" name="guarantor-search"
											id="guarantor-search" class="guarantor-search"
											onkeyup="search_guarantor(this)"
											onfocus="search_guarantor(this)" autocomplete="nope">
									</div>
									<div id="search-results">
										<div class="no-result-found">
											<img src="/images/no-results-found.png">
											<h3>No Result Found</h3>
										</div>

										<div class="results"></div>

									</div>
									<div id="added-guarantors">
										<div id="no-guarantor-select">
											<img src="/images/no-select.svg" alt="" srcset="">
											<h3>Select 2 Guarantors</h3>
										</div>
									</div>
								</div>
								<div id="loan-page-5"></div>
							</div>
							<div class="btns"
								style="display: flex; width: 100%; justify-content: flex-end;">
								<button type="button" class="loan-back-btn"
									onclick="back_submit()">
									<i class="fa-solid fa-angle-left"></i> &nbsp; Back
								</button>
								<button type="button" class="loan-next-btn"
									onclick="next_submit()">
									Next &nbsp;<i class="fa-solid fa-angle-right"></i>
								</button>
							</div>
						</form>
					</div>
				</div>
				<script type="text/javascript">
			 
		        var current_page = 1;

		        var total_pages = 5;
		        
		        var gurantors_selected_acc_no = [];

		        for (var i = 1; i <= total_pages; i++) {
		            $("#loan-page-" + i).hide();
		        }

		        $("#loan-page-" + current_page).show();

		        $(".loan-back-btn").hide();
            
            	let select = document.querySelector(".loan-type-div .select-container .select");
            
	            select.onclick = () => {
	                selectContainer.classList.toggle("active");
	            };
	            
	            window.addEventListener('click', function (e) {
	                if (!document.getElementById('search-results').contains(e.target) && !document.getElementById('guarantor-search-box').contains(e.target)) {
	                    $("#search-results").hide();
	                }
	            });
	            
	            let selectContainer = document.querySelector(".loan-type-div .select-container");

	            let inputlt = document.getElementById("loan-type");
	            let options = document.querySelectorAll(".loan-type-div .select-container .option");
	            
	            options.forEach((e) => {
	                e.addEventListener("click", () => {
	                    inputlt.value = e.innerText;
	                    loan_type_changed(inputlt.value);
	                    calculateEMI();
	                    selectContainer.classList.remove("active");
	                    options.forEach((en) => {
	                        en.classList.remove("selected");
	                    });
	                    e.classList.add("selected");
	                });
	            });
	            
	            var current_guarantor = 1;
	            var guarantor_count = 0;
            </script>
			</c:if>
			<c:if test="${tab== 'repayment'}">
				<div class="content user-repayments">
					<div id="section-name">
						<h1>Repayments ></h1>
					</div>
					<div id="repayments-container">
						<h2 class="heading">Upcoming EMIs</h2>
						<div class="table-heading">
							<p>Loan Id</p>
							<p>Due Date</p>
							<p></p>
						</div>
						<div class="repayments"></div>
					</div>
					<div id="repayment-form-container" onclick="hide_repayment_form()">
						<div class="sub-container">
							<div id="repayment-form">
								<img src="/images/3d-casual-life-shopping-calendar.png" alt=""
									srcset="">
								<div class="sub-div">
									<p>Loan Id</p>
									<p class="repayment-loanid-text">#154</p>
									<input type="number" id="repayment-accountno" name="accountno"
										value="" hidden> <input type="number"
										id="repayment-loanid" name="loanid" value="" hidden> <input
										type="number" id="repayment-latefee-ip" name="latefee"
										value="" hidden>
								</div>
								<div class="sub-div">
									<p>EMI Installment:</p>
									<p class="repayment-emi">&#8377 54563.12</p>
								</div>
								<div class="sub-div">
									<p>Late Fee:</p>
									<p class="repayment-latefee-text">&#8377 200.00</p>
								</div>
								<button class="submit-repayment-btn" onclick="makePayment()"></button>
							</div>
							<div id="after-pay-confirm">
								<img src="/images/3d-fluency-protect.png" alt="" srcset="">
								<h2>Payment Successful</h2>
								<p class="counter">Ok (3s)</p>
							</div>
						</div>
					</div>
				</div>
			</c:if>
		</div>
	</section>

	<script src="/CSS/dashboard.js"></script>
	<c:if test="${tab== 'repayment'}">
		<script type="text/javascript">
	    	fetchRepayments(${user.getAccount_no()});
    	</script>
	</c:if>
	<script type="text/javascript">
		updateActiveTab("${tab}");
	</script>
</body>

</html>


<!-- 
@Query("SELECT * FROM Users WHERE acc_no LIKE %?1% OR name LIKE %?2%")
List<Users> searchUserLikeAccNoOrname(Integer accno, String name);
-->