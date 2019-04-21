#include <string>
#include <vector>
#include "ExternInput.hpp"
#include "rtmidi/RtMidi.h"

using std::string;
using std::vector;

string HaxeRtMidi_ExternInput::api = "alsa";
RtMidiIn *HaxeRtMidi_ExternInput::staticMidi = NULL;
vector<HaxeRtMidi_ExternInput> HaxeRtMidi_ExternInput::instances;
string HaxeRtMidi_ExternInput::staticError = "null";

void HaxeRtMidi_ExternInput::setApi(string _api)
{
    if (staticMidi != NULL)
    {
        delete staticMidi;
    }

    try
    {
        if (_api == "alsa")
        {
            staticMidi = new RtMidiIn(RtMidi::LINUX_ALSA);
        }
        else if (_api == "jack")
        {
            staticMidi = new RtMidiIn(RtMidi::UNIX_JACK);
        }
    }
    catch (RtMidiError &e)
    {
        staticError = e.getMessage();
    }

    api = _api;
}

int HaxeRtMidi_ExternInput::count()
{
    return (int) staticMidi->getPortCount();
}

int HaxeRtMidi_ExternInput::get(int id)
{
    HaxeRtMidi_ExternInput input(id, api);
    instances.push_back(input);
    return (int) instances.size() - 1;
}

int HaxeRtMidi_ExternInput::create(string name)
{
    HaxeRtMidi_ExternInput input(name, api);
    instances.push_back(input);
    return (int) instances.size() - 1;
}

HaxeRtMidi_ExternInput::HaxeRtMidi_ExternInput(int _id, string _api)
{
    try
    {
        if (_api == "alsa")
        {
            midi = new RtMidiIn(RtMidi::LINUX_ALSA);
        }
        else if (_api == "jack")
        {
            midi = new RtMidiIn(RtMidi::UNIX_JACK);
        }

        isVirtualBool = false;
        id = _id;
        midi->openPort(_id);
        midi->ignoreTypes(false);
        error = "null";
    }
    catch (RtMidiError &e)
    {
        error = e.getMessage();
    }
}

HaxeRtMidi_ExternInput::HaxeRtMidi_ExternInput(string _name, string _api)
{
    try
    {
        if (_api == "alsa")
        {
            midi = new RtMidiIn(RtMidi::LINUX_ALSA);
        }
        else if (_api == "jack")
        {
            midi = new RtMidiIn(RtMidi::UNIX_JACK);
        }

        isVirtualBool = true;
        name = _name;
        midi->openVirtualPort(_name);
        midi->ignoreTypes(false);
        error = "null";
    }
    catch (RtMidiError &e)
    {
        error = e.getMessage();
    }
}

int HaxeRtMidi_ExternInput::isVirtual()
{
    return isVirtualBool ? 1 : 0;
}

int HaxeRtMidi_ExternInput::instanceIsVirtual(int instance)
{
    return instances[instance].isVirtual();
}

string HaxeRtMidi_ExternInput::getName()
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

string HaxeRtMidi_ExternInput::instanceGetName(int instance)
{
    return instances[instance].getName();
}

int HaxeRtMidi_ExternInput::getMessageSize()
{
    try
    {
        midi->getMessage(&message);
    }
    catch (RtMidiError &e)
    {
        error = e.getMessage();
    }

    return (int) message.size();
}

int HaxeRtMidi_ExternInput::instanceGetMessageSize(int instance)
{
    return instances[instance].getMessageSize();
}

int HaxeRtMidi_ExternInput::getMessageByte(int i)
{
    return (int) message[i];
}

int HaxeRtMidi_ExternInput::instanceGetMessageByte(int instance, int i)
{
    return instances[instance].getMessageByte(i);
}

void HaxeRtMidi_ExternInput::close()
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

void HaxeRtMidi_ExternInput::instanceClose(int instance)
{
    instances[instance].close();
}

string HaxeRtMidi_ExternInput::getStaticError()
{
    return staticError;
}

void HaxeRtMidi_ExternInput::resetStaticError()
{
    staticError = "null";
}

string HaxeRtMidi_ExternInput::getError()
{
    return error;
}

string HaxeRtMidi_ExternInput::instanceGetError(int instance)
{
    return instances[instance].getError();
}

void HaxeRtMidi_ExternInput::resetError()
{
    error = "null";
}

void HaxeRtMidi_ExternInput::instanceResetError(int instance)
{
    instances[instance].resetError();
}