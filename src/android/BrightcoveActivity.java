package com.brightcove.player;

import android.content.Intent;
import android.content.res.Resources;
import android.os.Bundle;
import android.util.Log;

import com.brightcove.player.edge.Catalog;
import com.brightcove.player.edge.VideoListener;
import com.brightcove.player.event.EventEmitter;
import com.brightcove.player.model.Video;
import com.brightcove.player.view.BrightcovePlayer;
import com.brightcove.player.view.BrightcoveVideoView;

public class BrightcoveActivity extends BrightcovePlayer {

    private static final String BRIGHTCOVE_ACTIVITY_NAME = "player";
    private static final String BRIGHTCOVE_VIEW_NAME = "brightcove_video_view";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        // When extending the BrightcovePlayer, we must assign the BrightcoveVideoView before
        // entering the superclass.
        setContentView(this.getIdFromResources(BRIGHTCOVE_ACTIVITY_NAME, "layout"));
        brightcoveVideoView = (BrightcoveVideoView) findViewById(this.getIdFromResources(BRIGHTCOVE_VIEW_NAME, "id"));

        super.onCreate(savedInstanceState);

        Intent intent = getIntent();

        String brightcovePolicyKey = intent.getStringExtra("brightcove-policy-key");
        String brightcoveAccountId = intent.getStringExtra("brightcove-account-id");
        String videoId = intent.getStringExtra("video-id");

        playById(brightcovePolicyKey, brightcoveAccountId, videoId);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
    }

    private int getIdFromResources(String activityName, String location) {
        String package_name = getApplication().getPackageName();
        Resources resources = getApplication().getResources();
        return resources.getIdentifier(activityName, location, package_name);
    }

    private void playById(String policyKey, String accountId, String videoId) {
        EventEmitter eventEmitter = brightcoveVideoView.getEventEmitter();
        Catalog catalog = new Catalog(eventEmitter, accountId, policyKey);
        catalog.findVideoByID(videoId, new VideoListener() {

            @Override
            public void onVideo(Video video) {
                brightcoveVideoView.add(video);
                brightcoveVideoView.start();
            }

            @Override
            public void onError(String error) {
                Log.e("BrightcoveActivity", error);
            }
        });
    }
}
