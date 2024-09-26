import * as express from "express";
import NotifyController from "../controllers/notify.controller";

const notificationRouter = express.Router();

notificationRouter.post("/requestUpdates", (req, res) => {
  let notificationController = new NotifyController();
  notificationController.notifyOnStatusUpdate(req.body).then(() => {
    res.status(200).send();
  });
});
notificationRouter.post("/newRequest", (req, res) => {
  let notificationController = new NotifyController();
  notificationController.notifyOnRequestCreated(req.body).then(() => {
    res.status(200).send();
  });
});

export default notificationRouter;
/*
1. Status updates of requests
2. When pickup is done
3. When a request is assigned to deliver agent
4. when a request is created from the app.
*/
