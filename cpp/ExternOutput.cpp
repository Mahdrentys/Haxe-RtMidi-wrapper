#include <string>
#include <vector>
#include "ExternOutput.hpp"
#include "rtmidi/RtMidi.h"

using std::string;
using std::vector;

string HaxeRtMidi_ExternOutput::api = "alsa";
RtMidiOut *HaxeRtMidi_ExternOutput::staticMidi = NULL;
vector<HaxeRtMidi_ExternOutput> HaxeRtMidi_ExternOutput::instances;
string HaxeRtMidi_ExternOutput::staticError = "null";

void HaxeRtMidi_ExternOutput::setApi(string _api)
{
    if (staticMidi != NULL)
    {
        delete staticMidi;
    }

    try
    {
        if (_api == "alsa")
        {
            staticMidi = new RtMidiOut(RtMidi::LINUX_ALSA);
        }
        else if (_api == "jack")
        {
            staticMidi = new RtMidiOut(RtMidi::UNIX_JACK);
        }
    }
    catch (RtMidiError &e)
    {
        staticError = e.getMessage();
    }

    api = _api;
}

int HaxeRtMidi_ExternOutput::count()
{
    return (int) staticMidi->getPortCount();
}

int HaxeRtMidi_ExternOutput::get(int id)
{
    HaxeRtMidi_ExternOutput output(id, api);
    instances.push_back(output);
    return (int) instances.size() - 1;
}

int HaxeRtMidi_ExternOutput::create(string name)
{
    HaxeRtMidi_ExternOutput output(name, api);
    instances.push_back(output);
    return (int) instances.size() - 1;
}

HaxeRtMidi_ExternOutput::HaxeRtMidi_ExternOutput(int _id, string _api)
{
    try
    {
        if (_api == "alsa")
        {
            midi = new RtMidiOut(RtMidi::LINUX_ALSA);
        }
        else if (_api == "jack")
        {
            midi = new RtMidiOut(RtMidi::UNIX_JACK);
        }

        isVirtualBool = false;
        id = _id;
        midi->openPort(_id);
        error = "null";
    }
    catch (RtMidiError &e)
    {
        error = e.getMessage();
    }
}

HaxeRtMidi_ExternOutput::HaxeRtMidi_ExternOutput(string _name, string _api)
{
    try
    {
        if (_api == "alsa")
        {
            midi = new RtMidiOut(RtMidi::LINUX_ALSA);
        }
        else if (_api == "jack")
        {
            midi = new RtMidiOut(RtMidi::UNIX_JACK);
        }

        isVirtualBool = true;
        name = _name;
        midi->openVirtualPort(_name);
        error = "null";
    }
    catch (RtMidiError &e)
    {
        error = e.getMessage();
    }
}

int HaxeRtMidi_ExternOutput::isVirtual()
{
    return isVirtualBool ? 1 : 0;
}

int HaxeRtMidi_ExternOutput::instanceIsVirtual(int instance)
{
    return instances[instance].isVirtual();
}

string HaxeRtMidi_ExternOutput::getName()
{
    if (isVirtualBool)
    {
        return name;
    }
    else
    {
        return midi->getPortName(id);
    }
}

string HaxeRtMidi_ExternOutput::instanceGetName(int instance)
{
    return instances[instance].getName();
}

void HaxeRtMidi_ExternOutput::sendMessageByte(int byte)
{
    message.push_back((unsigned char) byte);
}

void HaxeRtMidi_ExternOutput::instanceSendMessageByte(int instance, int byte)
{
    instances[instance].sendMessageByte(byte);
}

void HaxeRtMidi_ExternOutput::sendMessage()
{
    try
    {
        midi->sendMessage(&message);
        message.clear();
    }
    catch (RtMidiError &e)
    {
        error = e.getMessage();
    }
}

void HaxeRtMidi_ExternOutput::instanceSendMessage(int instance)
{
    instances[instance].sendMessage();
}

void HaxeRtMidi_ExternOutput::close()
{
    try
    {
        midi->closePort();
        delete midi;
    }
    catch (RtMidiError &e)
    {
        error = e.getMessage();
    }
}

void HaxeRtMidi_ExternOutput::instanceClose(int instance)
{
    instances[instance].close();
}

string HaxeRtMidi_ExternOutput::getStaticError()
{
    return staticError;
}

void HaxeRtMidi_ExternOutput::resetStaticError()
{
    staticError = "null";
}

string HaxeRtMidi_ExternOutput::getError()
{
    return error;
}

string HaxeRtMidi_ExternOutput::instanceGetError(int instance)
{
    return instances[instance].getError();
}

void HaxeRtMidi_ExternOutput::resetError()
{
    error = "null";
}

void HaxeRtMidi_ExternOutput::instanceResetError(int instance)
{
    instances[instance].resetError();
}