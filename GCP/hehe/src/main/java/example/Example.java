package example;

import example.Example.PubSubMessage;
import com.google.cloud.functions.BackgroundFunction;
import com.google.cloud.functions.Context;
import java.util.Base64;
import java.util.Map;
import java.util.logging.Logger;
import java.io.*;
import java.lang.reflect.Type;
import java.security.GeneralSecurityException;
import java.nio.charset.StandardCharsets;
import com.google.auth.oauth2.GoogleCredentials;
import com.google.api.client.json.gson.GsonFactory;
import com.google.api.client.http.HttpRequestInitializer;
import com.google.api.services.cloudiot.v1.CloudIot;
import com.google.api.client.googleapis.javanet.GoogleNetHttpTransport;
import com.google.auth.http.HttpCredentialsAdapter;
import com.google.api.services.cloudiot.v1.model.DeviceConfig;
import com.google.api.services.cloudiot.v1.model.ModifyCloudToDeviceConfigRequest;
import com.google.api.services.cloudiot.v1.model.SendCommandToDeviceRequest;
import com.google.api.services.cloudiot.v1.CloudIotScopes;

import com.google.cloud.storage.Blob;
import com.google.cloud.storage.BlobId;
import com.google.cloud.storage.Storage;
import com.google.cloud.storage.StorageOptions;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

public class Example implements BackgroundFunction<PubSubMessage> {

    private static final Logger logger = Logger.getLogger(Example.class.getName());

    private static final String projectID = "snappy-provider-295713";

    private static final String appName = "mqtt-app";
    private static final String devicePath = "projects/snappy-provider-295713/locations/asia-east1/registries/mqtt-registry/devices/app";

    private static final String bucketName = "master_bucket-snappy-provider-295713";
    private static final String passwordFileName = "app_password.TXT";
    private static final long version = 0;

    private static final String failureConfig = "{ \"passwordIsTrue\":\"false\"}";

    public static void main(String[] args) throws GeneralSecurityException, IOException, NullPointerException {

    }

    @Override
    public void accept(PubSubMessage message, Context context)
            throws GeneralSecurityException, IOException, NullPointerException {
        final String truePassword = new String(getTruePassword().getContent());
        final String inputPassword = Base64ToUTF8(message.data);
        logger.info("Input password: " + inputPassword);

        final Boolean passwordIsTrue = truePassword.equals(inputPassword);
        String newConfig = "";
        try {
            String oldConfigDataBase64 = getCurrentConfig().getBinaryData();
            String oldConfigData = Base64ToUTF8(oldConfigDataBase64);
            newConfig = putPasswordStatusInConfig(passwordIsTrue, oldConfigData);
        } catch (Exception e) {
            newConfig = failureConfig;
        } finally {
            setDeviceConfiguration(newConfig);
            logger.info("New config: " + newConfig);
        }
    }

    protected static String putPasswordStatusInConfig(Boolean passwordIsTrue, String configData) {
        String key = "passwordIsTrue";
        Type mapType = new TypeToken<Map<String, String>>() {
        }.getType();
        Map<String, String> map = new Gson().fromJson(configData, mapType);
        map.put(key, passwordIsTrue.toString());
        String json = new Gson().toJson(map);
        return json;
    }

    public static class PubSubMessage {
        String data;
        Map<String, String> attributes;
        String messageId;
        String publishTime;
    }

    protected static void sendCommand(String data) throws GeneralSecurityException, IOException {
        final CloudIot service = getService();
        SendCommandToDeviceRequest req = new SendCommandToDeviceRequest();
        req.setBinaryData(UTF8ToBase64(data));
        System.out.printf("Sending command to %s%n", devicePath);
        service.projects().locations().registries().devices().sendCommandToDevice(devicePath, req).execute();
    }

    protected static DeviceConfig getCurrentConfig() throws GeneralSecurityException, IOException {
        CloudIot service = getService();
        DeviceConfig config = service.projects().locations().registries().devices().configVersions().list(devicePath)
                .execute().getDeviceConfigs().get(0);
        return config;
    }

    /**
     * Set a device configuration to the specified data (string, JSON) and version
     * (0 for latest).
     */
    protected static void setDeviceConfiguration(String data) throws GeneralSecurityException, IOException {
        final CloudIot service = getService();
        ModifyCloudToDeviceConfigRequest req = new ModifyCloudToDeviceConfigRequest();
        req.setVersionToUpdate(version);
        req.setBinaryData(UTF8ToBase64(data));
        DeviceConfig config = service.projects().locations().registries().devices()
                .modifyCloudToDeviceConfig(devicePath, req).execute();
        System.out.println("Updated: " + config.getVersion());
    }

    protected static String Base64ToUTF8(String data) {
        return new String(Base64.getDecoder().decode(data));
    }

    public static Blob getTruePassword() {
        Storage storage = StorageOptions.newBuilder().setProjectId(projectID).build().getService();
        Blob blob = storage.get(BlobId.of(bucketName, passwordFileName));
        return blob;
    }

    public static String UTF8ToBase64(String UTF8string) throws GeneralSecurityException, IOException {
        // Data sent through the wire has to be base64 encoded.
        Base64.Encoder encoder = Base64.getEncoder();
        return encoder.encodeToString(UTF8string.getBytes(StandardCharsets.UTF_8.name()));
    }

    protected static CloudIot getService() throws GeneralSecurityException, IOException {
        GoogleCredentials credential = GoogleCredentials.getApplicationDefault().createScoped(CloudIotScopes.all());
        GsonFactory jsonFactory = GsonFactory.getDefaultInstance();
        HttpRequestInitializer init = new HttpCredentialsAdapter(credential);
        final CloudIot service = new CloudIot.Builder(GoogleNetHttpTransport.newTrustedTransport(), jsonFactory, init)
                .setApplicationName(appName).build();
        return service;
    }

}
