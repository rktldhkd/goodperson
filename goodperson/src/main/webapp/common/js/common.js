/**
 * 
 */

/**
 * CommSubmit 함수에서 commonForm 객체 생성 여부를 판단할 boolean타입 값 반환.
 * @param str
 * @returns {Boolean}
 */
function gfn_isNull(str) {
    if (str == null) return true;
    if (str == "NaN") return true;
    if (new String(str).valueOf() == "undefined") return true;    
    var chkStr = new String(str);
    if( chkStr.valueOf() == "undefined" ) return true;
    if (chkStr == null) return true;    
    if (chkStr.toString().length == 0 ) return true;   
    return false; 
}
 
/**
 * 코드의 중복을 막고 가독성을 높이기 위해<br>
 * form의 action 경로 지정, 파라미터 추가, submit처리 등의 작업을 미리 지정.
 * @param opt_formId
 */
function ComSubmit(opt_formId) {
    this.formId = gfn_isNull(opt_formId) == true ? "commonForm" : opt_formId;
    this.url = "";
     
    if(this.formId == "commonForm"){
        $("#commonForm")[0].reset();
    }
     
    this.setUrl = function setUrl(url){
        this.url = url;
    };
     
    this.addParam = function addParam(key, value){
        $("#"+this.formId).append($("<input type='hidden' name='"+key+"' id='"+key+"' value='"+value+"' >"));
    };
     
    this.submit = function submit(){
        var frm = $("#"+this.formId)[0];
        frm.action = this.url;
        frm.method = "post";
        frm.submit();   
    };
}


function chkNull(obj){
	var flag=false;
	if(obj.val()=='' || obj.val()==null){
		obj.focus();
		flag = true;
	}//end if
	return flag;
}//chkNull


//<![CDATA[
// 날짜 객체(date)의 format 형식을 편리하게 사용하기 위해 정해놓은 기능.
// format에 밑의 case문에 위치한 알파벳 명시 시, 편하게 format 가능.
// Date 클래스 안에 format()이라는 메소드 추가. 나중에 데이터객체 만들고 메소드로 호출.
Date.prototype.format = function (f) {
    if (!this.valueOf()) return " ";
    var weekName = ["일요일", "월요일", "화요일", "수요일", "목요일", "금요일", "토요일"];
    var d = this;
    return f.replace(/(yyyy|yy|MM|dd|E|hh|mm|ss|a\/p)/gi, function ($1) {
        switch ($1) {
            case "yyyy": return d.getFullYear();
            case "yy": return (d.getFullYear() % 1000).zf(2);
            case "MM": return (d.getMonth() + 1).zf(2);
            case "dd": return d.getDate().zf(2);
            case "E": return weekName[d.getDay()];
            case "HH": return d.getHours().zf(2);
            case "hh": return ((h = d.getHours() % 12) ? h : 12).zf(2);
            case "mm": return d.getMinutes().zf(2);
            case "ss": return d.getSeconds().zf(2);
            case "a/p": return d.getHours() < 12 ? "오전" : "오후";
            default: return $1;
        }
    });
};
String.prototype.string = function (len) { var s = '', i = 0; while (i++ < len) { s += this; } return s; };
String.prototype.zf = function (len) { return "0".string(len - this.length) + this; };
Number.prototype.zf = function (len) { return this.toString().zf(len); };
// ]]>
