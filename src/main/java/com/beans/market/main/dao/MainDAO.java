package com.beans.market.main.dao;

import java.util.List;

import com.beans.market.board.dto.BoardDTO;
import com.beans.market.main.dto.InquiryDTO;
import com.beans.market.main.dto.MainDTO;
import com.beans.market.member.dto.MemberDTO;
import com.beans.market.photo.dto.PhotoDTO;
import com.beans.market.photo.dto.ProfilePicDTO;

public interface MainDAO {


	
	// 게시글 리스트
	List<MainDTO> goodsList(String logEmail, int startNo);
	List<MainDTO> goodsList2(String logEmail, int startNo);
	List<MainDTO> goodsList3(String logEmail, int startNo);
	List<MainDTO> goodsList4(String logEmail, int startNo);
	List<MainDTO> goodsHitList(String logEmail, int startNo);
	List<MainDTO> goodsHitList2(String logEmail, int startNo);
	List<MainDTO> goodsHitList3(String logEmail, int startNo);
	List<MainDTO> goodsHitList4(String logEmail, int startNo);
	// 로그인 시, 로그인 계정의 범위 내에서 보이도록 
	String myGetLocation(String logEmail);
	int equalsLocation(int idx, String logEmail);
	// 게시글 리스트 총 페이지 수
	int allCount(String logEmail, int startNo);
	int allCount2(String logEmail, int startNo);
	int allCount3(String logEmail, int startNo);
	int allCount4(String logEmail, int startNo);
	String mainPhoto(int i);
	int fullPrice(int idx);
	int bidCnt(int idx);
	String sellerName(int idx);
	int heartCnt(int idx);
	// 로그인 시, 나의 관심목록 표시
	int mine(int idx, String logEmail);
	
	// 게시글 관심 등록삭제
	void clickHeart(int idxInt, String logEmail);
	void deleteHeart(int idxInt, String logEmail);
	
	// 게시글 제목 검색
	List<MainDTO> bbsSearch(String textVal);
	
	// 게시글 카테고리 검색
	List<MainDTO> bbsCategorySearch(String textVal);
	
	// 알림
	int newAlarm(String logEmail);
	List<MainDTO> alarm(String logEmail);
	int alarmRead(int idxInt);
	String alarmReadUrl(int idxInt);
	void alarmSend(String content, String email);
	void alarmSendLink(String content, String email, String link); // link 추가 된 버전
	
	// 최근 본 게시글
	MainDTO recentBBS(int idx);
	
	
	// 멤버 프로필
	MemberDTO profile(String logEmail);
	ProfilePicDTO profilePic(String logEmail);
	String nicname(String logEmail);
	void tempoPhotoDel(int pic_idx);
	
	
	// 문의하기
	void tempoPhoto(long idx, String orifilename, String newfileName);
	int tempoPhotoGetPicidx(String string);
	List<String> tempoPhotoGetNames(int tempoBbsIdx);
	void tempoPhotoDel2(int pic_idx);
	int writeInquire(InquiryDTO dto);
	void photoSave(int idx, String string);
	// 문의 리스트 출력
	List<InquiryDTO> inquireListAjax();
	InquiryDTO inquireDetail(int idxInt);
	List<PhotoDTO> inquireGetPhoto(int idxInt);
	
	
	
	
	// 로그인 네임
	String getName(String logEmail);
	
	
	
	

}
