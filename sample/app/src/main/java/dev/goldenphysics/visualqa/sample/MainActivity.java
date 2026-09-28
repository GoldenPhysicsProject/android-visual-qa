package dev.goldenphysics.visualqa.sample;

import android.app.Activity;
import android.graphics.Color;
import android.os.Bundle;
import android.view.Gravity;
import android.widget.LinearLayout;
import android.widget.TextView;

public final class MainActivity extends Activity {
    @Override
    protected void onCreate(Bundle state) {
        super.onCreate(state);

        LinearLayout root = new LinearLayout(this);
        root.setOrientation(LinearLayout.VERTICAL);
        root.setGravity(Gravity.CENTER);
        root.setPadding(48, 48, 48, 48);
        root.setBackgroundColor(Color.BLACK);

        TextView title = new TextView(this);
        title.setText("ANDROID VISUAL QA");
        title.setTextColor(Color.rgb(241, 211, 107));
        title.setTextSize(28);
        title.setGravity(Gravity.CENTER);

        TextView body = new TextView(this);
        body.setText("Real emulator. Real screenshot. No app source or secrets in the harness.");
        body.setTextColor(Color.LTGRAY);
        body.setTextSize(17);
        body.setGravity(Gravity.CENTER);
        body.setPadding(0, 32, 0, 0);

        root.addView(title);
        root.addView(body);
        setContentView(root);
    }
}
