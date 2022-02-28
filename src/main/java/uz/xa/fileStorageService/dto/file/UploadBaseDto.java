package uz.xa.fileStorageService.dto.file;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import uz.xa.fileStorageService.dto.Dto;


@Getter
@Setter
@Builder
public class UploadBaseDto implements Dto {

    private Long id;
    private String originalName;
    private String generatedName;
    private String mimeType;
    private long size;

}
