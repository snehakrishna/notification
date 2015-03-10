import QtQuick 2.0

Item {
    id: wrapper

    property string ip_addr: "http://10.1.10.167:8080"

    property variant model: devices

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
}
