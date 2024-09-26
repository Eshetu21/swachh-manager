import { BaseMessage } from "firebase-admin/lib/messaging/messaging-api";
import { PickupRequestStatus } from "../../interfaces";

export class NotificationMessageHelper {
  static getMessageOnStatusUpdate(status: PickupRequestStatus): BaseMessage {
    if (status === PickupRequestStatus.ACCEPTED) {
      return {
        notification: {
          title: "🎉 Pickup Request Accepted! 🚀",
          body: " ✅ Your pickup request has been accepted!",
        },
      };
    } else if (status === PickupRequestStatus.DENIED) {
      return {
        notification: {
          title: "We are sorry 😔 🙇",
          body: "Unfortunately, we cannot pick up your request due to some internal reasons. 😔 We appreciate your understanding! 🙏✨",
        },
      };
    } else if (status === PickupRequestStatus.ON_THE_WAY) {
      return {
        notification: {
          title: "🚗✨ Our team is on the way! 🚀",
          body: "Our boys are on the way to pick you up! 🥳 We will notify you when they're ready. 📲",
        },
      };
    } else if (status === PickupRequestStatus.PICKED) {
      return {
        notification: {
          title: "🎉 Scrap Picked Up! 🚀",
          body: "Your scrap pickup request has been successfully picked up by our team! 🛠️ We will email you the receipts shortly. 📧",
        },
      };
    } else {
      return {
        notification: {
          title: `Your pickup request status is ${status}`,
          body: `Your pickup request status has been changed to ${status}`,
        },
      };
    }
  }

  static getMessageOnRequestAssignedToPickupBoy(reqId: string): BaseMessage {
    return {
      notification: {
        title: "New Request assigned",
        body: "New request has been assigned to you",
      },
      data: {
        navigate: `/requestPreview/${reqId}`,
      },
    };
  }

  static getMessageOnRequestCreated(
    reqId: string,
    qtyRange: string
  ): BaseMessage {
    return {
      notification: {
        title: `New Pickup request of ${qtyRange} Kgs.`,
        body: "See new request for more information.",
      },
    };
  }
}
