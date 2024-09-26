import * as cors from "cors";
import * as express from "express";
import * as admin from "firebase-admin";
import { applicationDefault, initializeApp } from "firebase-admin/app";
import * as functions from "firebase-functions";
import notificationRouter from "./notify/routes/notify.routes";

initializeApp({
  credential: applicationDefault(),
  projectId: process.env.GCLOUD_PROJECT,
});
admin.firestore().settings({ ignoreUndefinedProperties: true });

// Create Express app
const app = express();

// Enable CORS for all routes
app.use(cors());
app.use(express.json()); // Ensure the body is parsed as JSON


app.get("/status", (req, res) => {
  res.status(200).send("Server is running");
});

// notification router
app.use("/notify", notificationRouter);
// Error handler
app.use(
  (
    err: any,
    req: express.Request,
    res: express.Response,
    next: express.NextFunction
  ) => {
    console.error("Unhandled error:", err.stack);
    res.status(500).send("Something broke!");
  }
);

// Expose Express app as a Cloud Function
exports.apiv1 = functions.region("asia-south1").https.onRequest(app);
