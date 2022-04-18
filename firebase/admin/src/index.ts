import admin from "firebase-admin";
import fs from "fs";

const exportedDataPath = "C:/Dev/Projects/HVAC-remote/firebase/admin/exported/exportedData.json";
const certPath = "C:/Dev/Projects/HVAC-remote/firebase/admin/src/snappy-provider-295713-firebase-adminsdk-hx6eu-4cf9751134.json";

admin.initializeApp({
  credential: admin.credential.cert(certPath),
});

(async () => {
  const colRef = await admin.firestore().collection("measurements");
  const snap = await colRef.get();

  const timeseries = snap.docs.map((doc)=>{
    const data = doc.data();
    data.time = doc.id;
    return data;
  });

  fs.writeFile(exportedDataPath, JSON.stringify(timeseries), ()=>0 );
})();
