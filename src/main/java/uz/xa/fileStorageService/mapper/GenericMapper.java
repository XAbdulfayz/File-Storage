package uz.xa.fileStorageService.mapper;



import uz.xa.fileStorageService.dto.Dto;
import uz.xa.fileStorageService.dto.GenericDto;
import uz.xa.fileStorageService.entity.BaseEntity;

import java.util.List;

/**
 *
 * @param <E> Entity
 * @param <D> Dto
 * @param <CD> CreateDto
 * @param <UD> UpdateDto
 */

public interface GenericMapper<E extends BaseEntity, D extends GenericDto, CD extends Dto, UD extends GenericDto> extends Mapper{

    D toDto(E domain);

    CD toCDto(E domain);

    List<D> toDto(List<E> domain);

    List<CD> toCDto(List<E> domain);

    E fromCreateDto(CD dto);

    E fromUpdateDto(UD dto);

}
