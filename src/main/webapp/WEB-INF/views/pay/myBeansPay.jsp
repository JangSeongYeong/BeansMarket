<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" integrity="sha512-z3gLpd7yknf1YoNbCzqRKc4qyor8gaKU1qmn+CShxbuBusANI9QpRohGBreCFkKxLhei6S9CQXFEbbKuqLg0DA==" crossorigin="anonymous" referrerpolicy="no-referrer" />
<link rel="stylesheet" href="../resources/css/pay.css" type="text/css"/>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<style>

</style>
</head>

<body>
	<jsp:include page="../member/profileCommon.jsp" />
			<div class="main">
				<div class="container">
					<div class="username">
						<h3>${userName} 님의 빈즈페이</h3>
					</div>
					<div class="beanspay">
						<div>
							<p class="my_amount"><span>빈즈페이</span> ${my_amount} <span>원</span></p>
						</div>
						<button class="charge">+ 충전</button>
					</div>
					
					<div class="content">
					    <p><b>내역 확인</b></p>
					    <div id="historyContainer">
					        <c:forEach var="bean" items="${beans}" varStatus="loop">
					            <div class="history" style="display: ${loop.index < 10 ? 'block' : 'none'};">
					                <div class="top">
					                    <div class="date">${bean.reg_date}</div>
					                    <div class="category">${bean.option}</div>
					                </div>
					                <div class="bottom">
					                    <div class="title">${bean.content}</div>
					                    <c:choose>
					                        <c:when test="${bean.option =='경매글 입찰' || bean.option == '거래금 지불'}">
					                            <div class="amount" style="color: red;">-${bean.price}</div>
					                        </c:when>
					                        <c:when test="${bean.option == '거래금 수령' || bean.option == '입찰금 반환' || bean.option == '빈즈페이 충전' || bean.option == '경매금 수령'}">
					                            <div class="amount" style="color: blue;">+${bean.price}</div>
					                        </c:when>
					                        <c:otherwise>
					                            <div class="amount">${bean.price}</div>
					                        </c:otherwise>
					                    </c:choose>
					                </div>
					            </div>
					        </c:forEach>
					    </div>
					    <button id="moreButton">더 보기</button>
					</div>

					<div class="modal_charge">
						<div class="modal_body">
							<button type="button" class="modal_close">X</button>							
							<h2>빈즈페이 충전</h2>
							<p>얼마를 충전하시겠습니까? </p>
							<form id="chargeForm" action="/main/pay/charge" method="post">
								<input type="number" id="chargeAmount" name="pay" min="0" step="100">원
								<input type="submit" value="확인"/>
							</form>
						</div>
					</div>
				</div><!--container 종료-->
			</div><!-- main 종료 -->
		</div> <!-- include 마무리 하는 태그 -->
</body>

<script>
	const modal = document.querySelector('.modal_charge');
	const btnOpenModal = document.querySelector('.charge');
	const btnCloseModal = document.querySelector('.modal_close');
	const chargeAmount = document.getElementById('chargeAmount'); // 금액 입력 필드
	
	// 충전 재확인 창 출력
	$(document).ready(function() {
	    $('#chargeForm').submit(function(event) {
	        var chargeAmount = $('#chargeAmount').val();
	        
	        if (!confirm(chargeAmount + '원을 충전하시겠습니까?')) {
	            event.preventDefault(); // 제출을 취소합니다.
	        } else {
	        	if (chargeAmount % 1000 != 0) {
		            event.preventDefault(); // 제출을 취소합니다.
					alert("1,000원 단위로 충전 가능합니다.");
	        	}
			}
	    });
	    
	    $('#moreButton').click(function() {
	        $('.history:hidden').slice(0, 10).show(); // 숨겨진 10개의 요소를 보여줍니다.
	        if ($('.history:hidden').length === 0) {
	            $('#moreButton').hide(); // 남은 요소가 없으면 버튼을 숨깁니다.
	        }
	    });
	});

	
	btnOpenModal.addEventListener("click", () => {
	    modal.style.display = "flex";
	});
	
	btnCloseModal.addEventListener("click", () => {
	    modal.style.display = "none";
	});

	
</script>
</html>