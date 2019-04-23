package rtmidi.externs;

import cpp.Int32;
import cpp.StdString;

@:include("ExternInput.hpp")
@:native("HaxeRtMidi_ExternInput")
@:structAccess

extern class ExternInput
{
    @:native("HaxeRtMidi_ExternInput::setApi") public static function setApi(api:StdString):Void;
    @:native("HaxeRtMidi_ExternInput::count") public static function count():Int32;
    @:native("HaxeRtMidi_ExternInput::get") public static function get(id:Int32):Int32;
    @:native("HaxeRtMidi_ExternInput::create") public static function create(name:StdString):Int32;
    @:native("HaxeRtMidi_ExternInput::getStaticError") public static function getStaticError():StdString;
    @:native("HaxeRtMidi_ExternInput::resetStaticError") public static function resetStaticError():Void;

    @:native("HaxeRtMidi_ExternInput::instanceIsVirtual") public static function isVirtual(instance:Int32):Int32;
    @:native("HaxeRtMidi_ExternInput::instanceGetName") public static function getName(instance:Int32):StdString;
    @:native("HaxeRtMidi_ExternInput::instanceGetMessageSize") public static function getMessageSize(instance:Int32):Int32;
    @:native("HaxeRtMidi_ExternInput::instanceGetMessageByte") public static function getMessageByte(instance:Int32, i:Int32):Int32;
    @:native("HaxeRtMidi_ExternInput::instanceClose") public static function close(instance:Int32):Void;
    @:native("HaxeRtMidi_ExternInput::instanceGetError") public static function getError(instance:Int32):StdString;
    @:native("HaxeRtMidi_ExternInput::instanceResetError") public static function resetError(instance:Int32):Void;
}