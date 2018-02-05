package goodperson.common.util;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
 


import javax.servlet.http.HttpServletRequest;
 


import org.apache.log4j.Logger;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
 
//@Component 애노테이션을 이용, 객체를 스프링이 관리.
//applicationContext.xml 에  <context:component-scan>에 의해 스프링이 
//클래스들을 검색하며, 지정된 패키지에서 클래시 검색 시 @Component가 선언된 클래스들을
//빈으로 자동 생성한다.
@Component("fileUtils")
public class FileUtils {
	// 저장할 특정 폴더의 위치값.
	private static final String FILEPATH = "C:\\dev\\file\\";
    
	Logger log = Logger.getLogger(this.getClass());
	
    /**
     * 파일을 특정 폴더에 저장하고 DB에 입력될 정보를 반환하도록 구성.
     * @param map
     * @param request
     * @return
     * @throws Exception
     */
    public List<Map<String,Object>> parseInsertFileInfo(Map<String,Object> map, HttpServletRequest request) throws Exception{
        MultipartHttpServletRequest multipartHttpServletRequest = (MultipartHttpServletRequest)request;
        Iterator<String> iterator = multipartHttpServletRequest.getFileNames();
         
        MultipartFile multipartFile = null;
        String originalFileName = null;
        String originalFileExtension = null;
        String storedFileName = null;
         
        //클라이언트에서 전송된 파일 정보를 담아서 반환해 줄 List
        List<Map<String,Object>> list = new ArrayList<Map<String,Object>>();
        Map<String, Object> listMap = null; 
         
        //ServiceImpl 에서 전달해준 map에서 신규 생성되는 게시글의 번호를 받아옴.
        String boardIdx = (String)map.get("IDX");
         
        //FILEPATH상수에 저장된 해당 경로에 폴더가 존재하지 않을 때,
        //폴더 생성.
        File file = new File(FILEPATH);
        if(file.exists() == false){
            file.mkdirs();
        }//if
         
        //총 파일의 개수로서, 그 개수만큼 반복문 실행.
        while(iterator.hasNext()){
        	//총 파일들 중, 해당 차례의 파일 하나를 가져옴.
            multipartFile = multipartHttpServletRequest.getFile(iterator.next());
            
            if(multipartFile.isEmpty() == false){
            	//원래 이름.
                originalFileName = multipartFile.getOriginalFilename();
                //확장자.
                originalFileExtension = originalFileName.substring(originalFileName.lastIndexOf("."));
                //저장할 이름. 랜덤생성된 32글자(CommonUtils class)에 확장자를 붙인다.
                storedFileName = CommonUtils.getRandomString() + originalFileExtension;
                 
                //storedFileName으로 해당 파일의 이름을 설정, 해당 경로에 저장.
                file = new File(FILEPATH + storedFileName);
                //multipartFile.transferTo()메소드를 사용하여 지정된 경로에 파일을 생성.
                multipartFile.transferTo(file);
                 
                //listMap : 해당 번째의 저장된 파일의 정보들 저장.
                //list : 총 결과. listMap들을 가짐.
                listMap = new HashMap<String,Object>();
                listMap.put("BOARD_IDX", boardIdx);
                listMap.put("ORIGINAL_FILE_NAME", originalFileName);
                listMap.put("STORED_FILE_NAME", storedFileName);
                listMap.put("FILE_SIZE", multipartFile.getSize());
                list.add(listMap);
            }//if
        }//while
        return list;
    }//parseInsertFileInfo

    
    //이 메서드를 실행한 시점즈음엔 게시글 수정화면의 첨부파일 리스트가 DB에서 전부 삭제 된 상태(DEL_GB='Y').
    //하지만 request객체에 수정된 첨부파일 리스트의 정보가 들어 있으므로, 이정보를 Multipart형으로 변환하여,
    //IS_NEW 변수를 사용하여 새로 DB에 저장하는 형식. 즉, 수정 정보를 request에 담은 후 기존 정보를 다 지워버리고 수정 정보로 다시 덮어씌우는 방식. 
    //map : 첨부파일의 정보들이 담긴 객체.
    public List<Map<String, Object>> parseUpdateFileInfo(Map<String, Object> map, HttpServletRequest request) throws Exception{
        MultipartHttpServletRequest multipartHttpServletRequest = (MultipartHttpServletRequest)request;
        Iterator<String> iterator = multipartHttpServletRequest.getFileNames();
         
        MultipartFile multipartFile = null;
        String originalFileName = null;
        String originalFileExtension = null;
        String storedFileName = null;
         
        List<Map<String,Object>> list = new ArrayList<Map<String,Object>>();
        Map<String, Object> listMap = null; 
         
        String boardIdx = (String)map.get("IDX");  // 게시글 번호.
        String requestName = null;
        String idx = null; // 첨부파일 번호.
        
        while(iterator.hasNext()){
            multipartFile = multipartHttpServletRequest.getFile(iterator.next());
            // 수정된 첨부파일 목록 중,
            // 첨부파일 목록에서 기존에 있던 첨부파일들은 웹에 파일을 첨부해서 올린 게 아니라, DB에서 list를 뽑아서 view에서 뿌린 것이므로,
            // input file 태그에 파일이 담긴게 아니다. boardUpdate의 view단에서 input file 태그의 값부분을 보면, '선택된 파일 없음' 
            // 이라고 되있는 것을 확인 가능하다.
            // 첨부파일 목록에서 새로 추가된 첨부파일들은 input file 태그에서 첨부파일이 추가된 것이므로, input file 태그에서 첨부파일이 담긴다.
            // multipartFile은 input file 태그의 첨부파일 목록을 나타낸다.
            // 그래서 multipartFile에는 새로 첨부된 파일들만 담기게 된다.
            if(multipartFile.isEmpty() == false){
                originalFileName = multipartFile.getOriginalFilename();
                originalFileExtension = originalFileName.substring(originalFileName.lastIndexOf("."));
                storedFileName = CommonUtils.getRandomString() + originalFileExtension;
                 
                multipartFile.transferTo(new File(FILEPATH + storedFileName));
                 
                log.debug("original_file_name : " + originalFileName);
                listMap = new HashMap<String,Object>();
                listMap.put("IS_NEW", "Y");
                listMap.put("BOARD_IDX", boardIdx);
                listMap.put("ORIGINAL_FILE_NAME", originalFileName);
                listMap.put("STORED_FILE_NAME", storedFileName);
                listMap.put("FILE_SIZE", multipartFile.getSize());
                list.add(listMap);
            }
            else{
            	//input=file 태그의 name 값 리턴.
                requestName = multipartFile.getName();
                log.debug("file_name : " + requestName);
                idx = "IDX_"+requestName.substring(requestName.indexOf("_")+1);
                if(map.containsKey(idx) == true && map.get(idx) != null){
                    listMap = new HashMap<String,Object>();
                    listMap.put("IS_NEW", "N");
                    listMap.put("FILE_IDX", map.get(idx));
                    list.add(listMap);
                }
            }
        }
        return list;
    }//parseUpdateFileInfo
    
}//class
