<?php
	//header("HTTP/1.1 503 Service Temporarily Unavailable");
	//header("Status: 503 Service Temporarily Unavailable");
	//header("Retry-After: Mon, 01 September 2014 00:00:59 GMT");
	header("Retry-After: 3600");
?>

<!DOCTYPE html>
<!--[if IE 8 ]> <html lang="en" class="ie8"> <![endif]-->
<!--[if IE 9 ]> <html lang="en" class="ie9"> <![endif]-->
<!--[if (gt IE 9)|!(IE)]><!--> <html lang="en"> <!--<![endif]-->
<head>
  <meta charset="utf-8" />
  <meta content="IE=edge,chrome=1" http-equiv="X-UA-Compatible" />
  <title>tech-otaku.com | Maintenance</title>
  <meta content="Bootsrap based theme" name="description" />
  <meta content="width=device-width" name="viewport" />
  <link href="favicon.ico" rel="shortcut icon" />
<link href="caelus/images/apple-touch-icon-144-precomposed.png" rel="apple-touch-icon-precomposed" sizes="144x144" />
<link href="caelus/images/apple-touch-icon-114-precomposed.png" rel="apple-touch-icon-precomposed" sizes="114x114" />
<link href="caelus/images/apple-touch-icon-72-precomposed.png" rel="apple-touch-icon-precomposed" sizes="72x72" />
<link href="caelus/images/apple-touch-icon-57-precomposed.png" rel="apple-touch-icon-precomposed" />
  <link href="caelus/stylesheets/bootstrap.css" media="screen" rel="stylesheet" type="text/css" />
  <link href="caelus/stylesheets/responsive.css" media="screen" rel="stylesheet" type="text/css" />
  <link href="caelus/stylesheets/font-awesome.css" media="screen" rel="stylesheet" type="text/css" />
  <link href="caelus/stylesheets/fonts-set1.css" media="screen" rel="stylesheet" type="text/css" />
  <link href="caelus/stylesheets/theme.css" media="screen" rel="stylesheet" type="text/css" />
  <!--[if lt IE 9]>
    <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
  <![endif]-->
</head>
<body class="theme-sepia">
<!-- <body> -->
  <div class="wrapper">
    <div class="container">
      <div class="row-fluid">
        <div class="span5">
          <div class="brand hide">
            <h1>
              <img alt="caelus" src="caelus/images/logo.png" />
            </h1>
          </div>
        </div>
        <div class="span7">
          <div class="hero-unit">
            <h2 class="slab">
              <span class="slabtext">
                tech-otaku.com 
              </span>
              <span class="slabtext">
                is temporarily
              </span>
              <span class="slabtext">
                unavailable due to
              </span>
              <span class="slabtext">
                server maintenance
              </span>
              <!--
              <span class="slabtext slablight">
                of our new website
              </span>
              -->
            </h2>
            
            <h2 class="slab subtext">
              <span class="slabtext hide">
                sign up & stay updated
              </span>
            </h2>
            
          </div>
        </div>
        <!--
        <div class="row-fluid">
          <div class="span7 offset5 tonooffeset">
            <ul class="countdown-unit">
              <li>
                <span class="days">00</span>
                <p class="timeRef">days</p>
              </li>
              <li>
                <span class="hours">00</span>
                <p class="timeRef">hours</p>
              </li>
              <li>
                <span class="minutes">00</span>
                <p class="timeRef">minutes</p>
              </li>
              <li>
                <span class="seconds">00</span>
                <p class="timeRef">seconds</p>
              </li>
            </ul>
          </div>
        </div>
        -->
        <div class="row-fluid">
          <div class="span5"></div>
          <div class="span7">
            <h3>
              Please check back shortly.
            </h3>
            <!-- <p>tech-otaku.com is currently taking a sabbatical and is scheduled to return on 1st August 2013</p> -->
            <br />
            <br />
            <br />
            <br />
            <br />
            <br />
            <!-- add a class to the .signup div when clicking the submit button. Eiher .signup-success or .signup-error -->
            <div class="signup">
              <div class="signup-inner hide">	<!-- add/remove 'hide' class to hide/show -->
                <form>
                  <input id="email-signup" placeholder="       Your email" type="email" />
                  <button class="btn signup-button" type="submit">Submit</button>
                </form>
                <div class="response">
                  <p class="email"></p>
                  <p class="status"></p>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="row-fluid">
          <div class="span5"></div>
          <div class="span7">
            <ul class="list-social">
              <li class="link-facebook hide">
                <a href="#">
                  facebook
                </a>
              </li>
              <li class="link-google hide">
                <a href="#">
                  google
                </a>
              </li>
              <li class="link-twitter hide">
                <a href="#">
                  twitter
                </a>
              </li>
              <li class="link-linkedin hide">
                <a href="#">
                  linkedin
                </a>
              </li>
              <li class="link-pinterest hide">
                <a href="#">
                  pinterest
                </a>
              </li>
            </ul>
          </div>
        </div>
      </div>
    </div>
    <div class="bg-1"></div>
    <div class="bg-2"></div>
    <div class="bg-3"></div>
    <!-- <div class="bg-4"></div> -->
    <div class="bg-5"></div>
    <div class="bg-6"></div>
  </div>
  <script src="caelus/javascripts/jquery.1.8.3.min.js" type="text/javascript"></script>
  <script src="caelus/javascripts/bootstrap.js" type="text/javascript"></script>
  <script src="caelus/javascripts/jquery.slabtext.min.js" type="text/javascript"></script>
  <script src="caelus/javascripts/countdown.jquery.js" type="text/javascript"></script>
  <script src="caelus/javascripts/jquery.parallax-0.2-min.js" type="text/javascript"></script>
  <script src="caelus/javascripts/jquery.placeholder.min.js" type="text/javascript"></script>
  <script src="caelus/javascripts/script.js" type="text/javascript"></script>
<script type="text/javascript">
if (typeof gaJsHost == 'undefined') {
  var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
  document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
}
</script>
<script type="text/javascript">
try {
var pageTracker = _gat._getTracker("#########");
pageTracker._trackPageview();
} catch(err) {}</script>
</body>
