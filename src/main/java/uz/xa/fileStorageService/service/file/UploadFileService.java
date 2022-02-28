package uz.xa.fileStorageService.service.file;


import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import uz.xa.fileStorageService.dto.ApiResponse;
import uz.xa.fileStorageService.dto.file.UploadBaseDto;
import uz.xa.fileStorageService.dto.file.UploadFileDto;
import uz.xa.fileStorageService.entity.file.UploadFilesInfo;
import uz.xa.fileStorageService.mapper.file.UploadFileMapper;
import uz.xa.fileStorageService.repository.file.UploadFileInfoRepository;
import uz.xa.fileStorageService.service.AbstractService;


import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDate;
import java.util.*;

@Service
public class UploadFileService extends AbstractService<UploadFileInfoRepository, UploadFileMapper> {


    String uploadDirectory = "src/main/resources/fileStorage/";


    protected UploadFileService(UploadFileInfoRepository repository, UploadFileMapper mapper) {
        super(repository, mapper);
    }

    public ApiResponse saveFile(MultipartHttpServletRequest request) throws IOException {

        LocalDate date= LocalDate.now();

        Iterator<String> fileNames = request.getFileNames();
        MultipartFile file = request.getFile(fileNames.next());

        if (!Objects.isNull(file) && !file.isEmpty()) {

            String originalName = file.getOriginalFilename();

            String[] split = originalName.split("\\.");
            String generatedName = date.getYear() +"_"+ date.getMonthValue() +"_"+ date.getDayOfMonth()
                    + UUID.randomUUID().toString()
                    + "."
                    + split[split.length - 1];

            UploadFilesInfo uploadFile = new UploadFilesInfo();
            uploadFile.setOriginalName(originalName);
            uploadFile.setSize(file.getSize());
            uploadFile.setMimeType(file.getContentType());
            uploadFile.setGeneratedName(generatedName);

            Path path = Paths.get(uploadDirectory + generatedName);
            Files.copy(file.getInputStream(), path);

            repository.save(uploadFile);
            return new ApiResponse("File successfully saved", true);
        }

        return new ApiResponse("File is Empty", false);
    }


    public List<UploadBaseDto> searchFile(String name, Long minValue, Long maxValue) {

        List<UploadFilesInfo> filteredFiles;

        if (maxValue != null && minValue != null) {
            filteredFiles = repository.findByNameWithFilter(name+"%", minValue, maxValue);
        } else {
            filteredFiles = repository.searchByName(name+"%");
        }
        List<UploadBaseDto> files = mapper.toCDto(filteredFiles);
        return files;
    }

    public List<UploadBaseDto> getAll(){
        List<UploadFilesInfo> all = repository.findAll();
        List<UploadBaseDto> response= mapper.toCDto(all);
        return response;
    }


    public UploadFileDto download(Long id){

        Optional<UploadFilesInfo> optionalFile = repository.findById(id);

        UploadFileDto fileDto = null;

        if(optionalFile.isPresent()){
            UploadFilesInfo file = optionalFile.get();
            fileDto = mapper.toDto(file);
            return fileDto;
        }
        return fileDto;

    }

}
