<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" integrity="sha512-z3gLpd7yknf1YoNbCzqRKc4qyor8gaKU1qmn+CShxbuBusANI9QpRohGBreCFkKxLhei6S9CQXFEbbKuqLg0DA==" crossorigin="anonymous" referrerpolicy="no-referrer" />
<link rel="stylesheet" href="resources/css/common.css" type="text/css"/>
<link rel="stylesheet" href="resources/css/goodsDetail.css" type="text/css"/>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<style>
</style>
</head>
<body>
    <section>
        <div class="container">
            <div class="goods-detail">
                <div class="left">
                    <div class="picture">
                        <img class="goodsImg" src="/photo/${photos[0].new_picname}" alt="goodsImage"/>
                    </div>
                    <div class="controller">
                        <button class="prev"><i class="fa-solid fa-arrow-left"></i></button>
                        <button class="next"><i class="fa-solid fa-arrow-right"></i></button>
                    </div>
                    <div class="select-pic">
                    </div><!-- 사진 선택 공간 -->
                </div>
                <div class="right">
                    <div class="report">
                        <button class="reportBtn">신고하기</button> 
                    </div>
                    <div class="profile">
                        <div class="left">
                            <img src="/photo/${profilePic.new_filename}" alt="profileImage"/>
                        </div>
                        <div class="right">
                            <p class="user_name">${bbs.email}</p>
                            <div class="reivew">
                            	<!-- 로그인 관련해서 완성되면 추가 -->
                            	<p><i class="fa-solid fa-thumbs-up"></i> 17</p>
                                <p><i class="fa-solid fa-thumbs-down"></i> 3</p>
                            </div>
                        </div>
                    </div>
                    <div class="subject">
                        <p>${bbs.subject}</p>
                        <div class="icon">
                        	<!-- 로그인 관련해서 완성되면 추가 -->
                            <!-- <i class="fa-solid fa-heart"></i> -->
                            <i class="fa-regular fa-heart"></i> <!-- 빈 하트 -->
                        </div>
                    </div>
                    <p class="price">${bbs.price} 원</p>
                    <hr/>
                    <p class="place">거래 희망 장소 : ${bbs.place}</p>
                    <p class="reg-date">등록일 : ${reg_date}</p>
                    <div class="btn">
                        <button> <i class="fa-solid fa-paper-plane">&nbsp;</i> 쪽지 보내기</button> 
                    </div>
                </div>
            </div> 
            <hr/>
            <br/>
            <div class="goods-content">
            	<h2>상품 설명</h2>
            	<br/>
            	<p>${bbs.content}</p>
               	<c:forEach items="${photos}" var="photo">
					<img src="/photo/${photo.new_picname}"/>
					<br/>				
				</c:forEach>
            </div>
            <div id="reportForm">
                <form action="./report.do" method="post">
                    <div class="option">
                        <p>신고 분류</p>
                        <select id="report_option" name="category_idx">
                            <option value="r001">도배</option>
                            <option value="r002">욕설</option>
                            <option value="r003">성희롱</option>
                        </select>
                    </div>
                    <div class="content">
                        <p>신고 사유를 입력해주세요</p>
                        <textarea name="content"></textarea>
                    </div>
                    <input type="hidden" name="idx" value=${bbs.idx}>
                    <input type="hidden" name="perpet_email" value=${bbs.email}>
                    <div class="btn-controller">
                        <button class="ok">확인</button>
                        <button type="button" class="reportBtn">취소</button>
                    </div>
                </form>
            </div>
        </div> <!--container 종료-->
    </section>
</body>
<script>
    var picCount = 0;     // 현재 사진이 몇번째 사진인지
	var bbsIdx = '${bbs.idx}'; // String	
	
    // 특정 게시물 모든 사진 이름 받아오기
    var photoArray = [];
    $('.goods-content img').each(function() {
        photoArray.push($(this).attr('src'));
    });

    // 사진 밑에 점
    for (var photo_idx = 0;  photo_idx < '${photos.size()}'; photo_idx++) {
        $('.select-pic').append(photo_idx == 0 ? '<button class="select" onclick="photoChange('+photo_idx+')"></button>' : '<button class="unselect" onclick="photoChange('+photo_idx+')"></button>');        
    }
	
    function photoChange(photo_idx) {
        $('.goodsImg').attr('src', photoArray[photo_idx]);
        $('.select').removeClass('select').addClass('unselect');
        $('.select-pic button').eq(photo_idx).removeClass('unselect').addClass('select');
	}
    
    
    // 사진 이동 버튼
    $('.goods-detail .left').hover(function(){
        $('.next').show();
        $('.prev').show();
    });

    $('.goods-detail .left').mouseleave(function(){
        $('.next').hide();
        $('.prev').hide();
    });

    // 관심 목록 추가 및 삭제
    $('.icon').click(function(){
    	var i = $('.icon i');
        if(i.attr('class') == 'fa-regular fa-heart'){
            i.removeClass('fa-regular fa-heart').addClass('fa-solid fa-heart');
            interest(i.attr('class'));
        } else if(i.attr('class') == 'fa-solid fa-heart'){
            i.removeClass('fa-solid fa-heart').addClass('fa-regular fa-heart');
            interest(i.attr('class'));
        }
    });

    // 관심목록 ajax
    function interest(className){
		$.ajax({
			type:'get',
			url:'./interest.ajax',
			data:{
				'className':className,
				'bbsIdx':bbsIdx
			},
			dataType:'json',
			success:function(data){
				console.log(data.result);
			},
			error:function(error){
				console.log(error);
			}
		});
	}

    // 다음 버튼 클릭 시
    $('.next').click(function() {        
        var curSelect = $('.select');

        if(picCount == $('.select-pic button').length-1){
            curSelect.removeClass('select').addClass('unselect');
            $('.select-pic button').first().removeClass('unselect').addClass('select');
            picCount = 0;
            $('.goodsImg').attr('src', photoArray[picCount]);
            return;
        }
        picCount++;
        curSelect.removeClass('select').addClass('unselect');
        curSelect.next().removeClass('unselect').addClass('select');
        $('.goodsImg').attr('src', photoArray[picCount]);
    });

    // 이전 버튼 클릭 시
    $('.prev').click(function() {        
        var curSelect = $('.select');

        if(picCount == 0){
            curSelect.removeClass('select').addClass('unselect');
            $('.select-pic button').last().removeClass('unselect').addClass('select');
            picCount = $('.select-pic button').length-1;
            $('.goodsImg').attr('src', photoArray[picCount]);
            return;
        }
        picCount--;
        curSelect.removeClass('select').addClass('unselect');
        curSelect.prev().removeClass('unselect').addClass('select');
        $('.goodsImg').attr('src', photoArray[picCount]);
    });

    $('.reportBtn').click(function(){
        $('#reportForm').toggle();
    });

</script>
</html>