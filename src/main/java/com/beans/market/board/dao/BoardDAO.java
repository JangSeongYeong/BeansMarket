package com.beans.market.board.dao;

import com.beans.market.board.dto.BoardDTO;

public interface BoardDAO {

	int connectTest();

	void upHit(int idx);

	BoardDTO goodsDetail(int idx);

}
