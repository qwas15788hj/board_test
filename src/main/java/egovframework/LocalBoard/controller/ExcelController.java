package egovframework.LocalBoard.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.DataFormatter;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import egovframework.LocalBoard.dto.ExcelDTO;
import egovframework.LocalBoard.service.ExcelService;

@Controller
@RequestMapping("/excel")
public class ExcelController {

	@Autowired
	private ExcelService excelService;
	
	@GetMapping("")
	public String main() {
		return "excelMain";
	}

	@GetMapping("/success")
	public String success() {
		return "success";
	}
	 
	// 엑셀 작성
	@PostMapping("/addExcel")
	public String readExcel(@RequestParam("file") MultipartFile file, Model model) throws IOException {
		XSSFWorkbook workbook = new XSSFWorkbook(file.getInputStream());
		XSSFSheet worksheet = workbook.getSheetAt(0);
		
		for (int i = 1; i < worksheet.getPhysicalNumberOfRows(); i++) {
			ExcelDTO excel = new ExcelDTO();
			DataFormatter formatter = new DataFormatter();
			XSSFRow row = worksheet.getRow(i);

			String userName = formatter.formatCellValue(row.getCell(0));
			String userEmail = formatter.formatCellValue(row.getCell(1));
			String userId = formatter.formatCellValue(row.getCell(2));
			String userPhone = formatter.formatCellValue(row.getCell(3));
			String userType = formatter.formatCellValue(row.getCell(4));

			excel.setUserName(userName);
			excel.setUserEmail(userEmail);
			excel.setUserId(userId);
			excel.setUserPhone(userPhone);
			excel.setUserType(userType);
			System.out.println("excel : " + excel);
			
			excelService.insertExcel(excel);
			System.out.println("insertExcel 종료!");
		}
		return "redirect:/success";

	}
	
	// 엑셀 다운로드
    @GetMapping("/download")
    public void excelDownload(HttpServletResponse response) throws IOException {
    	System.out.println("다운로드 호출!!!");
//        Workbook wb = new HSSFWorkbook();
        Workbook wb = new XSSFWorkbook();
        Sheet sheet = wb.createSheet("첫번째 시트");
        Row row = null;
        Cell cell = null;
        int rowNum = 0;

        // Header
        row = sheet.createRow(rowNum++);
        cell = row.createCell(0);
        cell.setCellValue("이름");
        cell = row.createCell(1);
        cell.setCellValue("이메일");
        cell = row.createCell(2);
        cell.setCellValue("아이디");
        cell = row.createCell(3);
        cell.setCellValue("핸드퐅");
        cell = row.createCell(4);
        cell.setCellValue("타입");
        
        List<ExcelDTO> excelList = excelService.excelDownload();
        
        // Body
        for (int i=0; i<excelList.size(); i++) {
            row = sheet.createRow(rowNum++);
            cell = row.createCell(0);
            cell.setCellValue(excelList.get(i).getUserName());
            cell = row.createCell(1);
            cell.setCellValue(excelList.get(i).getUserEmail());
            cell = row.createCell(2);
            cell.setCellValue(excelList.get(i).getUserId());
            cell = row.createCell(3);
            cell.setCellValue(excelList.get(i).getUserPhone());
            cell = row.createCell(4);
            cell.setCellValue(excelList.get(i).getUserType());
        }

        // 컨텐츠 타입과 파일명 지정
        response.setContentType("ms-vnd/excel");
//        response.setHeader("Content-Disposition", "attachment;filename=example.xls");
        response.setHeader("Content-Disposition", "attachment;filename=example.xlsx");

        // Excel File Output
        wb.write(response.getOutputStream());
        wb.close();
    }
	

}