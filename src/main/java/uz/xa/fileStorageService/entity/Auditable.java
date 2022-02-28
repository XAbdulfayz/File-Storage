package uz.xa.fileStorageService.entity;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.Type;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import javax.persistence.*;
import java.io.Serializable;
import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@MappedSuperclass
@EntityListeners(AuditingEntityListener.class)
public abstract class Auditable implements BaseEntity, Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(nullable = false, unique = true)
    protected Long id;


    @CreatedDate
    @CreationTimestamp
    @Column(name="created_at", columnDefinition = "TIMESTAMP default NOW()")
    protected LocalDateTime createdAt;

    @Column(name="is_deleted", columnDefinition = "NUMERIC default 0")
    @Type(type="org.hibernate.type.NumericBooleanType")
    private boolean deleted;



}
