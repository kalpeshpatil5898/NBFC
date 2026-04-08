// Menu Handler For Admin

function updateActiveTab(tab) {

	var tabs = document.querySelectorAll('#side-bar #side-bar-list li');

	d = {
		'Dashboard': 0,
		'admin-loans': 1,
		'New-Loan': 1,
		'single-loans': 1,
		'Users': 2,
		'AddUser': 2,
		'emi-calc': 3,
		'fund': 4
	}

	//tabs.classList.remove('active');

	tabs.forEach((el) => el.classList.remove('active'));

	tabs[d[tab]].classList.add('active');

}





//show_collection_chart();

//var pie_chart = show_data([50, 50]);

//calculateEMI();

function show_collection_chart(type) {

	const weekly_btn = $('.daily-chart-btn');
	const monthly_btn = $('.monthly-chart-btn');

	if (type == 'weekly') {
		weekly_btn.addClass('chart-active');
		monthly_btn.removeClass('chart-active');
	}
	else {
		weekly_btn.removeClass('chart-active');
		monthly_btn.addClass('chart-active');
	}

	const Utils = ChartUtils.init();


	let chartStatus = Chart.getChart("daily-monthly-collection-chart");

	if (chartStatus != undefined) {
		chartStatus.destroy();
	}

	const chart = document.getElementById("daily-monthly-collection-chart");

	const DATA_COUNT = 7;
	const NUMBER_CFG = { count: DATA_COUNT, min: 0, max: 100 };

	var labels = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];

	var data_points = [20, 70, 50, 65, 40, 60, 35, 20, 75, 50, 65, 10, 60, 35]

	// Get data from server

	var search = {
		"type": type,
	}

	$.ajax({
		type: "POST",
		contentType: "application/json",
		url: "/api/admin/getCollectionsData",
		data: JSON.stringify(search),
		dataType: 'json',
		cache: false,
		timeout: 600000,
		success: function(data) {
			//console.log(data['values']);
			data_points = data['values'];
			labels = data['labels'];
			//console.log(labels);

			const dataCol = {
				labels: labels,
				datasets: [
					{
						label: 'Collection',
						data: data_points,
						borderColor: "rgb(0, 208, 0)",
						backgroundColor: Utils.transparentize("rgb(0, 208, 0)", 0.85),
						borderWidth: 2,
						borderRadius: 5,
						borderSkipped: false,
						pointRadius: 5,
						pointHoverRadius: 8,
						cubicInterpolationMode: 'monotone',
						tension: 0.4,
						fill: true
					}
				]
			};

			const config = {
				type: 'line',
				data: dataCol,
				options: {
					responsive: true,
					plugins: {
						legend: {
							display: false,
							position: 'top',
						},
						title: {
							display: false,
							text: 'Collections'
						}
					},
					scales: {
						x: {
							grid: {
								display: false,
							},
							ticks: {
								callback: function(val, index) {
									if (type == 'monthly') {
										return index % 6 == 0 || index == 29 ? this.getLabelForValue(val).substring(0, 6) : null;
									}

									return this.getLabelForValue(val).split(" ")[0].replace(",", "");
								}
							}
						},
						y: {
							grid: {
								display: true,
							},
							min: 0,
						},
					},

				},
			};

			return new Chart(chart, config);
		}
	});


}

function select_loan_type() {
	selectContainer.classList.toggle("active");
}


function show_data(points) {
	const chart = document.getElementById("interest-pie-chart-canvas");

	let chart_data = {
		labels: ["Total Interest", "Principal Amount"],
		data: points,
		bgColor: ["rgb(0, 208, 0)", "rgb(225, 225, 225)"]
	}

	return new Chart(chart, {
		type: "doughnut",
		data: {
			labels: chart_data.labels,
			datasets: [
				{
					label: "Amount",
					data: chart_data.data,
					borderWidth: 5,
					borderRadius: 2,
					hoverBorderWidth: 0,
					backgroundColor: chart_data.bgColor,
					borderColor: 'rgb(248, 248, 248)',
				}
			]
		},
		options: {

			plugins: {
				legend: {
					display: false
				}
			}
		}
	});

}

let interest_rate = 0;

function loan_type_changed(type) {
	if (type == "Home Loan") {
		interest_rate = 36;
	}
	else if (type == "Car Loan") {
		interest_rate = 36;
	}
	else if (type == "Personal Loan") {
		interest_rate = 36;
	}

	$("#loan-interest-rate").val(interest_rate)
}

function amount_change(amt) {
	$("#loan-amount").val(amt);
	$("#loan-amount-slider").val(amt);
	calculateEMI();
}

function yr_change(yr) {
	$('#loan-tenure').val(yr);
	$('#loan-tenure-slider').val(yr);
	calculateEMI();
}

function calculateEMI() {
	principal = parseInt($("#loan-amount").val());
	rate_yr = parseInt($("#loan-interest-rate").val());
	tenure_yr = parseInt($("#loan-tenure").val());

	if (isNaN(rate_yr)) {
		rate_yr = 0.00000001;
	}

	rate_m = (rate_yr / 12) / 100;
	tenure_m = tenure_yr * 12;

	monthly_emi = Math.round((principal * rate_m * (Math.pow((1 + rate_m), tenure_m))) / ((Math.pow((1 + rate_m), tenure_m)) - 1));

	total_amount = monthly_emi * tenure_m;

	total_interest = total_amount - principal;

	$("#monthly-emi-box").html("&#8377 " + monthly_emi + ".0");
	$("#total-interest-box").html("&#8377 " + total_interest + ".0")
	$("#total-amount-box").html("&#8377 " + total_amount + ".0");

	pie_chart.data.datasets[0].data = [total_interest, principal];

	pie_chart.update();

}





// Loans Status Pie Chart

//show_loan_stats();

function show_loan_stats(count) {
	var chart = document.getElementById("loans-stats-chart");

	let chart_data = {
		labels: ["Pending Approval Loans", "Approved Loans", "Disbursed Loans", "Active Loans", "Rejected Loans", "Closed Loans"],
		data: count,
		bgColor: ["#ffb700", "#32ffbb", "#4da2ec", "#00d40f", "#ff3232", "#a2a2a2"]
	}
	//console.log(count);
	var config = {
		type: "pie",
		data: {
			labels: chart_data.labels,
			datasets: [
				{
					label: "Amount",
					data: chart_data.data,
					borderWidth: 4,
					borderRadius: 2,
					hoverBorderWidth: 0,
					backgroundColor: chart_data.bgColor,
					borderColor: 'rgb(255,255,255)',
				}
			]
		},
		options: {

			plugins: {
				legend: {
					display: false
				}
			}
		}
	};

	return new Chart(chart, config);
}

function getUsers(defaultArg = "") {
	var search_box = $("#search-user-for-admin");

	var text = search_box.val();

	text = "%" + text + "%";

	var search = {};

	search["searchString"] = text;

	var results_div = $(".admin-users-page .users-container .all-users-display");

	$.ajax({
		type: "POST",
		contentType: "application/json",
		url: "/api/getUsers",
		data: JSON.stringify(search),
		dataType: 'json',
		cache: false,
		timeout: 600000,
		success: function(data) {

			results_div.html("");

			if (data["users"].length == 0) {
				var nouserdiv = `<div id="universal_no_results">
												<img class="" src="/images/notfound.png" alt="" srcset="">
												<h2>Opss!! No Users Found</h2>
											</div>`;

				results_div.html(nouserdiv);
			}

			for (let i in data["users"]) {

				var user = data["users"][i];

				var user_div = `<div class="users-div">
                                                <p>${user["account_no"]}</p>
                                                <p>${user["fullname"]}</p>
                                                <p>${user["email"]}</p>
                                                <p>&#8377 ${user["balance"]}.0</p>
                                            </div>`;

				results_div.append(user_div);

			}
		}
	});

}


// Loan Status Change Div


function change_status_btns(status) {
	var reject_btn = $('.status-btn.reject-loan-btn');
	var approve_btn = $('.status-btn.approve-loan-btn');
	var approve_disburse_btn = $('.status-btn.approve-disburse-btn');
	var disburse_btn = $('.status-btn.disburse-loan-btn');

	var status_div = $('.loan-component .loan-status');

	var d = {
		'Pending': 'yellow',
		'Approved': 'cyan',
		'Disbursed': 'blue',
		'Active': 'green',
		'Rejected': 'red',
		'Closed': 'grey'
	}

	var dot_class = d[status];

	reject_btn.hide();
	approve_btn.hide();
	approve_disburse_btn.hide();
	disburse_btn.hide();

	if (status == "Pending") {
		reject_btn.show();
		approve_btn.show();
		approve_disburse_btn.show();

	}
	else if (status == "Approved") {
		disburse_btn.show();
	}

	status_div.html(`<span class="${dot_class}-dot"></span> ${status}`);

}

function change_status(status, loanid) {

	var search = {};

	search['status'] = status;

	search['loanid'] = loanid;

	$.ajax({
		type: "POST",
		contentType: "application/json",
		url: "/api/admin/changeStatus",
		data: JSON.stringify(search),
		dataType: 'json',
		cache: false,
		timeout: 600000,
		success: function(data) {

			//console.log(status);
			change_status_btns(status);

		}
	});
}

function show_image_preview(user_id, guarantor_id, photo_name, heading) {
	var show_image_div = $('.show-image');
	var preview_image = $('.show-image .preview-image');
	var heading_div = $(".show-image .image-name");

	heading_div.text(heading);
	//console.log(guarantor_id);
	var path = "/documents/" + user_id + "/";

	if (guarantor_id != "") {
		path += "G" + guarantor_id + "/";
	}
	//console.log(user_id);
	path += photo_name;

	preview_image.attr("src", path);

	//console.log(path);

	show_image_div.show();
	show_image_div.css("transform", "scale(1)");
}

function hide_image_preview() {
	var show_image_div = $('.show-image');
	var cross_btn = $('.show-image .hide-image-preview-div');

	show_image_div.css("transform", "scale(0)");
	setTimeout(() => {
		show_image_div.hide();
	}, 300);
}

function validateAdminUser() {
	var form = $('.admin-add-user-page #customer-registration-form');

	form.submit();
	return true;
}

//New Loan

function selectUser(userbox, index) {

	$('.user-info').removeClass('selected-user');

	$(userbox).addClass('selected-user');
	selectedUser = allUsers[index];

	setUserImages(selectedUser);
}


function getUsersToAdd() {
	var search_box = $("#add-loan-user-search-box");

	var text = search_box.val();

	var results_div = $(" #admin-loan-page-1 .all-users-container");

	if (text == "") {
		results_div.html(`<div class="no-user-found">
                                <a href="/adduser">Add User <i class="fa-solid fa-user-plus"></i></a>
                                </div>`);
		return;
	}

	text = "%" + text + "%";

	var search = {};

	search["searchString"] = text;

	$.ajax({
		type: "POST",
		contentType: "application/json",
		url: "/api/getUsers",
		data: JSON.stringify(search),
		dataType: 'json',
		cache: false,
		timeout: 600000,
		success: function(data) {

			allUsers = data["users"];

			selectedUser = null;

			results_div.html("");
			//console.log(results_div);

			if (data["users"].length == 0) {
				results_div.html(`<div class="no-user-found">
		                                <a href="/adduser">Add User <i class="fa-solid fa-user-plus"></i></a>
		                                </div>`);
			}

			for (let i in data["users"]) {

				var user = data["users"][i];

				var user_div = `<div class="user-info" onclick="selectUser(this, ${i})">
                                                        <p class="sno">${parseInt(i) + 1}</p>
                                                        <p class="accno">${user["account_no"]}</p>
                                                        <p class="name">${user["fullname"]}</p>
                                                        <p class="add-user"><i class="fa-solid fa-plus"></i></p>
                                                        <p><i class="fa-solid fa-check"></i></p>
                                                    </div>`;

				results_div.append(user_div);

			}
		}
	});

}

function back_page() {
	this_page = "#admin-loan-page-" + current_page;
	target_page = "#admin-loan-page-" + (current_page - 1);

	$(this_page).hide();

	$(target_page).show();

	current_page--;

}

function next_page() {
	this_page = "#admin-loan-page-" + current_page;
	target_page = "#admin-loan-page-" + (current_page + 1);

	$(this_page).hide();

	$(target_page).show();

	current_page++;
}

function back_submit() {

	$(".next-loan-page-btn").html("Next &nbsp;<i class='fa-solid fa-angle-right'></i>");

	if (current_page != 1) {
		back_page();
	}

	if (current_page == 1) {
		$(".prev-loan-page-btn").hide();
	}
}

function next_submit() {

	if (current_page == 5) {
		$('#admin-user-loan-apply-form').submit();
	}

	if (current_page == 4) {
		if (guarantor_count != 2) {
			alert(`Please add ${2 - guarantor_count} Guarantor`);
			return;
		}

		$("#admin-loan-page-5").html("");

		var heading = '<h2 class="heading">Guarantor Documents</h2>';

		$("#admin-loan-page-5").append(heading, getDocsDiv(1), getDocsDiv(2));

	}

	if (current_page == 1) {
		if (selectedUser == null) {
			alert("Please select the User to issue loan.");
			return;
		}

		$('#admin-loan-page-2 #account-no').val(selectedUser['account_no']);
		$('#admin-loan-page-2 #fullname').val(selectedUser['fullname']);
		$('#admin-loan-page-2 #email').val(selectedUser['email']);
		$('#admin-loan-page-2 #phoneno').val(selectedUser['contact']);


	}

	$(".next-loan-page-btn").html("Next &nbsp;<i class='fa-solid fa-angle-right'></i>");


	if (current_page != total_pages) {
		next_page();
	}

	if (current_page == total_pages) {
		$(".next-loan-page-btn").html("Submit &nbsp;<i class='fa-solid fa-angle-right'></i>");
	}

	if (current_page != 1) {
		$(".prev-loan-page-btn").show();
	}


}


function setUserImages(user) {
	var profile_photo = $('#admin-loan-page-3 #profile-photo-preveiw');
	var adhaar_photo = $('#admin-loan-page-3 #adhaar-photo-preveiw');
	var pan_photo = $('#admin-loan-page-3 #pan-photo-preveiw');

	if (user['profile_photo'] != null) {
		profile_photo.attr("src", "/documents/" + user['account_no'] + "/UserProfile.jpg");
	}
	if (user['adhaar_photo'] != null) {
		adhaar_photo.attr("src", "/documents/" + user['account_no'] + "/UserAdhaar.jpg");
	}
	if (user['pan_photo'] != null) {
		pan_photo.attr("src", "/documents/" + user['account_no'] + "/UserPan.jpg");
	}
}

function calculateEMILoanApply() {

	principal = parseInt($("#admin-loan-page-2 #loan-amount").val());
	rate_yr = 36;
	tenure_yr = parseInt($("#admin-loan-page-2 #loan-tenure").val());

	if (isNaN(rate_yr)) {
		rate_yr = 0.00000001;
	}

	rate_m = (rate_yr / 12) / 100;
	tenure_m = tenure_yr * 12;

	monthly_emi = Math.round((principal * rate_m * (Math.pow((1 + rate_m), tenure_m))) / ((Math.pow((1 + rate_m), tenure_m)) - 1));

	total_amount = monthly_emi * tenure_m;

	total_interest = total_amount - principal;

	$("#admin-loan-page-2 #monthly-emi-input").val(parseInt(monthly_emi));
	$("#admin-loan-page-2 #total-interest-input").val(parseInt(total_interest))
	$("#admin-loan-page-2 #total-amount-input").val(parseInt(total_amount));

}

function fileChosen(ip, type, section) {

	if (section == "documents-content") {
		$('#profile-doc-save-btn').prop('disabled', false);
		$('#profile-doc-save-btn').addClass("activeBtn");
	}

	// console.log("#" + section + " #" + type + "-photo-file-name")
	$("#" + section + " #" + type + "-photo-file-name").text(ip.files[0].name);

	img = $("#" + section + " #" + type + "-photo-preveiw");
	img.addClass("active-image");

	if (ip.files[0].type == "application/pdf") {
		img.attr('src', 'pdf-file-icon.png');
	}
	else {

		var reader = new FileReader();

		reader.onload = function(e) {
			img.attr('src', e.target.result);
		};

		reader.readAsDataURL(ip.files[0]);

	}
}

function search_guarantor(search_box) {
	var search_box = $(search_box);

	if (search_box.val() == "") {
		$("#admin-loan-page-4 #search-results").hide();
	}
	else {


		$("#admin-loan-page-4 #search-results").show();

		console.log(gurantors_selected_acc_no);


		var text = search_box.val();

		text = "%" + text + "%";

		var search = {};

		search["searchString"] = text;
		var no_result_div = $("#admin-loan-page-4 #search-results .no-result-found");
		var results_div = $("#admin-loan-page-4 #search-results .results");

		no_result_div.show();
		results_div.hide();

		$.ajax({
			type: "POST",
			contentType: "application/json",
			url: "/api/getUsers",
			data: JSON.stringify(search),
			dataType: 'json',
			cache: false,
			timeout: 600000,
			success: function(data) {

				json = JSON.stringify(data, null, 4);

				if (data["msg"] == "No user found") {
					no_result_div.show();
					no_result_div.css("display", 'flex');
					results_div.hide();

				}
				else {
					no_result_div.hide();
					results_div.show();

					results_div.html("");

					var cnt = 0;

					for (let i in data["users"]) {

						var user = data["users"][i];

						var user_div = `<div class="result" onclick="select_guarantor(this)">
                                                        <p class="g_name">${user["fullname"]}</p>
                                                        <p class="account_number">${user["account_no"]}</p>
                                                        <button type="button"><i class="fa-solid fa-plus"></i> </button>
                                                    </div>`;

						if (!gurantors_selected_acc_no.includes(user["account_no"]) && selectedUser['account_no'] != user["account_no"]) {
							results_div.append(user_div);
							cnt++;
						}

					}

					if (cnt == 0) {
						no_result_div.show();
						no_result_div.css("display", 'flex');
						results_div.hide();
					}
				}

			},
			error: function(e) {

				var json = e.responseText;

			}
		});

	}

}

function hide_results() {
	$("#search-results").hide();
}

function select_guarantor(element) {


	if (guarantor_count == 0) {
		$("#no-guarantor-select").hide();
	}

	if (guarantor_count == 2) {
		alert("You can add 2 guarantors only.");
		return;
	}

	var g_name = $(element).children(".g_name").text();
	var acc_no = parseInt($(element).children(".account_number").text());

	var add_guarantor_div = $("#added-guarantors");

	new_element = `<div id="select_guarantor_${current_guarantor}_div" class="selected-guarantor"><p>${g_name}</p>
                        <input type="number" name="guarantor_${current_guarantor}" id="guarantor_${current_guarantor}" value="${acc_no}" hidden>
                        <button type="button" onclick="deleteGuarantor(this, ${current_guarantor}, ${acc_no})"><i class="fa-solid fa-xmark"></i> </button></div>`;

	add_guarantor_div.append(new_element);

	current_guarantor++;
	guarantor_count++;

	gurantors_selected_acc_no.push(acc_no);

	$("#search-results").hide();
}

function deleteGuarantor(guarantor, g_no, gaccno) {
	current_guarantor = g_no;
	guarantor_count--;

	gurantors_selected_acc_no = gurantors_selected_acc_no.filter(item => item !== gaccno);

	$(guarantor).parent().remove();
	if (guarantor_count == 0) {
		$("#no-guarantor-select").show();
	}
}

function getDocsDiv(guarantor_no) {
	var main_get_div = $("#select_guarantor_" + guarantor_no + "_div");

	var g_name = main_get_div.children("p").text();
	var g_accno = main_get_div.children("input").val();

	var g_fname = g_name.split(" ")[0];

	var user_account_no = selectedUser['account_no'];

	// var user_account_no = "";

	var doc_upload_div = `<div id="guarantor-${guarantor_no}-docs" class="guarantor-docs">
                                            <h3 id="guarantor-name">${g_fname}'s Documents</h3>
                                            <div class="docs-div">
                                                <div class="guarantor-adhaar-upload">
                                                    <label class="adhaar-label">${g_fname}'s Adhaar Photo</label>
                                                    <div>
                                                        <img id="adhaar-photo-preveiw" src="/documents/${user_account_no}/G${g_accno}/g_adhaar.jpg" onerror="this.onerror=null; this.src='/images/image-upload-icon.png';" for="guarantor-${guarantor_no}-adhaar-photo" alt="Adhaar Photo">
                                                        <div>
                                                            <p class="uploaded-file-name" id="adhaar-photo-file-name">No File
                                                                Chosen</p>
                                                            <label for="guarantor-${guarantor_no}-adhaar-photo"
                                                                class="photo-label upload-btn">Upload</label>
                                                            <input type="file" name="guarantor-${guarantor_no}-adhaar-photo" id="guarantor-${guarantor_no}-adhaar-photo"
                                                                onchange="fileChosen(this, 'adhaar', 'guarantor-${guarantor_no}-docs')"
                                                                accept=".jpg, .png, .jpeg" hidden>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="guarantor-pan-upload">
                                                    <label class="pan-label">${g_fname}'s Pan Photo</label>
                                                    <div>
                                                        <img id="pan-photo-preveiw" src="/documents/${user_account_no}/G${g_accno}/g_pan.jpg" onerror="this.onerror=null; this.src='/images/image-upload-icon.png';" for="guarantor-${guarantor_no}-pan-photo" alt="Pan Photo">
                                                        <div>
                                                            <p class="uploaded-file-name" id="pan-photo-file-name">No File
                                                                Chosen</p>
                                                            <label for="guarantor-${guarantor_no}-pan-photo" class="photo-label upload-btn">Upload</label>
                                                            <input type="file" name="guarantor-${guarantor_no}-pan-photo" id="guarantor-${guarantor_no}-pan-photo"
                                                                onchange="fileChosen(this, 'pan', 'guarantor-${guarantor_no}-docs')"
                                                                accept=".jpg, .png, .jpeg" hidden>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>`;

	return doc_upload_div;

}

function getDot(status, element) {

	var d = {
		'Pending': 'yellow',
		'Approved': 'cyan',
		'Disbursed': 'blue',
		'Active': 'green',
		'Rejected': 'red',
		'Closed': 'grey',
	}

	var dot_class = d[status];

	var ele = "#" + element;

	$(ele).addClass(dot_class + "-dot");

	// console.log(ele);


}



function sendAlerts(btn) {

	var btn_txt = $('.content #charts-analytics .right-chart .h3 .outer-btn p');
	var loader = $('.content #charts-analytics .right-chart .h3 .outer-btn .loader');

	var toast = $('header #toast');

	$(btn).css("pointer-events", "none");

	btn_txt.hide();
	loader.show();

	$.ajax({
		type: "GET",
		contentType: "application/json",
		url: "/api/admin/sendAlerts",
		dataType: 'json',
		cache: false,
		timeout: 600000,
		success: function(data) {
		
			setTimeout(() => {

				toast.addClass('activate');
				$(btn).addClass("deactivate");
				$(btn).css("pointer-events", "none");
				$(btn).removeAttr('onclick');
				btn_txt.show();
				loader.hide();
	
				//console.log(data);
			
			}, 3000);

		}
	});

}




