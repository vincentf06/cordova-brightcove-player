package com.brightcove.player;

import android.content.Intent;
import android.content.res.Resources;
import android.os.Bundle;

import com.brightcove.player.edge.Catalog;
import com.brightcove.player.edge.VideoListener;
import com.brightcove.player.event.EventEmitter;
import com.brightcove.player.model.Video;
import com.brightcove.player.view.BrightcovePlayer;
import com.brightcove.player.view.BrightcoveVideoView;

public class BrightcoveActivity extends BrightcovePlayer {

    private static final String BRIGHTCOVE_ACTIVITY = "player";
    private static final String BRIGHTCOVE_VIEW = "brightcove_video_view";

    static final String PLAYER_EVENT = "PLAYER_EVENT";

    private String brightcovePolicyKey = null;
    private String brightcoveAccountId = null;
    private String videoId = null;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        setContentView(this.getIdFromResources(BRIGHTCOVE_ACTIVITY, "layout"));
        brightcoveVideoView = (BrightcoveVideoView) findViewById(this.getIdFromResources(BRIGHTCOVE_VIEW, "id"));

        super.onCreate(savedInstanceState);

        Intent intent = getIntent();

        brightcovePolicyKey = intent.getStringExtra("brightcove-policy-key");
        brightcoveAccountId = intent.getStringExtra("brightcove-account-id");
        videoId = intent.getStringExtra("video-id");

        playById(brightcovePolicyKey, brightcoveAccountId, videoId);

        return;
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
    }

    private int getIdFromResources(String what, String where){
        String package_name = getApplication().getPackageName();
        Resources resources = getApplication().getResources();
        return resources.getIdentifier(what, where, package_name);
    }

    private void playById(String policyKey, String accountId, String id){

        this.fullScreen();
        EventEmitter eventEmitter = brightcoveVideoView.getEventEmitter();
        Catalog catalog = new Catalog(eventEmitter, brightcoveAccountId, brightcovePolicyKey);
        catalog.findVideoByID(videoId, new VideoListener() {

            @Override
            public void onVideo(Video video) {
                brightcoveVideoView.add(video);
                brightcoveVideoView.start();
            }

            @Override
            public void onError(String s) {
                throw new RuntimeException(s);
            }
        });

        return;
    }
}
