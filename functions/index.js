const functions = require("firebase-functions");
const admin = require("firebase-admin");
const cron = require("node-cron");

admin.initializeApp();

const db = admin.firestore();

exports.scheduledTaskNotification = functions.pubsub.schedule("every 1 minutes").onRun(async (context) => {
    const now = admin.firestore.Timestamp.now();
    const oneHourLater = new Date(now.toDate().getTime() + 60 * 60 * 1000);

    // Получаем задачи, срок которых истекает через час
    const tasksSnapshot = await db.collectionGroup("tasks")
        .where("endDate", ">=", now)
        .where("endDate", "<=", oneHourLater)
        .get();

    const notifications = [];

    tasksSnapshot.forEach((doc) => {
        const task = doc.data();
        const userId = doc.ref.parent.parent.id; // ID пользователя из коллекции
        
        // Отправляем уведомление пользователю
        notifications.push(
            admin.messaging().sendToTopic(userId, {
                notification: {
                    title: "Task Reminder",
                    body: `Task "${task.title}" is due in less than an hour.`,
                },
            })
        );
    });

    await Promise.all(notifications);
    console.log("Notifications sent successfully!");
});


const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");
