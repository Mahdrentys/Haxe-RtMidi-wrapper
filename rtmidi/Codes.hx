package rtmidi;

import haxe.macro.Expr;

enum MessageType
{
    NoteOn;
    NoteOff;
    PitchBend;
    ProgramChange;
    ControlChange;
    Code(code:Int);
}

enum Control
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
    Code(code:Int);
}

class Codes
{
    public static var types =
    [
        "NoteOn" => 144,
        "NoteOff" => 128,
        "PitchBend" => 224,
        "ProgramChange" => 192,
        "ControlChange" => 176
    ];

    public static var controls =
    [
        "SoundBankMSB" => 0,
        "Modulation" => 1,
        "Aftertouch" => 2,
        "Foot" => 4,
        "Portamento" => 5,
        "Volume" => 7,
        "Balance" => 8,
        "Pan" => 10,
        "Expression" => 11,
        "SoundBankLSB" => 32,
        "Sustain" => 64,
        "PortamentoOnOff" => 65,
        "Sostenuto" => 66,
        "Soft" => 67,
        "LegatoOnOff" => 68,
        "Hold" => 69,
        "Code" => 0
    ];

    public static function getStatus(byte:Int):{type: MessageType, channel: Int}
    {
        for (type in types.keys())
        {
            var code = types.get(type);

            if (byte >= code && byte < code + 16)
            {
                var channel = byte - code;
                return {type: Type.createEnum(MessageType, type), channel: channel};
            }
        }

        var availableCodes = [0];

        for (i in 0...70)
        {
            var newCode = availableCodes[availableCodes.length - 1] + 16;
            availableCodes.push(newCode);
        }

        for (code in availableCodes)
        {
            if (byte >= code && byte < code + 16)
            {
                var channel = byte - code;
                return {type: MessageType.Code(code), channel: channel};
            }
        }

        return null;
    }

    public static function getControl(code:Int):Control
    {
        for (control in controls.keys())
        {
            if (code == controls.get(control))
            {
                return Type.createEnum(Control, control);
            }
        }

        return null;
    }
}