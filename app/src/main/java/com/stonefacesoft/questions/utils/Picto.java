package com.stonefacesoft.questions.utils;

import android.content.Context;
import android.content.res.TypedArray;
import android.graphics.drawable.Drawable;
import android.util.AttributeSet;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.constraintlayout.widget.ConstraintLayout;

import com.bumptech.glide.Glide;
import com.stonefacesoft.questions.R;

import java.util.Locale;

public class Picto extends ConstraintLayout {

    private int pictoId;
    private Drawable drawablePicto;
    private String strTexto;
    private int intColor;
    private Context mContext;

    private TextView txtViewTexto;
    private ImageView imgViewPicto;
    private ImageView imgViewColor;

    private static final String TAG = "Picto";


    public Picto(Context context){
        super(context);
    }

    public Picto(Context context, AttributeSet attrs){
        super(context, attrs);
        this.mContext = context;
        TypedArray a = context.getTheme().obtainStyledAttributes(attrs, R.styleable.Picto, 0, 0);
        try {
            strTexto = a.getString(R.styleable.Picto_Texto);
            intColor = a.getColor(R.styleable.Picto_Color,getResources().getColor(android.R.color.black));
        } finally {
            a.recycle();
        }
        init();
    }

    /**
     * Constructor de la clase Picto, todos los datos que se pasan como parametros son sacados de la base de datos
     * @param ID unique pictogram identifier
     * @param picto drawable with the image of the pictogram
     * @param text text to say outloud
     * @param color Fitzgerald key of the pictogram
     */
    public Picto(Context context,int ID, Drawable picto, String text, int color, AttributeSet attrs){
        super(context, attrs);
        this.mContext = context;
        this.pictoId = ID;
        this.drawablePicto = picto;
        this.strTexto = text;
        this.intColor = color;

        TypedArray a = context.getTheme().obtainStyledAttributes(attrs, R.styleable.Picto, 0, 0);
        try {
            strTexto = a.getString(R.styleable.Picto_Texto);
            intColor = a.getColor(R.styleable.Picto_Color,getResources().getColor(android.R.color.black));
        } finally {
            a.recycle();
        }
        init();
    }

    /**
     * Constructor de la clase Picto, todos los datos que se pasan como parametros son sacados de la base de datos
     * @param ID unique pictogram identifier
     * @param picto drawable with the image of the pictogram
     * @param text text to say outloud
     * @param color Fitzgerald key of the pictogram
     */
    public Picto(Context context,int ID, Drawable picto, String text, int color){
        super(context);
        this.mContext = context;
        this.pictoId = ID;
        this.drawablePicto = picto;
        this.strTexto = text;
        this.intColor = color;

        init();
    }

    public Picto(Context context, int ID, Drawable picto, String text, int color, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        this.mContext = context;
        this.pictoId = ID;
        this.drawablePicto = picto;
        this.strTexto = text;
        this.intColor = color;

        TypedArray a = context.getTheme().obtainStyledAttributes(attrs, R.styleable.Picto, 0, 0);
        try {
            strTexto = a.getString(R.styleable.Picto_Texto);
            intColor = a.getColor(R.styleable.Picto_Color,getResources().getColor(android.R.color.black));
        } finally {
            a.recycle();
        }
        init();

    }

    private void init() {
        inflate(getContext(), R.layout.picto, this);
        this.txtViewTexto = findViewById(R.id.grid_text);
        this.imgViewPicto = findViewById(R.id.imagen_Picto);
        this.imgViewColor = findViewById(R.id.color_Picto);
    }

    /**
     * Devuelve el ID unico del Picto
     * @return ID del Picto (int)
     */
    public int getPictoId() {return pictoId;}

    /**
     * Devuelve la imagen del Picto
     * @return  Icono del Picto (Drawable)
     */
    public Drawable getPictogram() {return drawablePicto;}

    /**
     * Devuelve el nombre del Picto
     * @return  Nombre del Picto (String)
     */
    public String getText() {return strTexto;}

    /**
     * Devuelve el color del Picto, es un entero que representa un color
     * @return color del Picto (int)
     */
    public int getColor() {return intColor;}

    /**
     * Setea el color del picto
     * @param color (int)
     */
    public void setColor(int color) {
        this.intColor = color;
        imgViewColor.setColorFilter(color);
        invalidate();
        requestLayout();
    }

    /**
     * Setea la nombre del Picto
     * @param text   (String)
     */
    public void setText(String text) {
        this.strTexto = text;
        txtViewTexto.setText(strTexto);
        invalidate();
        requestLayout();
    }

    /**
     * Setea el Icono del Picto
     * @param URLpictogram     (String)
     */

    public void setPictogram(String URLpictogram){
        //this.drawablePicto = URLpictogram;
        //imgViewPicto.setImageDrawable(drawablePicto);
        Glide.with(mContext).load(URLpictogram).into(imgViewPicto);
        invalidate();
        requestLayout();
    }

    public void setPictogram(Drawable drawablePicto){
        //this.drawablePicto = URLpictogram;
        //imgViewPicto.setImageDrawable(drawablePicto);
        Glide.with(mContext).load(drawablePicto).into(imgViewPicto);
        invalidate();
        requestLayout();
    }

    public void reset() {
        txtViewTexto.setText("");
        imgViewPicto.setImageDrawable(null);
        invalidate();
        requestLayout();
    }

//    public void setPicto(PictoFirebase pictoFirebase){
//        if(pictoFirebase!=null){
//            this.setText(pictoFirebase.getNombre(Locale.getDefault().getLanguage()));
//            this.setPictogram(pictoFirebase.getPicto());
//            this.setColor(getColorFromTipo(pictoFirebase.getTipo()));
//        }
//    }

    private Drawable getPictogramFromString(String imagen) {
        return mContext.getResources().getDrawable(mContext.getResources().getIdentifier(imagen, "drawable", mContext.getPackageName()));

    }

    private Integer getColorFromTipo(int tipo){
        switch (tipo) {
            case 1:
                return getResources().getColor(R.color.Yellow);
            case 2:
                return getResources().getColor(R.color.Orange);
            case 3:
                return getResources().getColor(R.color.YellowGreen);
            case 4:
                return getResources().getColor(R.color.DodgerBlue);
            case 5:
                return getResources().getColor(R.color.Magenta);
            case 6:
                return getResources().getColor(R.color.Black);
            default:
                return getResources().getColor(R.color.Black);
        }
    }

    public ImageView getImgViewColor() {
        return imgViewColor;
    }

    public ImageView getImgViewPicto() {
        return imgViewPicto;
    }

    public Drawable getDrawablePicto() {
        return drawablePicto;
    }
}

