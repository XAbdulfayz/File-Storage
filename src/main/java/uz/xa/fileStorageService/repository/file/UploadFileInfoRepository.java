package uz.xa.fileStorageService.repository.file;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import uz.xa.fileStorageService.entity.file.UploadFilesInfo;
import uz.xa.fileStorageService.repository.AbstractRepository;

import java.util.List;


@Repository
public interface UploadFileInfoRepository extends JpaRepository<UploadFilesInfo, Long> {

    @Query(value = "select * from upload_files_info where original_name like :name and size between :minValue and :maxValue", nativeQuery = true)
    public List<UploadFilesInfo> findByNameWithFilter(@Param("name") String name, @Param("minValue") Long minValue, @Param("maxValue") Long maxValue);

    @Query(value = "select * from upload_files_info where original_name like :name", nativeQuery = true)
    public List<UploadFilesInfo> searchByName(@Param("name") String name);
}
