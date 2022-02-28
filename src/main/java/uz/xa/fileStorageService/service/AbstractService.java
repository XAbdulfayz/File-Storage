package uz.xa.fileStorageService.service;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Component;
import uz.xa.fileStorageService.mapper.GenericMapper;
import uz.xa.fileStorageService.mapper.Mapper;
import uz.xa.fileStorageService.repository.AbstractRepository;

/**
 * @param <R> repository
 * @param <M> mapper
 */


public abstract class AbstractService<
        R extends JpaRepository,
        M extends GenericMapper> {

    protected final R repository;
    protected final M mapper;


    protected AbstractService(R repository, M mapper) {
        this.repository = repository;
        this.mapper = mapper;

    }
}
