package an.qt.myjava;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.database.Cursor;
import android.app.PendingIntent;
import android.widget.Toast;
import android.view.WindowManager;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.util.DisplayMetrics;
import android.provider.Settings;
import android.os.Bundle;
import android.os.Environment;
import android.provider.MediaStore;
import android.net.Uri;
import java.io.File;

public class MyJava extends org.qtproject.qt5.android.bindings.QtActivity
{


        @Override
        public void onCreate(Bundle savedInstanceState) {
                super.onCreate(savedInstanceState);


                        //透明状态栏

                        //透明导航栏
                        //getWindow().addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_NAVIGATION);





                        //获取status_bar_height资源的ID
                        int resourceId = getResources().getIdentifier("status_bar_height", "dimen", "android");
                        if (resourceId > 0) {
                            //根据资源ID获取响应的尺寸值

                            statusBarHeight1 = String.valueOf(getResources().getDimensionPixelSize(resourceId));
                            Log.e("s",statusBarHeight1);
                            }

                      getWindow().addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
        }

    private static String statusBarHeight1 = "-1";
    private static MyJava m_instance;
    private static String imagePath = "Qt";

    private static Handler m_handler = new Handler() {
        @Override
        public void handleMessage(Message msg) {
            switch (msg.what) {
            case 1:
                String toastText = String.format("%s",(String)msg.obj);
                Toast toast = Toast.makeText(m_instance, toastText, Toast.LENGTH_LONG);
                toast.show();
                break;
            };
        }
    };


    public MyJava(){
        m_instance = this;
    }


    public static void makeToast(String s){
        m_handler.sendMessage(m_handler.obtainMessage(1, s));
    }

    public static void getImage(){
        imagePath = "Qt";
        Intent i = new Intent(Intent.ACTION_PICK,android.provider.MediaStore.Images.Media.EXTERNAL_CONTENT_URI);
        m_instance.startActivityForResult(i, 1);
    }



    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
            if (resultCode == RESULT_OK) {
                Uri uri = data.getData();
                Log.e("uri", uri.toString());

                String[] filePathColumn = { MediaStore.Images.Media.DATA };
                Cursor cursor = getContentResolver().query(uri,filePathColumn, null, null, null);
                cursor.moveToFirst();
                int columnIndex = cursor.getColumnIndex(filePathColumn[0]);
                imagePath = cursor.getString(columnIndex);
                cursor.close();
            }
            super.onActivityResult(requestCode, resultCode, data);
        }



    public static String getImagePath(){
        return imagePath;
    }

public static String getStatusBarHeight(){
    return statusBarHeight1;

}




    public static String getSdcardPath(){
           File sdDir = null;
           boolean sdCardExist = Environment.getExternalStorageState()
                           .equals(android.os.Environment.MEDIA_MOUNTED);   //判断sd卡是否存在
           if(sdCardExist)
           {
                sdDir = Environment.getExternalStorageDirectory();//获取跟目录
                return sdDir.toString();
           }
           return "";
    }



}
