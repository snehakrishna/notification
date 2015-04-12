import QtQuick 2.0

Item {
    id: wrapper
    property variant model: rooms

    property int status: XMLHttpRequest.UNSENT
    property bool isLoading: status === XMLHttpRequest.LOADING
    property bool wasLoading: false
    signal isLoaded

    ListModel { id: rooms }
    function encodePhrase(x) { return encodeURIComponent(x); }

    function reload() {
        rooms.clear()

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
                } catch (e) {
                    console.log("network not available");
                    return;
                }
                if (objectArray.errors !== undefined)
                    console.log("Error fetching tweets: " + objectArray.errors[0].message)
                else {
                    for (var key in objectArray) {
                        var jsonObject = objectArray[key];
                        rooms.append(jsonObject);
                    }
                }
                if (wasLoading == true)
                    wrapper.isLoaded()
                scheduleModel.reload()
            }
            wasLoading = (status === XMLHttpRequest.LOADING);
        }
        req.send();
    }
}
