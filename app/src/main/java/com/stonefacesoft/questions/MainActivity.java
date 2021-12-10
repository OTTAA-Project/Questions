package com.stonefacesoft.questions;

import android.content.ActivityNotFoundException;
import android.content.Context;
import android.content.Intent;
import android.hardware.input.InputManager;
import android.os.Bundle;
import android.speech.RecognizerIntent;
import android.speech.tts.TextToSpeech;
import android.util.Log;
import android.view.InputDevice;
import android.view.KeyEvent;
import android.view.MotionEvent;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

import com.google.android.material.floatingactionbutton.FloatingActionButton;


import com.google.firebase.analytics.FirebaseAnalytics;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.stonefacesoft.pictogramslibrary.view.PictoView;
import com.stonefacesoft.questions.utils.MovableFloatingActionButton;
//import com.stonefacesoft.questions.utils.RequestTask;

import java.text.Normalizer;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

//First push
public class MainActivity extends AppCompatActivity implements View.OnClickListener, TextToSpeech.OnInitListener, View.OnTouchListener {
    public final static int SPEECH_RECOGNITION_CODE = 199;
    private static final String TAG = "MainActivity";
    TextToSpeech tts;
    ArrayList<PictoView> listPictos, emptyList;
    private FirebaseAuth mAuth;
    private FirebaseAnalytics mFirebaseAnalytics;
    private FloatingActionButton btnMorePictos, btnMicrophone;
    private MovableFloatingActionButton btnMovable;
    private TextView txtOutput;
    private PictoView Picto1, Picto2, Picto3, Picto4;
    private Button TouchButton;
    private String mStrIdioma;
    private YesNoQuestions yesNoQuestions;
    private final boolean mute = false;



    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        tts = new TextToSpeech(MainActivity.this, this);
        yesNoQuestions = new YesNoQuestions();
        mAuth = FirebaseAuth.getInstance();

        mFirebaseAnalytics = FirebaseAnalytics.getInstance(this);
        listPictos = new ArrayList<PictoView>();
        emptyList = new ArrayList<PictoView>();
        UIbinding();

    }

    @Override
    public void onInit(int status) {
        if (status == TextToSpeech.SUCCESS) {
            int result = tts.setLanguage(getResources().getConfiguration().locale);
            if (result == TextToSpeech.LANG_MISSING_DATA
                    || result == TextToSpeech.LANG_NOT_SUPPORTED) {
                Toast.makeText(getApplicationContext(), getString(R.string.tts_error_language), Toast.LENGTH_SHORT).show();
            }
        } else {
            Toast.makeText(getApplicationContext(), getApplicationContext().getString(R.string.init_faile), Toast.LENGTH_SHORT).show();
        }
    }

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (event.getSource() == InputDevice.SOURCE_MOUSE) {
            Picto4.callOnClick();
            return true;
        }
        return false;
    }

    @Override
    public void onClick(View view) {

        int id = view.getId();
        if (id == R.id.picto1) {
            speak(Picto1.getCustom_Texto());
        } else if (id == R.id.picto2) {
            speak(Picto2.getCustom_Texto());
        } else if (id == R.id.picto3) {
            speak(Picto3.getCustom_Texto());
        } else if (id == R.id.picto4) {
            speak(Picto4.getCustom_Texto());
        } else if (id == R.id.btn_mic) {
            //morePressed = 0;
            //loadMore(false);
            startSpeechToText();
//          Bundle bundle = new Bundle();
//          bundle.putString(FirebaseAnalytics.Param.CONTENT_TYPE, "Question");
//          mFirebaseAnalytics.logEvent(FirebaseAnalytics.Event.SELECT_CONTENT, bundle);
        } else if (id == R.id.btn_more) {
            //morePressed = morePressed + cantPictosAMostrar;
//            if (morePressed > listPictos.size())
//                morePressed = 0;
//            cargarPictos(listPictos);
//            bundle = new Bundle();
//            bundle.putString(FirebaseAnalytics.Param.CONTENT_TYPE, "More Pictos");
//            mFirebaseAnalytics.logEvent(FirebaseAnalytics.Event.SELECT_CONTENT, bundle);
        }
    }

    /**
     * Start speech to text intent. This opens up Google Speech Recognition API dialog box to listen the speech input.
     */
    private void startSpeechToText() {
        Intent intent = new Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH);
//        TODO  ver si podemos usar es-US
        intent.putExtra(RecognizerIntent.EXTRA_LANGUAGE, Locale.getDefault().getLanguage());
        intent.putExtra(RecognizerIntent.EXTRA_LANGUAGE_MODEL,
                RecognizerIntent.LANGUAGE_MODEL_FREE_FORM);
        intent.putExtra(RecognizerIntent.EXTRA_PROMPT,
                getResources().getString(R.string.str_MakeAQuestion));
        try {
            startActivityForResult(intent, SPEECH_RECOGNITION_CODE);
        } catch (ActivityNotFoundException a) {
            Toast.makeText(getApplicationContext(),
                    "Sorry! Speech recognition is not supported in this device.",
                    Toast.LENGTH_SHORT).show();
        }
    }

    /**
     * Callback for speech recognition activity
     */
    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        switch (requestCode) {
            case SPEECH_RECOGNITION_CODE:
                if (resultCode == RESULT_OK && null != data) {
                    ArrayList<String> result = data
                            .getStringArrayListExtra(RecognizerIntent.EXTRA_RESULTS);
                    String text = result.get(0);
                    text = text + "?";
                    processText(text);
                }
                break;
        }
    }

    private void processText(String text) {
        txtOutput.setText(text);
        if (YesNoQuestions.esSiNo(text)) {
            loadPictos(listPictos);
        } else {
          //  QueryInput queryInput = QueryInput.newBuilder().setText(TextInput.newBuilder().setText(text).setLanguageCode(mStrIdioma)).build();
          //  loadPictos(emptyList);
        }
    }

    private void UIbinding() {
        txtOutput = findViewById(R.id.txt_output);
        btnMorePictos = findViewById(R.id.btn_more);
        btnMicrophone = findViewById(R.id.btn_mic);

        Picto1 = findViewById(R.id.picto1);
        Picto1.setOnClickListener(this);
        Picto2 = findViewById(R.id.picto2);
        Picto2.setOnClickListener(this);
        Picto3 = findViewById(R.id.picto3);
        Picto3.setOnClickListener(this);
        Picto4 = findViewById(R.id.picto4);
        Picto4.setOnClickListener(this);
        TouchButton = findViewById(R.id.btnBarrido);
        TouchButton.setOnTouchListener(this);
        TouchButton.setVisibility(View.GONE);
        btnMicrophone.setOnClickListener(this);
        btnMorePictos.setOnClickListener(this);

        Picto1.setVisibility(View.INVISIBLE);
        Picto2.setVisibility(View.INVISIBLE);
        Picto3.setVisibility(View.INVISIBLE);
        Picto4.setVisibility(View.INVISIBLE);

        Picto1.setCustom_Img(getResources().getDrawable(R.drawable.picto_si));
        Picto1.setCustom_Texto("Si");
        Picto1.setCustom_Color(getResources().getColor(R.color.Magenta));
        Picto4.setCustom_Img(getResources().getDrawable(R.drawable.picto_no));
        Picto4.setCustom_Texto("No");
        Picto4.setCustom_Color(getResources().getColor(R.color.Magenta));

        listPictos.add(Picto1);
        listPictos.add(Picto2);


        mStrIdioma = Locale.getDefault().getLanguage();
        yesNoQuestions.setmStrIdioma(mStrIdioma);
        InputManager inputManager = (InputManager) this.getSystemService(Context.INPUT_SERVICE);
        inputManager.registerInputDeviceListener(new InputManager.InputDeviceListener() {
            @Override
            public void onInputDeviceAdded(int deviceId) {
                if (TouchButton.getVisibility() == View.GONE || TouchButton.getVisibility() == View.INVISIBLE) {
                    TouchButton.setVisibility(View.VISIBLE);
                    TouchButton.setOnTouchListener(MainActivity.this::onTouch);
                }
            }

            @Override
            public void onInputDeviceRemoved(int deviceId) {
                if (TouchButton.getVisibility() == View.VISIBLE) {
                    TouchButton.setVisibility(View.GONE);
                }
            }

            @Override
            public void onInputDeviceChanged(int deviceId) {

            }
        }, null);

    }

    void loadPictos(List<PictoView> array) {
        cleanPictos();

        if (array.size() == 0) {
            speak(getRandomReply());
            Picto1.setVisibility(View.INVISIBLE);
            Picto2.setVisibility(View.INVISIBLE);
            Picto3.setVisibility(View.INVISIBLE);
            Picto4.setVisibility(View.INVISIBLE);
        } else if (array.size() == 2) {
            Picto1.setVisibility(View.VISIBLE);
            Picto4.setVisibility(View.VISIBLE);
        }
    }

    private String getRandomReply() {
        String pregunta = "";
        int valor = (int) (Math.random() * 3 + 0);
        switch (valor) {
            case 0:
                return getResources().getString(R.string.str_WhatDidYouSay);

            case 1:
                return getResources().getString(R.string.str_DidNotUnderstand);

            case 2:
                return getResources().getString(R.string.str_PleaseReformulate);

            case 3:
                return getResources().getString(R.string.str_CanYouSayItAgain);

        }
        return pregunta;
    }

    void cleanPictos() {
        Picto1.setVisibility(View.INVISIBLE);
        Picto2.setVisibility(View.INVISIBLE);
        Picto3.setVisibility(View.INVISIBLE);
        Picto4.setVisibility(View.INVISIBLE);
    }


    private void speak(String utterance) {
//        Bundle bundle = new Bundle();
//        bundle.putString(FirebaseAnalytics.Param.ITEM_ID, String.valueOf(picto.getPictoId()));
//        bundle.putString(FirebaseAnalytics.Param.ITEM_NAME, picto.getText());
//        bundle.putString(FirebaseAnalytics.Param.CONTENT_TYPE, "Picto");
//        mFirebaseAnalytics.logEvent(FirebaseAnalytics.Event.SELECT_CONTENT, bundle);
        if (!tts.isSpeaking() && !mute) {
            tts.speak(utterance, TextToSpeech.QUEUE_ADD, null, null);
            Toast.makeText(this, utterance, Toast.LENGTH_SHORT).show();
        } else if (mute)
            Toast.makeText(this, utterance, Toast.LENGTH_SHORT).show();
    }

    @Override
    public void onStart() {
        super.onStart();
        // Check if user is signed in (non-null) and update UI accordingly.
        FirebaseUser currentUser = mAuth.getCurrentUser();
        isLogged(currentUser);

    }

    @Override
    protected void onDestroy() {
        super.onDestroy();

        tts.shutdown();
    }

    private void isLogged(FirebaseUser user) {
        if (user == null) {
            Log.e(TAG, "updateUI: Account is null");
            Intent openMain = new Intent(this, LoginActivity.class);
            startActivity(openMain);
            finish();
        } else {
            Log.d(TAG, "updateUI: User Logged in");
        }
    }


    @Override
    public boolean onTouch(View v, MotionEvent event) {
        if (event.getSource() == InputDevice.SOURCE_MOUSE) {
            switch (event.getButtonState()) {
                case MotionEvent.BUTTON_PRIMARY:
                    Log.e(TAG, "onTouchEvent: Primary Button");
                    Picto1.callOnClick();
                    return true;
                case MotionEvent.BUTTON_SECONDARY:
                    Log.e(TAG, "onTouchEvent: Secundary Button");
                    Picto4.callOnClick();
                    return true;
                case MotionEvent.BUTTON_TERTIARY:
                    Log.e(TAG, "onTouchEvent: Tertiary Button");
                    Picto4.callOnClick();
                    return true;
                case MotionEvent.AXIS_HAT_Y:
                    return true;

            }
            return false;
        } else {

        }
        return false;
    }








}