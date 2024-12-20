package egovframework.LocalBoard.service;

import java.util.List;

import egovframework.LocalBoard.dto.ExcelDTO;

public interface ExcelService {

	void insertExcel(ExcelDTO excel);

	List<ExcelDTO> excelDownload();

}
