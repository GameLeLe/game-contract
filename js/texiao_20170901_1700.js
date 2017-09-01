$(function () {
    // 字体设置
    (function ($) {
        var isMac = /^Mac/.test(navigator.platform);
        if(!isMac) {
            $("body")[0].setAttribute("style","font-family: 'Microsoft YaHei'");
        }
    })($);


    // 首页黄点特效
    (function ($) {
        var $nav = $("#section0 .nav1");
        var $lis = $("#section0 .nav1 li");
        $lis.each(function (index, item) {
            if (index <= 2) {
                item.addEventListener("mouseover", function () {
                    $nav.css({
                        "background-position-x": 14 + index * 80 + "px"
                    })
                })
            }
            if (index >= 4) {
                item.addEventListener("mouseover", function () {
                    $nav.css({
                        "background-position-x": 26 + index * 80 + "px"
                    })
                })
            }
        });
        $nav.on("mouseout", function () {
            $nav.css({
                "background-position-x": "14px"
            })
        })
    })($);


    // 第三页点击特效
    (function ($) {
        var $dt1 = $("#section2 .dt-wallet");
        var $dt2 = $("#section2 .dt-ico");
        var $dt3 = $("#section2 .dt-im");
        var $dt4 = $("#section2 .dt-vc");
        var $dt5 = $("#section2 .dt-trade");

        var $ls1 = $("#icon_wallet");
        var $ls2 = $("#icon_ico");
        var $ls3 = $("#icon_im");
        var $ls4 = $("#icon_vc");
        var $ls5 = $("#icon_trade");

        var canCl = true;

        var $fa = $("#section2 .w");

        $ls1.click(function () {
            if (canCl) {
                canCl = false;
                $fa.animate({opacity: 0}, 250, function () {
                    $ls1.addClass("des").siblings().removeClass("des");
                    $dt1.removeClass("des").siblings(".detail").addClass("des");
                    $fa.animate({opacity: 1}, 250, function () {
                        canCl = true;
                    })
                })
            }
        });

        $ls2.click(function () {
            if (canCl) {
                canCl = false;
                $fa.animate({opacity: 0}, 250, function () {
                    $ls2.addClass("des").siblings().removeClass("des");
                    $dt2.removeClass("des").siblings(".detail").addClass("des");
                    $fa.animate({opacity: 1}, 250, function () {
                        canCl = true;
                    })
                })
            }
        });

        $ls3.click(function () {
            if (canCl) {
                canCl = false;
                $fa.animate({opacity: 0}, 250, function () {
                    $ls3.addClass("des").siblings().removeClass("des");
                    $dt3.removeClass("des").siblings(".detail").addClass("des");
                    $fa.animate({opacity: 1}, 250, function () {
                        canCl = true;
                    })
                })
            }
        });

        $ls4.click(function () {
            if (canCl) {
                canCl = false;
                $fa.animate({opacity: 0}, 250, function () {
                    $ls4.addClass("des").siblings().removeClass("des");
                    $dt4.removeClass("des").siblings(".detail").addClass("des");
                    $fa.animate({opacity: 1}, 250, function () {
                        canCl = true;
                    })
                })
            }
        });

        $ls5.click(function () {
            if (canCl) {
                canCl = false;
                $fa.animate({opacity: 0}, 250, function () {
                    $ls5.addClass("des").siblings().removeClass("des");
                    $dt5.removeClass("des").siblings(".detail").addClass("des");
                    $fa.animate({opacity: 1}, 250, function () {
                        canCl = true;
                    })
                })
            }
        });


    })($);


    // 阶段特效
    (function ($) {
        //left: 631px;
        //left: 378px;
        //left: 123px;
        var $sel1 = $(".sel1");
        var $sel2 = $(".sel2");
        var $sel3 = $(".sel3");

        var tri = $(".tri")[0];

        $sel1.click(function () {
            // 上
            $sel1.addClass("active").removeClass("sil").siblings().addClass("sil").removeClass("active");

            // 中
            tri.style.left = "123px";

            // 下
            // tx 里的div消失
            $("#section6 .text div").fadeOut(300);
            $("#section6 .container").animate({height: "128px"}, 300);
            $("#section6 .t1").show().siblings().hide();
            // 过了300ms 点击文字的div显示
            setTimeout(function () {
                $("#section6 .t1 div").fadeIn(300);
            }, 300);
        });

        $sel2.click(function () {
            // 上
            $sel2.addClass("active").removeClass("sil").siblings().addClass("sil").removeClass("active");

            // 中
            tri.style.left = "378px";

            // 下
            $("#section6 .text div").fadeOut(300);
            $("#section6 .container").animate({height: "128px"}, 300);
            $("#section6 .t2").show().siblings().hide();
            // 过了300ms 点击文字的div显示
            setTimeout(function () {
                $("#section6 .t2 div").fadeIn(300);
            }, 300);
        });

        $sel3.click(function () {
            // 上
            $sel3.addClass("active").removeClass("sil").siblings().addClass("sil").removeClass("active");

            // 中
            tri.style.left = "631px";

            // 下
            $("#section6 .text div").fadeOut(300);
            $("#section6 .container").animate({height: "277px"}, 300);
            $("#section6 .t3").show().siblings().hide();
            // 过了300ms 点击文字的div显示
            setTimeout(function () {
                $("#section6 .t3 div").fadeIn(300);
            }, 300);
        });


    })($);


    // 首页点击特效
    (function ($) {
        var $lis = $("#section0 .buy li");
        var $d = $(".time .day");
        var $h = $(".time .hour");
        var $m = $(".time .min");
        var $s = $(".time .sec");

        ShowCountDown(2017, 9, 1, function () {
            ShowCountDown(2017, 10, 1);
            $("#section0 .buyBtn").text("私募中");
        });

        var timer = setInterval(function () {
            ShowCountDown(2017, 9, 1, function () {
                ShowCountDown(2017, 10, 1);
                $("#section0 .buyBtn").text("私募中");
            });
        }, 1000);

        $lis.click(function () {
            var data = $(this).data("type");
            var dur = 400;
            if ($(".buy" + data).hasClass("active")) {
                return;
            }
            $(this).addClass("active").siblings().removeClass("active");
            if (data == 1) {
                $(".mmm").animate({opacity: 0}, dur, function () {
                    clearInterval(timer);
                    ShowCountDown(2017, 9, 1, function () {
                        ShowCountDown(2017, 10, 1);
                        $("#section0 .buyBtn").text("私募中");
                    });
                    timer = setInterval(function () {
                        ShowCountDown(2017, 9, 1, function () {
                            ShowCountDown(2017, 10, 1);
                            $("#section0 .buyBtn").text("私募中");
                        });
                    }, 1000);
                    $("#section0 .dur").text("2017.9.1 - 2017.9.30");
                    $(".mmm").animate({opacity: 1}, dur)
                });
            }
            if (data == 2) {
                $(".mmm").animate({opacity: 0}, dur, function () {
                    clearInterval(timer);
                    $("#section0 .buyBtn").text("即将开售");
                    ShowCountDown(2017, 10, 10);
                    timer = setInterval(function () {
                        ShowCountDown(2017, 10, 10);
                    }, 1000);
                    $("#section0 .dur").text("2017.10.10 - 2017.10.31");
                    $(".mmm").animate({opacity: 1}, dur)
                });
            }
            if (data == 3) {
                $(".mmm").animate({opacity: 0}, dur, function () {
                    clearInterval(timer);
                    $("#section0 .buyBtn").text("即将开售");
                    ShowCountDown(2017, 11, 1);
                    timer = setInterval(function () {
                        ShowCountDown(2017, 11, 1);
                    }, 1000);
                    $("#section0 .dur").text("2017.11.1 - 2017.11.31");
                    $(".mmm").animate({opacity: 1}, dur)
                });
            }
            if (data == 4) {
                $(".mmm").animate({opacity: 0}, dur, function () {
                    clearInterval(timer);
                    $("#section0 .buyBtn").text("即将开售");
                    ShowCountDown(2018, 1, 1);
                    timer = setInterval(function () {
                        ShowCountDown(2018, 1, 1);
                    }, 1000);
                    $("#section0 .dur").text("2018.1.1 为期 300 天");
                    $(".mmm").animate({opacity: 1}, dur)
                });
            }

        });

        function ShowCountDown(year, month, day, cb) {
            var now = new Date();
            var endDate = new Date(year, month - 1, day);
            var leftTime = endDate.getTime() - now.getTime();
            var leftsecond = parseInt(leftTime / 1000);
            var day1 = Math.floor(leftsecond / (60 * 60 * 24));
            var hour = Math.floor((leftsecond - day1 * 24 * 60 * 60) / 3600);
            var minute = Math.floor((leftsecond - day1 * 24 * 60 * 60 - hour * 3600) / 60);
            var second = Math.floor(leftsecond - day1 * 24 * 60 * 60 - hour * 3600 - minute * 60);
            day1 = day1 < 10 ? "0" + day1 : day1;
            hour = hour < 10 ? "0" + hour : hour;
            minute = minute < 10 ? "0" + minute : minute;
            second = second < 10 ? "0" + second : second;
            $d.text(day1);
            $h.text(hour);
            $m.text(minute);
            $s.text(second);

            if(leftsecond <= 0) {
                cb&cb();
            }
        }


    })($);

    // 第二页点击特效
    (function ($) {
        $r1 = $("#section1 .r1");
        $r2 = $("#section1 .r2");
        $r3 = $("#section1 .r3");
        $r4 = $("#section1 .r4");
        $r5 = $("#section1 .r5");

        $r1.click(function () {
            $("#section2 .dt-im").removeClass("des").siblings(".detail").addClass("des");
            $("#section2 .im").addClass("des").siblings().removeClass("des");
        });

        $r2.click(function () {
            $("#section2 .dt-trade").removeClass("des").siblings(".detail").addClass("des");
            $("#section2 .trade").addClass("des").siblings().removeClass("des");
        });

        $r3.click(function () {
            $("#section2 .dt-vc").removeClass("des").siblings(".detail").addClass("des");
            $("#section2 .vc").addClass("des").siblings().removeClass("des");
        });

        $r4.click(function () {
            $("#section2 .dt-wallet").removeClass("des").siblings(".detail").addClass("des");
            $("#section2 .wallet").addClass("des").siblings().removeClass("des");
        });

        $r5.click(function () {
            $("#section2 .dt-ico").removeClass("des").siblings(".detail").addClass("des");
            $("#section2 .ic").addClass("des").siblings().removeClass("des");
        });
    })($);


});


