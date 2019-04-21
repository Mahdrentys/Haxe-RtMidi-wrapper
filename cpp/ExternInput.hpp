#ifndef HAXE_RTMIDI_EXTERN_INPUT_HPP
#define HAXE_RTMIDI_EXTERN_INPUT_HPP

#include <string>
#include <vector>
#include "rtmidi/RtMidi.h"

class HaxeRtMidi_ExternInput
{
    private:
    static std::string api;
    static RtMidiIn *staticMidi;
    static std::vector<HaxeRtMidi_ExternInput> instances;
    static std::string staticError;

    RtMidiIn *midi;
    bool isVirtualBool;
    int id;
    std::string name;
    std::vector<unsigned char> message;
    std::string error;

    public:
    static void setApi(std::string api);
    static int count();
    static int get(int id);
    static int create(std::string name);
    static std::string getStaticError();
    static void resetStaticError();

    static int instanceIsVirtual(int instance);
    static std::string instanceGetName(int instance);
    static int instanceGetMessageSize(int instance);
    static int instanceGetMessageByte(int instance, int i);
    static void instanceClose(int instance);
    static std::string instanceGetError(int instance);
    static void instanceResetError(int instance);
    
    HaxeRtMidi_ExternInput(int id, std::string _api);
    HaxeRtMidi_ExternInput(std::string name, std::string _api);
    int isVirtual();
    std::string getName();
    int getMessageSize();
    int getMessageByte(int i);
    void close();
    std::string getError();
    void resetError();
};

#endif