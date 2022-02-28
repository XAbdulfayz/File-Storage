package uz.xa.fileStorageService.controller.file;

import org.springframework.data.repository.query.Param;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import uz.xa.fileStorageService.controller.AbstractController;
import uz.xa.fileStorageService.dto.ApiResponse;
import uz.xa.fileStorageService.dto.file.UploadBaseDto;
import uz.xa.fileStorageService.dto.file.UploadFileDto;
import uz.xa.fileStorageService.service.file.UploadFileService;

import javax.servlet.http.HttpServletResponse;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.List;


@RestController
@RequestMapping("/api/storage")
public class UploadFileController extends AbstractController<UploadFileService> {


    protected UploadFileController(UploadFileService service) {
        super(service);
    }


    @PostMapping("/upload")
    public ResponseEntity<ApiResponse> uploadFile(MultipartHttpServletRequest request) throws IOException {
        ApiResponse apiResponse = service.saveFile(request);

        return ResponseEntity.status(apiResponse.isSuccess() ? HttpStatus.CREATED : HttpStatus.CONFLICT).body(apiResponse);

    }

    @GetMapping("/search")
    public List<UploadBaseDto> getAll(){
        return service.getAll();
    }

    @GetMapping("/search/{name}")
    public List<UploadBaseDto> getFile(@PathVariable("name") String name, @Param("minValue") Long minValue, @Param("maxValue") Long maxValue){

        List<UploadBaseDto> result = service.searchFile(name, minValue, maxValue);

        return result;

    }


    @GetMapping("/download/{id}")
    public void download(@PathVariable Long id, HttpServletResponse response) throws IOException {

        UploadFileDto dto = service.download(id);

        response.setHeader("Content-Disposition", "attachment; filename=\"" + dto.getOriginalName() + "\"");
        response.setContentType(dto.getMimeType());
        FileInputStream fileInputStream = new FileInputStream("src/main/resources/fileStorage/" + dto.getGeneratedName());

        FileCopyUtils.copy(fileInputStream, response.getOutputStream());
    }

}
