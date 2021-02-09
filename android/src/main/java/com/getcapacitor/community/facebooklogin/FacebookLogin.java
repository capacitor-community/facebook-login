package com.getcapacitor.community.facebooklogin;

import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;
import com.facebook.AccessToken;
import com.facebook.CallbackManager;
import com.facebook.FacebookCallback;
import com.facebook.FacebookException;
import com.facebook.FacebookRequestError;
import com.facebook.GraphRequest;
import com.facebook.GraphResponse;
import com.facebook.login.LoginManager;
import com.facebook.login.LoginResult;
import com.getcapacitor.JSArray;
import com.getcapacitor.JSObject;
import com.getcapacitor.NativePlugin;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import java.text.SimpleDateFormat;
import java.util.Collection;
import java.util.Date;
import java.util.List;
import java.util.Set;
import java.util.TimeZone;
import org.json.JSONException;
import org.json.JSONObject;

@NativePlugin(requestCodes = { FacebookLogin.FACEBOOK_SDK_REQUEST_CODE_OFFSET })
public class FacebookLogin extends Plugin {

    CallbackManager callbackManager;

    public static final int FACEBOOK_SDK_REQUEST_CODE_OFFSET = 0xface;

    /**
     * Convert date to ISO 8601 format.
     */
    private String dateToJson(Date date) {
        SimpleDateFormat simpleDateFormat;

        try {
            simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSXXX");
        } catch (Exception e) {
            simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ");
        }

        return simpleDateFormat.format(date);
    }

    private JSArray collectionToJson(Collection<String> list) {
        JSArray json = new JSArray();

        for (String item : list) {
            json.put(item);
        }

        return json;
    }

    private JSObject accessTokenToJson(AccessToken accessToken) {
        JSObject ret = new JSObject();
        ret.put("applicationId", accessToken.getApplicationId());
        ret.put("declinedPermissions", collectionToJson(accessToken.getDeclinedPermissions()));
        ret.put("expires", dateToJson(accessToken.getExpires()));
        ret.put("lastRefresh", dateToJson(accessToken.getLastRefresh()));
        ret.put("permissions", collectionToJson(accessToken.getPermissions()));
        ret.put("token", accessToken.getToken());
        ret.put("userId", accessToken.getUserId());
        ret.put("isExpired", accessToken.isExpired());

        return ret;
    }

    @Override
    public void load() {
        Log.d(getLogTag(), "Entering load()");

        this.callbackManager = CallbackManager.Factory.create();

        LoginManager
            .getInstance()
            .registerCallback(
                callbackManager,
                new FacebookCallback<LoginResult>() {
                    @Override
                    public void onSuccess(LoginResult loginResult) {
                        Log.d(getLogTag(), "LoginManager.onSuccess");

                        PluginCall savedCall = getSavedCall();

                        if (savedCall == null) {
                            Log.e(getLogTag(), "LoginManager.onSuccess: no plugin saved call found.");
                        } else {
                            JSObject ret = new JSObject();
                            ret.put("accessToken", accessTokenToJson(loginResult.getAccessToken()));
                            ret.put("recentlyGrantedPermissions", collectionToJson(loginResult.getRecentlyGrantedPermissions()));
                            ret.put("recentlyDeniedPermissions", collectionToJson(loginResult.getRecentlyDeniedPermissions()));

                            savedCall.success(ret);

                            saveCall(null);
                        }
                    }

                    @Override
                    public void onCancel() {
                        Log.d(getLogTag(), "LoginManager.onCancel");

                        PluginCall savedCall = getSavedCall();

                        if (savedCall == null) {
                            Log.e(getLogTag(), "LoginManager.onCancel: no plugin saved call found.");
                        } else {
                            JSObject ret = new JSObject();
                            ret.put("accessToken", null);

                            savedCall.success(ret);

                            saveCall(null);
                        }
                    }

                    @Override
                    public void onError(FacebookException exception) {
                        Log.e(getLogTag(), "LoginManager.onError", exception);

                        PluginCall savedCall = getSavedCall();

                        if (savedCall == null) {
                            Log.e(getLogTag(), "LoginManager.onError: no plugin saved call found.");
                        } else {
                            savedCall.reject(exception.toString());

                            saveCall(null);
                        }
                    }
                }
            );
    }

    @Override
    protected void handleOnActivityResult(int requestCode, int resultCode, Intent data) {
        Log.d(getLogTag(), "Entering handleOnActivityResult(" + requestCode + ", " + resultCode + ")");

        if (callbackManager.onActivityResult(requestCode, resultCode, data)) {
            Log.d(getLogTag(), "onActivityResult succeeded");
        } else {
            Log.w(getLogTag(), "onActivityResult failed");
        }
    }

    @PluginMethod
    public void login(PluginCall call) {
        Log.d(getLogTag(), "Entering login()");

        PluginCall savedCall = getSavedCall();

        if (savedCall != null) {
            Log.e(getLogTag(), "login: overlapped calls not supported");

            call.reject("Overlapped calls call not supported");

            return;
        }

        JSArray arg = call.getArray("permissions");

        Collection<String> permissions;

        try {
            permissions = arg.toList();
        } catch (Exception e) {
            Log.e(getLogTag(), "login: invalid 'permissions' argument", e);

            call.reject("Invalid permissions argument");

            return;
        }

        LoginManager.getInstance().logInWithReadPermissions(this.getActivity(), permissions);

        saveCall(call);
    }

    @PluginMethod
    public void logout(PluginCall call) {
        Log.d(getLogTag(), "Entering logout()");

        LoginManager.getInstance().logOut();

        call.success();
    }

    @PluginMethod
    public void getCurrentAccessToken(PluginCall call) {
        Log.d(getLogTag(), "Entering getCurrentAccessToken()");

        AccessToken accessToken = AccessToken.getCurrentAccessToken();

        JSObject ret = new JSObject();

        if (accessToken == null) {
            Log.d(getLogTag(), "getCurrentAccessToken: accessToken is null");
        } else {
            Log.d(getLogTag(), "getCurrentAccessToken: accessToken found");

            ret.put("accessToken", accessTokenToJson(accessToken));
        }

        call.success(ret);
    }

    @PluginMethod
    public void getProfile(final PluginCall call) {
        Log.d(getLogTag(), "Entering getProfile()");

        AccessToken accessToken = AccessToken.getCurrentAccessToken();

        if (accessToken == null) {
            Log.d(getLogTag(), "getProfile: accessToken is null");
            call.error("You're not logged in. Call FacebookLogin.login() first to obtain an access token.");

            return;
        }

        if (accessToken.isExpired()) {
            Log.d(getLogTag(), "getProfile: accessToken is expired");
            call.error("AccessToken is expired.");

            return;
        }

        Bundle parameters = new Bundle();

        try {
            JSArray fields = call.getArray("fields");
            String fieldsString = TextUtils.join(",", fields.toList());

            parameters.putString("fields", fieldsString);
        } catch (JSONException e) {
            call.error("Can't handle fields", e);

            return;
        }

        GraphRequest graphRequest = GraphRequest.newMeRequest(
            accessToken,
            new GraphRequest.GraphJSONObjectCallback() {
                @Override
                public void onCompleted(JSONObject object, GraphResponse response) {
                    FacebookRequestError requestError = response.getError();

                    if (requestError != null) {
                        call.error(requestError.getErrorMessage());

                        return;
                    }

                    try {
                        JSONObject jsonObject = response.getJSONObject();
                        JSObject jsObject = JSObject.fromJSONObject(jsonObject);

                        call.success(jsObject);
                    } catch (JSONException e) {
                        call.error("Can't create response", e);
                    }
                }
            }
        );

        graphRequest.setParameters(parameters);
        graphRequest.executeAsync();
    }
}
