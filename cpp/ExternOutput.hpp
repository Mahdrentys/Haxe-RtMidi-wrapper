#ifndef HAXE_RTMIDI_EXTERN_OUTPUT_HPP
#define HAXE_RTMIDI_EXTERN_OUTPUT_HPP

#include <string>
#include <vector>
#include "rtmidi/RtMidi.h"

class HaxeRtMidi_ExternOutput
{
    private:
    static std::string api;
    static RtMidiOut *staticMidi;
    static std::vector<HaxeRtMidi_ExternOutput> instances;
    static std::string staticError;

    RtMidiOut *midi;
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
    static void instanceSendMessageByte(int instance, int byte);
    static void instanceSendMessage(int instance);
    static void instanceClose(int instance);
    static std::string instanceGetError(int instance);
    static void instanceResetError(int instance);
    
    HaxeRtMidi_ExternOutput(int id, std::string _api);
    HaxeRtMidi_ExternOutput(std::string name, std::string _api);
    int isVirtual();
    std::string getName();
    void sendMessageByte(int byte);
    void sendMessage();
    void close();
    std::string getError();
    void resetError();
};

#endif