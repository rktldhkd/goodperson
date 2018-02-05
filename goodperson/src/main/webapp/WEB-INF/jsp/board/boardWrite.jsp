<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/include/include-header.jsp"%>

<!DOCTYPE html>
<html>
<head>
<title>:: 게시글 작성</title>
</head>
<script type="text/javascript">
	var gfv_count = 1;
	
	function fn_openBoardList(){
		var comSubmit = new ComSubmit();
		comSubmit.setUrl("<c:url value='/board/openBoardList.do' />");
		comSubmit.submit();
	}//fn_openBoardList()
	function fn_insertBoard(){
		var comSubmit = new ComSubmit("frm");
		comSubmit.setUrl("<c:url value='/board/insertBoard.do'/>");
		comSubmit.submit();
	}//fn_insertBoard()
	function fn_addFile(){
		var addObj = "<div class='attachment'><span style='margin-right:4px;'><input type='file' name='file_"+(gfv_count++)+"'></span>"+
		"<span><a href='#this' class='btn' id='deleteAddFile' name='deleteAddFile'>삭제</a></span></div>";
		$("#fileDiv").append(addObj);
		$("a[name='deleteAddFile']").on("click", function(e){
			e.preventDefault();
			fn_deleteAddFile($(this)); // a 태그의 name값이 deleteAddFile인게 넘어간다.
		});
	}//fn_addFile()
	function fn_deleteAddFile(obj){
		obj.parent().parent().remove();
	}//fn_deleteAddFile
	
	$(function() {
		$("#list").on("click", function(e){
			e.preventDefault();
			fn_openBoardList();
		});
		$("#write").on("click", function(e){
			e.preventDefault();
			fn_insertBoard();
		});
		$("#addFile").on("click", function(e){
			e.preventDefault();
			fn_addFile();
		});
		$("#deleteAddFile").on("click", function(e){
			e.preventDefault();
			fn_deleteAddFile($(this));
		});
	});//jQuery
	
</script>
<body>
	<!-- 
		enctype : 폼이 Multipart형식임을 알려줌. 
		글자가 아닌 사진,동영상등의 파일은 모두 Multipart형식의 데이터.
		파일 관련 개발 시, enctype 속성에 반드시 설정해 줄 것.
	-->
	<form id="frm" name="frm" enctype="multipart/form-data">
		<table class="board_view">
			<colgroup>
				<col width="15%">
				<col width="*" />
			</colgroup>
			<caption>:: 게시글 작성</caption>
			<tbody>
				<tr>
					<th scope="row">제목</th>
					<td>
						<input type="text" id="TITLE" name="TITLE" class="wdp_90"></input>
					</td>
				</tr>
				<tr>
					<td colspan="2" class="view_text">
						<textarea rows="20" cols="100" title="내용" id="CONTENTS" name="CONTENTS"></textarea>
					</td>
				</tr>
			</tbody>
		</table>
		
		<div id="fileDiv">
            <div class="attachment">
            	<span><input type="file" id="file" name="file_0"></span>
                <span><a href="#this" class="btn" id="deleteAddFile" name="deleteAddFile">삭제</a></span>
            </div>
        </div>
        <br/><br/>
        
		<a href="#this" class="btn" id="addFile">파일 추가</a>
		<a href="#this" class="btn" id="write">작성하기</a> 
		<a href="#this" class="btn" id="list">목록으로</a>
	</form>

	<jsp:include page="/WEB-INF/include/include-body.jsp" />
</body>
</html>