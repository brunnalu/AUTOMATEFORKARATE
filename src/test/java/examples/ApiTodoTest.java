package examples;

import com.intuit.karate.junit5.Karate;

public class ApiTodoTest {

    @Karate.Test
    public Karate testTodosFeature() {
        System.out.println("Iniciando execução do Karate...");
        return Karate.run("classpath:examples/todo/todo.feature");
    }
}