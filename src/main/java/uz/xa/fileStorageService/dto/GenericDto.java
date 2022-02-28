package uz.xa.fileStorageService.dto;


import lombok.*;

import javax.validation.constraints.NotNull;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class GenericDto implements Dto {
    private Long id;

}
