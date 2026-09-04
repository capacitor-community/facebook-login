package com.getcapacitor.community.facebooklogin;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertSame;

import com.getcapacitor.JSObject;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import org.json.JSONArray;
import org.json.JSONObject;
import org.junit.Test;

public class DeferredDeepLinkJsonTest {

    @Test
    public void recursivelyConvertsNestedArgumentsToJsonValues() throws Exception {
        Map<String, Object> arguments = new LinkedHashMap<>();
        arguments.put("target_url", "https://example.com/deferred-link");
        arguments.put("referer_data", Map.of("fb_ref", "neutral-ref"));
        arguments.put("items", List.of(Map.of("name", "first"), "second"));
        arguments.put("codes", new String[] { "one", "two" });
        arguments.put("attempts", new int[] { 1, 2 });
        arguments.put("missing", null);

        JSObject result = DeferredDeepLinkJson.fromArguments(arguments);

        assertEquals("neutral-ref", result.getJSONObject("referer_data").getString("fb_ref"));
        JSONArray items = result.getJSONArray("items");
        assertEquals("first", items.getJSONObject(0).getString("name"));
        assertEquals("second", items.getString(1));
        assertEquals("two", result.getJSONArray("codes").getString(1));
        assertEquals(2, result.getJSONArray("attempts").getInt(1));
        assertSame(JSONObject.NULL, result.get("missing"));
    }

    @Test
    public void convertsUnknownNativeValuesToStrings() throws Exception {
        JSObject result = DeferredDeepLinkJson.fromArguments(Map.of("value", new StringBuilder("native-value")));

        assertEquals("native-value", result.getString("value"));
    }
}
