package it.matteogalacci.app.Util;

import java.util.Scanner;

public class MyScan {
    public static void execute() {
        System.out.println( "Scrivi un numero" );
        Scanner keyboardScanner = new Scanner(System.in);
        int input1;
        input1 = keyboardScanner.nextInt();

        System.out.println( "Hai scritto: " + input1);
    }
}
