<?php
if(!isset($_SERVER['HTTPS']) || $_SERVER['HTTPS'] != 'on'){
    form("ربات باید روی دامنه ی دارای ssl فعال نصب بشه!");
    exit();
}
if(!file_exists("../createDB.php") || !file_exists("../baseInfo.php") || !file_exists("../bot.php") || !file_exists("../config.php")){
    form("فایل های مورد نیاز ربات یافت نشد");
    exit();
}

$fileAddress = str_replace(["install.php","?webhook", "?install", "?updateBot", "?update", "/install"],"", "https://" . $_SERVER['HTTP_HOST'] . $_SERVER['REQUEST_URI']);
$botUrl = $fileAddress . "bot.php";

    if(isset($_REQUEST['webhook'])){
    	$botToken = $_POST['bottoken'];
    	$adminId = $_POST['adminid'];
    	$dbName = $_POST['dbname'];
    	$dbUser = $_POST['dbuser'];
    	$dbPassword = $_POST['dbpassword'];

    	
    	$connection = new mysqli('localhost',$dbUser,$dbPassword,$dbName);
    	if($connection->connect_error){
    	    form("خطای دیتابیس: " . $connection->connect_error);
    	    exit();
    	}
        $checkBot = json_decode(file_get_contents("https://api.telegram.org/bot" . $botToken . "/getwebhookinfo"));
        if($checkBot->ok){
            if($checkBot->result->url != ""){
                form("این ربات قبلاً نصب شده");
                exit();
            }
        }else{
            form("رباتی با این توکن یافت نشد");
            exit();
        }

     	$baseInfo = file_get_contents("../baseInfo.php");
     	$baseInfo = str_replace(['[BOTTOKEN]','[DBUSERNAME]','[DBPASSWORD]','[DBNAME]','[ADMIN]','[BOTURL]'],
     	              [$botToken, $dbUser, $dbPassword, $dbName, $adminId, $fileAddress],
     	                        $baseInfo);
        file_put_contents("../baseInfo.php", $baseInfo);
        file_get_contents($fileAddress. "createDB.php");
        $response = json_decode(file_get_contents("https://api.telegram.org/bot" . $botToken . "/setWebhook?url=" . $botUrl));
        if($response->ok){
            file_get_contents("https://api.telegram.org/bot" . $botToken . "/sendMessage?chat_id=" . $adminId . "&text=✅| ربات بایوساید با موفقیت نصب شد");
            form("ربات با موفقیت نصب شد", false);
        }
    }elseif(isset($_REQUEST['install'])){
        $baseInfo = file_get_contents("../baseInfo.php");
        if(!strstr($baseInfo, '[BOTTOKEN]') || !strstr($baseInfo, '[DBUSERNAME]')
                        || !strstr($baseInfo, '[DBPASSWORD]') || !strstr($baseInfo, '[DBNAME]')
                        || !strstr($baseInfo, '[ADMIN]')){
            form('روی این سورس قبلاً رباتی نصب شده!');
            exit();
        }
        showForm("install");
    }elseif(isset($_REQUEST['update'])){
        showForm("update");
    }
    elseif(isset($_REQUEST['updateBot'])){
        if (!file_exists("update.php")){
            echo '<script type="text/javascript">alert("فایل آپدیت یافت نشد");history.go(-1)</script>';
            exit();
        }
    	require "update.php";
    	require "../baseInfo.php";
    	
    	
    	$connection = new mysqli('localhost',$dbUserName,$dbPassword,$dbName);
    	
    	if($connection->connect_error){
    	    form("خطای دیتابیس: " . $connection->connect_error);
    	    exit();
    	}
        
        updateBot();
        
        
        form("ربات با موفقیت آپدیت شد نسخه 8.1.1 می باشد",false);
    }
    else{
        showForm("unknown");
    }
?>
<?php 
function showForm($type){
?>
    <html lang="en">
        <head>
          <script>
          (function(w,d,s,l,i){w[l]=w[l]||[];
            w[l].push({'gtm.start': new Date().getTime(),event:'gtm.js', });
            var f=d.getElementsByTagName(s)[0],j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';
            j.async=true;j.src='https://www.googletagmanager.com/gtm.js?id='+i+dl+'&gtm_auth=&gtm_preview=&gtm_cookies_win=x';
            f.parentNode.insertBefore(j,f);
          })(window,document,'script','dataLayer','GTM-MSN6P6G');</script>
          <meta charset="utf-8"><meta name="viewport" content="width=device-width">
    		<title><?php if($type=="unknown") echo "نصب و آپدیت خودکار بایوساید";
    		elseif ($type=="install") echo "نصب ربات";
    		elseif ($type=="update") echo "آپدیت ربات";
    		?></title>
            <meta charset="utf-8">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <link type="text/css" href="../assets/style.css" rel="stylesheet" />
            <style>
                body{
                    direction: rtl;
                    padding-top: 15px;
                    text-align: center;
                    background: #345987;
                }

                button{
                    cursor: pointer;
                    font-size: 18px;
                    width: 90%;
                    margin-bottom: 10px;
                    border-radius: 10px;
                    padding: 10px;
                    border: 1px #eae1e1 solid;
                    font-family: iransans !important;
                }
                 type[input]{
                    direction: rtl;
                }
            </style>
        </head>
        <body>
                                <?php if ($type=="unknown"){?>

                                    <div>
                                        <img src="../assets/logo.png" width="200px">
                                    </div>
                                    <br>
                                <div>
        							<a href="./install.php?install">
                                        <button style="background-color: #e0eeee;
                                        border: none;font-weight: 600;color: #000509" type="button">
                                            <span>نصب ربات</span>
                                        </button>
                                    </a>
        							<a href="./install.php?update">
                                        <button style="margin: 5px;background-color: #eccfde;
                                        border: none;font-weight: 600;color: #620738">
                                            <span>آپدیت ربات</span>
                                        </button>
                                    </a>
                                </div>
								<div style="margin-top: 5px">
                                    <span>
                                        <a target="_blank" href="https://t.me/biocidech">
                                        <button style="width: 150px;margin: 5px;padding: 3px;font-size: 16px">
                                            <span>کانال تلگرام</span>
                                        </button>
                                    </a>
                                    </span>
                                        <span>
                                        <a target="_blank" href="https://t.me/ibiocide">
                                        <button style="width: 150px;margin: 5px;padding: 3px;font-size: 16px">
                                            <span>گروه تلگرام</span>
                                        </button>
                                    </a>
                                    </span>
                                </div>
                                <?php }elseif($type=="update"){
                                    ?>
                                    <h1 style="font-size: 25px">لطفا جهت آپدیت روی دکمه زیر رو بزنید</h1>
                                    <a href="./install.php?updateBot">
                                        <button type="button" class="ant-btn ant-btn-primary ant-btn-block ant-btn-rtl PayPing-button always-white">
                                            <span>آپدیت ربات</span>
                                        </button>
                                    </a>
                                    <?php
                                }
                                elseif($type=="install"){ ?>
                                
                                <h1>نصب ربات بایوساید</h1>
                                    <div class="container">
                                        <form id="contact" action="install.php?webhook" method="post">
                                    <h3>لطفا اطلاعات خواسته شده را وارد کنید</h3>
                                    <h4>نظرات و پیشنهادات خود را در گروه تلگرامی ibiocide ارسال کنید</h4>
                                            <fieldset>
                                                <input placeholder="توکن ربات" type="text" name="bottoken" autocomplete="off" required >
                                            </fieldset>
                                            <fieldset>
                                                <input placeholder="آیدی عددی ادمین" type="text" name="adminid" autocomplete="off" required>
                                            </fieldset>
                                            <fieldset>
                                                <input placeholder="اسم دیتابیس" type="text" name="dbname" autocomplete="off" required>
                                            </fieldset>
                                            <fieldset>
                                                <input placeholder="یوزرنیم دیتابیس" type="text" name="dbuser" autocomplete="off" required>
                                            </fieldset>
                                            <fieldset>
                                                <input placeholder="پسورد دیتابیس" type="text" name="dbpassword" autocomplete="off" required>
                                            </fieldset>
                                            <fieldset>
                                                <button class="btninstall" type="submit">نصب ربات</button>
                                            </fieldset>
											<p style="font-size:13px">Made with 🖤 in <a target="_blank" href="https://github.com/ibiocide/biocide-v2raybot">biocide</a></p>
                                        </form>
                                    </div>
                                    <br>
                                    <br>

                                <?php } ?>
        </body>
    </html>
<?php
}
function form($msg, $error = true){
    ?>
    
        <html dir="rtl">
        <head>
            <script>
          (function(w,d,s,l,i){w[l]=w[l]||[];
            w[l].push({'gtm.start': new Date().getTime(),event:'gtm.js', });
            var f=d.getElementsByTagName(s)[0],j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';
            j.async=true;j.src='https://www.googletagmanager.com/gtm.js?id='+i+dl+'&gtm_auth=&gtm_preview=&gtm_cookies_win=x';
            f.parentNode.insertBefore(j,f);
          })(window,document,'script','dataLayer','GTM-MSN6P6G');
          </script>
          <meta charset="utf-8"><meta name="viewport" content="width=device-width">
            <title>نصب ربات بایوساید</title>
            <meta name="next-head-count" content="4">
        </head>
        <style>
            .ant-layout1 {
                background: #f0f2f5;
                display: flex;
                flex: auto;
                flex-direction: column;
                min-height: 0;
            }
            .PayPing-layout1 {
                background-color: #fff;
            }
            body, html {
                padding: 0;
                margin: 0;
                font-family: iransans !important;
            }
            a {
                color: inherit;
                text-decoration: none;
            }
            * {
                box-sizing: border-box;
            }
            .w-100 {
                width: 100%
            }
            .align-center {
                align-items: center!important;display: flex;
            }
            .justify-center {
                display: flex;justify-content: center!important;
            }
        </style>
        <body>
            <div id="__next">
                <section class="ant-layout1 PayPing-layout1 " style="min-height:100vh;display: flex;justify-content: center!important;background-color: #172b4d;direction: rtl;">
                    <main class="" style="display: flex;flex-direction: column!important;align-items: center!important;display: flex;display: flex;justify-content: center!important;">
                        <div class="justify-center align-center w-100">
                            <div style="background-color: #fff;border-radius: 5px;padding: 20px;position: relative;display: block;flex: 0 0 50.83333333%;max-width: 50.83333333%;right: auto;left: auto;align-items: center;display: flex;justify-content: center!important;" class="">
                                <div style="padding-bottom: 2rem!important;padding-top: 2rem!important;align-items: center!important;display: flex;color: #e31b23;display: flex;flex-direction: column!important;" class="">
                                    <?php if ($error == true){ ?> <svg fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" viewBox="0 0 24 24" class="PayPing-icon" stroke-width="1" width="100">
                                        <circle cx="12" cy="12" r="11"></circle>
                                        <path d="M15.3 8.7l-6.6 6.6M8.7 8.7l6.6 6.6"></path>
                                    </svg>
                                    <?php }?>
                                    <div class="" style="padding: 40px 30px" > <?php echo $msg ?></div>
                                </div>
                            </div>
                        </div>
                    </main>
                </section>
            </div>
        </body>
    </html>

    
    <?php
}
?>
