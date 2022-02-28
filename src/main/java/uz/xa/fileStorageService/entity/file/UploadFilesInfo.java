package uz.xa.fileStorageService.entity.file;

import lombok.Getter;
import lombok.Setter;
import uz.xa.fileStorageService.entity.Auditable;

import javax.persistence.Column;
import javax.persistence.Entity;

@Getter
@Setter
@Entity
public class UploadFilesInfo extends Auditable {

    @Column(nullable = false)
    private String originalName;

    @Column(nullable = false)
    private String generatedName;


    private String path;

    @Column(nullable = false)
    private String mimeType;

    @Column(nullable = false)
    private long size;

}
