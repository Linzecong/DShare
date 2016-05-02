package an.qt.myjava;
import android.content.Context;
import android.content.Intent;
import android.database.Cursor;
import android.app.PendingIntent;
import android.widget.Toast;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.provider.Settings;
import android.os.Bundle;
import android.os.Environment;
import android.provider.MediaStore;
import android.net.Uri;
import java.io.File;
public class MyJava extends org.qtproject.qt5.android.bindings.QtActivity
{

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
