package goodperson.user.join.controller;

import goodperson.common.common.CommandMap;
import goodperson.user.join.service.JoinService;

import java.util.Iterator;
import java.util.Map.Entry;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;


@Controller
public class JoinController {
	Logger log = Logger.getLogger(this.getClass());
	
	@Resource(name = "JoinService")
	private JoinService joinService;
	
	
	/**
	 * 약관 동의 화면으로 이동.
	 * @return
	 */
	@RequestMapping(value="/user/join/AgreementTerms.do")
	public String openAgmtTerms() throws Exception{
		return "/user/join/AgreementTerms";
	}//openAgmtTerms
	
	/**
	 * 회원정보 입력화면으로 이동.
	 * @return
	 */
	@RequestMapping(value="/join/openMemInfo_input.do")
	public String openMemInfoInput() throws Exception{
		return "/user/join/memInfo_input";
	}//openMemInfoInput
	
	/**
	 * 아이디 중복 확인. 
	 * ajax, json 사용 시, @ResponseBody 애노테이션 사용 요망. Unknown return value type [java.lang.Integer] 등의 에러 발생방지.
	 * @return The number of duplicated ID
	 */
	@RequestMapping(value="/join/chkId.do", method=RequestMethod.POST)
	public @ResponseBody int chkId(@RequestParam String userId) throws Exception{
		log.debug("Controller chkId userId : [" + userId +"]");
		int result  = joinService.duplicateUserId(userId);
		log.debug("the number of duplicating Id : [" + result + "]");
		return result;
	}//chkId
	
	
	/**
	 * 회원정보를 DB에 입력하고 회원 등록을 마친다.
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/join/joinSuccess.do", method=RequestMethod.POST)
	public String openJoinSuccess(CommandMap commandMap) throws Exception{
		// DB에서 제대로 값을 가져와서 map 객체에 값이 제대로 담겨서 오는지 체크.
	    log.debug("========== JoinController - 사용자 정보 확인 ==========");
  		//Map<String, Object> testMap = (Map<String, Object>)commandMap.get("map");
  		Iterator<Entry<String,Object>> it = commandMap.entrySet().iterator();
  		Entry<String,Object> entry = null;
  		while(it.hasNext()){
  			entry = it.next();
            log.debug("key : "+entry.getKey()+", value : "+entry.getValue());
  		}//while, commandMap에 사용자 정보 유효 확인.
		
  		joinService.insertUser(commandMap.getMap());
  		log.debug("=====                   회원 추가 완료                             ======");
  		log.debug("============Insert Complete==============");
  		
		return "redirect:/main.do";
	}
}//class