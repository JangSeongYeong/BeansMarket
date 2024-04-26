package com.beans.market.message.service;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.Timestamp;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.beans.market.board.dto.BoardDTO;
import com.beans.market.board.service.BoardService;
import com.beans.market.history.service.HistoryService;
import com.beans.market.main.service.MainService;
import com.beans.market.member.dto.MemberDTO;
import com.beans.market.member.service.MemberService;
import com.beans.market.message.dao.MessageDAO;
import com.beans.market.message.dto.MessageDTO;
import com.beans.market.message.dto.RoomDTO;
import com.beans.market.pay.service.PayService;
import com.beans.market.photo.dto.ProfilePicDTO;
import com.beans.market.photo.service.PhotoService;

@Service
public class MessageService {
	
	Logger logger = LoggerFactory.getLogger(getClass());
	
	@Autowired MessageDAO messageDAO;
	@Autowired BoardService boardService;
	@Autowired PhotoService photoService;
	@Autowired MainService mainService;
	@Autowired HistoryService historyService;
	@Autowired PayService payService;
	@Autowired MemberService memberService;
	
	public String upload_root="C:/upload/";
	
	public Map<String, Object> messageCallAjax(int idx, String email, String otherEmail) {
		Map<String, Object> map = new HashMap<String, Object>();
		
		List<MessageDTO> messageList = messageDAO.messageList(idx, email, otherEmail); // 특정 게시물의 특정 인원과의 게시물을 가져오기
		/*
		for (MessageDTO messageDTO : messageList) {
			logger.info("{}번, {}",  messageDTO.getMessage_idx() ,messageDTO.getNew_picname());
		}
		*/
		//logger.info("mssageList : {}", messageList.toString());
		
		/*email이 본인인데 후에 세션으로 가져오는게 좋을거 같음*/
		MemberDTO Info = memberService.profileGet(otherEmail);
		ProfilePicDTO profileImg = memberService.profilePicGet(otherEmail);
		// ajax로 하거나 서브쿼리
		
		map.put("messageList", messageList);
		map.put("bbs_email", email);
		
		map.put("name", Info.getName());
		map.put("profileImg", profileImg.getNew_filename());
		
		return map;
	}

	public Map<String, Object> messageSendAjax(int idx, String senderEmail, String receiveEmail, String content) {
		boolean result = false;
		Map<String, Object> map = new HashMap<String, Object>();
		
		int row = messageDAO.sendMessage(content, receiveEmail, senderEmail, idx);
		if(row == 1) {
			result = true;
			mainService.alarmSend(idx+"번 게시물 : "+content, receiveEmail);
		}
		map.put("result", "보낸 결과"+result);
		
		
		return map;
	}

	public Map<String, Object> roomListCallAjax(String email) {
		Map<String, Object> map = new HashMap<String, Object>();
		List<RoomDTO> roomList = messageDAO.roomList(email); // 특정 게시물의 특정 인원과의 게시물을 가져오기
		
		for (RoomDTO roomDTO : roomList) {
			logger.info("other_email : {}, idx : {}", roomDTO.getOther_email(), roomDTO.getIdx());
			RoomDTO lastContent = messageDAO.lastContent(roomDTO.getIdx(), roomDTO.getOther_email(), email);
			String content = lastContent.getContent();
			Timestamp reg_date = lastContent.getReg_date();
			String new_picname = lastContent.getNew_picname();
			
			//logger.info("content : {} ", content);
			//logger.info("reg_date : {} ", reg_date);
			//logger.info("new_picname : {}", new_picname);
			
			roomDTO.setContent(content);
			roomDTO.setReg_date(reg_date);
			roomDTO.setNew_picname(new_picname);
		}
		
		/*
		for (RoomDTO roomDTO : roomList) {
			logger.info("other_email : {}, idx : {}", roomDTO.getOther_email(), roomDTO.getIdx());
			logger.info("content : {}, reg_date : {}", roomDTO.getContent(), roomDTO.getReg_date());	
			logger.info("new_picname : {}", roomDTO.getNew_picname());
		}
		*/
		
		map.put("roomList", roomList);
		
		return map;
	}

	public Map<String, Object> subjectCallAjax(String myEmail, int idx) {
		Map<String, Object> map = new HashMap<String, Object>();
		BoardDTO roomSubject = boardService.getBoardInfo(idx);
		String roomPhoto = photoService.getMainPhoto(idx);
		boolean returnApprove = false;
		int approve = historyService.dealApproveCheck(idx, myEmail);
		
		if(approve == 1) returnApprove = true;
		
		//logger.info("제목 정보 확인 : {}", roomSubject.getSubject());
		//logger.info("사진 이름 : {}", roomPhoto);
		map.put("approve", returnApprove);
		map.put("bbs_idx", idx); // 나중에 제거
		map.put("roomSubject", roomSubject);
		map.put("roomPhoto", roomPhoto);
		
		return map;
	}

	public Map<String, Object> approveAjax(String myEmail, String email, int idx) {
		Map<String, Object> map = new HashMap<String, Object>();
		boolean result = false;
		boolean dealSuccess = false;
		
		historyService.dealApprove(idx, myEmail);
		logger.info("{} 게시물 {}가 거래승인", idx, myEmail);
		
		// 상대방이 승인했는지 체크 - 1이 나오면 상대방이 승인했다는거 = email이 상대방 아이디
		int approveCnt = historyService.dealApproveCheck(idx, email);
		if (approveCnt == 1) {
				boardService.updataBbsState(idx, "거래완료");
				
				BoardDTO dto = boardService.getBoardInfo(idx);
				// 거래 내역에 추가
				if(dto.getEmail() == myEmail) {
					historyService.insertDealHistory(myEmail, email, idx);					
				} else {
					historyService.insertDealHistory(email, myEmail, idx);	
				}
				if (dto.getOption().equals("경매")) {
					payService.autionPaySend(dto.getEmail(), idx);
				}
				dealSuccess = true;
				logger.info("거래 완료");
		}
		result = true;
		
		map.put("dealSuccess", dealSuccess);
		map.put("idx", idx);
		map.put("result", result);
		
		return map;
	}

	public Map<String, Object> comentDo(String coment, String email, int idx) {
		Map<String, Object> map = new HashMap<String, Object>();
		boolean result = false;
		
		int row = historyService.comentDo(coment, email, idx);
		if(row == 1) result = true;
		
		map.put("result", result);
		return map;
	}

	public Map<String, Object> photoSend(MultipartFile photo, int idx, String email, String loginEmail) {
		Map<String, Object> map = new HashMap<String, Object>();
		MessageDTO dto = new MessageDTO();
		dto.setContent("사진을 전송했습니다.");
		dto.setReceive_email(email);
		dto.setSender_email(loginEmail);
		dto.setIdx(idx);
		
		int row = messageDAO.sendMessagePic(dto);
		boolean result = false;
		
		logger.info("실행 결과 : {}, messageidx : {}", row, dto.getMessage_idx());
		if (row == 1) {
			String orifilename = photo.getOriginalFilename();
			String ext = orifilename.substring(orifilename.lastIndexOf("."));
			String newFileName = System.currentTimeMillis()+ext;
			logger.info(newFileName);
			try {
				Path path = Paths.get(upload_root+newFileName);
				Files.write(path, photo.getBytes());
				photoService.insertPhoto(newFileName, dto.getMessage_idx(), 2);
				result = true;
			} catch (Exception e) {
				e.printStackTrace();
				logger.info("실패");
			}			
		}
		map.put("result", result);
		
		return map;
	}
	
	
}
