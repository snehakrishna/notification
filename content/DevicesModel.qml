import QtQuick 2.0

Item {
    id: wrapper
    property variant model: devices

    property int status: XMLHttpRequest.UNSENT
    property bool isLoading: status === XMLHttpRequest.LOADING
    property bool wasLoading: false
    signal isLoaded

    ListModel { id: devices }

    function reload() {
        devices.clear()
        var req = new XMLHttpRequest;
        req.open("GET", ip_addr + "/sensors", true);
        req.setRequestHeader("content-type", "application/json");
        req.setRequestHeader("accept", "application/json");
        req.responseType = "json"
        //console.debug("opened xmlHttpRequest")
        req.onreadystatechange = function() {
            //console.debug("onreadystatechange")
            status = req.readyState;
            if (status === XMLHttpRequest.DONE) {
                try {
                    var objectArray = JSON.parse(req.responseText);
                    console.log(req.responseText)
                } catch (e) {
                    console.log("network not available: " + e.message);
                    return;
                }
                if (objectArray.errors !== undefined)
                    console.log("Error fetching tweets: " + objectArray.errors[0].message)
                else {
                    for (var key in objectArray) {
                        var jsonObject = objectArray[key];
                        devices.append(jsonObject);
                        console.log(jsonObject.sensor_id)
                    }
                }
                if (wasLoading == true)
                    wrapper.isLoaded()
                scheduleModel.reload()
                roomModel.reload()
            }
            wasLoading = (status === XMLHttpRequest.LOADING);
        }
        req.send();
    }
}
