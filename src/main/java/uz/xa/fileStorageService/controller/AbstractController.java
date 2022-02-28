package uz.xa.fileStorageService.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Controller;

@Component
public abstract class AbstractController<T> {
    protected final T service;

    @Autowired
    protected AbstractController(T service) {
        this.service = service;
    }
}
