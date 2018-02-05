package goodperson.common.controller;

import java.io.File;
import java.net.URLEncoder;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

import goodperson.common.common.CommandMap;
import goodperson.common.service.CommonService;

import org.apache.commons.io.FileUtils;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class CommonController {
	Logger log	=	Logger.getLogger(this.getClass());
	
	@Resource(name="commonService")
	private CommonService commonService;
	
	@RequestMapping(value="/common/downloadFile.do")
	public void downloadFile(CommandMap commandMap, HttpServletResponse response) throws Exception{
		//첨부파일 정보(이름) 조회
	    Map<String,Object> map = commonService.selectFileInfo(commandMap.getMap());
	    String storedFileName = (String)map.get("STORED_FILE_NAME");
	    String originalFileName = (String)map.get("ORIGINAL_FILE_NAME");
	     
	    
	    //첨부파일 정보(이름)을 위에서 가져왔으면, 그 정보를 기반으로
	    //실제 첨부파일이 있는 물리적인 경로를 타고 파일을 가져와서 byte[] 형태로 변환해야 한다.
	    //실질적으로 파일을 바이트 형태로 가져온다.
	    byte fileByte[] = FileUtils.readFileToByteArray(new File("C:\\dev\\file\\"+storedFileName));
	    
	    //request, response에는 전송할 데이터뿐만 아니라 여러가지 정보가 담겨 있다.(헤더 등)
	    //위에서 바이트 형태로 가져온 파일정보를 화면에서 다운로드 할 수 있도록 변환하는 부분.
	    response.setContentType("application/octet-stream");
	    response.setContentLength(fileByte.length);
	    /* 
	      * request의 content-disposition은 multipart-form/data로 설정되어 있다.
	      * content-disposition속성을 이용하여 해당 패킷이 어떤 형식의 데이터인지 알 수 있다.
	      * 밑의 헤더 설정 중, attachment 설정 부분이 첨부파일을 의미.
	      * fileName 설정 부분은 첨부파일의 이름을 지정해 주는 역할.
	      * 파일을 다운로드 받을 때, 저장위치를 정하는 창이 뜨고 파일의 이름이 지정되어 있는데, 이 부분이 그 역할.
	      * 주의사항 : 코딩 시 띄어쓰기, 대소문자 구별등에 주의할 것.(attachment; fileName 간의 띄어쓰기 중요. \ 부분도 붙여써야된다.)
	    */
	    response.setHeader("Content-Disposition", "attachment; fileName=\"" + URLEncoder.encode(originalFileName,"UTF-8")+"\";");
	    response.setHeader("Content-Transfer-Encoding", "binary");
	    response.getOutputStream().write(fileByte);
	     
	    // 화면에서 서버로 요청 : request
	    // 서버에서 화면으로 응답 : response
	    response.getOutputStream().flush();
	    response.getOutputStream().close();
	}//downloadFile
}//class