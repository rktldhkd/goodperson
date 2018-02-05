<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/include/include-header.jsp" %> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title>::좋은사람 - 주소찾기</title>
<script type="text/javascript">
function fn_setAddr(zipcode, addr){
	var p_obj 	= window.opener.document;
	
	p_obj.getElementById("zipcode").value 	= zipcode;
	p_obj.getElementById("addr").value		= addr;
	
	self.close();
}

$(function(){
	var tab1 = $("#tab1");
	var tab2 = $("#tab2");
	var tabView1 = $("#tabView1");
	var tabView2 = $("#tabView2");
	
	tab1.click(function(){
		tab1.addClass("selected");
		tab2.removeClass("selected");
		
		tabView1.css("display", "block");
		tabView2.css("display", "none");
		return false;
	})
	tab2.click(function(){
		tab2.addClass("selected");
		tab1.removeClass("selected");
		
		tabView2.css("display", "block");
		tabView1.css("display", "none");
		return false;
	})
});//jQuery

</script>
</head>
<body>
<!-- <a href="#" id="" class="addr" onclick="fn_setAddr('111-111', '경기도 안산시')">주소찾기 창</a> -->
<div id="popWrap" class=".addr_wrap">
	<header id="popHead">
		<div class="popHeadEnd">
			<h1>주소 찾기(Search Address)</h1>
		</div>
	</header>
	
	<main class="popBody">
		<div class="menu_list">
			<ul>
				<!-- //새우편번호 지번/도로명 소스 위치 및 이름변경 변경 -->
				<li>
					<a class="selected" href="#tabView1" target="_blank" id="tab1" style="display: block;">도로명 주소</a>
				</li>
				<li>
					<a href="#tabView2" target="_blank" id="tab2" style="display: block;" class="">지번 주소</a><!-- 선택되면 addclass "selected" -->
				</li>
			</ul>
		</div>
		<div style="background-color: green;">
			<div id="tabView1" style="display:;">
				<div class="search_guid">
					<p>
						<strong>※ 주소명 검색방법</strong><br/>
						1. 동 + 건물명 입력 : 예) '<strong>충무로1가(동명)</strong> <strong>중앙우체국</strong>(건물명)'<br/>
						2. 도로명 + 건물번호 입력 : 예) '<strong>소공로</strong>(도로명) <strong>70</strong>(건물번호)'<br/>
						3. 건물명 입력 : 예) '<strong>중앙우체국</strong>(건물명)'<br/>
					</p>
					<div style="margin-top:2px;"><strong>시/도 및 시/군/구 선택 후 주소명을 입력하세요.</strong></div>
				</div>
				<div class="search_area">
					<div id="select_local">
						<span>
							<h4>시/도</h4>
							<select name="sido" id="select_0">
								<option value="">선택</option>
								<option value="서울특별시">서울특별시</option>
								<option value="경기도">경기도</option>
								<option value="강원도">강원도</option>
								<option value="경상남도">경상남도</option>
								<option value="경상북도">경상북도</option>
								<option value="광주광역시">광주광역시</option>
								<option value="대구광역시">대구광역시</option>
								<option value="대전광역시">대전광역시</option>
								<option value="부산광역시">부산광역시</option>
								<option value="세종특별자치시">세종특별자치시</option>
								<option value="울산광역시">울산광역시</option>
								<option value="인천광역시">인천광역시</option>
								<option value="전라남도">전라남도</option>
								<option value="전라북도">전라북도</option>
								<option value="제주특별자치도">제주특별자치도</option>
								<option value="충청남도">충청남도</option>
								<option value="충청북도">충청북도</option>
							</select>
						</span>
						<span>
							<h4>시/군/구</h4>
							<select style="display: inline;">
							</select>
						</span>
					</div>
					<div id="search_addr">
						<input type="text" id="input_addr" placeholder="주소명을 입력해주세요."/>
					</div>
				</div>
				<div id="result_area">
				</div>
			</div>
			<div id="tabView2" style="display:none;">
				<div class="search_guid">
				</div>
				<div class="search_area">
				</div>
				<div id="result_area">
				</div>
			</div>
		</div>
	</main>
</div>
</body>
</html>