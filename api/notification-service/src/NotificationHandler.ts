import { SupabaseClient } from "@supabase/supabase-js";
import * as admin from "firebase-admin";
import { supabaseClient, tokensTable } from "./constants";
import { UserMessage } from "./interfaces";

export default class NotificationHandler {
  private supabase: SupabaseClient;

  constructor() {
    this.supabase = supabaseClient();
  }

  async handle(message: UserMessage) {
    if (message.subscriptions == "push") {
      const tokens = await this.getTokens(message.recipientIds);
      await this.sendPushNotifications(tokens, message);
    } else if (message.subscriptions == "email") {
      // Send email notifications using SMTP or a third-party service
      console.log("Sending email notifications to recipients.");
    }
  }

  private async getTokens(userIds: string[]): Promise<string[]> {
    return this.supabase
      .from(tokensTable)
      .select("token")
      .in("user_id", userIds)
      .then(({ data, error }) => {
        if (error) {
          throw new Error("Failed to retrieve tokens");
        } else {
          return data.map((json) => json.token);
        }
      });
  }
  private async sendPushNotifications(
    tokens: string[],
    notification: UserMessage
  ): Promise<void> {
    if (!tokens.length) {
      console.log("No tokens found to send notifications.");
      return Promise.resolve();
    }

    const payload = {
      ...notification,
      tokens,
    };

    return admin
      .messaging()
      .sendEachForMulticast(payload)
      .then((response) => {
        console.log(response.responses[0].error)
        console.log(
          `Successfully sent ${response.successCount} notifications.`
        );
        if (response.failureCount > 0) {
          console.log(`Failed to send ${response.failureCount} notifications.`);
        }
      })
      .catch((error) => {
        console.error("Error sending push notifications:", error);
        throw error;
      });
  }
}
