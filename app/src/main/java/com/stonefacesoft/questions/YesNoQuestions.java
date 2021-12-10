package com.stonefacesoft.questions;

import java.text.Normalizer;

public class YesNoQuestions {
    private String question;
    private static String mStrIdioma ="es";
    public YesNoQuestions(){

    }

    public void setmStrIdioma(String mStrIdioma) {
        this.mStrIdioma = mStrIdioma;
    }

    public static String stripAccents(String s) {
        s = s.toLowerCase();
        s = Normalizer.normalize(s, Normalizer.Form.NFD);
        s = s.replaceAll("[\\p{InCombiningDiacriticalMarks}]", "");
        return s;
    }
    public static boolean esSiNo(String pregunta) {
        switch (mStrIdioma) {
            case "es":
                pregunta = stripAccents(pregunta);
                int i = pregunta.indexOf(' ');
                if (i != -1)
                    pregunta = pregunta.substring(0, i);
                return pregunta.equals("podes") ||
                        pregunta.equals("puedes") ||
                        pregunta.equals("tenes") ||
                        pregunta.equals("te") ||
                        pregunta.equals("conoces") ||
                        pregunta.equals("queres") ||
                        pregunta.equals("quieres") ||
                        pregunta.equals("vas") ||
                        pregunta.equals("ya") ||
                        pregunta.equals("tienes") ||
                        pregunta.equals("tomaste") ||
                        pregunta.equals("es") ||
                        pregunta.equals("lo") ||
                        pregunta.equals("hace") ||
                        pregunta.equals("somos") ||
                        pregunta.equals("sos");

            case "en":
                switch (pregunta.substring(0, 2)) {
                    case "wh":
                        return false;
                    case "ho":
                        return false;
                    default:
                        return true;
                }

            default:
                switch (pregunta.substring(0, 2)) {
                    case "wh":
                        return false;
                    case "ho":
                        return false;
                    default:
                        return true;
                }
        }
    }
}
