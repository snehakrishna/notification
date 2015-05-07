import QtQuick 2.0

Item {
    id: rooms_wrapper
    property variant model: rooms

    property int status: XMLHttpRequest.UNSENT
    property bool isLoading: status === XMLHttpRequest.LOADING
    property bool wasLoading: false
    signal isLoaded

    property var rooms_array
    property var rooms_list

    ListModel { id: rooms }

    function reload() {
        rooms.clear()

        //find unique rooms and number of rooms r
        var rooms_list = new Array()
        for (var i = 0; i < main.sensor_rooms.length; i++){
            console.log("room: " + main.sensor_rooms[i]);
            if (main.sensor_rooms[i] in rooms_list)
                continue;
            rooms_list.push(main.sensor_rooms[i]);
        }

        //create array (rooms_array) with length of r
        //sort sensors into each room using an object style
        rooms_array = new Array(rooms_list.length)
        for (var i = 0; i < rooms_list.length; i++){
            rooms_array[i] = new Array()
            for (var j = 0; j < main.sensor_rooms.length; j++){
                if (main.sensor_rooms[j] == rooms_list[i]){
                    rooms_array[i].push({"name": sensor_ids[j]})
                }
            }
            rooms.append({"room": rooms_list[i], "devices": rooms_array[i]})
            rooms_wrapper.isLoaded()
        }

        //build device models for each room
        //load device models for each room

    }
}
