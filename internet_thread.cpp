#include "internet_thread.h"

internet_thread::internet_thread()
{
    start();
}

internet_thread::~internet_thread()
{
}

void internet_thread::run()
{
    forever{
        if(isConnectedToNetwork()){
            emit connected();
        }
        else{
            emit not_connected();
        }
    }
}

