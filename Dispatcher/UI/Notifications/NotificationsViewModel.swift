import Foundation

class NotificationsViewModel {
    
    var notificationsArray: [NotificationModel] = [
        NotificationModel(text: "Notification text about a new article from a tag you liked, two lines of text.", wasRead: true),
        NotificationModel(text: "Unread notification text about a new article from a tag you liked, two lines of text.", wasRead: false)
    ]
}
