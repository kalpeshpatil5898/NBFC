// Menu Handler For User

function updateActiveTab(tab){

	var tabs = document.querySelectorAll('#side-bar #side-bar-list li');
	
	d = {
		'home': 0,
		'UserTransferMoney':0,
		'profile':1,
		'loans':2,
		'UserLoan':2,
		'repayment': 3
	}
	
	//tabs.classList.remove('active');
	
	tabs.forEach((el) => el.classList.remove('active'));
	
	tabs[d[tab]].classList.add('active');

}







        // Guarantor Selection 



        function search_guarantor(search_box) {
            var search_box = $(search_box);

            if (search_box.val() == "") {
                $("#search-results").hide();
            }
            else {

                $("#search-results").show();

                var text = search_box.val();
            
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
                    success: function (data) {

                        json = JSON.stringify(data, null, 4);
                        //console.log(data["users"]);

                        var no_result_div = $("#search-results .no-result-found");
                        var results_div = $("#search-results .results");
                        
						//console.log(data["msg"]);

                        if(data["msg"] == "No user found"){
                            //no_result_div.show();
                            no_result_div.css("display",'flex');
                            results_div.hide();
                            //console.log("Not Found");

                        }
                        else{
                            no_result_div.hide();
                            results_div.show();

                            results_div.html("");
                            
                            var cnt = 0;

                            for(let i in data["users"]){
								//console.log(user);
								var user = data["users"][i];
                                var user_div = `<div class="result" onclick="select_guarantor(this)">
                                            <p class="g_name">${user["fullname"]}</p>
                                            <p class="account_number display_none">${user["account_no"]}</p>
                                            <button type="button"><i class="fa-solid fa-plus"></i> </button>
                                        </div>`;

								if(!gurantors_selected_acc_no.includes(user["account_no"]) && user_account_no != user["account_no"]){
                                    results_div.append(user_div);  
                                    cnt++;                                      
                                }
                            }
                            
                            if(cnt == 0){
                            	no_result_div.show();
                                no_result_div.css("display",'flex');
                                results_div.hide();
                            }
                        }

                    },
                    error: function (e) {

                        var json = e.responseText;

                        //console.log(json);
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

            g_name = $(element).children(".g_name").text();
            acc_no = parseInt($(element).children(".account_number").text());

            add_guarantor_div = $("#added-guarantors");

            new_element = `<div id="select_guarantor_${current_guarantor}_div" class="selected-guarantor">
            <p>${g_name}</p><input type="number" name="guarantor_${current_guarantor}" id="guarantor_${current_guarantor}" value="${acc_no}" hidden>
            <button type="button" onclick="deleteGuarantor(this, ${current_guarantor}, ${acc_no})"><i class="fa-solid fa-xmark"></i> 
            </button></div>`;

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


        // Profile Section 

        var general_btn = $('#profile-container #profile-toggle-btns .general-btn');
        var doc_btn = $('#profile-container #profile-toggle-btns .doc-btn');
        var general_prof_content = $('#profile-container #profile-content #general-profile-content');
        var doc_prof_content = $('#profile-container #profile-content #documents-content');

        general_btn.addClass("active");
        doc_prof_content.hide();

        function show_general() {
            general_btn.addClass("active");
            doc_btn.removeClass("active");
            doc_prof_content.hide();
            general_prof_content.show();
        }

        function show_docs() {
            general_btn.removeClass("active");
            doc_btn.addClass("active");
            doc_prof_content.show();
            general_prof_content.hide();

        }


        document.querySelectorAll('#send-money-form .input input, #guarantor-search-box input').forEach(input => {
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



        function change_page_details(cp) {
            heads = ["Personal Details", "Loan Details", "Required Documents", "Add 2 Guarantor", "Guarantor Documents"];

            $('#loan-page-detail-heading').text(heads[cp - 1]);
        }

        function back_page() {
            this_page = "#loan-page-" + current_page;
            target_page = "#loan-page-" + (current_page - 1);

            $('#step-number').text(current_page - 1);
            change_page_details(current_page - 1);

            $(this_page).hide();

            $(target_page).show();

            current_page--;

        }

        function next_page() {
            this_page = "#loan-page-" + current_page;
            target_page = "#loan-page-" + (current_page + 1);

            $('#step-number').text(current_page + 1);
            change_page_details(current_page + 1);

            $(this_page).hide();

            $(target_page).show();

            current_page++;
        }

        function back_submit() {

            $(".loan-next-btn").html("Next &nbsp;<i class='fa-solid fa-angle-right'></i>");

            if (current_page != 1) {
                back_page();
            }

            if (current_page == 1) {
                $(".loan-back-btn").hide();
            }
        }

        function next_submit() {
			
			 if(current_page == 5)
			 {
				 $('#loan-apply-form').submit();
			 }

            if(current_page == 4){
                if(guarantor_count != 2){
                    alert(`Please add ${2-guarantor_count} Guarantor`);
                    return;
                }

                $("#loan-page-5").html("")
                
                $("#loan-page-5").append(getDocsDiv(1), getDocsDiv(2));
                
            }

            $(".loan-next-btn").html("Next &nbsp;<i class='fa-solid fa-angle-right'></i>");


            if (current_page != total_pages) {
                next_page();
            }

            if (current_page == total_pages) {
                $(".loan-next-btn").html("Submit &nbsp;<i class='fa-solid fa-angle-right'></i>");
            }

            if (current_page != 1) {
                $(".loan-back-btn").show();
            }
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

        var pie_chart = show_data([50, 50]);

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

            $("#loan-interest-rate").val(interest_rate + "%")
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
            $("#monthly-emi-input").val(parseInt(monthly_emi));
            $("#total-interest-box").html("&#8377 " + total_interest + ".0")
            $("#total-interest-input").val(parseInt(total_interest));
            $("#total-amount-box").html("&#8377 " + total_amount + ".0");
            $("#total-amount-input").val(parseInt(total_amount));

            pie_chart.data.datasets[0].data = [total_interest, principal];

            pie_chart.update();

        }

        function fileChosen(ip, type, section) {
			
			if(section == "documents-content")
			{
				$('#profile-doc-save-btn').prop('disabled',false);
				$('#profile-doc-save-btn').addClass("activeBtn");
			}
            $("#" + section + " #" + type + "-photo-file-name").text(ip.files[0].name);

            img = $("#" + section + " #" + type + "-photo-preveiw");
            img.addClass("active-image");

            if (ip.files[0].type == "application/pdf") {
                img.attr('src', 'pdf-file-icon.png');
            }
            else {

                var reader = new FileReader();

                reader.onload = function (e) {
                    img.attr('src', e.target.result);
                };

                reader.readAsDataURL(ip.files[0]);

            }
        }




        // Get guarantor doc upload div
 		function getDocsDiv(guarantor_no) {
            var main_get_div = $("#select_guarantor_" + guarantor_no + "_div");

            var g_name = main_get_div.children("p").text();
            var g_accno = main_get_div.children("input").val();

            var g_fname = g_name.split(" ")[0];

            var doc_upload_div= `<div id="guarantor-${guarantor_no}-docs" class="guarantor-docs">
                                <h3 id="guarantor-name">${g_fname}'s Documents</h3>
                                <div class="docs-div">
                                    <div class="guarantor-adhaar-upload">
                                        <label class="adhaar-label">${g_fname}'s Adhaar Photo</label>
                                        <div>
                                            <img id="adhaar-photo-preveiw" src="/documents/${user_account_no}/G${g_accno}/g_adhaar.jpg" onerror="this.src='/images/image-upload-icon.png'" for="guarantor-${guarantor_no}-adhaar-photo"
                                                alt="Adhaar Photo">
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
                                            <img id="pan-photo-preveiw" src="/documents/${user_account_no}/G${g_accno}/g_pan.jpg" onerror="this.src='/images/image-upload-icon.png'" for="guarantor-${guarantor_no}-pan-photo"
                                                alt="Pan Photo">
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
        
        function toggleLoan(btn) {
            var hiddenPart = $(btn).parent().parent().children(".hidden-part");

            $(btn).toggleClass("loan-active");
            hiddenPart.toggleClass("loan-active");  
        }
        
        
        
        
        
        // functions Repayments Tab
        
        
        function openRepayment(accountNo, loanId, monthlyEmi, lateFee) {
            var acc_ip = $('.content.user-repayments #repayment-form-container #repayment-accountno');
            var loanid_ip = $('.content.user-repayments #repayment-form-container #repayment-loanid');
            var latefee_ip = $('.content.user-repayments #repayment-form-container #repayment-latefee-ip');
            var loanid_text = $('.content.user-repayments #repayment-form-container .repayment-loanid-text');
            var emi_text = $('.content.user-repayments #repayment-form-container .repayment-emi');
            var latefee_text = $('.content.user-repayments #repayment-form-container .repayment-latefee-text');
            var form_btn = $('.content.user-repayments #repayment-form-container .submit-repayment-btn');

            var totalPayment = 0;

            totalPayment = monthlyEmi + lateFee;
            
            acc_ip.val(parseInt(accountNo));
            loanid_ip.val(parseInt(loanId));
            latefee_ip.val(parseFloat(lateFee));
            emi_text.html("&#8377 "+ monthlyEmi + ".00");
            latefee_text.html("&#8377 "+ lateFee + ".00");
            form_btn.html('Pay &#8377 ' + totalPayment + ".00");
            loanid_text.html('#' + loanId);

            var repay_form = $('.content.user-repayments #repayment-form-container');

            repay_form.show();
            repay_form.css("transform", "scale(1)");

        }

        function hide_repayment_form() {
            var repay_form = $('.content.user-repayments #repayment-form-container');

            repay_form.css("transform", "scale(0)");
            setTimeout(() => {
                repay_form.hide();
            }, 300);
        }

        function makePayment() {
            window.event.stopPropagation();

            var acc_ip = $('.content.user-repayments #repayment-form-container #repayment-accountno');
            var loanid_ip = $('.content.user-repayments #repayment-form-container #repayment-loanid');
            var latefee_ip = $('.content.user-repayments #repayment-form-container #repayment-latefee-ip');

            var repay_form = $('.content.user-repayments #repayment-form-container .sub-container #repayment-form');

            var confirm_div = $('.content.user-repayments #repayment-form-container .sub-container #after-pay-confirm');

            var counter = $('.content.user-repayments #repayment-form-container .sub-container #after-pay-confirm .counter');

            payload = {
                'lid': parseInt(loanid_ip.val()),
                'account_no': parseInt(acc_ip.val()),
                'late_fee': parseFloat(latefee_ip.val())
            }
            

            $.ajax({
                    type: "POST",
                    contentType: "application/json",
                    url: "/api/repayment",
                    data: JSON.stringify(payload),
                    dataType: 'json',
                    cache: false,
                    timeout: 600000,
                    success: function (data) {
                        
                        repay_form.css("transform","translateY(-110%)");
                        repay_form.css("opacity", "0");
            
                        confirm_div.css("transform","translateY(-110%)");
                        confirm_div.css("opacity", "1");
            
            
                        var i = 2;
                        var intervalId = setInterval(() => {
                            counter.html('Ok (' + (i-- )+ 's)');
                            if(i < 0) clearInterval(intervalId);
                        }, 1000);
            
                        setTimeout(() => {
            
                            hide_repayment_form();
            
                            counter.html('Ok (3s)');
            
                            repay_form.css("transform","translateY(0%)");
                            repay_form.css("opacity", "1");
                
                            confirm_div.css("transform","translateY(0%)");
                            confirm_div.css("opacity", "0");
                            
                        }, 3000);
                        
                        fetchRepayments(acc_ip.val());

                    }
                });
                
        }

   
   
          function fetchRepayments(accno) {
            search = {
                'account_no': accno
            }

            var repayments_div = $('.content.user-repayments #repayments-container .repayments');

            $.ajax({
                    type: "POST",
                    contentType: "application/json",
                    url: "/api/getEmis",
                    data: JSON.stringify(search),
                    dataType: 'json',
                    cache: false,
                    timeout: 600000,
                    success: function (data) {

                        repayments_div.html("");
                        
                        if(data.length == 0){
							var noresfound = `<div id="universal_no_results">
												<img src="/images/notfound.png" alt="" srcset="">
												<h2>No Upcoming Repayments !!</h2>
											</div>`;
							
							repayments_div.html(noresfound);
						}
						
						for(let i in data){
							
                            var loan_id = data[i]["lid"];
                            
                            const due = new Date(data[i]["nextEmiDate"]);
                            
                            const today = new Date();
                            
							const months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];

                            var dueDate = due.getDate() + " " + months[due.getMonth()] + " " + due.getFullYear();

                            var accountNo = data[i]["appliedUser"]["account_no"];

                            var monthlyEmi = data[i]["monthlyEmi"];

							var dayDiff = Math.floor((today - due)/(1000*60*60*24));
							
							var lateFee = 0;
							
							var div_para = `<p>${dueDate}</p>`;
							
							if(dayDiff > 0){
								lateFee = data[i]['loanAmount'] * 0.001 * dayDiff;
								div_para = `<p class="red">${dueDate}</p>`
							}
							
                            var div = `<div class="each-payment">
                                                <p>#${loan_id}</p>
                                                ${div_para}
                                                <p><span class="repayment-btn" onclick="openRepayment(${accountNo}, ${loan_id}, ${monthlyEmi}, ${lateFee})">Pay &#8377 ${monthlyEmi + lateFee}.00</span></p>
                                            </div>`;
                                            
                            repayments_div.append(div);
						}
						
                    }
                });

        }
        
        function searchForReceiver(inp, selfaccno){
        	var recev_inp = $(inp);
        	
        	var search_results = $('#transfer-money-container .receivers-list-container');
        	
        	
        	
        	if (recev_inp.val() == "") {
                search_results.hide();
            }
            else {

                search_results.show();

                var text = recev_inp.val();
            
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
                    success: function (data) {

                        json = JSON.stringify(data, null, 4);

                        if(data["msg"] == "No user found"){
                            search_results.html(`<div class="no-such-user">
									<img src="/images/notfound.png">
									<p>No Such User</p>
								</div>`);
                        }
                        else{
                            search_results.html("");
                            
                            var cnt = 0;

                            for(let i in data["users"]){
								var user = data["users"][i];
                                var user_div = `<div class="receiver" onclick="selectReceiverForTransferMoney(${user["account_no"]})">
													<p>${user["account_no"]}</p>
													<p>${user["fullname"]}</p>
												</div>`;

								if(selfaccno != user["account_no"]){
                                    search_results.append(user_div);  
                                    cnt++;                                      
                                }
                            }
                            
                            if(cnt == 0){
                            	search_results.html(`<div class="no-such-user">
									<img src="/images/notfound.png">
									<p>No Such User</p>
								</div>`);
                            }
                        }

                    },
                    error: function (e) {

                        var json = e.responseText;

                        //console.log(json);
                    }
                });

            }
        	
        	
        	
       	}
        
        function selectReceiverForTransferMoney(accno){
        	var searchInp = $('#transfer-money-container .input #receiver');
        	var actualInp = $('#transfer-money-container .input #receiversearch');
        	var search_results = $('#transfer-money-container .receivers-list-container');
        	
        	search_results.html("");
        	search_results.hide();
        	searchInp.val(accno);
        	actualInp.val(accno);
        }



        
