package com.getcapacitor.community.facebooklogin;

import android.os.Bundle;
import com.getcapacitor.JSArray;
import com.getcapacitor.JSObject;
import java.lang.reflect.Array;
import java.util.Collection;
import java.util.Map;
import org.json.JSONArray;
import org.json.JSONObject;

final class DeferredDeepLinkJson {

    private DeferredDeepLinkJson() {}

    static JSObject fromArguments(Map<String, Object> arguments) {
        return fromMap(arguments);
    }

    private static JSObject fromBundle(Bundle bundle) {
        JSObject result = new JSObject();
        for (String key : bundle.keySet()) {
            result.put(key, toJsonValue(bundle.get(key)));
        }
        return result;
    }

    private static JSObject fromMap(Map<?, ?> map) {
        JSObject result = new JSObject();
        for (Map.Entry<?, ?> entry : map.entrySet()) {
            result.put(String.valueOf(entry.getKey()), toJsonValue(entry.getValue()));
        }
        return result;
    }

    private static JSArray fromCollection(Collection<?> collection) {
        JSArray result = new JSArray();
        for (Object value : collection) {
            result.put(toJsonValue(value));
        }
        return result;
    }

    private static JSArray fromArray(Object array) {
        JSArray result = new JSArray();
        int length = Array.getLength(array);
        for (int index = 0; index < length; index++) {
            result.put(toJsonValue(Array.get(array, index)));
        }
        return result;
    }

    private static Object toJsonValue(Object value) {
        if (value == null) {
            return JSONObject.NULL;
        }
        if (value instanceof Bundle) {
            return fromBundle((Bundle) value);
        }
        if (value instanceof Map) {
            return fromMap((Map<?, ?>) value);
        }
        if (value instanceof Collection) {
            return fromCollection((Collection<?>) value);
        }
        if (value.getClass().isArray()) {
            return fromArray(value);
        }
        if (
            value instanceof JSONObject ||
            value instanceof JSONArray ||
            value instanceof Boolean ||
            value instanceof Number ||
            value instanceof String
        ) {
            return value;
        }
        return value.toString();
    }
}
