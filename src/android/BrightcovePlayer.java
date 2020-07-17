package com.brightcove.player;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaWebView;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.content.Context;
import android.content.Intent;

public class BrightcovePlayer extends CordovaPlugin {

    private String brightcovePolicyKey = null;
    private String brightcoveAccountId = null;
    private CordovaWebView appView;

    @Override
    public void initialize(CordovaInterface cordova, CordovaWebView webView) {
        super.initialize(cordova, webView);
        appView = webView;
    }

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if (action.equals("play")) {
            String id = args.getString(0);
            this.play(id, callbackContext);
            return true;
        } else if(action.equals("initAccount")) {
            String policyKey = args.getString(0);
            String accountId = args.getString(1);
            this.initAccount(policyKey, accountId, callbackContext);
            return true;
        } else if(action.equals("switchAccount")) {
            String policyKey = args.getString(0);
            String accountId = args.getString(1);
            this.switchAccount(policyKey, accountId, callbackContext);
            return true;
        }

        return false;
    }

    private void play(String videoId, CallbackContext callbackContext) {
        if (this.brightcovePolicyKey == null || this.brightcoveAccountId == null) {
            callbackContext.error("Please init your account first");
            return;
        }

        if (videoId != null && videoId.length() > 0) {
            Context context = this.cordova.getActivity().getApplicationContext();
            Intent intent = new Intent(context, BrightcoveActivity.class);
            intent.putExtra("video-id", videoId);
            intent.putExtra("brightcove-policy-key", this.brightcovePolicyKey);
            intent.putExtra("brightcove-account-id", this.brightcoveAccountId);
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            context.startActivity(intent);

            callbackContext.success("Playing now with Brightcove ID: " + videoId);
        } else {
            callbackContext.error("Empty video ID!");
        }
    }

    private void initAccount(String policyKey, String accountId, CallbackContext callbackContext) {
        if (policyKey != null && policyKey.length() > 0 && accountId != null && accountId.length() > 0 ) {
            this.brightcovePolicyKey = policyKey;
            this.brightcoveAccountId = accountId;
            callbackContext.success("Brightcove account was initialised");
        } else {
            callbackContext.error("Brightcove policy key or account id is not valid");
        }
    }

    private void switchAccount(String policyKey, String accountId, CallbackContext callbackContext) {
        this.initAccount(policyKey, accountId, callbackContext);
    }
}
