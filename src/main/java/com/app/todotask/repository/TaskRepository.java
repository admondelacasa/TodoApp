package com.app.todotask.repository;

import com.app.todotask.entities.Task;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.Optional;
@Repository
public interface TaskRepository extends JpaRepository<Task, Long> {
    Optional<Task> findById(long id);
    long countByCompleted(boolean completed);

}
