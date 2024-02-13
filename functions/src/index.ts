import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();

export const updateUserLevel = functions.firestore
  .document("users/{userId}")
  .onUpdate(async (change, context) => {
    const newValue = change.after.data();
    const oldPercent = change.before.data();

    const newPercent = newValue.level_percentage || 0;
    const previousPercentage = oldPercent.level_percentage;

    if (newPercent >= 100 && previousPercentage < 100) {
      const newLevel = newValue.level ? newValue.level + 1 : 1;
      return change.after.ref.update({
        level: newLevel,
        level_percentage: 0, // Reset the percentage
      });
    }
    return null;
  });
