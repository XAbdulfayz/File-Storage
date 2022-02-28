package uz.xa.fileStorageService.dto.file;


import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import org.springframework.core.io.Resource;
import uz.xa.fileStorageService.dto.GenericDto;


@Getter
@Setter
public class UploadFileDto extends GenericDto {
    private String originalName;
    private String generatedName;
    private String path;
    private String mimeType;
    private Resource resource;
    private long size;

    @Builder(builderMethodName = "childBuilder")
    public UploadFileDto(Long id, String originalName, String generatedName, String path, String mimeType, Resource resource, long size) {
        super(id);
        this.originalName = originalName;
        this.generatedName = generatedName;
        this.path = path;
        this.mimeType = mimeType;
        this.resource = resource;
        this.size = size;
    }
}
