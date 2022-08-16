package it.matteogalacci.app;

import java.util.Scanner;

public class App
{
    public static void main( String[] args )
    {
        String hello="Hello World!!!!!";
        System.out.println( hello );

        System.out.println( "Scrivi un numero" );
        Scanner keyboardScanner = new Scanner(System.in);
        int input1;
        input1 = keyboardScanner.nextInt();

        System.out.println( "Hai scritto: " + input1);
    }
}
