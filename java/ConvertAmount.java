import java.util.Scanner;

public class ConvertAmount {
  public static void main(String[] args) {
    final double ROUBLES_PER_10THB = 28.5;
    
    int thbs;
    double roubles;
    double x = 1.0;
    
    Scanner input = new Scanner(System.in);
    
    // Ввод кол-ва бат
    System.out.print("Введите кол-ва бат: ");
    thbs = input.nextInt();
    input.close();
    
    // Конвертировать сумму в рубли
    roubles = ROUBLES_PER_10THB * thbs * x / 10;
    
    // Вывести сумму в рублях
    System.out.println("В рублях: " + roubles);
  }
}