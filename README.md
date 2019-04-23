# Haxe RtMidi wrapper

*Haxe c++ RtMidi high-level wrapper for real time midi events.*

Works on Linux (for Alsa and Jack APIs), for cpp target.

## Usage

Midi input:

```haxe
import rtmidi.Input;
import rtmidi.Api;
import rtmidi.Message;
import rtmidi.Codes;

class Main
{
    public static function main():Void
    {
        // Set the api to use
        Input.api = Api.Alsa; // The standard audio and midi api on Linux
        // Or:
        Input.api = Api.Jack; // The professional audio and midi api on Linux

        // Get the number of midi input devices
        var inputDevicesNumber:Int = Input.count();

        // Get the first midi input device
        var input:Input = Input.get(0);

        // Get device infos
        var isDeviceVirtual:Bool = input.virtual; // false
        var deviceId:Int = input.id; // 0
        var deviceName:String = input.name;

        // You can also create virtual midi inputs
        var virtualInput:Input = Input.create("input name");

        // Get device infos
        isDeviceVirtual = virtualInput.virtual; // true
        deviceId = virtualInput.id;
        deviceName = virtualInput.name; // "input name"

        // Get all midi input devices
        var inputs:Array<Input> = Input.all();

        // Listen for midi events
        input.listen();

        // Listen for all midi messages
        input.onMessage(function(message:Message):Void
        {
            var messageType:MessageType = message.type; // It's a value of the MessageType enum, which has these possible values:
            /*
            enum MessageType // located in rtmidi.Codes
            {
                NoteOn;
                NoteOff;
                PitchBend;
                MonoAftertouch;
                PolyAftertouch;
                ProgramChange;
                ControlChange;
                Code(code:Int); // When the message status byte is unknown, the type takes this value, with the code as the status byte code
            }
            */

            // When the message status byte is unknown, you can also get the status byte code and the data bytes with:
            if (Type.enumEq(message.type, MessageType.Code))
            {
                var code:Int = message.code;
                var dataBytes:Array<Int> = message.data;
            }
            else
            {
                message.code == null; // true
                message.data == null; // true
            }

            var channel:Int = message.channel; // The channel where was send the message, from 0 to 15
        });

        // There are different types of midi messages (located in rtmidi.Message), that extend from the rtmidi.Message class
        // You can also listen to them separately:
        input.on(NoteOnMessage, function(message:NoteOnMessage):Void
        {
            var note:Int = message.note; // from 0 to 127 in semitones (the center C (aka Do) is 60)
            var velocity:Float = message.velocity; // from 0 to 1
        });

        input.on(NoteOffMessage, function(message:NoteOffMessage):Void
        {
            var note:Int = message.note; // from 0 to 127
        });

        input.on(PitchBendMessage, function(message:PitchBendMessage):Void
        {
            var value:Int = message.value; // value of the pitch bend wheel, from -1 to 1
        });

        input.on(MonoAftertouchMessage, function(message:MonoAftertouchMessage):Void
        {
            var value:Int = message.value; // amount of monophonic aftertouch, from 0 to 1
        });

        input.on(PolyAftertouchMessage, function(message:PolyAftertouchMessage):Void
        {
            var note:Int = message.note; // from 0 to 127
            var value:Int = message.value; // amount of polyphonic aftertouch, from 0 to 1
        });

        input.on(ProgramChangeMessage, function(message:ProgramChangeMessage):Void // Change of sound
        {
            var program:Int = message.program; // from 0 to 127
        });

        input.on(ControlChangeMessage, function(message:ControlChangeMessage):Void
        {
            var control:Control = message.control; // It's a value of the Control enum, which has these possible values:
            /*
            enum Control // located in rtmidi.Codes
            {
                SoundBankMSB;
                Modulation;
                Aftertouch;
                Foot;
                Portamento;
                Volume;
                Balance;
                Pan;
                Expression;
                SoundBankLSB;
                Sustain;
                PortamentoOnOff;
                Sostenuto;
                Soft;
                LegatoOnOff;
                Hold;
                Code(code:Int); // When the control number (cc) is unknown, the type takes this value, with the code as the control number
            }
            */

            // When the control number is unknown, you can also get the control number with:
            if (Type.enumEq(message.control, Control.Code))
            {
                var code:Int = message.cc;
            }
            else
            {
                message.cc == null; // true
            }

            var value:Float = message.value; // The control new value, from 0 to 1
        });

        // Finally, you must stop the event listening
        input.stop();

        // You can handle internal c++ RtMidi errors like this:
        input.errorHandler = function(e:Dynamic):Void
        {
            trace(e); // e is simply a String
        };
    }
}
```

Midi output:

```haxe
import rtmidi.Output;
import rtmidi.Api;
import rtmidi.Message;
import rtmidi.Codes;

class Main
{
    public static function main():Void
    {
        // Set the api to use
        Output.api = Api.Alsa; // The standard audio and midi api on Linux
        // Or:
        Output.api = Api.Jack; // The professional audio and midi api on Linux

        // Get the number of midi output devices
        var outputDevicesNumber:Int = Output.count();

        // Get the first midi output device
        var output:Output = Output.get(0);

        // Get device infos
        var isDeviceVirtual:Bool = output.virtual; // false
        var deviceId:Int = output.id; // 0
        var deviceName:String = output.name;

        // You can also create virtual midi outputs
        var virtualOutput:Output = Output.create("output name");

        // Get device infos
        isDeviceVirtual = virtualOutput.virtual; // true
        deviceId = virtualOutput.id;
        deviceName = virtualOutput.name; // "output name"

        // Get all midi output devices
        var outputs:Array<Output> = Output.all();

        // You can send midi messages like this:
        var note:Int = 60; // from 0 to 127 in semitones (the center C (aka Do) is 60)
        var velocity:Float = 0.5; // from 0 to 1
        var channel:Int = 0; // from 0 to 15
        var message:Message = new NoteOnMessage(note, velocity, channel /* optional (default value: 0) */);
        output.send(message);

        note = 60; // from 0 to 127
        channel = 0; // from 0 to 15
        message = new NoteOffMessage(note, channel /* optional */);
        output.send(message);

        var pitchBendValue:Float = 0.2; // from -1 to 1
        channel:Int = 0; // from 0 to 15
        message = new PitchBendMessage(pitchBendValue, channel /* optional */);
        output.send(message);

        var aftertouchValue:Float = 0.5; // from 0 to 1
        channel = 0; // from 0 to 15
        message = new MonoAftertouchMessage(aftertouchValue, channel /* optional */);
        output.send(message);

        note = 60; // from 0 to 127
        aftertouchValue = 0.5; // from 0 to 1
        channel = 0; // from 0 to 15
        message = new PolyAftertouchMessage(note, aftertouchValue, channel /* optional */);
        output.send(message);

        var newProgram:Int = 5; // from 0 to 127
        channel = 0; // from 0 to 15
        message = new ProgramChangeMessage(newProgram, channel /* optional */);
        output.send(message);

        // Control change messages
        var control:Control = Control.Modulation; // See Control enum located in rtmidi.Codes
        var value:Float = 0.3; // from 0 to 1
        channel = 0; // from 0 to 15
        message = new ControlChangeMessage(control, value, channel /* optional */);
        output.send(message);

        // You can also send custom control change messages (that aren't included in the Control enum)
        var code:Int = 71; // from 0 to 127
        var control:Control = Control.Code(code);
        var value:Float = 0.3; // from 0 to 1
        channel = 0; // from 0 to 15
        message = new ControlChangeMessage(control, value, channel /* optional */);
        output.send(message);

        // You can also send custom midi messages by directly giving the midi bytes (2 or 3)
        message = Message.fromRaw([235, 34, 124]);
        output.send(message);

        // Finally, you must close the connection
        output.close();
    }
}
```