import QtQuick 2.0

Item {
    id: wrapper

    // Insert valid consumer key and secret tokens below
    // See https://dev.twitter.com/apps
    property string consumerKey : ""
    property string consumerSecret : ""
    property string bearerToken : ""
    property string ip_addr: "http://10.1.5.219:3000"

    property variant model: devices
    property string from : ""
    property string phrase : ""

    property int status: XMLHttpRequest.UNSENT
    property bool isLoading: status === XMLHttpRequest.LOADING
    property bool wasLoading: false
    signal isLoaded

    ListModel { id: devices }

    function encodePhrase(x) { return encodeURIComponent(x); }

    function reload() {
        devices.clear()

        var req = new XMLHttpRequest;
        req.open("GET", ip_addr + "/sensors", true);
        req.setRequestHeader("content-type", "application/json");
        req.setRequestHeader("accept", "application/json");
        req.responseType = "json"
        console.debug("opened xmlHttpRequest")
        req.onreadystatechange = function() {
            console.debug("onreadystatechange")
            status = req.readyState;
            if (status === XMLHttpRequest.DONE) {
                //console.debug("mystuff: ", req.responseText)
                var objectArray = JSON.parse(req.responseText);
                if (objectArray.errors !== undefined)
                    console.log("Error fetching tweets: " + objectArray.errors[0].message)
                else {
                    for (var key in objectArray) {
                        var jsonObject = objectArray[key];
                        console.debug(objectArray[key].sensor_id)
                        devices.append(jsonObject);
                    }
                }
                if (wasLoading == true)
                    wrapper.isLoaded()
            }
            wasLoading = (status === XMLHttpRequest.LOADING);
        }
        req.send();
    }

//    Component.onCompleted: {
//        var authReq = new XMLHttpRequest;
//        authReq.open("POST", "https://api.twitter.com/oauth2/token");
//        authReq.setRequestHeader("Content-Type", "application/x-www-form-urlencoded;charset=UTF-8");
//        authReq.setRequestHeader("Authorization", "Basic " + Qt.btoa(consumerKey + ":" + consumerSecret));
//        authReq.onreadystatechange = function() {
//            if (authReq.readyState === XMLHttpRequest.DONE) {
//                var jsonResponse = JSON.parse(authReq.responseText);
//                if (jsonResponse.errors !== undefined)
//                    console.log("Authentication error: " + jsonResponse.errors[0].message)
//                else
//                    bearerToken = jsonResponse.access_token;
//            }
//        }
//        authReq.send("grant_type=client_credentials");
//    }
}
