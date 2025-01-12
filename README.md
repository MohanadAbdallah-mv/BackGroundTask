# How to execute periodic tasks while your Flutter app is in background?   
“Below 15 min window”
Every once in a while you will need to execute a task even if the app is not in foreground .

First thing you would find in this topic is WorkManager package which allows you to execute background tasks periodically but as the package stated 

“Minimum frequency is 15 min. Android will automatically change your frequency to 15 min if you have configured a lower frequency.”

Work Manager  would serve you the best if you want to :

• Deferrable and guaranteed execution : WorkManager is ideal for tasks that can be deferred and executed at an appropriate time, considering factors like network connectivity and battery optimization.

• Periodic or one-off tasks : If you have tasks that need to be executed periodically (e.g., sync data with a server every hour) or only once (e.g., sending analytics data), WorkManager simplifies scheduling and handling of such tasks.

• Battery-friendly : WorkManager is designed to optimize battery usage, allowing it to efficiently batch tasks and execute them even when the app is not running.

## How to get below the 15 min window  ??
 Let’s say you are developing order tracking application where you want to track your order on a map or UBER where you want to update the driver location on the map , the 15 min window won’t be efficient.

The solution i found was creating a Native service → Locked Native Notification using method channel .

Creating this notification with a trigger button to turn it on/off  allowed me to send driver/user location every  15 seconds   “ instead of 15 min “ to the server even if the app is in foreground, background  or locked screen .
Turn the trigger off to turn off  task execution and remove the locked notification  .

It’s important to note that WorkManager is more suitable for most background tasks, as it provides a robust and battery-efficient solution while supporting backward compatibility to a wider range of Android versions. 
Services, on the other hand, can still be used for certain scenarios where WorkManager might not be the best fit, such as real-time continuous monitoring tasks.

## disclaimer :
The service method should be used with apps that require user interaction with the server most of the time .
Don’t force the user to use this method in your app, user should be able to start/stop the service on his own during his “working “ state such as a driver-user at Uber or delivery-user at Food-delivery app . 

👉If you want to learn more about when to use WorkManager vs Service you can check this article: https://medium.com/@appdevinsights/when-to-use-service-and-when-to-use-workmanager-9760613ce5c2



https://github.com/user-attachments/assets/eaf610c7-94e7-4034-890b-2359dbee5298

