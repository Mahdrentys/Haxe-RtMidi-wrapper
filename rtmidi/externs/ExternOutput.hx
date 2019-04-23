package rtmidi.externs;

import cpp.Int32;
import cpp.StdString;

@:include("ExternOutput.hpp")
@:native("HaxeRtMidi_ExternOutput")
@:structAccess

extern class ExternOutput
{
    @:native("HaxeRtMidi_ExternOutput::setApi") public static function setApi(api:StdString):Void;
    @:native("HaxeRtMidi_ExternOutput::count") public static function count():Int32;
    @:native("HaxeRtMidi_ExternOutput::get") public static function get(id:Int32):Int32;
    @:native("HaxeRtMidi_ExternOutput::create") public static function create(name:StdString):Int32;
    @:native("HaxeRtMidi_ExternOutput::getStaticError") public static function getStaticError():StdString;
    @:native("HaxeRtMidi_ExternOutput::resetStaticError") public static function resetStaticError():Void;

    @:native("HaxeRtMidi_ExternOutput::instanceIsVirtual") public static function isVirtual(instance:Int32):Int32;
    @:native("HaxeRtMidi_ExternOutput::instanceGetName") public static function getName(instance:Int32):StdString;
    @:native("HaxeRtMidi_ExternOutput::instanceSendMessageByte") public static function sendMessageByte(instance:Int32, byte:Int32):Int32;
    @:native("HaxeRtMidi_ExternOutput::instanceSendMessage") public static function sendMessage(instance:Int32):Int32;
    @:native("HaxeRtMidi_ExternOutput::instanceClose") public static function close(instance:Int32):Void;
    @:native("HaxeRtMidi_ExternOutput::instanceGetError") public static function getError(instance:Int32):StdString;
    @:native("HaxeRtMidi_ExternOutput::instanceResetError") public static function resetError(instance:Int32):Void;
}