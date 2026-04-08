<%@page import="java.util.HashMap"%>
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
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>


<script src="/CSS/chart-utils.min.js"></script>
<script src="/CSS/adminJS.js"></script>

<link rel="stylesheet" href="/CSS/admin_css.css">
<link rel="stylesheet" href="/CSS/calender.css">
<link rel="stylesheet" href="/CSS/loader.css">

<title>NBFCPlus Admin Dashboard</title>


<script
	src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>

<script
	src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>

<script
	src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>
</head>

<body>

	<div id="entire-page-loader">
		<img src="/images/loaderImage.png">
		<div class="inside">
			<span style="--i:0;"></span>
			<span style="--i:1;"></span>
			<span style="--i:2;"></span>
			<span style="--i:3;"></span>
			<span style="--i:4;"></span>
			<span style="--i:5;"></span>
			<span style="--i:6;"></span>
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
		<a class="logout-btn" href="logout"> Logout <img
			src="/images/logout.svg" alt="" srcset=""></a>
		<div id="toast">SMS sent Successfully!!</div>
	</header>
	<section id="dashboard">

		<div id="side-bar">
			<nav>
				<ul id="side-bar-list">
					<li style="--c: #ff3c6a; --s1: #f9225484; --s2: #f9225451;"><a
						href="Dashboard"><i class="fa-solid fa-chart-line icon-color"></i>
							<span>Dashboard</span></a></li>
					<li style="--c: #57D357; --s1: #57D35784; --s2: #57D35751;"><a
						href="admin-loans"><i
							class="fa-solid fa-money-check-dollar icon-color"></i> <span>Loans</span></a>
					</li>
					<li style="--c: #4da2ec; --s1: #4da2ec84; --s2: #4da2ec51;"><a
						href="Users"><i class="fa-solid fa-people-group icon-color"></i>
							<span>Users</span></a></li>
					<li style="--c: #ffb700; --s1: #ffb70084; --s2: #ffb70051;"><a
						href="emi-calc"><i class="fa-solid fa-calculator icon-color"></i>
							<span>EMI Calculator</span></a></li>
					<li class="active"
						style="--c: #8e67f0; --s1: #8e67f084; --s2: #8e67f051;"><a
						href="fund"><i class="fa-solid fa-wallet icon-color"></i> <span>Funds</span></a>
					</li>
				</ul>
			</nav>
		</div>

		<div id="content-section">
			<script type="text/javascript">
	    		updateActiveTab("${tab}");
	    	</script>
			<c:if test="${tab == 'Dashboard'}">
				<div class="content dashboard-page">
					<div id="section-name">
						<h1>Admin Dashboard ></h1>
					</div>
					<div id="details-cards">
						<div class="detail-card">
							<h1>Loan Disbursed</h1>
							<h2>&#8377 ${nbfc.getTotalDisbursed()}</h2>
						</div>
						<div class="detail-card">
							<h1>Loan Repayments</h1>
							<h2>&#8377 ${nbfc.getTotalRepayments()}</h2>
						</div>
						<div class="detail-card">
							<h1>Wallet Balance</h1>
							<h2>&#8377 ${nbfc.getWalletBalance()}</h2>
						</div>
						<div class="detail-card">
							<h1>Total Loans : ${nbfc.getTotalLoans()}</h1>
							<br>
							<h1>Total Users : ${nbfc.getTotalUsers()}</h1>

						</div>
					</div>
					<div id="charts-analytics">
						<div class="left-chart">
							<h1>Weekly Collections</h1>
							<canvas id="daily-monthly-collection-chart"></canvas>
							<div class="toggle-charts">
								<span class="daily-chart-btn chart-active"
									onclick="show_collection_chart('weekly')">Weekly</span> <span
									class="monthly-chart-btn"
									onclick="show_collection_chart('monthly')">Monthly</span>
							</div>
						</div>
						<div class="right-chart">
							<div class="h3">
								<h3>Pending Collection</h3>
								<c:if test="${pending.size() != 0}">
									<div class="outer-btn" onclick="sendAlerts(this)">
										<p>Send Alerts <i class="fa-solid fa-bell"></i></p>
										<div class="loader"></div>
									</div>								
								</c:if>
								<c:if test="${pending.size() == 0}">
									<div class="outer-btn deactivate">
										<p>Send Alerts <i class="fa-solid fa-bell"></i></p>
										<div class="loader"></div>
									</div>								
								</c:if>
							</div>
							<div class="heading">
								<p>Account No.</p>
								<p>Due Date</p>
								<p>EMI Amount</p>
							</div>
							<div class="pending-collections-div">
								<c:if test="${pending.size() == 0}">
									<div id="universal_no_results">
										<img class="small" src="/images/notfound.png" alt="" srcset="">
										<h2>No Pending EMIs !!</h2>
									</div>
								</c:if>
								<c:forEach items="${pending}" var="e">
									<div class="pending-collection">
										<p>${e.getAppliedUser().getAccount_no()}</p>
										<c:choose>
											<c:when test="${e.isDued()}">
												<p class="red">${e.getFormatedDate()}</p>
											</c:when>
											<c:otherwise>
												<p>${e.getFormatedDate()}</p>
											</c:otherwise>
										</c:choose>
										<p class="pending-amount">&#8377 ${e.getMonthlyEmi()}</p>
									</div>
								</c:forEach>
							</div>

						</div>
					</div>
				</div>
				<script>show_collection_chart('weekly');</script>
			</c:if>
			<c:if test="${tab == 'emi-calc'}">
				<div class="content emi-calculator">
					<div id="section-name">
						<h1>EMI Calculator ></h1>
					</div>
					<div id="emi-calculator-div">
						<div class="left">
							<div class="loan-input loan-type-div">
								<label for="loan-type">Loan Type</label>
								<div class="select-container">
									<div class="select" onclick="select_loan_type()">
										<input type="text" name="loan-type" id="loan-type"
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
									type="number" name="loan-amount" id="loan-amount"
									value="100000" min="10000" max="1000000"
									oninput="amount_change(this.value)"> <input
									type="range" name="loan-amount-slider" id="loan-amount-slider"
									value="100000" min="10000" max="1000000"
									oninput="amount_change(this.value)">
							</div>
							<div class="loan-input loan-interest-rate-div">
								<label for="loan-interest-rate">Interest Rate % (p.a)</label> <input
									type="number" name="loan-interest-rate" id="loan-interest-rate"
									value=36 onkeyup="calculateEMI()" disabled>
							</div>
							<div class="loan-input loan-tenure-div">
								<label for="loan-tenure">Loan Tenure (Yrs)</label> <input
									type="number" name="loan-tenure" id="loan-tenure"
									oninput="yr_change(this.value)" value="5" min="1" max="32">
								<input type="range" name="loan-tenure-slider"
									id="loan-tenure-slider" oninput="yr_change(this.value)"
									value="5" min="1" max="32">
							</div>
						</div>
						<div class="right">
							<div id="interest-pie-chart" class="interest-pie-chart">
								<canvas id="interest-pie-chart-canvas"></canvas>
							</div>
							<div class="interest-details">
								<div class="legends">
									<p>
										<span style="background-color: rgb(0, 208, 0);"></span> Total
										Interest
									</p>
									<p>
										<span style="background-color: rgb(225, 225, 225);"></span>
										Principal Amount
									</p>
								</div>
								<div class="counts">
									<div>
										<p>Monthly EMI :</p>
										<p id="monthly-emi-box"></p>
									</div>
									<div>
										<p>Total Interest :</p>
										<p id="total-interest-box"></p>
									</div>
									<div>
										<p>Total Amount :</p>
										<p id="total-amount-box"></p>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
				<script type="text/javascript">
	            let selectContainer = document.querySelector(".loan-type-div .select-container");
	            let select = document.querySelector(".loan-type-div .select-container .select");
	            let input = document.getElementById("loan-type");
	            let options = document.querySelectorAll(".loan-type-div .select-container .option");
	            options.forEach((e) => {
	                e.addEventListener("click", () => {
	                    input.value = e.innerText;
	                    loan_type_changed(input.value);
	                    calculateEMI();
	                    selectContainer.classList.remove("active");
	                    options.forEach((en) => {
	                        en.classList.remove("selected");
	                    });
	                    e.classList.add("selected");
	                });
	            });
	            var pie_chart = show_data([50, 50]);
	
	            calculateEMI();</script>

			</c:if>
			<c:if test="${tab == 'admin-loans'}">
				<div class="content admin-loans-page">
					<div id="section-name">
						<h1>Loans ></h1>
					</div>
					<div id="issue-new-loan">
						<div class="left">
							<h1>Issue New Loan</h1>
							<p>Directly Disburse New loan to the User.</p>
						</div>
						<div class="right">
							<a href="newLoan">New Loan <i
								class="fa-regular fa-paper-plane"></i></a>
						</div>
					</div>
					<div id="all-loans-container">
						<div class="left">
							<div class="title-filter">
								<p>User Loans</p>
							</div>
							<div class="heading">
								<p>Loan Id</p>
								<p>Account No</p>
								<p>Status</p>
								<p>Loan Amount</p>
							</div>
							<div class="loans-div">
								<c:if test="${loans.size() == 0}">
									<div id="universal_no_results">
										<img class="" src="/images/notfound.png" alt="" srcset="">
										<h2>No Pending EMIs !!</h2>
									</div>
								</c:if>
								<c:forEach items="${loans}" var="e">
									<c:set var="loanStatus" value="${e.getStatus()}"
										scope="session" />
									<div class="loan-info"
										onclick="window.location.href = '/single-loans/${e.getLid()}'">
										<p style="text-align: center;">#${e.getLid()}</p>
										<p>${e.getAppliedUser().getAccount_no()}</p>
										<p>
											<span id="spanFor${e.getLid()}"><script
													type="text/javascript">getDot("${e.getStatus()}", "spanFor${e.getLid()}")</script></span>${e.getStatus()}</p>
										<p>&#8377 ${e.getLoanAmount()}</p>
									</div>
								</c:forEach>
							</div>
						</div>
						<div class="right">
							<div class="title">
								<p>Loan Status Stats</p>
							</div>
							<div class="chart">
								<canvas id="loans-stats-chart"></canvas>
							</div>
							<div class="legends">
								<div class="legend">
									<span class="legend-color"
										style="--lclr: #ffb700; --lclr1: #ffb7006e; --lclr2: #ffb7001e;"></span>
									<p>Pending Loan</p>
								</div>
								<div class="legend">
									<span class="legend-color"
										style="--lclr: #32ffbb; --lclr1: #32ffbb6e; --lclr2: #32ffbb1e;"></span>
									<p>Approved Loan</p>
								</div>
								<div class="legend">
									<span class="legend-color"
										style="--lclr: #4da2ec; --lclr1: #4da2ec6e; --lclr2: #4da2ec1e;"></span>
									<p>Disbursed Loan</p>
								</div>
								<div class="legend">
									<span class="legend-color"
										style="--lclr: #00d40f; --lclr1: #00d40f6e; --lclr2: #00d40f1e;"></span>
									<p>Active Loan</p>
								</div>
								<div class="legend">
									<span class="legend-color"
										style="--lclr: #ff3232; --lclr1: #ff32326e; --lclr2: #ff32321e;"></span>
									<p>Rejected Loan</p>
								</div>
								<div class="legend">
									<span class="legend-color"
										style="--lclr: #a2a2a2; --lclr1: #a2a2a26e; --lclr2: #a2a2a21e;"></span>
									<p>Closed Loan</p>
								</div>
							</div>
						</div>
					</div>
				</div>
				<script>show_loan_stats(${count_array});</script>
			</c:if>
			<c:if test="${tab == 'New-Loan'}">
				<div class="content admin-issue-new-loan">
					<div id="section-name">
						<h1>Loans > Issue Loan</h1>
					</div>
					<form action="/adminSaveLoan" method="post"
						id="admin-user-loan-apply-form" enctype=multipart/form-data>
						<div class="main-container">
							<div id="admin-loan-page-1" class="admin-loan-page">
								<h2 class="heading">Select User</h2>
								<div class="user-search-box">
									<input type="text" name="user-search"
										id="add-loan-user-search-box"
										placeholder="Enter Account No or Name ....."
										onkeyup="getUsersToAdd()">
								</div>
								<div class="all-users-container">
									<div class="no-user-found">
										<a href="/adduser">Add User <i
											class="fa-solid fa-user-plus"></i></a>
									</div>
								</div>
							</div>
							<div id="admin-loan-page-2" class="admin-loan-page">
								<h2 class="heading">User & Loan Info</h2>
								<input type="number" id="account-no" name="user-account-no"
									hidden>
								<div class="input">
									<label for="fullname" class="focused">Full Name</label> <i
										class="fa-regular fa-user" for="fullname"></i> <input
										type="text" name="fullname" id="fullname"
										class="fullname default" autocomplete="nope">
								</div>
								<div class="single-line-inputs">
									<div class="input">
										<label for="email" class="focused">Email</label> <i
											class="fa-regular fa-envelope" for="email"></i> <input
											type="text" name="email" id="email" class="email default"
											autocomplete="nope">
									</div>
									<div class="input">
										<label for="phoneno" class="focused">Mobile</label> <i
											class="fa-solid fa-phone" for="phoneno"></i> <span>+91
											- </span> <input type="number" name="phoneno" id="phoneno"
											class="phoneno default" autocomplete="nope">
									</div>
								</div>
								<div class="single-line-inputs">
									<div class="loan-input loan-type-div">
										<label for="loan-type">Loan Type</label>
										<div class="select-container">
											<div class="select"
												onclick="$('.loan-type-div .select-container').toggleClass('active');">
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
											oninput="calculateEMILoanApply()">
									</div>
								</div>
								<div class="single-line-inputs">
									<div class="loan-input loan-interest-rate-div">
										<label for="loan-interest-rate">Interest Rate (p.a)</label> <input
											type="text" name="interestRate" id="loan-interest-rate"
											value="36 %" disabled>
									</div>
									<div class="loan-input loan-tenure-div">
										<label for="loan-tenure">Loan Tenure (Yrs)</label> <input
											type="number" name="loanTenure" id="loan-tenure"
											oninput="calculateEMILoanApply()" value="5" min="1" max="32">
									</div>
								</div>
								<div class="single-line-inputs">
									<div class="loan-input loan-monthlyEmi">
										<label for="monthlyEmi">Monthly EMI (&#8377)</label> <input
											type="number" placeholder="Select Loan Type"
											name="monthlyEmi" id="monthly-emi-input">
									</div>
									<div class="loan-input loan-totalInterest">
										<label for="totalInterest">Total Interest (&#8377)</label> <input
											type="number" placeholder="Select Loan Type"
											name="totalInterest" id="total-interest-input">
									</div>
								</div>
								<div class="single-line-inputs">
									<div class="loan-input loan-totalAmount">
										<label for="totalAmount">Total Amount (&#8377)</label> <input
											type="number" placeholder="Select Loan Type"
											name="totalAmount" id="total-amount-input">
									</div>

								</div>
							</div>
							<div id="admin-loan-page-3" class="admin-loan-page">
								<h2 class="heading">User Documents</h2>
								<div id="main-container">
									<div class="photo-upload">
										<label class="photo-label">Profile Photo</label> <img
											id="profile-photo-preveiw"
											src="/images/image-upload-icon.png" for="profile-photo"
											alt="Profile Photo">
										<p class="uploaded-file-name" id="profile-photo-file-name">No
											File Chosen</p>
										<label for="profile-photo" class="photo-label upload-btn">Upload</label>
										<input type="file" name="profile-photo" id="profile-photo"
											onchange="fileChosen(this, 'profile', 'admin-loan-page-3')"
											accept=".jpg, .png, .jpeg" hidden>
									</div>
									<div class="photo-upload">
										<label class="photo-label">Adhaar Card</label> <img
											id="adhaar-photo-preveiw" src="/images/image-upload-icon.png"
											for="adhaar-photo" alt="Adhaar Card Photo">
										<p class="uploaded-file-name" id="adhaar-photo-file-name">No
											File Chosen</p>
										<label for="adhaar-photo" class="photo-label upload-btn">Upload</label>
										<input type="file" name="adhaar-photo" id="adhaar-photo"
											onchange="fileChosen(this, 'adhaar', 'admin-loan-page-3')"
											accept=".jpg, .png, .jpeg" hidden>
									</div>
									<div class="photo-upload">
										<label class="photo-label">Pan Card</label> <img
											id="pan-photo-preveiw" src="/images/image-upload-icon.png"
											for="pan-photo" alt="Pan Card Photo">
										<p class="uploaded-file-name" id="pan-photo-file-name">No
											File Chosen</p>
										<label for="pan-photo" class="photo-label upload-btn">Upload</label>
										<input type="file" name="pan-photo" id="pan-photo"
											onchange="fileChosen(this, 'pan', 'admin-loan-page-3')"
											accept=".jpg, .png, .jpeg" hidden>
									</div>
								</div>
							</div>
							<div id="admin-loan-page-4" class="admin-loan-page">
								<h2 class="heading">Add 2 Guarantor (Jamindaar)</h2>
								<div id="guarantor-search-box" class="input">
									<label for="guarantor-search">Search Guarantor</label> <i
										class="fa-brands fa-searchengin" for="guarantor-search"></i> <input
										type="text" name="guarantor-search" id="guarantor-search"
										class="guarantor-search" onkeyup="search_guarantor(this)"
										onfocus="search_guarantor(this)" autocomplete="nope">
								</div>
								<div id="search-results">
									<div class="no-result-found">
										<img src="/images/no-results-found.png">
										<h3>No Result Found</h3>
									</div>
									<div class="results">
										<div class="result" onclick="select_guarantor(this)">
											<p class="g_name">Punam Sonawane</p>
											<p class="account_number display_none">2110001001</p>
											<button type="button">
												<i class="fa-solid fa-plus"></i>
											</button>
										</div>
									</div>
								</div>
								<div id="added-guarantors">
									<div id="no-guarantor-select">
										<img src="./images/no-select.svg" alt="" srcset="">
										<h3>Select 2 Guarantors</h3>
									</div>
								</div>
							</div>
							<div id="admin-loan-page-5" class="admin-loan-page"></div>
							<div class="prev-next-btns">
								<div class="prev-loan-page-btn" onclick="back_submit()">
									<i class="fa-solid fa-angle-left" aria-hidden="true"></i> Back
								</div>
								<div class="next-loan-page-btn" onclick="next_submit()">
									Next <i class="fa-solid fa-angle-right" aria-hidden="true"></i>
								</div>
							</div>

							<script>

                            var allUsers;

                            var selectedUser = null;

                            var current_page = 1;

                            var total_pages = 5;
                            
                            var gurantors_selected_acc_no = [];

                            for (var i = 1; i <= total_pages; i++) {
                                $("#admin-loan-page-" + i).hide();
                            }

                            $("#admin-loan-page-" + current_page).show();

                            $(".prev-loan-page-btn").hide();

                            let selectContainer = document.querySelector(".loan-type-div .select-container");
                            let select = document.querySelector(".loan-type-div .select-container .select");
                            let loan_type_input = $(".select-container #loan-type");
                            let options = document.querySelectorAll(".loan-type-div .select-container .option");

                            options.forEach((e) => {
                                e.addEventListener("click", () => {
                                    loan_type_input.val(e.innerText);
                                    calculateEMILoanApply();
                                    $(".loan-type-div .select-container").removeClass("active");
                                    options.forEach((en) => {
                                        en.classList.remove("selected");
                                    });
                                    e.classList.add("selected");
                                });
                            });

                            document.querySelectorAll('.main-container .input input').forEach(input => {
                                input.addEventListener('focus', () => {
                                    input.labels.forEach(label => {
                                        label.classList.add('focused');
                                    })
                                });


                                input.addEventListener('blur', () => {
                                    if (input.value == "") {
                                        input.labels.forEach(label => {
                                            label.classList.remove('focused');
                                        });
                                    }
                                });
                            });

                            document.querySelectorAll('input.default').forEach(input => {
                                input.disabled = true;
                                if (input.value != "") {
                                    input.focus()
                                    input.labels.forEach(label => {
                                        label.classList.add('focused');
                                    });
                                }

                                input.addEventListener('focus', () => {
                                    input.labels.forEach(label => {
                                        label.classList.add('focused');
                                    })
                                })

                                input.addEventListener('blur', () => {
                                    if (input.value == "") {
                                        input.labels.forEach(label => {
                                            label.classList.remove('focused');
                                        });
                                    }
                                })
                            });

                            window.addEventListener('click', function (e) {
                                if (!document.getElementById('search-results').contains(e.target) && !document.getElementById('guarantor-search-box').contains(e.target)) {
                                    $("#search-results").hide();
                                }
                            });

                            var current_guarantor = 1;
                            var guarantor_count = 0;
							


                        </script>
						</div>
					</form>

					<script>


                </script>
				</div>
			</c:if>
			<c:if test="${tab == 'single-loans'}">
				<div class="content admin-view-loan">
					<div id="section-name">
						<h1>Loans > ${loans.getLid()}</h1>
					</div>
					<div class="loan-info-container">
						<h3 class="heading">
							Loan Details - <i>#${loans.getLid()}</i>
						</h3>
						<div class="loan-details">
							<div class="loan-component">
								<p>Account No</p>
								<p>${loans.getAppliedUser().getAccount_no()}</p>
							</div>
							<div class="loan-component">
								<p>Applicant Name</p>
								<p>${loans.getAppliedUser().getFullname()}</p>
							</div>
							<div class="loan-component">
								<p>Mobile No.</p>
								<p>+91 ${loans.getAppliedUser().getContact()}</p>
							</div>
							<div class="loan-component">
								<p>Email Id</p>
								<p>${loans.getAppliedUser().getEmail()}</p>
							</div>
							<div class="loan-component">
								<p>Principal Amount</p>
								<p>&#8377 ${loans.getLoanAmount()}</p>
							</div>
							<div class="loan-component">
								<p>Status</p>
								<p class="loan-status">
									<span class="green-dot"></span>${loans.getStatus()}</p>
							</div>
							<div class="loan-component">
								<p>Monthly EMI</p>
								<p>&#8377 ${loans.getMonthlyEmi()}</p>
							</div>
							<div class="loan-component">
								<p>Loan Type</p>
								<p>${loans.getLoanType()}</p>
							</div>
							<div class="loan-component">
								<p>Total Amount</p>
								<p>&#8377 ${loans.getTotalAmount()}</p>
							</div>
							<div class="loan-component">
								<p>Interest Rate</p>
								<p>36% (p.a)</p>
							</div>
							<div class="loan-component">
								<p>Loan Tenure</p>
								<p>${loans.getLoanTenure()}Yrs</p>
							</div>
						</div>
						<h3 class="heading">Applicant Documents</h3>
						<div class="applicant-docs">
							<div class="applicant-doc">
								<p>Profile Photo</p>
								<span id="applicant-profile-photo-view-btn"
									onclick="show_image_preview(${loans.getAppliedUser().getAccount_no()}, '', 'UserProfile.jpg' , 'Applicant Profile Photo')">Verify</span>
							</div>
							<div class="applicant-doc">
								<p>Adhaar Card</p>
								<span id="applicant-adhaar-photo-view-btn"
									onclick="show_image_preview(${loans.getAppliedUser().getAccount_no()}, '', 'UserAdhaar.jpg', 'Applicant Adhaar Card')">Verify</span>
							</div>
							<div class="applicant-doc">
								<p>Pan Card</p>
								<span id="applicant-pan-photo-view-btn"
									onclick="show_image_preview(${loans.getAppliedUser().getAccount_no()}, '', 'UserPan.jpg', 'Applicant Pan Card')">Verify</span>
							</div>
						</div>
						<h3 class="heading">Guarantor Documents</h3>
						<div class="guarantors-docs">
							<div class="guarantor-1-div">
								<div>
									Guarantor 1 :
									<div class="guarantor-name">${loans.getGuarantor_1().getParentUser().getFullname()}</div>
								</div>
								<div class="guarantor-1-adhaar">
									<p>Adhaar Card</p>
									<p class="guarantor-1-adhaar-view-btn"
										onclick="show_image_preview(${loans.getAppliedUser().getAccount_no()}, ${loans.getGuarantor_1().getParentUser().getAccount_no()}, 'g_adhaar.jpg', 'Guarantor 1 Adhaar Card')">Verify</p>
								</div>
								<div class="guarantor-1-pan">
									<p>Pan Card</p>
									<p class="guarantor-1-pan-view-btn"
										onclick="show_image_preview(${loans.getAppliedUser().getAccount_no()}, ${loans.getGuarantor_1().getParentUser().getAccount_no()}, 'g_pan.jpg', 'Guarantor 1 Pan Card')">Verify</p>
								</div>
							</div>
							<div class="partition"></div>
							<div class="guarantor-2-div">
								<div>
									Guarantor 2 :
									<div class="guarantor-name">${loans.getGuarantor_2().getParentUser().getFullname()}</div>
								</div>
								<div class="guarantor-2-adhaar">
									<p>Adhaar Card</p>
									<p class="guarantor-2-adhaar-view-btn"
										onclick="show_image_preview(${loans.getAppliedUser().getAccount_no()}, ${loans.getGuarantor_2().getParentUser().getAccount_no()}, 'g_adhaar.jpg', 'Guarantor 2 Adhaar Card')">Verify</p>
								</div>
								<div class="guarantor-2-pan">
									<p>Pan Card</p>
									<p class="guarantor-2-pan-view-btn"
										onclick="show_image_preview(${loans.getAppliedUser().getAccount_no()}, ${loans.getGuarantor_2().getParentUser().getAccount_no()}, 'g_pan.jpg', 'Guarantor 2 Pan Card')">Verify</p>
								</div>
							</div>
						</div>
						<div class="status-change-btns">
							<div class="status-btn reject-loan-btn"
								onclick="change_status('Rejected',${loans.getLid()})"
								style="--stat-clr: #ff3232; --stat-clr2: #ff3232cc;">
								Reject <i class="fa-regular fa-circle-xmark"></i>
							</div>
							<div class="status-btn approve-loan-btn"
								onclick="change_status('Approved',${loans.getLid()})"
								style="--stat-clr: #8e67f0; --stat-clr2: #8e67f0cc;">
								Approve <i class="fa-regular fa-circle-check"></i>
							</div>
							<div class="status-btn approve-disburse-btn"
								onclick="change_status('Disbursed',${loans.getLid()})"
								style="--stat-clr: #00d40f; --stat-clr2: #00d40fcc;">
								Approve & Disburse <i class="fa-solid fa-check-double"></i>
							</div>
							<div class="status-btn disburse-loan-btn"
								onclick="change_status('Disbursed',${loans.getLid()})"
								style="--stat-clr: #00d40f; --stat-clr2: #00d40fcc;">
								Disburse <i class="fa-solid fa-check-double"></i>
							</div>
						</div>

						<div class="show-image" onclick="hide_image_preview()">
							<div class="hide-image-preview-div"
								onclick="hide_image_preview()">
								<i class="fa-regular fa-circle-xmark"></i>
							</div>
							<div class="outer-div">
								<h2 class="image-name">Applicant Profile</h2>
								<div class="preview-img-div">
									<img src="" alt="" class="preview-image">
								</div>
							</div>
						</div>
					</div>

				</div>
				<script>change_status_btns("${loans.getStatus()}");</script>
			</c:if>
			<c:if test="${tab == 'Users'}">
				<div class="content admin-users-page">
					<div id="section-name">
						<h1>Users ></h1>
					</div>
					<div class="users-container">
						<div class="heading">
							<h2>All Users</h2>
							<a href="adduser" class="add-new-user-btn">Add User +</a>
						</div>
						<div class="search-filter-container">
							<div class="search-box-div">
								<input type="text" name="search-user" id="search-user-for-admin"
									onkeyup="getUsers()"
									placeholder="Enter Account No or Name ....">
								<div class="search-user-btn" onclick="getUsers()">
									<i class="fa-solid fa-magnifying-glass"></i>
								</div>
							</div>
							<!-- <div class="filters">
                            <i class="fa-solid fa-arrow-up-wide-short"></i>
                            <i class="fa-solid fa-arrow-down-short-wide"></i>
                        </div> -->
						</div>
						<div class="table-heading">
							<p>Account No</p>
							<p>Name</p>
							<p>Email Id</p>
							<p>Balance</p>
						</div>
						<div class="all-users-display"></div>
					</div>
				</div>
				<script>
            getUsers("allusers");
            </script>

				<!--  
				<a href="convertTopdf">Convert</a>
				-->
			</c:if>
			<c:if test="${tab == 'fund'}">
				<div class="content admin-funds-page">
					<div id="section-name">
						<h1>Funds ></h1>
					</div>

					<div class="wallet-div">
						<img src="/images/wallet-rupees.png" alt="" srcset="">
						<div class="balance">
							<p>Wallet Balance</p>
							<h2 id="admin-fund-page-wallet-balance">&#8377
								${nbfc.getWalletBalance()}</h2>
						</div>
						<button onclick="openAddMoneyAdmin()">Add Money +</button>
					</div>

					<div id="add-money-container" onclick="closeAddMoney()">
						<div class="add-money-form"
							onclick="window.event.stopPropagation();">
							<p>Add Money</p>
							<div class="input">
								<label for="addMoneyAmount">Amount</label> <i
									class="fa-solid fa-indian-rupee-sign" for="amount"></i> <input
									type="number" name="addMoneyAmount" id="addMoneyAmount"
									class="addMoneyAmount">
							</div>
							<button class="add-money-btn" onclick="addMoney()">Add
								Money</button>
						</div>
					</div>

					<div class="transactions" id="transactions">
						<div class="heading">
							<h2>All Transactions</h2>
							<c:if test="${transaction.size() == 0}">
								<a href="/api/admin/download_pdf" target="_blank"
									class="disabled">Transactions &nbsp;<i
									class="fa-regular fa-file-pdf"></i></a>
							</c:if>
							<c:if test="${transaction.size() != 0}">
								<a href="/api/admin/download_pdf" target="_blank">Transactions
									&nbsp;<i class="fa-regular fa-file-pdf"></i>
								</a>
							</c:if>
						</div>
						<div class="transactions-div">
							<div class="transaction-heading">
								<p>Trans. ID</p>
								<p>Details</p>
								<p>Credit/Debit</p>
								<p>From/To</p>
								<p>Date & Time</p>
								<p>Amount</p>
							</div>
							<div class="transactions-table">
								<c:if test="${transaction.size() == 0}">
									<div id="universal_no_results">
										<img class="small" src="/images/notfound.png" alt="" srcset="">
										<h2>Opss!! No Transactions Yet</h2>
									</div>
								</c:if>
								<c:forEach items="${transaction}" var="e">
									<div class="transaction">
										<p>${e.getTid()}</p>
										<p>${e.getMessages()}</p>
										<c:if test="${e.getSender().getAccount_no() == 211001000}">
											<p>Debited</p>
											<p>${e.getReceiver().getAccount_no()}</p>
											<p>${e.getFormatedDate()}</p>
											<p class="red">- &#8377 ${e.getAmount()}</p>
										</c:if>
										<c:if test="${e.getReceiver().getAccount_no() == 211001000}">
											<p>Credited</p>
											<p>${e.getSender().getAccount_no()}</p>
											<p>${e.getFormatedDate()}</p>
											<p class="green">+ &#8377 ${e.getAmount()}</p>
										</c:if>

									</div>

								</c:forEach>

							</div>
						</div>
					</div>
				</div>
				<script type="text/javascript">
				
					 function openAddMoneyAdmin(){
	                     var container = $('.admin-funds-page #add-money-container');
	                     
	                     container.css('display', 'flex');
	                     container.css('transform', 'scale(1)');
	                 }
	                 
	                 function closeAddMoney(){
	                     var container = $('.admin-funds-page #add-money-container');
	                     container.css('transform', 'scale(0)');
	
	                     $('.admin-funds-page #add-money-container #addMoneyAmount').val('');
	                 }
	
	                 function addMoney() {
	                     window.event.stopPropagation();
	
	                     var addMoneyValue = $('.admin-funds-page #add-money-container #addMoneyAmount').val();
	
	                     //alert(addMoneyValue);
	
	                     payload = {
	                         //'amount': parseFloat(addMoneyValue),
	                     }
	
	                     $.ajax({
	                         type: "GET",
	                         contentType: "application/json",
	                         url: "/api/admin/addMoney/" + parseFloat(addMoneyValue),
	                         dataType: 'json',
	                         cache: false,
	                         timeout: 600000,
	                         success: function (data) {
	
	                             var container = $('.admin-funds-page #add-money-container');
	                             container.css('transform', 'scale(0)');
	
	                             $('.admin-funds-page #add-money-container #addMoneyAmount').val('');
	                             
	                             $('.admin-funds-page .wallet-div #admin-fund-page-wallet-balance').html('&#8377 ' + data['walletBalance'] + '.0');
	                         }
	                 	});
	
	
	                 }

			        function converttoPDF() {
			
			            const { jsPDF } = window.jspdf;
			 
			
			            let doc = new jsPDF('l', 'mm', [1500, 1400]);
			
			            let pdfjs = document.querySelector('.transactions-div');
			 	
			
			            doc.html(pdfjs, {
							
			                callback: function(doc) {
			
			                    doc.save("newpdf.pdf");
			
			                },
			               
			                x: 12,
			
			                y: 12
			
			            });                
			
			        }      
			        
			        document.querySelectorAll('.admin-funds-page #add-money-container .add-money-form .input input').forEach(input => {
			            input.addEventListener('focus', () => {
			                input.labels.forEach(label => {
			                    label.classList.add('focused');
			                })
			            })
			
			            input.addEventListener('blur', () => {
			                if (input.value == "") {
			                    input.labels.forEach(label => {
			                        label.classList.remove('focused');
			                    });
			                }
			            })
			        }); 
			
			    </script>
			</c:if>
			<c:if test="${tab == 'AddUser'}">

				<div class="content admin-add-user-page">
					<div id="section-name">
						<h1>Users > Add User</h1>
					</div>
					<div class="register-form">
						<h3>Register New User</h3>
						<form action="addAdminUser" method="post" class="form"
							id="customer-registration-form">
							<div class="input">
								<label for="fullname">Full Name</label> <i
									class="fa-regular fa-user" for="fullname"></i> <input
									type="text" name="fullname" id="fullname" class="fullname"
									autocomplete="nope">
							</div>
							<div class="partition">
								<div class="dob-input">
									<div id="date_picker">
										<div id="date_picker_input">
											<label><i class="fa-solid fa-calendar-days"></i> Date
												of Birth</label> <input name="dob" type="text" id="date"
												class="onFocus" readonly />
											<p class="up-down-icon">
												<i class="fa-solid fa-caret-down"></i>
											</p>
										</div>
										<div id="date_picker_calendar" class="hidden">
											<div id="calendar_header">
												<div class="back-btns">
													<button type="button" class="cal-btn yr-back"><<</button>
													<button type="button" class="cal-btn back"><</button>
												</div>
												<span></span>
												<div class="front-btns">
													<button type="button" class="cal-btn front">></button>
													<button type="button" class="cal-btn yr-front">>></button>
												</div>
											</div>
											<div id="cal_wrapper">
												<div id="cal_days"></div>
												<div id="calendar_main"></div>
											</div>
										</div>
									</div>
								</div>
								<div class="gender-input">
									<i class="fa-solid fa-venus-mars"></i>
									<p class="gender-label">Gender</p>
									<input type="radio" name="gender" id="male" class="male"
										value="Male"> <label for="male"><i
										class="fa-solid fa-mars"></i> Male</label> <input type="radio"
										name="gender" id="female" class="female" value="Female">
									<label for="female"><i class="fa-solid fa-venus"></i>
										Female</label>
								</div>
							</div>
							<div class="partition">
								<div class="input">
									<label for="email">Email</label> <i
										class="fa-regular fa-envelope" for="email"></i> <input
										type="text" name="email" id="email" class="email"
										autocomplete="nope">
								</div>
								<div class="input">
									<label for="phoneno">Mobile</label> <i
										class="fa-solid fa-phone" for="phoneno"></i> <span>+91
										- </span> <input type="number" name="contact" id="phoneno"
										class="phoneno" autocomplete="nope">
								</div>
							</div>
							<div class="input">
								<label for="address">Address</label><i
									class="fa-solid fa-location-dot"></i> <input type="text"
									name="address" id="address" class="address" autocomplete="nope">
							</div>
							<button type="button" class="register-submit"
								onclick="validateAdminUser()">Register</button>
						</form>
					</div>
				</div>
				<script>
        // Add User 
        document.querySelectorAll('.admin-add-user-page .register-form form input').forEach(input => {
            input.addEventListener('focus', () => {
                input.labels.forEach(label => {
                    label.classList.add('focused');
                })
            })

            input.addEventListener('blur', () => {
                if (input.value == "") {
                    input.labels.forEach(label => {
                        label.classList.remove('focused');
                    });
                }
            })
        }); 
   </script>

				<script src="/CSS/calender.js"></script>
			</c:if>
		</div>



	</section>

</body>

</html>
