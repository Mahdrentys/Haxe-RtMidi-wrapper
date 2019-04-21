package rtmidi;

enum MessageType
{
    NoteOn;
    NoteOff;
    ProgramChange;
    ControlChange;
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
}

class Codes
{
    private static var types =
    [
        "NoteOn" => 144,
        "NoteOff" => 128,
        "ProgramChange" => 192,
        "ControlChange" => 176
    ];

    private static var controls =
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
        "Hold" => 69
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