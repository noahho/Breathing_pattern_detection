package com.example.noahh_000.bluetoothgix;

/**
 * Created by NoahH_000 on 25.11.2016.
 */

import java.util.HashMap;

/**
 * This class includes a small subset of standard GATT attributes for demonstration purposes.
 */
public class GattAttributes {
    private static HashMap<String, String> attributes = new HashMap();
    public static String BLUNO_SERVICE = "0000dfb0-0000-1000-8000-00805f9b34fb";
    public static String BLUNO_OUTPUT_ANALOG = "0000dfb1-0000-1000-8000-00805f9b34fb";
    public static String CLIENT_CHARACTERISTIC_CONFIG = "00002902-0000-1000-8000-00805f9b34fb";

    static {
        // Sample Services.
        attributes.put(BLUNO_SERVICE, "Bluno Bluetooth Service Analog");
        attributes.put("0000180a-0000-1000-8000-00805f9b34fb", "Device Information Service");

        // Sample Characteristics.
        attributes.put(BLUNO_OUTPUT_ANALOG, "BlUNO analog output");
        attributes.put("00002a29-0000-1000-8000-00805f9b34fb", "Manufacturer Name String");
    }

    public static String lookup(String uuid, String defaultName) {
        String name = attributes.get(uuid);
        return name == null ? defaultName : name;
    }
}