<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
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
    <script src="https://kit.fontawesome.com/898070658c.js" crossorigin="anonymous"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"
        integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>
    <title>NBFC Software</title>
    <link rel="stylesheet" href="/CSS/main.css">
    <link rel="stylesheet" href="/CSS/user-login.css">
    <link rel="stylesheet" href="/CSS/loader.css">
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

    <header>
        <h1>NBFC <img src="/images/graph-icon.svg" alt="" srcset=""> Plus </h1>
    </header>
    <section class="admin-login">
        <div class="container">
            <div class="left">
                <div class="login-form">
                    <img src="/images/graph.svg" alt="" srcset="" class="bg-graph">
                    <h1 class="title">Update your Password</h1>
                    <p class="smsg">Enter your registered Email address and Password to update.</p>
                    <div class="message-wrap">
                        <div class="message" id="message"></div>
                    </div>
                    <form action="updatePassword" method="post" class="form" id="customer-login-form">
                        <div class="input">
                            <label for="email">Email</label>
                            <i class="fa-regular fa-envelope" for="email"></i>
                            <input type="text" name="email"  id="email" class="email" autocomplete="nope" value="${user.getEmail()}">
                        </div>
                        <div class="input">
                            <label for="password">Password</label>
                            <i class="fa-solid fa-key" for="password"></i>
                            <input type="password" name="password" id="password" class="password">
                        </div>

                        <div class="input">
                            <label for="cpassword">Confirm Password</label>
                            <i class="fa-solid fa-key" for="cpassword"></i>
                            <input type="password" name="cpassword" id="cpassword" class="cpassword">
                        </div>
                        
                        <button type="button" class="login-submit" onclick="validate()">Update</button>
                    </form>
                    <div class="register-div">
                        <p class="splitter">- OR -</p>
                        <p>Don't have account? </p>
                        <a href="/"><button class="register">Register Now</button></a>
                    </div>
                </div>
            </div>
            <div class="right">
                <h3 class="upper-title">Nice to see you again</h3>
                <h1 class="wback">Welcome back :)</h1>
                <img src="/images/customer-svg2.svg" alt="" srcset="">
                <img src="/images/blob-1.svg" alt="" srcset="">
                <p>Don't have account? </p>
                <a href="/"><button class="register">Register Now</button></a>
            </div>
        </div>
    </section>


    <script>
        document.querySelectorAll('input').forEach(input => {
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

        function show_msg(msg) {
            var cross = '<i class="fa-regular fa-circle-xmark" onclick="msg_fade()"></i>';
            var msg_box = $('#message');
            msg_box.html(msg + cross);
            msg_box.fadeIn();
            setTimeout(() => {
                msg_box.fadeOut();
            }, 5000);
        }

        function msg_fade() {
            $('#message').fadeOut();
        }

        function validate() {
            var email = $('#email');
            var password = $('#password');
            var cpassword = $('#cpassword');

            var form = $('#customer-login-form');

            var validRegex = /^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/;

            if (email.val() == '') {
                show_msg("Please Enter Your E-Mail ");
                email.focus();
                return false;
            }
            else if(!email.val().match(validRegex)){
                show_msg("Please Enter Valid E-Mail ");
                email.focus();
                return false;
            }
            else if (password.val() == '') {
                show_msg("Please Enter Your Password ");
                password.focus();
                return false;
            }
            else if (cpassword.val() == '') {
                show_msg("Please Enter Your Confirm Password.");
                cpassword.focus();
                return false;
            }
            else if (password.val() != cpassword.val()) {
                show_msg("Password and Confirm Password must be same.");
                password.focus();
                return false;
            }

            form.submit();
            return true;

        }

    </script>
</body>

</html>