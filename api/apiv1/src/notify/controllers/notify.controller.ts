import { SupabaseClient } from "@supabase/supabase-js";
import { BaseMessage } from "firebase-admin/lib/messaging/messaging-api";
import { logger } from "firebase-functions/v1";
import { supabaseClient } from "../../constants";
import { DatabaseWebhook, UserMessage } from "../../interfaces";
import PubSubService from "../../services/pubsub.service";
import { NotificationMessageHelper } from "../helpers/notificationMessage.helper";

export default class NotifyController {
  private supabase: SupabaseClient;
  private pubsubService: PubSubService;

  constructor() {
    this.supabase = supabaseClient();
    this.pubsubService = new PubSubService();
  }
  async notifyOnStatusUpdate(webhook: DatabaseWebhook): Promise<void> {
    let messsage: BaseMessage =
      NotificationMessageHelper.getMessageOnStatusUpdate(webhook.record.status);
    let userMessage: UserMessage = {
      ...messsage,
      recipientIds: [webhook.record.requestingUserId],
      subscriptions:"push",
    };
    /// deliver notification to owner of scrap request
    this.pubsubService.publishMessage(userMessage);
    /// deliver notification to the pickup boy
    if (
      webhook.record.deliveryPartnerId != null &&
      webhook.old_record.deliveryPartnerId == null
    ) {
      /// send push notification to all pickup boy
      let pickupBoyMessage =
        NotificationMessageHelper.getMessageOnRequestAssignedToPickupBoy(
          webhook.record.id
        );
      let userMessage: UserMessage = {
        ...pickupBoyMessage,
        recipientIds: [webhook.record.deliveryPartnerId],
        subscriptions:"push"
      };
      logger.log(`Notified pickupboy`);
      this.pubsubService.publishMessage(userMessage);
    }
  }

  async notifyOnRequestCreated(webhook: DatabaseWebhook) {
    let message = NotificationMessageHelper.getMessageOnRequestCreated(
      webhook.record.id,
      webhook.record.qtyRange
    );
    this.supabase
      .from("admins")
      .select("user_id")
      .select()
      .then(({ data, error }) => {
        if (data) {
          let userIds = data.map((item) => item.user_id);
          let userMessage: UserMessage = {
            ...message,
            recipientIds: userIds,
            subscriptions:"push"
          };
          logger.info(`Recieved ${userIds.length} admins`);
          this.pubsubService.publishMessage(userMessage);
        }
        if (error) {
          logger.error(error);
        }
      });
  }
}
