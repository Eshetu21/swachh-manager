import { PubSub } from "@google-cloud/pubsub";
import { logger } from "../constants";

export default class PubSubService {
  private pubsubClient: PubSub;
  private topicName: string;
  constructor(topicName?: string) {
    this.pubsubClient = new PubSub();
    this.topicName = topicName || "user-notifications";
  }

  async publishMessage(message: any): Promise<void> {
  
    const data = Buffer.from(JSON.stringify(message));
  
    return this.pubsubClient
      .topic(this.topicName)
      .publishMessage({ data: data })
      .then((id) => {
        logger.info(`Published message ${id}`);
        return;
      });
  }
}
