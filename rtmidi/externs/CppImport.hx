package rtmidi.externs;

@:buildXml('
<files id="haxe">
    <file name="${haxelib:rtmidi-wrapper}/cpp/rtmidi/RtMidi.cpp" unless="RTAUDIO_TEST"></file>
    <file name="${haxelib:rtmidi-wrapper}/cpp/ExternInput.cpp" unless="RTAUDIO_TEST"></file>
    <file name="../../package/cpp/rtmidi/RtMidi.cpp" if="RTAUDIO_TEST"></file>
    <file name="../../package/cpp/ExternInput.cpp" if="RTAUDIO_TEST"></file>
    <compilerflag value="-I${haxelib:rtmidi-wrapper}/cpp" unless="RTAUDIO_TEST"/>
    <compilerflag value="-I../../package/cpp" if="RTAUDIO_TEST"/>
    <compilerflag value="-D__LINUX_ALSA__"/>
    <compilerflag value="-D__UNIX_JACK__"/>
</files>

<target id="haxe">
    <lib name="-lasound"/>
    <lib name="-lpthread"/>
    <lib name="-ljack"/>
</target>
')

@:keep class CppImport
{
    public function new() {}
}