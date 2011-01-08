import java.io.Serializable;

public class Employee implements Serializable {

  public String name;
  public int age;
  public boolean active;
  public double salary;

  public Employee(String name, int age, boolean live, double price) {
    this.name = name;
    this.age = age;
    this.active = live;
    this.salary = price;
  }

  public Employee() {
  }

  public String getName() {
      return name;
  }

  public int getAge() {
      return age;
  }

  public double getSalary() {
      return salary;
  }

  public boolean isActive() {
      return active;
  }

}
