package uz.xa.fileStorageService.mapper.file;

import org.mapstruct.Mapper;
import uz.xa.fileStorageService.dto.file.UploadBaseDto;
import uz.xa.fileStorageService.dto.file.UploadFileDto;
import uz.xa.fileStorageService.entity.file.UploadFilesInfo;
import uz.xa.fileStorageService.mapper.GenericMapper;


@Mapper(componentModel = "spring")
public interface UploadFileMapper extends GenericMapper<UploadFilesInfo, UploadFileDto, UploadBaseDto, UploadFileDto> {

}
